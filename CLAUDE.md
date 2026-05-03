# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## Development commands

### Flutter app (`flutter_app/`)
```bash
flutter pub get                                      # install deps
dart run build_runner build --delete-conflicting-outputs  # codegen (Freezed, Riverpod, Isar)
flutter run                                          # run on connected device
flutter test                                         # run all tests
flutter test test/path/to/test_file.dart             # run single test file
flutter analyze                                      # lint
```

### Cloud Functions (`functions/`)
```bash
npm install
npm run build          # tsc compile
npm run build:watch    # watch mode during development
npm run lint           # eslint
npm test               # jest (unit tests)
npm run serve          # build + start emulators (functions only)
firebase deploy --only functions   # deploy all functions
firebase deploy --only functions:generateStory  # deploy single function
```

### TypeScript type-check only (no emit)
```bash
# From functions/
~/.nvm/versions/node/v20.19.2/bin/node ./node_modules/.bin/tsc --noEmit
```

### Firebase emulators (full stack)
```bash
firebase emulators:start --only auth,firestore,storage,functions
```

---

## Architecture overview

Two workspaces: `flutter_app/` (Flutter/Dart client) and `functions/` (Node.js 20 TypeScript Cloud Functions).

### Key data flow: story generation
1. Flutter calls `generateStory` (Firebase Callable) with a **pre-generated UUID** `storyId`.
2. Flutter immediately subscribes to `users/{uid}/stories/{storyId}` via Firestore real-time listener.
3. Cloud Function writes progress to the story doc: `cover_generating → cover_ready → complete`.
4. When `cover_ready`: Flutter shows the cover image while pages generate (~40 s).
5. When `complete`: Flutter navigates to the story reader.
6. The callable itself also returns `{ storyId }` as a navigation fallback.

### Cloud Functions domain structure (`functions/src/`)
- **`handlers/`** — HTTP/callable entry points; thin wrappers that validate, check caps, and delegate.
- **`domain/services/StoryOrchestrator.ts`** — Core pipeline: GPT → moderation → cover image → 8 page images (parallel) → TTS → upload → Firestore.
- **`infrastructure/ai/`** — `RunningHubClient` (async submit+poll, ~40 s/image), `GptStoryWriter`, `ElevenLabsTts`, `ContentModerator`.
- **`infrastructure/firestore/`** — Repository classes (one per collection).
- All AI API keys are backend-only secrets; the Flutter client never sees them.

### Flutter app structure (`flutter_app/lib/`)
- **State management**: Riverpod 2.x with code generation (`@riverpod` annotations). Run `build_runner` after any `@riverpod` change.
- **Routing**: `go_router` in `core/router/app_router.dart`.
- **Offline cache**: Isar for story data; write-through on `watchAll()`.
- **Repositories** in `data/repositories/` wrap Cloud Functions callables and Firestore streams. Features import only repositories, never Firestore/Functions directly.

### Image generation (RunningHub)
- Async submit-then-poll pattern (2.5 s poll interval, 120 s timeout).
- Each story generates a **cover image first** (all characters together, used as consistency reference), then 8 page images in parallel — each with up to 3 references: cover + hero anchor + original child photo (if within 24 h window).
- 3 retry attempts per image before marking failed.

### Subscriptions
- RevenueCat is the source of truth. Firestore `users/{uid}.subscription` is a webhook-synced cache.
- `DailyCapManager` reads from Firestore (not RevenueCat SDK) at generation time.

---

# Lullabook — Technical Specification & Developer Handbook

> Version: 1.0 — initial spec
> Last updated: April 2026
> Companion document to: `lullabook-prd.md` v1.6
> Purpose: Day-one developer handbook. Read this end-to-end before writing any code.

---

## 0. How to use this document

This is the implementation companion to the PRD. The PRD answers "what and why"; this answers "how, in what order, with what files."

**Reading order for a fresh start**:
1. §1 Stack overview — confirm tooling decisions
2. §2 Repo layout — set up the folder structure
3. §3 Data model — create Firestore collections + security rules
4. §4 Cloud Functions — deploy the backend skeleton
5. §5 Flutter app structure — scaffold the client
6. §6 AI pipeline — wire up RunningHub + GPT-4o + ElevenLabs
7. §7–§9 Feature implementation — build F-0, F-1, F-3 in order
8. §10–§12 Cross-cutting concerns — analytics, security, deployment

Estimated time to a working dev environment: **1 day**. Estimated time to MVP-feature-complete: **7 weeks** (Phase 1 in the PRD).

---

## 1. Stack overview

### 1.1 Locked technology choices

| Layer | Technology | Why |
|---|---|---|
| Mobile client | Flutter 3.24+, Dart 3.5+ | Cross-platform iOS + Android with one codebase. Matches Portraiz (you already know the patterns). |
| State management | Riverpod 2.5+ | Reactive, testable, code-generated. Same as Portraiz. |
| Local storage | `isar` 3.x | Fast NoSQL for offline story cache. Hive is the backup option. |
| Auth | Firebase Auth | Apple Sign-In, Google, email — required for COPPA-friendly parent accounts. |
| Database | Cloud Firestore | Real-time, scalable, free tier sufficient for MVP. |
| File storage | Firebase Storage | Hero anchors, story images, narration audio. |
| Backend functions | Cloud Functions (Node.js 20, TypeScript) | Same runtime as Portraiz; matches your existing skill set. |
| Subscription management | RevenueCat SDK + RevenueCat Paywalls | Industry standard for mobile subscription tracking; free up to 2.5K MTR; simpler purchase flow than direct StoreKit; remote-config paywall builder for A/B tests. |
| Image AI | RunningHub Enterprise-Shared API (`rhart-image-v1/edit`) | Locked. Async submit + poll pattern, $0.012/task, ~40s avg completion. |
| Image AI fallback | None in MVP | Single retry on RunningHub failure; user-facing error if both fail. Multi-provider deferred to V1.1+. |
| Story writer | OpenAI GPT-4o (`gpt-4o-2024-11-20`) | Locked. |
| TTS | ElevenLabs Multilingual v2 | Locked. Default voices in MVP, voice cloning in V1.1. |
| Content safety | OpenAI Moderation API + custom regex | Defense in depth. |
| Analytics | Firebase Analytics + Mixpanel | Funnel tracking + cohort analysis. |
| Crash reporting | Sentry (`sentry_flutter`, `@sentry/node`) | Same as Portraiz. |
| Push notifications | Firebase Cloud Messaging (FCM) | Built-in with Firebase. |

### 1.2 Tooling and accounts you need before Day 1

```
[ ] Apple Developer Program account ($99/yr) — already have
[ ] Google Play Developer account ($25 one-time) — defer to Phase 2
[ ] Firebase project created (free tier, upgrade to Blaze when launching)
[ ] RunningHub Enterprise-Shared API key (already have from Portraiz; reuse same wallet or create separate workspace for Lullabook)
[ ] OpenAI API account with GPT-4o access ($30 initial credit)
[ ] ElevenLabs Creator tier subscription ($22/month for ~100K chars)
[ ] RevenueCat account + dashboard set up (App Store + Google Play apps connected, products + entitlements configured)
[ ] Sentry organization + Flutter + Node projects created
[ ] Mixpanel project (free tier OK for MVP)
[ ] GitHub private repository (or GitLab/Bitbucket)
[ ] Domain DNS setup: lullabook.app primary, getlullabook.com redirect
```

### 1.3 Environment variables / secrets matrix

Never commit any of these to git. Use Firebase Functions config + flutter_dotenv for client.

**Backend (`functions/.env.production`, configured via `firebase functions:secrets:set`)**:
```
RUNNINGHUB_API_KEY                (Image generation via Enterprise-Shared API)
OPENAI_API_KEY                    (GPT-4o + Moderation + TTS fallback)
ELEVENLABS_API_KEY                (TTS narration)
REVENUECAT_SECRET_KEY             (Webhook validation + REST API for server-side ops)
REVENUECAT_WEBHOOK_AUTH_HEADER    (Bearer token for webhook signature check)
SENTRY_DSN_NODE                   (Backend crash reporting)
APP_FRONTEND_URL                  (For email links — https://lullabook.app)
```

**Client (`flutter_app/.env.production`, bundled via flutter_dotenv)**:
```
FIREBASE_PROJECT_ID
REVENUECAT_PUBLIC_API_KEY_IOS     (client-side public key, iOS)
REVENUECAT_PUBLIC_API_KEY_ANDROID (client-side public key, Android)
SENTRY_DSN_FLUTTER
MIXPANEL_TOKEN
```

**Strict rule**: no AI API keys in the client. All RunningHub, GPT, ElevenLabs calls go through Cloud Functions. Client never sees them. Hard rule, no exceptions.

---

## 2. Repository layout

Single monorepo, two top-level workspaces.

```
lullabook/
├── README.md
├── CLAUDE.md                    # this document
├── docs/
│   ├── prd.md                   # product requirements
│   ├── architecture.md          # extended technical decisions
│   └── runbooks/
│       ├── deploy.md
│       ├── rollback.md
│       └── incident-response.md
├── flutter_app/
│   ├── pubspec.yaml
│   ├── lib/
│   │   ├── main.dart
│   │   ├── app.dart
│   │   ├── core/                # cross-cutting: theme, router, errors
│   │   ├── data/                # repositories, data sources, DTOs
│   │   ├── domain/              # entities, use cases (pure Dart)
│   │   ├── features/            # feature modules (see §5.2)
│   │   └── shared/              # widgets, utilities
│   ├── assets/
│   │   ├── illustrations/       # static art (onboarding, etc.)
│   │   ├── animations/          # Lottie / Rive
│   │   └── fonts/
│   ├── ios/
│   ├── android/
│   └── test/
├── functions/
│   ├── package.json
│   ├── tsconfig.json
│   ├── src/
│   │   ├── index.ts             # function exports
│   │   ├── config/              # env + secrets loaders
│   │   ├── domain/              # business logic, framework-free
│   │   ├── infrastructure/      # AI provider clients, Firestore, Storage
│   │   ├── handlers/            # HTTP/callable endpoints
│   │   ├── triggers/            # Firestore + Auth triggers
│   │   ├── webhooks/            # RevenueCat + future Gelato
│   │   └── utils/
│   └── test/
├── firestore.rules
├── firestore.indexes.json
├── storage.rules
├── firebase.json
├── .github/
│   └── workflows/
│       ├── flutter-ci.yml
│       ├── functions-ci.yml
│       └── deploy.yml
└── scripts/
    ├── setup-dev-env.sh
    └── seed-test-data.ts
```

---

## 3. Data model — Firestore

### 3.1 Collections

```
/users/{uid}
/users/{uid}/heroes/{heroId}
/users/{uid}/stories/{storyId}
/users/{uid}/recurringCharacters/{charId}      # V1.1
/users/{uid}/voiceModel                         # V1.1, document not collection
/previews/{previewId}                           # F-0 ephemeral
/systemPrompts/{language}                       # admin-managed
/abuseTracking/{deviceFingerprint}              # F-0 rate limiting
```

### 3.2 Document schemas

#### `/users/{uid}`

```typescript
interface UserDoc {
  uid: string;                              // matches Firebase Auth UID
  email: string;
  displayName: string | null;
  locale: string;                           // 'en-US', 'hu-HU', 'de-DE'
  contentLanguage: string;                  // user-chosen story language
  timezone: string;                         // for daily cap reset
  createdAt: Timestamp;
  lastActiveAt: Timestamp;
  
  subscription: {
    tier: 'free' | 'weekly' | 'yearly';
    purchaseSource: 'apple' | 'google' | null;
    subscriptionId: string | null;          // RevenueCat App User ID (matches uid)
    expiresAt: Timestamp | null;
    isInTrial: boolean;
    cancelledAt: Timestamp | null;
  };
  
  // Daily cap tracking
  dailyUsage: {
    date: string;                           // 'YYYY-MM-DD' in user's timezone
    storiesGenerated: number;               // resets at midnight local
  };
  
  // Aggregate stats
  totalStoriesCreated: number;
  totalHeroesCreated: number;
  
  // Preview tracking (F-0 abuse prevention)
  previewsUsed: number;
  
  // V1.1
  hasVoiceModel: boolean;
  voiceModelId: string | null;              // ElevenLabs voice ID, encrypted at rest
}
```

#### `/users/{uid}/heroes/{heroId}`

```typescript
interface HeroDoc {
  heroId: string;
  name: string;
  age: number;                              // 3-8
  pronouns: 'he/him' | 'she/her' | 'they/them';
  
  // Defining traits — text reinforcement for every image gen prompt
  definingTraits: string;                   // "brown wavy hair, blue glasses, freckles"
  
  // Hero Anchor — the single image asset used as RunningHub reference
  heroAnchorStoragePath: string;            // Firebase Storage path (for signed URL generation)
  heroAnchorImageUrl: string;               // public download URL (for display in Flutter app)
  heroAnchorThumbUrl: string;               // 256x256 thumbnail for UI
  artStyle: 'pixar_3d' | 'watercolor' | 'flat_modern' | 'storybook_classic';
  
  // Original photo: deleted within 24h, only path stored for audit
  originalPhotoDeletedAt: Timestamp | null;
  
  // V1.1: hero evolution
  narrativeTraits: string[];                // accumulated from past stories
  
  createdAt: Timestamp;
  updatedAt: Timestamp;
}
```

#### `/users/{uid}/stories/{storyId}`

```typescript
interface StoryDoc {
  storyId: string;
  heroId: string;                           // ref
  
  title: string;                            // generated by GPT-4o
  language: string;
  
  // From kid-participation setup
  setup: {
    theme: string;                          // 'astronaut', 'pirate', etc.
    companion: string | null;               // 'mom', 'dog Rex', etc.
    location: string;                       // 'space', 'jungle', etc.
    goal: string;                           // 'find treasure', etc.
    teachingMoment: string | null;          // parent-set, optional
  };
  
  // 8 pages
  pages: Array<{
    pageNumber: number;                     // 1-8
    text: string;                           // story text in user's language
    imageUrl: string;                       // Firebase Storage
    audioUrl: string;                       // ElevenLabs TTS output
    imagePrompt: string;                    // English, what was sent to RunningHub
    isReusedFromHeroReveal: boolean;        // true only for page 1 of first story
  }>;
  
  // Aggregate stats
  durationSeconds: number;                  // total narration duration
  readCount: number;
  lastReadAt: Timestamp | null;
  favorite: boolean;
  
  // Generation metadata (for cost tracking + debugging)
  generationMetadata: {
    imageProvider: 'runninghub';
    runningHubTaskIds: string[];            // for debugging + audit
    retryCount: number;
    totalCostUsd: number;                   // actual measured cost
    durationMs: number;
    storyWriterModel: string;               // 'gpt-4o-2024-11-20'
    ttsProvider: 'elevenlabs';
    ttsVoiceId: string;
  };
  
  createdAt: Timestamp;
}
```

#### `/previews/{previewId}` — ephemeral, F-0

```typescript
interface PreviewDoc {
  previewId: string;
  deviceFingerprint: string;                // SHA-256 of device ID
  ipHash: string;                           // SHA-256 of client IP
  
  childName: string;
  adventureChoice: string;                  // one of 6 preview options
  artStyle: string;
  
  heroRevealImageUrl: string;               // the generated image
  openingText: string;                      // 1-2 sentences
  
  // Set when user signs up — links preview to user account
  claimedByUid: string | null;
  claimedAt: Timestamp | null;
  
  createdAt: Timestamp;
  expiresAt: Timestamp;                     // 24h TTL, auto-delete via scheduled function
}
```

#### `/abuseTracking/{deviceFingerprint}`

```typescript
interface AbuseTrackingDoc {
  deviceFingerprint: string;
  ipHashes: string[];                       // multiple IPs from same device
  previewAttempts: Array<{
    timestamp: Timestamp;
    ipHash: string;
    result: 'success' | 'blocked';
  }>;
  blockedUntil: Timestamp | null;
  totalAttempts: number;
}
```

#### `/systemPrompts/{language}` — admin-managed, client-readable

```typescript
interface SystemPromptDoc {
  language: string;                         // 'en-US', 'hu-HU', 'de-DE'
  storyWriterPrompt: string;                // full GPT-4o system prompt
  safetyInstructions: string;
  artStyleModifiers: {
    pixar_3d: string;
    watercolor: string;
    flat_modern: string;
    storybook_classic: string;
  };
  ttsVoiceMap: {                            // chosen ElevenLabs voice IDs
    female: string;
    male: string;
  };
  updatedAt: Timestamp;
  version: number;                          // increment on changes
}
```

### 3.3 Firestore Security Rules

```javascript
// firestore.rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Users can read/write only their own user doc
    match /users/{userId} {
      allow read: if request.auth != null && request.auth.uid == userId;
      allow create: if request.auth != null && request.auth.uid == userId;
      allow update: if request.auth != null 
                    && request.auth.uid == userId
                    && !affectedKeys().hasAny(['subscription', 'totalStoriesCreated', 'previewsUsed']);
      // Subscription, totals, abuse counters mutable only by Cloud Functions (admin SDK)
      allow delete: if false;  // Use deleteAccount Cloud Function
    }

    // Heroes — owned by user
    match /users/{userId}/heroes/{heroId} {
      allow read: if request.auth != null && request.auth.uid == userId;
      allow write: if false;  // All hero mutations via Cloud Functions for validation
    }

    // Stories — read-only for owner; created/deleted only via Cloud Functions
    match /users/{userId}/stories/{storyId} {
      allow read: if request.auth != null && request.auth.uid == userId;
      allow update: if request.auth != null 
                    && request.auth.uid == userId
                    && affectedKeys().hasOnly(['readCount', 'lastReadAt', 'favorite']);
      // generationMetadata, pages, etc. immutable once written
      allow create, delete: if false;
    }

    // Previews — write-protected, readable only by claimer
    match /previews/{previewId} {
      allow read: if request.auth != null 
                  && resource.data.claimedByUid == request.auth.uid;
      allow write: if false;  // Cloud Functions only
    }

    // Abuse tracking — Cloud Functions only
    match /abuseTracking/{anyId} {
      allow read, write: if false;
    }

    // System prompts — read-only for client
    match /systemPrompts/{language} {
      allow read: if request.auth != null;
      allow write: if false;
    }

    // Helper
    function affectedKeys() {
      return request.resource.data.diff(resource.data).affectedKeys();
    }
  }
}
```

### 3.4 Storage Rules

```javascript
// storage.rules
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    
    // User's hero anchor images — owner can read, only Cloud Functions write
    match /heroes/{userId}/{heroId}/{filename} {
      allow read: if request.auth != null && request.auth.uid == userId;
      allow write: if false;
    }

    // Story images + audio — owner can read, only Cloud Functions write
    match /stories/{userId}/{storyId}/{filename} {
      allow read: if request.auth != null && request.auth.uid == userId;
      allow write: if false;
    }

    // Preview images — public temporarily (until claimed), then deleted
    match /previews/{previewId}/{filename} {
      allow read: if true;  // public for preview, deleted after claim or 24h
      allow write: if false;
    }

    // User uploads (original photos) — write only via Cloud Function signed URL
    match /uploads/{userId}/{filename} {
      allow read: if request.auth != null && request.auth.uid == userId;
      allow write: if false;  // Use signed URL upload only
    }
  }
}
```

### 3.5 Composite indexes

```json
// firestore.indexes.json
{
  "indexes": [
    {
      "collectionGroup": "stories",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "heroId", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "stories",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "favorite", "order": "DESCENDING" },
        { "fieldPath": "lastReadAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "previews",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "deviceFingerprint", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    }
  ]
}
```

---

## 4. Cloud Functions — backend skeleton

### 4.1 Function inventory

| Function | Trigger | Purpose |
|---|---|---|
| `generatePreview` | HTTPS callable | F-0: photo → Hero Reveal image (no auth required) |
| `claimPreview` | HTTPS callable | Link preview to newly signed-up user |
| `createHero` | HTTPS callable (auth) | Onboarding: validate + generate Hero Card |
| `regenerateHeroAnchor` | HTTPS callable (auth) | Up to 2 free regens during onboarding |
| `generateStory` | HTTPS callable (auth) | F-3: full pipeline orchestration |
| `regeneratePage` | HTTPS callable (auth) | Per-page retry within a story |
| `revenuecatWebhook` | HTTPS endpoint | Subscription state sync from RevenueCat events |
| `onUserCreate` | Auth trigger | Initialize user document |
| `cleanupExpiredPreviews` | Scheduled (every hour) | Delete previews > 24h old |
| `resetDailyUsage` | Scheduled (every hour, checks each user's TZ) | Reset story counter at local midnight |
| `deleteAccount` | HTTPS callable (auth) | GDPR-compliant full account wipe |

### 4.2 Folder structure inside `functions/src/`

```
src/
├── index.ts                      # exports all functions
├── config/
│   ├── env.ts                    # process.env loader, type-safe
│   └── secrets.ts                # firebase functions secrets accessor
├── domain/
│   ├── entities/
│   │   ├── User.ts
│   │   ├── Hero.ts
│   │   ├── Story.ts
│   │   └── Preview.ts
│   ├── services/
│   │   ├── StoryOrchestrator.ts   # core pipeline logic
│   │   ├── HeroFactory.ts
│   │   ├── PreviewFactory.ts
│   │   └── DailyCapManager.ts
│   └── errors/
│       ├── DomainError.ts
│       ├── RateLimitError.ts
│       └── GenerationError.ts
├── infrastructure/
│   ├── firestore/
│   │   ├── UserRepository.ts
│   │   ├── HeroRepository.ts
│   │   ├── StoryRepository.ts
│   │   └── PreviewRepository.ts
│   ├── storage/
│   │   └── AssetUploader.ts
│   ├── ai/
│   │   ├── RunningHubClient.ts
│   │   ├── ImageProvider.ts       # retry orchestrator over RunningHub
│   │   ├── GptStoryWriter.ts
│   │   ├── ElevenLabsTts.ts
│   │   └── ContentModerator.ts
│   └── auth/
│       └── AuthMiddleware.ts
├── handlers/
│   ├── generatePreview.ts
│   ├── claimPreview.ts
│   ├── createHero.ts
│   ├── regenerateHeroAnchor.ts
│   ├── generateStory.ts
│   ├── regeneratePage.ts
│   └── deleteAccount.ts
├── triggers/
│   └── onUserCreate.ts
├── webhooks/
│   └── revenuecatWebhook.ts
├── scheduled/
│   ├── cleanupExpiredPreviews.ts
│   └── resetDailyUsage.ts
└── utils/
    ├── deviceFingerprint.ts
    ├── logger.ts                  # Sentry + Cloud Logging
    ├── cost.ts                    # tracks per-request costs
    └── timezone.ts
```

### 4.3 Core function: `generateStory` skeleton

This is the most important Cloud Function — full pipeline orchestration. Use this as the canonical pattern for the others.

```typescript
// src/handlers/generateStory.ts
import { onCall, HttpsError } from 'firebase-functions/v2/https';
import { defineSecret } from 'firebase-functions/params';
import { logger } from '../utils/logger';
import { StoryOrchestrator } from '../domain/services/StoryOrchestrator';
import { DailyCapManager } from '../domain/services/DailyCapManager';

const RUNNINGHUB_KEY = defineSecret('RUNNINGHUB_API_KEY');
const OPENAI_KEY = defineSecret('OPENAI_API_KEY');
const ELEVENLABS_KEY = defineSecret('ELEVENLABS_API_KEY');

interface GenerateStoryInput {
  heroId: string;
  setup: {
    theme: string;
    companion: string | null;
    location: string;
    goal: string;
    teachingMoment: string | null;
  };
  language: string;
}

export const generateStory = onCall<GenerateStoryInput>(
  {
    secrets: [RUNNINGHUB_KEY, OPENAI_KEY, ELEVENLABS_KEY],
    cors: true,
    memory: '1GiB',
    timeoutSeconds: 180,
    maxInstances: 100,
  },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError('unauthenticated', 'Sign in required');
    }

    const uid = request.auth.uid;
    const input = request.data;

    // Step 1: enforce daily cap
    const capManager = new DailyCapManager(uid);
    const allowed = await capManager.canGenerate();
    if (!allowed) {
      throw new HttpsError(
        'resource-exhausted',
        'Daily story cap reached. New stories tomorrow at midnight.'
      );
    }

    // Step 2: orchestrate full pipeline
    const orchestrator = new StoryOrchestrator({
      uid,
      input,
      secrets: { runninghub: RUNNINGHUB_KEY.value(), openai: OPENAI_KEY.value(), elevenlabs: ELEVENLABS_KEY.value() }
    });

    try {
      const story = await orchestrator.generate();
      await capManager.incrementUsage();
      return { storyId: story.storyId, success: true };
    } catch (err) {
      logger.error('Story generation failed', { uid, error: err });
      throw new HttpsError('internal', 'Story generation failed. Please try again.');
    }
  }
);
```

### 4.4 StoryOrchestrator — the core domain logic

```typescript
// src/domain/services/StoryOrchestrator.ts
export class StoryOrchestrator {
  constructor(private deps: OrchestratorDeps) {}

  async generate(): Promise<StoryDoc> {
    const startTime = Date.now();

    // 1. Load Hero Card
    const hero = await this.heroRepo.get(this.deps.uid, this.deps.input.heroId);
    if (!hero) throw new DomainError('hero_not_found');

    // 2. Generate story text (GPT-4o)
    const storyText = await this.storyWriter.write({
      hero,
      setup: this.deps.input.setup,
      language: this.deps.input.language,
    });

    // 3. Moderate generated text
    await this.contentModerator.assertSafe(storyText.fullText);

    // 4. Generate images for pages 2-8 in parallel
    //    (Page 1 reuses Hero Reveal image)
    const isFirstStory = await this.heroRepo.isFirstStoryForHero(hero.heroId);
    const pagesToGenerate = isFirstStory ? storyText.pages.slice(1) : storyText.pages;

    const imageResults = await Promise.allSettled(
      pagesToGenerate.map((page) =>
        this.imageProvider.generateScene({
          heroAnchorStoragePath: hero.heroAnchorStoragePath,
          definingTraits: hero.definingTraits,
          scenePrompt: page.imagePrompt,
          artStyle: hero.artStyle,
          pageNumber: page.pageNumber,
        })
      )
    );

    // 5. Validate images, retry failures via fallback
    const finalImages = await this.handleImageResults(imageResults, storyText.pages);

    // 6. Generate TTS narration for all 8 pages in parallel
    const audioResults = await Promise.all(
      storyText.pages.map((page) =>
        this.ttsClient.synthesize({
          text: page.text,
          language: this.deps.input.language,
          voiceId: this.getVoiceForLanguage(this.deps.input.language),
        })
      )
    );

    // 7. Upload all assets to Firebase Storage
    const uploadedAssets = await this.assetUploader.uploadStoryAssets({
      uid: this.deps.uid,
      storyId: this.generateStoryId(),
      heroRevealImageUrl: isFirstStory ? hero.heroAnchorImageUrl : null,
      pageImages: finalImages,
      pageAudios: audioResults,
    });

    // 8. Persist story document
    const story = await this.storyRepo.create({
      uid: this.deps.uid,
      heroId: hero.heroId,
      title: storyText.title,
      pages: this.assembleFinalPages(storyText.pages, uploadedAssets, isFirstStory),
      generationMetadata: {
        imageProvider: 'runninghub',
        runningHubTaskIds: this.taskIdTracker.all(),
        retryCount: this.retryCount,
        totalCostUsd: this.costTracker.getTotal(),
        durationMs: Date.now() - startTime,
        storyWriterModel: 'gpt-4o-2024-11-20',
        ttsProvider: 'elevenlabs',
        ttsVoiceId: this.getVoiceForLanguage(this.deps.input.language),
      },
    });

    return story;
  }

  // ... helper methods omitted for brevity
}
```

### 4.5 Image provider with retry

```typescript
// src/infrastructure/ai/ImageProvider.ts
export class ImageProvider {
  constructor(
    private runningHub: RunningHubClient,
    private costTracker: CostTracker,
    private taskIdTracker: TaskIdTracker,
  ) {}

  async generateScene(input: SceneInput): Promise<GeneratedImage> {
    try {
      const result = await this.runningHub.generate(input);
      this.costTracker.add('runninghub', 0.012);
      this.taskIdTracker.record(result.taskId);
      return result;
    } catch (primaryErr) {
      logger.warn('RunningHub task failed, retrying once', { error: primaryErr });
      try {
        const result = await this.runningHub.generate(input);
        this.costTracker.add('runninghub', 0.012);
        this.taskIdTracker.record(result.taskId);
        return result;
      } catch (retryErr) {
        logger.error('Image generation failed after retry', { primaryErr, retryErr });
        throw new GenerationError('image_generation_failed');
      }
    }
  }

  async generateHeroReveal(input: HeroRevealInput): Promise<GeneratedImage> {
    // Same retry pattern, different prompt structure
    // ...
  }
}

interface GeneratedImage {
  imageBuffer: Buffer;
  taskId: string;
  costUsd: number;
}
```

**Retry semantics**:
- One automatic retry on RunningHub failure (transient errors are common in async polling).
- No alternate provider fallback in MVP — operational simplicity.
- If both attempts fail, the page is regenerable by parent via "tap-to-regenerate" UI.
- Story orchestrator continues with whatever pages succeeded; failed pages show a "tap to retry" placeholder, not a blocking error for the whole story.

### 4.6 GPT-4o story writer

```typescript
// src/infrastructure/ai/GptStoryWriter.ts
import OpenAI from 'openai';

export class GptStoryWriter {
  private client: OpenAI;

  async write(input: StoryWriterInput): Promise<GeneratedStory> {
    const systemPrompt = await this.systemPromptRepo.get(input.language);
    
    const response = await this.client.chat.completions.create({
      model: 'gpt-4o-2024-11-20',
      messages: [
        { role: 'system', content: systemPrompt.storyWriterPrompt },
        { role: 'user', content: JSON.stringify(input) },
      ],
      response_format: { type: 'json_object' },
      temperature: 0.8,
    });

    const usage = response.usage!;
    this.costTracker.add('gpt4o', this.calculateCost(usage));

    const parsed = this.parseAndValidate(response.choices[0].message.content!);
    return parsed;
  }

  private calculateCost(usage: { prompt_tokens: number; completion_tokens: number }): number {
    return (usage.prompt_tokens * 2.5 + usage.completion_tokens * 10) / 1_000_000;
  }
}
```

The full system prompt is the one we drafted earlier in the conversation — it goes in `/systemPrompts/{language}` Firestore doc, fetched at runtime so you can iterate without redeploying.

---

## 5. Flutter app structure

### 5.1 `pubspec.yaml` core dependencies

```yaml
name: lullabook
description: AI Bedtime Stories for Kids
version: 1.0.0+1
publish_to: 'none'

environment:
  sdk: ^3.5.0
  flutter: ">=3.24.0"

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  
  # State management
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5
  
  # Routing
  go_router: ^14.2.0
  
  # Firebase
  firebase_core: ^3.4.0
  firebase_auth: ^5.2.0
  cloud_firestore: ^5.4.0
  firebase_storage: ^12.3.0
  firebase_messaging: ^15.1.0
  cloud_functions: ^5.1.0
  firebase_analytics: ^11.3.0
  firebase_crashlytics: ^4.1.0
  firebase_remote_config: ^5.1.0
  
  # Subscriptions
  purchases_flutter: ^8.1.0
  purchases_ui_flutter: ^8.1.0
  
  # Storage
  isar: ^3.1.0
  isar_flutter_libs: ^3.1.0
  path_provider: ^2.1.4
  
  # Auth
  sign_in_with_apple: ^6.1.2
  google_sign_in: ^6.2.1
  
  # Audio
  just_audio: ^0.9.40
  audio_session: ^0.1.21
  
  # Image/file
  image_picker: ^1.1.2
  cached_network_image: ^3.4.0
  
  # UI delight
  flutter_animate: ^4.5.0
  lottie: ^3.1.2
  
  # Utilities
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0
  intl: ^0.19.0
  uuid: ^4.5.0
  device_info_plus: ^10.1.2
  package_info_plus: ^8.0.2
  flutter_dotenv: ^5.1.0
  
  # Observability
  sentry_flutter: ^8.7.0
  mixpanel_flutter: ^2.3.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
  build_runner: ^2.4.13
  riverpod_generator: ^2.4.3
  freezed: ^2.5.7
  json_serializable: ^6.8.0
  isar_generator: ^3.1.0
  custom_lint: ^0.6.7
  riverpod_lint: ^2.3.13
  mocktail: ^1.0.4
```

### 5.2 Feature modules

Each feature is self-contained: presentation + domain glue + data adapters.

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── theme/
│   │   ├── app_theme.dart           # warm bedtime palette
│   │   ├── app_colors.dart
│   │   └── app_text_styles.dart
│   ├── router/
│   │   └── app_router.dart          # go_router config
│   ├── errors/
│   │   ├── app_error.dart
│   │   └── error_handler.dart
│   └── utils/
│       ├── logger.dart              # Sentry-aware
│       └── analytics.dart           # Mixpanel + Firebase wrapper
│
├── data/
│   ├── repositories/
│   │   ├── user_repository.dart
│   │   ├── hero_repository.dart
│   │   ├── story_repository.dart
│   │   └── preview_repository.dart
│   ├── sources/
│   │   ├── remote/
│   │   │   ├── functions_client.dart    # Cloud Functions wrapper
│   │   │   └── firestore_client.dart
│   │   └── local/
│   │       └── isar_client.dart         # offline cache
│   └── dtos/
│       └── ...
│
├── domain/
│   ├── entities/
│   │   ├── user.dart                # Freezed
│   │   ├── hero.dart
│   │   ├── story.dart
│   │   └── preview.dart
│   ├── usecases/
│   │   ├── generate_preview_usecase.dart
│   │   ├── create_hero_usecase.dart
│   │   ├── generate_story_usecase.dart
│   │   └── ...
│   └── value_objects/
│       └── art_style.dart
│
├── features/
│   ├── splash/
│   ├── onboarding_preview/          # F-0
│   ├── auth/
│   ├── hero_setup/                  # F-1
│   ├── tonight_adventure/           # F-2
│   ├── story_generation/            # F-3 (loading screen)
│   ├── story_reader/                # F-6
│   ├── library/                     # F-7
│   ├── paywall/
│   └── settings/
│
├── shared/
│   ├── widgets/
│   │   ├── animated_loading.dart
│   │   ├── hero_anchor_avatar.dart
│   │   ├── adventure_tile.dart
│   │   └── page_flip_view.dart
│   └── extensions/
│
└── l10n/
    ├── intl_en.arb
    ├── intl_hu.arb
    └── intl_de.arb
```

### 5.3 Entity examples (Freezed)

```dart
// lib/domain/entities/hero.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'hero.freezed.dart';
part 'hero.g.dart';

@freezed
class Hero with _$Hero {
  const factory Hero({
    required String heroId,
    required String name,
    required int age,
    required Pronouns pronouns,
    required String definingTraits,
    required String heroAnchorStoragePath,
    required String heroAnchorImageUrl,
    required String heroAnchorThumbUrl,
    required ArtStyle artStyle,
    @Default([]) List<String> narrativeTraits,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Hero;

  factory Hero.fromJson(Map<String, dynamic> json) => _$HeroFromJson(json);
}

enum ArtStyle {
  pixar3d('pixar_3d', 'Pixar Style'),
  watercolor('watercolor', 'Watercolor'),
  flatModern('flat_modern', 'Flat Modern'),
  storybookClassic('storybook_classic', 'Storybook Classic');

  const ArtStyle(this.id, this.label);
  final String id;
  final String label;
}

enum Pronouns {
  heHim('he/him'),
  sheHer('she/her'),
  theyThem('they/them');

  const Pronouns(this.value);
  final String value;
}
```

### 5.4 Riverpod providers

```dart
// lib/data/repositories/story_repository.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'story_repository.g.dart';

@riverpod
StoryRepository storyRepository(StoryRepositoryRef ref) {
  return StoryRepository(
    functions: ref.watch(functionsClientProvider),
    firestore: ref.watch(firestoreClientProvider),
    isar: ref.watch(isarClientProvider),
  );
}

class StoryRepository {
  StoryRepository({
    required FunctionsClient functions,
    required FirestoreClient firestore,
    required IsarClient isar,
  }) : _functions = functions, _firestore = firestore, _isar = isar;

  final FunctionsClient _functions;
  final FirestoreClient _firestore;
  final IsarClient _isar;

  Future<Story> generateStory({
    required String heroId,
    required AdventureSetup setup,
    required String language,
  }) async {
    final result = await _functions.callable('generateStory').call({
      'heroId': heroId,
      'setup': setup.toJson(),
      'language': language,
    });

    final storyId = result.data['storyId'] as String;
    final story = await _firestore.fetchStory(storyId);
    
    // Cache for offline
    await _isar.cacheStory(story);
    
    return story;
  }

  Stream<List<Story>> watchLibrary(String uid) {
    return _firestore.watchStories(uid);
  }
}
```

---

## 6. AI pipeline implementation

### 6.1 RunningHub client (image generation)

The RunningHub Enterprise-Shared API uses an **async submit-then-poll** pattern. This affects the entire generation pipeline architecture: tasks must be submitted in parallel and polled concurrently to fit the ~90s end-to-end story budget.

#### Operational characteristics (from Portraiz production data)

- **Per-task cost**: $0.012 (deducted from RunningHub wallet)
- **Avg completion time**: ~40 seconds (varies 25–60s under load)
- **Endpoint**: `rhart-image-v1/edit` for character + style consistent generation
- **Concurrency**: tasks run in parallel; submitting 7 simultaneously is supported
- **Image URL TTL**: result URL valid for 24 hours — must download to Firebase Storage promptly

#### Reference image strategy

The Hero Anchor lives in Firebase Storage. To pass it to RunningHub:

- **Generate a Firebase Storage signed URL** with 1-hour expiration before each task submit
- Pass that URL in the `imageUrls` array
- Avoids base64 encoding overhead (faster network, smaller request)

#### Client implementation

```typescript
// functions/src/infrastructure/ai/RunningHubClient.ts
import { logger } from '../../utils/logger';
import { getStorage } from 'firebase-admin/storage';

interface RunningHubSubmitResponse {
  taskId: string;
  status: 'QUEUED' | 'RUNNING' | 'SUCCESS' | 'FAILED';
  errorCode: string;
  errorMessage: string;
  results: null;
}

interface RunningHubQueryResponse {
  taskId: string;
  status: 'QUEUED' | 'RUNNING' | 'SUCCESS' | 'FAILED';
  errorCode: string;
  errorMessage: string;
  results: Array<{
    url: string;
    nodeId: string;
    outputType: string;
    text: string | null;
  }> | null;
  usage: {
    consumeMoney: string | null;
    taskCostTime: string;
    thirdPartyConsumeMoney: string | null;
  };
}

export class RunningHubClient {
  private apiKey: string;
  private editEndpoint = 'https://www.runninghub.ai/openapi/v2/rhart-image-v1/edit';
  private queryEndpoint = 'https://www.runninghub.ai/openapi/v2/query';

  // Polling config (tuned for ~40s avg completion)
  private pollIntervalMs = 2500;          // poll every 2.5 seconds
  private maxPollDurationMs = 120_000;    // hard stop at 120s per task

  constructor(apiKey: string) {
    this.apiKey = apiKey;
  }

  /**
   * Generate the Hero Reveal image (used in F-0 preview, F-1 anchor, F-3 page 1).
   * Reference image is the original child photo (uploaded by parent).
   */
  async generateHeroReveal(input: HeroRevealInput): Promise<GeneratedImage> {
    const photoSignedUrl = await this.signedUrlFor(input.childPhotoStoragePath);
    const prompt = this.buildHeroRevealPrompt(input);
    
    return this.submitAndPoll({
      prompt,
      imageUrls: [photoSignedUrl],
      aspectRatio: 'auto',
    });
  }

  /**
   * Generate a story page scene using the Hero Anchor as visual reference.
   */
  async generateScene(input: SceneInput): Promise<GeneratedImage> {
    const anchorSignedUrl = await this.signedUrlFor(input.heroAnchorStoragePath);
    const prompt = this.buildScenePrompt(input);

    return this.submitAndPoll({
      prompt,
      imageUrls: [anchorSignedUrl],
      aspectRatio: 'auto',
    });
  }

  /**
   * Core async pattern: submit a task, then poll until SUCCESS or FAILED.
   */
  private async submitAndPoll(payload: SubmitPayload): Promise<GeneratedImage> {
    const submitResponse = await this.submit(payload);

    if (submitResponse.status === 'FAILED') {
      throw new GenerationError(
        `runninghub_submit_failed: ${submitResponse.errorCode} ${submitResponse.errorMessage}`
      );
    }

    const queryResult = await this.pollUntilDone(submitResponse.taskId);

    if (queryResult.status !== 'SUCCESS' || !queryResult.results?.[0]) {
      throw new GenerationError(
        `runninghub_task_failed: ${queryResult.errorCode} ${queryResult.errorMessage}`
      );
    }

    const imageUrl = queryResult.results[0].url;
    const imageBuffer = await this.downloadImage(imageUrl);

    return {
      taskId: submitResponse.taskId,
      imageBuffer,
      costUsd: 0.012,
    };
  }

  private async submit(payload: SubmitPayload): Promise<RunningHubSubmitResponse> {
    const response = await fetch(this.editEndpoint, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${this.apiKey}`,
      },
      body: JSON.stringify(payload),
    });

    if (!response.ok) {
      throw new GenerationError(`runninghub_submit_http_${response.status}`);
    }

    return await response.json() as RunningHubSubmitResponse;
  }

  private async pollUntilDone(taskId: string): Promise<RunningHubQueryResponse> {
    const startTime = Date.now();

    while (Date.now() - startTime < this.maxPollDurationMs) {
      const response = await fetch(this.queryEndpoint, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${this.apiKey}`,
        },
        body: JSON.stringify({ taskId }),
      });

      const result = await response.json() as RunningHubQueryResponse;

      if (result.status === 'SUCCESS' || result.status === 'FAILED') {
        return result;
      }

      await this.sleep(this.pollIntervalMs);
    }

    throw new GenerationError(`runninghub_task_timeout_${taskId}`);
  }

  private async downloadImage(url: string): Promise<Buffer> {
    const response = await fetch(url);
    if (!response.ok) {
      throw new GenerationError(`image_download_failed_${response.status}`);
    }
    return Buffer.from(await response.arrayBuffer());
  }

  private async signedUrlFor(storagePath: string): Promise<string> {
    const bucket = getStorage().bucket();
    const file = bucket.file(storagePath);
    const [url] = await file.getSignedUrl({
      action: 'read',
      expires: Date.now() + 60 * 60 * 1000,  // 1 hour
    });
    return url;
  }

  private sleep(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms));
  }

  private buildHeroRevealPrompt(input: HeroRevealInput): string {
    const styleModifier = ART_STYLE_PROMPTS[input.artStyle];
    return `
Create a ${styleModifier}.

This is the opening illustration of a personalized children's bedtime
storybook. Transform the child in the reference photo into the hero
of this scene.

Scene: ${input.openingSceneDescription}

Character requirements:
- Faithfully preserve the child's facial features, hair color and style,
  skin tone, and any distinctive traits visible in the reference photo
- Friendly, warm expression, engaged with the scene
- Three-quarter or full body visible
${input.definingTraits ? `- Defining traits to preserve: ${input.definingTraits}` : ''}

Composition: Cinematic storybook illustration, warm and inviting,
soft lighting suitable for a bedtime story. The character is the
focal point but the scene background tells part of the story.

This image will serve as the master reference for 7 additional pages,
so the character must be clearly defined and recognizable.
    `.trim();
  }

  private buildScenePrompt(input: SceneInput): string {
    return `
Create an illustration matching the reference image's art style and
character EXACTLY.

Scene for this page: ${input.scenePrompt}

CRITICAL CONSISTENCY RULES:
- The character must be visually identical to the reference: same face,
  same hair color and style, same skin tone, same defining features
- Defining traits to preserve: ${input.definingTraits}
- The art style must match the reference precisely — same rendering
  technique, same color palette mood, same level of detail
- The character's outfit may change to fit the scene
- The character's pose, expression, and surroundings should match the
  scene description

Composition: Cinematic storybook page illustration. The character
should be visible and identifiable.
    `.trim();
  }
}

const ART_STYLE_PROMPTS = {
  pixar_3d: "warm 3D-rendered children's book illustration, Pixar-style, soft cinematic lighting, expressive features",
  watercolor: "gentle watercolor children's book illustration, soft edges, pastel palette, traditional storybook aesthetic",
  flat_modern: "contemporary flat-vector children's book illustration, bold colors, clean geometric shapes, modern picture book style",
  storybook_classic: "detailed ink-and-wash children's book illustration, warm tones, classic heritage storybook style",
};

interface HeroRevealInput {
  artStyle: 'pixar_3d' | 'watercolor' | 'flat_modern' | 'storybook_classic';
  openingSceneDescription: string;
  definingTraits: string | null;
  childPhotoStoragePath: string;
}

interface SceneInput {
  scenePrompt: string;
  definingTraits: string;
  heroAnchorStoragePath: string;
}

interface SubmitPayload {
  prompt: string;
  imageUrls: string[];
  aspectRatio: string;
}

interface GeneratedImage {
  taskId: string;
  imageBuffer: Buffer;
  costUsd: number;
}
```

#### Parallel orchestration pattern

Story generation submits 7 tasks (or 8 if not first story) and polls all concurrently. Each `submitAndPoll` runs in its own Promise — `Promise.allSettled` orchestrates them.

```typescript
// In StoryOrchestrator.generate():
const sceneTasks = pagesToGenerate.map((page) =>
  this.imageProvider.generateScene({
    heroAnchorStoragePath: hero.heroAnchorStoragePath,
    definingTraits: hero.definingTraits,
    scenePrompt: page.imagePrompt,
  })
);
const imageResults = await Promise.allSettled(sceneTasks);
```

**Total wall-clock time** for 7 parallel scenes: ~40s (slowest task), not 7 × 40s = 280s.

#### Cost & timing tracking

Every successful generation records:
- `taskId` (for debugging via RunningHub dashboard)
- $0.012 cost contribution
- Wall-clock time (submit-to-success duration)

These flow into `generationMetadata` in the Story document.

#### Notes on RunningHub specifics

- The `aspectRatio: "auto"` lets the model pick the natural ratio for the scene. Set to `"3:2"` or `"4:3"` if a consistent storybook page ratio is preferred — to be tested in implementation.
- Authorization: `Bearer ${RUNNINGHUB_API_KEY}` header on every request.
- `Rh-Comfy-Auth` and `Rh-Identify` query parameters seen in some example URLs are session tokens for browser-based usage — not needed for API access via Bearer auth.
- The `aspectRatio` enum supports: `auto, 1:1, 16:9, 9:16, 4:3, 3:4, 3:2, 2:3, 5:4, 4:5, 21:9`.
- Prompt length limit: 1–20,000 characters. Our prompts (~400-600 chars) are well within limits.

### 6.2 ElevenLabs TTS client

```typescript
// functions/src/infrastructure/ai/ElevenLabsTts.ts
export class ElevenLabsTts {
  private apiKey: string;
  private baseUrl = 'https://api.elevenlabs.io/v1';

  async synthesize(input: TtsInput): Promise<Buffer> {
    const response = await fetch(
      `${this.baseUrl}/text-to-speech/${input.voiceId}`,
      {
        method: 'POST',
        headers: {
          'xi-api-key': this.apiKey,
          'Content-Type': 'application/json',
          'Accept': 'audio/mpeg',
        },
        body: JSON.stringify({
          text: input.text,
          model_id: 'eleven_multilingual_v2',
          voice_settings: {
            stability: 0.6,
            similarity_boost: 0.7,
            style: 0.3,             // gentle, bedtime-appropriate
            use_speaker_boost: true,
          },
        }),
      }
    );

    if (!response.ok) {
      throw new GenerationError(`tts_failed_${response.status}`);
    }

    return Buffer.from(await response.arrayBuffer());
  }
}
```

### 6.3 Cost tracker

```typescript
// functions/src/utils/cost.ts
export class CostTracker {
  private costs: Map<string, number> = new Map();

  add(provider: string, costUsd: number): void {
    this.costs.set(provider, (this.costs.get(provider) ?? 0) + costUsd);
  }

  getTotal(): number {
    let total = 0;
    for (const c of this.costs.values()) total += c;
    return total;
  }

  getBreakdown(): Record<string, number> {
    return Object.fromEntries(this.costs);
  }
}
```

Every Cloud Function invocation that touches AI providers must instantiate a CostTracker, pass it through to all provider clients, and persist the total to `generationMetadata.totalCostUsd`. This is your operational dashboard for cost regression detection.

---

### 6.4 RevenueCat subscription integration

RevenueCat is the **source of truth** for subscription state. Firestore caches it for fast client reads and Cloud Function authorization checks, but RevenueCat is authoritative.

#### Setup steps

1. Create RevenueCat project at app.revenuecat.com
2. Connect App Store Connect (upload App-Specific Shared Secret)
3. Create products in App Store Connect:
   - `lullabook_weekly_799` — auto-renewable subscription, $7.99/week, 3-day intro trial
   - `lullabook_yearly_9999` — auto-renewable subscription, $99.99/year, no trial
4. Import products into RevenueCat
5. Create one entitlement called `premium` and attach both products to it
6. Create one offering called `default` with two packages: `weekly` and `yearly`
7. Generate public API key (iOS) and (Android) — these are bundled in the client

#### Client integration pattern

```dart
// lib/data/sources/remote/revenuecat_client.dart
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatClient {
  Future<void> configure({required String userId}) async {
    final config = PurchasesConfiguration(_publicApiKey)
      ..appUserID = userId;
    await Purchases.configure(config);
  }

  Future<Offering?> getDefaultOffering() async {
    final offerings = await Purchases.getOfferings();
    return offerings.current;
  }

  Future<bool> purchase(Package package) async {
    try {
      final result = await Purchases.purchasePackage(package);
      return result.entitlements.all['premium']?.isActive ?? false;
    } on PlatformException catch (e) {
      if (PurchasesErrorHelper.getErrorCode(e) == 
          PurchasesErrorCode.purchaseCancelledError) {
        return false;
      }
      rethrow;
    }
  }

  Future<bool> isPremium() async {
    final info = await Purchases.getCustomerInfo();
    return info.entitlements.all['premium']?.isActive ?? false;
  }

  Future<void> restorePurchases() async {
    await Purchases.restorePurchases();
  }
}
```

#### Login linking — critical

When a user signs in with Firebase Auth, immediately link the RevenueCat App User ID to the Firebase UID. This ensures the same subscription works across devices and survives reinstalls.

```dart
// In your auth provider after successful Firebase sign-in:
await Purchases.logIn(firebaseUid);
```

When user signs out:

```dart
await Purchases.logOut();
```

#### Backend webhook handler

```typescript
// functions/src/webhooks/revenuecatWebhook.ts
import { onRequest } from 'firebase-functions/v2/https';
import { defineSecret } from 'firebase-functions/params';

const RC_AUTH = defineSecret('REVENUECAT_WEBHOOK_AUTH_HEADER');

export const revenuecatWebhook = onRequest(
  { secrets: [RC_AUTH], cors: false },
  async (req, res) => {
    // Verify webhook authentication
    if (req.headers.authorization !== `Bearer ${RC_AUTH.value()}`) {
      res.status(401).send('Unauthorized');
      return;
    }

    const event = req.body.event;
    const uid = event.app_user_id;

    switch (event.type) {
      case 'INITIAL_PURCHASE':
      case 'RENEWAL':
      case 'PRODUCT_CHANGE':
        await syncSubscriptionState(uid, {
          tier: deriveTierFromProductId(event.product_id),
          isInTrial: event.period_type === 'TRIAL',
          expiresAt: new Date(event.expiration_at_ms),
          subscriptionId: event.app_user_id,
          purchaseSource: event.store === 'APP_STORE' ? 'apple' : 'google',
        });
        break;

      case 'CANCELLATION':
      case 'EXPIRATION':
        await syncSubscriptionState(uid, {
          tier: 'free',
          isInTrial: false,
          expiresAt: null,
          cancelledAt: new Date(),
        });
        break;

      case 'BILLING_ISSUE':
        // Don't immediately downgrade — Apple has 16-day grace period
        await flagBillingIssue(uid);
        break;
    }

    res.status(200).send('OK');
  }
);

function deriveTierFromProductId(productId: string): 'weekly' | 'yearly' {
  if (productId.includes('weekly')) return 'weekly';
  if (productId.includes('yearly')) return 'yearly';
  throw new Error(`Unknown product: ${productId}`);
}
```

Configure the webhook URL in RevenueCat dashboard: Project Settings → Integrations → Webhooks → add `https://us-central1-lullabook-prod.cloudfunctions.net/revenuecatWebhook` with custom header `Authorization: Bearer <random-secret>`.

#### Authorization checks in Cloud Functions

The `generateStory` function reads `users/{uid}.subscription.tier` for cap enforcement. Since the webhook keeps this fresh, no additional RevenueCat REST call is needed at request time. **One source of truth, one read.**

```typescript
// functions/src/domain/services/DailyCapManager.ts
async canGenerate(): Promise<boolean> {
  const user = await this.userRepo.get(this.uid);

  if (user.subscription.tier === 'free') {
    return user.totalStoriesCreated === 0;  // free tier: 1 lifetime story
  }

  const cap = user.subscription.tier === 'weekly' ? 3 : 1;
  const today = this.todayInUserTimezone(user.timezone);
  
  if (user.dailyUsage.date !== today) {
    return true;  // first story today, automatic reset
  }

  return user.dailyUsage.storiesGenerated < cap;
}
```

#### Restore purchases UX

Add a "Restore Purchases" button in Settings (Apple requirement). Calls `Purchases.restorePurchases()`. Useful for users who delete and reinstall the app.

#### Sandbox testing

Before TestFlight, use Apple StoreKit Configuration files in Xcode for local testing without burning real subscriptions. RevenueCat detects sandbox vs production automatically.

---

## 7. Feature implementation order

### 7.1 Week 3 — foundations (Phase 1 starts here per PRD)

```
Day 1-2: Repository + Firebase project setup
  [ ] Create Firebase project lullabook-prod
  [ ] Create lullabook-staging
  [ ] Enable Auth (Email, Apple, Google), Firestore, Storage, Functions, Crashlytics, Analytics, Remote Config, FCM
  [ ] Initialize Flutter app with dependencies
  [ ] Initialize functions workspace
  [ ] Set up CI workflows (lint + test on PR)
  [ ] Configure Sentry for both client and server

Day 3-4: Auth + onboarding scaffolding
  [ ] Sign in with Apple, Google, Email/Password
  [ ] Splash → onboarding teaser route
  [ ] User document auto-created via onUserCreate trigger
  [ ] Basic theme + design tokens

Day 5: RevenueCat integration
  [ ] Create RevenueCat project; connect App Store Connect (StoreKit credentials)
  [ ] Configure products in App Store Connect: lullabook_weekly_799, lullabook_yearly_9999, with 3-day intro trial on weekly
  [ ] Configure entitlements in RevenueCat: 'premium' entitlement attached to both products
  [ ] Create one Offering ('default') with both packages
  [ ] Wire purchases_flutter SDK in client; configure with public API key from .env
  [ ] Set RevenueCat App User ID = Firebase Auth UID on sign-in for cross-device entitlement sync
  [ ] revenuecatWebhook function in Cloud Functions: verifies Authorization header, parses event types (INITIAL_PURCHASE, RENEWAL, CANCELLATION, EXPIRATION, BILLING_ISSUE)
  [ ] Webhook syncs subscription state to /users/{uid}.subscription as the source of truth on backend
  [ ] Client also reads CustomerInfo from RevenueCat SDK as fallback if Firestore is stale
```

### 7.2 Week 4 — F-0 Pre-Signup Preview

```
Day 1-2: Photo upload + signed URL flow
  [ ] Client photo picker
  [ ] Client compresses to <1MB (sharp library on backend would also work)
  [ ] Cloud Function generatePreview accepts base64 photo via callable
  [ ] Validates face detection on backend before billing user

Day 3-4: RunningHub Hero Reveal generation
  [ ] RunningHubClient.generateHeroReveal() implemented (submit + poll)
  [ ] Stores result in /previews/{previewId}
  [ ] Stores image in Firebase Storage at /previews/{previewId}/reveal.png
  [ ] Returns previewId + image URL to client

Day 5: Preview → signup flow
  [ ] Animated reveal screen on client
  [ ] Sign-up paywall after reveal
  [ ] claimPreview function: links previewId to newly authenticated user
  [ ] Promotes preview image to Hero Card
```

### 7.3 Week 5 — F-1 Hero Profile + F-2 Setup

```
Day 1-2: Hero Card refinement
  [ ] If user signed up via F-0: Hero Card already exists, just confirm details
  [ ] If user skipped F-0: full hero creation flow (name, age, photo, defining traits, art style)
  [ ] Anchor validation step: "Does this look like Sofia?" + max 2 free regenerations

Day 3-5: F-2 Tonight's Adventure setup flow
  [ ] 4-card swipe UI: theme, companion, location, goal
  [ ] Optional teaching moment (parent-only screen)
  [ ] Adventure setup → triggers generateStory cloud function
```

### 7.4 Week 6 — F-3 Story generation pipeline

```
Day 1-2: GPT-4o story writer
  [ ] System prompt loaded from /systemPrompts/{language}
  [ ] Schema-validated JSON output
  [ ] Moderation API check on output

Day 3-5: Full pipeline
  [ ] StoryOrchestrator wires together: GPT → moderation → 7 parallel RunningHub tasks (submit + poll concurrently) → 8 parallel TTS → Firestore + Storage
  [ ] Animated loading screen on client during ~60-90s generation
  [ ] Error handling: one auto-retry per failed RunningHub task; per-page tap-to-regenerate UI for partial failures
```

### 7.5 Week 7 — F-6 Reader + F-7 Library + F-8 Offline

```
Day 1-3: Page-flip reader
  [ ] Full-screen reader with page-curl animation
  [ ] Audio narration sync per page
  [ ] Auto-play with manual override
  [ ] Sleep Mode (gradual screen dim)

Day 4: Story library
  [ ] List view with cover thumbnails
  [ ] Sort/filter by hero, recent, favorite
  [ ] Tap to re-read

Day 5: Offline mode
  [ ] On story creation, Isar caches full story (text + image URLs + audio URLs)
  [ ] Background download on Wi-Fi
  [ ] Offline indicator in UI
```

### 7.6 Week 8 — Polish, paywall, analytics, beta prep

```
Day 1-2: Paywall finalization
  [ ] Two-card paywall (Weekly + Yearly) styled
  [ ] Daily cap enforcement: 3/day Weekly, 1/day Yearly
  [ ] Cap-hit message: "Sofia's adventures rest now. New stories tomorrow 🌙"

Day 3: Analytics wiring
  [ ] Funnel events: app_open, preview_started, preview_completed, signup, hero_created, story_generated, story_completed, paywall_shown, subscription_started
  [ ] Mixpanel + Firebase Analytics dual-writes

Day 4: Bug bash
  [ ] All happy paths tested on iPhone 12+ and iPad
  [ ] Edge cases: poor connectivity, photo too small, photo no face, language switching
  [ ] Crash-free rate ≥ 99%

Day 5: Closed beta TestFlight
  [ ] Invite 30 friends/family parents
  [ ] Set up feedback Slack channel or Linear inbox
```

### 7.7 Week 9 — Closed beta iteration

Run with the 30 families. Track WASGF target ≥ 30% D7 retention. Fix top 5 bugs. Refine paywall copy. If exit criterion met, proceed to public beta (Week 10).

---

## 8. Key implementation patterns

### 8.1 Error handling philosophy

Three error tiers:

1. **User-recoverable** (network, retry, resource exhausted): show friendly message, suggest action, log info-level
2. **System-recoverable** (provider failure, fallback success): silent retry on backend, log warning
3. **Fatal** (data corruption, auth violation): log error, show generic message to user, page Sentry alert

```dart
// Flutter: typed error handling
sealed class AppError {
  const AppError();
}

class NetworkError extends AppError {}
class RateLimitError extends AppError { final DateTime resetAt; }
class GenerationError extends AppError { final String reason; }
class ServerError extends AppError {}

// In UI
ref.listen(generateStoryProvider, (prev, next) {
  next.whenOrNull(
    error: (error, _) {
      switch (error) {
        case RateLimitError(:final resetAt):
          showCapHitDialog(resetAt);
        case NetworkError():
          showRetryToast();
        default:
          showGenericError();
      }
    },
  );
});
```

### 8.2 Async generation pattern

Story generation is 90s on the backend. The client should:

1. Show a "creating Sofia's adventure..." loading screen with animation
2. Subscribe to Firestore document for completion
3. Auto-route to reader on completion

```dart
final storyGenerationProvider = FutureProvider.family
    .autoDispose<Story, AdventureSetup>((ref, setup) async {
  final repo = ref.watch(storyRepositoryProvider);
  
  // Fire and wait — Firebase handles long timeouts
  final story = await repo.generateStory(
    heroId: setup.heroId,
    setup: setup,
    language: ref.read(currentLanguageProvider),
  );
  
  return story;
});
```

### 8.3 Daily cap enforcement (defense-in-depth)

Cap is enforced in two places:

**Backend (authoritative)**: `DailyCapManager` reads `users/{uid}.dailyUsage`, increments after successful generation. If user hits cap, throws `RateLimitError` from `generateStory`.

**Client (UX hint)**: subscribes to user doc, shows "Stories remaining today: 1" badge when applicable. Cosmetic only — backend is the truth.

Reset logic: scheduled function runs every hour, finds users in any timezone where local time just crossed midnight, resets `dailyUsage.storiesGenerated` to 0.

---

## 9. Testing strategy

### 9.1 What to test

**Backend (`functions/test/`)**:
- Domain entities and value objects: 100% unit test coverage
- StoryOrchestrator: integration tests with mocked AI providers
- ImageProvider retry logic: ensures one retry happens before propagating error
- DailyCapManager: timezone math, midnight reset edge cases
- Auth middleware: rejects unauth'd, accepts auth'd
- Webhook validation: RevenueCat Authorization header check + event payload schema validation

**Client (`flutter_app/test/`)**:
- Use cases (pure Dart): 100% unit
- Repositories: with `mocktail` for FunctionsClient
- Widget tests for critical screens: paywall, hero anchor confirmation, page reader
- Golden tests for theme consistency

### 9.2 What NOT to test in MVP

- E2E tests (manual testing in beta is sufficient at this scale)
- Real AI provider calls in CI (mock them; test real ones in staging manually)
- Performance tests (defer to scale phase)

---

## 10. Observability

### 10.1 Logging

Every Cloud Function logs structured JSON:

```typescript
logger.info('story_generated', {
  uid: 'abc123',
  storyId: 'xyz789',
  heroId: 'h456',
  durationMs: 78234,
  costUsd: 0.213,
  imageProvider: 'runninghub',
  retryCount: 0,
});
```

Cloud Logging exports to BigQuery for cost analysis. Sentry captures errors with context.

### 10.2 Metrics dashboards

Critical real-time metrics, build in Firebase Console + Mixpanel:

- Active users (DAU, WAU)
- Funnel: install → preview → signup → first story → paid
- Story generation success rate (target ≥ 98%)
- Avg generation time (target < 90s)
- Avg per-story cost (target < $0.25)
- D1, D7, D30 retention by cohort
- Subscription churn rate
- Daily cap hit rate (informational, not alert-worthy unless > 30%)

### 10.3 Alerts

Sentry alerts for:
- Crash-free rate drops below 99%
- New error type appears > 10 times in an hour
- Cloud Function p99 latency > 120s
- AI provider failure rate > 5% in 15 minutes

---

## 11. Deployment

### 11.1 Environments

- **dev**: local Flutter + Firebase Emulators
- **staging**: lullabook-staging Firebase project, separate API keys (test mode), test Apple Developer account
- **production**: lullabook-prod, prod API keys, prod Apple Developer account

### 11.2 Release flow

```
feature branch → PR → CI runs lint + test
↓
merge to main → auto-deploy functions to staging
↓
manual TestFlight build for QA
↓
manual approval → deploy functions to prod + TestFlight to App Store Review
↓
phased rollout: 1% → 10% → 50% → 100%
```

### 11.3 Rollback

- Cloud Functions: `firebase functions:rollback` to previous version
- Flutter: phased rollout halt + iOS 24h rollback if Apple cooperates (rare)
- Database migrations: forward-only; never destructive in MVP

---

## 12. Security & privacy hardening

### 12.1 Photo handling

```
Upload → Firebase Storage (encrypted at rest)
↓
Hero Reveal generation
↓
Schedule deletion job for original photo at +24h
↓
On scheduled execution: delete from Storage, log audit event
```

### 12.2 PII minimization

Stored long-term:
- Email (auth)
- Display name (optional)
- Child first name (story personalization)
- Hero anchor image (stylized, not photo)
- Defining traits text (e.g., "brown hair, glasses")

NOT stored long-term:
- Original child photo (deleted within 24h)
- Voice recordings (deleted within 24h post voice-clone in V1.1)
- IP addresses (only hashed for abuse tracking, 30-day TTL)
- Device fingerprints (only hashed, 30-day TTL)

### 12.3 Account deletion

`deleteAccount` Cloud Function:

1. Delete all subcollections under `/users/{uid}/`
2. Delete all storage paths under `/heroes/{uid}/`, `/stories/{uid}/`, `/uploads/{uid}/`
3. Delete user document
4. Delete ElevenLabs voice model (V1.1)
5. Cancel active subscription (RevenueCat REST API: POST /subscribers/{uid}/subscriptions/{product}/revoke_promotional)
6. Sign out client
7. Send confirmation email
8. Log audit event with timestamp

GDPR compliance: complete within 30 days, with reasonable best-effort within 7 days.

---

## 13. Cost ceilings — alarms to set

Set Firebase budget alerts and provider dashboards. Hard ceiling per month for the first 90 days:

| Provider | Soft alert | Hard ceiling |
|---|---|---|
| RunningHub (image generation) | $300/mo | $800/mo |
| OpenAI (GPT + moderation) | $100/mo | $300/mo |
| ElevenLabs | $200/mo | $500/mo |
| Firebase | $100/mo | $400/mo |
| **Total** | **$700/mo** | **$2000/mo** |

These ceilings assume a few thousand active subscribers. If you hit hard ceilings, kill switch via Remote Config:

```
lullabook:
  generation_enabled: false
  cap_override_message: "We're at capacity tonight — back tomorrow"
```

---

## 14. Open implementation questions for Day 1

These need a decision in the first week, not week-by-week:

1. **State management granularity** — fully Riverpod with code-gen, or BLoC for some flows? **Recommendation: Riverpod everywhere for MVP, simpler.**
2. **Local cache eviction policy** — keep last 10 stories offline, or all? **Recommendation: keep last 10 + favorites. Configurable in Settings.**
3. **Push notification strategy for V1** — how aggressive? **Recommendation: minimal in MVP. One "your story is ready" if generation runs in background. Bedtime reminders deferred to V1.1.**
4. **RunningHub task polling timeout** — current default is 120s per task (vs ~40s avg completion). Should be tightened to 90s to fail faster and trigger retry sooner? **Recommendation: keep 120s for MVP to absorb p95 spikes; tighten in V1.1 with production data.**
5. **First-time user art style default** — do they choose during onboarding, or pick by default ("Pixar-style 3D") with option to change? **Recommendation: default to Pixar-style 3D for fastest onboarding; switchable in Hero settings.**

---

## Appendix A — Day 1 setup script

Run this on a fresh laptop:

```bash
#!/bin/bash
# scripts/setup-dev-env.sh

set -e

echo "→ Installing Flutter dependencies..."
cd flutter_app
flutter pub get
dart run build_runner build --delete-conflicting-outputs

echo "→ Installing functions dependencies..."
cd ../functions
npm install

echo "→ Configuring Firebase emulators..."
cd ..
firebase use lullabook-staging
firebase emulators:start --only auth,firestore,storage,functions &

echo "→ Setup complete. Run 'flutter run' in flutter_app/ to start."
```

---

## Appendix B — Glossary (developer-facing)

- **Hero Card** — the persistent character profile (entity in Firestore)
- **Hero Anchor** — the image asset used as RunningHub visual reference for character + style consistency
- **Hero Reveal** — the F-0 preview image; physically same as Hero Anchor for first-time users
- **Tonight's Adventure** — F-2 setup flow
- **Story Object** — a generated story document with 8 pages
- **Daily Cap** — backend-enforced story generation limit (3/day Weekly, 1/day Yearly)
- **WASGF** — north star: Weekly Active Story Generations per Family

---

*End of technical specification. Update this document as architecture evolves; commit changes alongside code.*
