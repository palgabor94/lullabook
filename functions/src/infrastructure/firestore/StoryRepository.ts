import { getFirestore, FieldValue, Timestamp } from 'firebase-admin/firestore';
import { StoryDoc, StoryPage, GenerationMetadata, AdventureSetup } from '../../domain/entities/Story';

export class StoryRepository {
  private db = getFirestore();

  private col(uid: string) {
    return this.db.collection('users').doc(uid).collection('stories');
  }

  // Step 1: create a minimal stub so Flutter can subscribe before generation completes
  async initPending(
    uid: string,
    storyId: string,
    data: { heroId: string; title: string; language: string; setup: AdventureSetup }
  ): Promise<void> {
    await this.col(uid).doc(storyId).set({
      storyId,
      heroId: data.heroId,
      title: data.title,
      language: data.language,
      setup: data.setup,
      status: 'cover_generating',
      coverImageUrl: '',
      coverCaption: '',
      pages: [],
      durationSeconds: 0,
      readCount: 0,
      lastReadAt: null,
      favorite: false,
      generationMetadata: null,
      createdAt: Timestamp.now(),
    });
  }

  // Step 2: cover image is ready — Flutter shows it while pages generate
  async updateCoverReady(
    uid: string,
    storyId: string,
    coverImageUrl: string,
    coverCaption: string
  ): Promise<void> {
    await this.col(uid).doc(storyId).update({
      status: 'cover_ready',
      coverImageUrl,
      coverCaption,
    });
  }

  // Step 2 error path: cover failed, pages will still generate
  async updateCoverError(uid: string, storyId: string): Promise<void> {
    await this.col(uid).doc(storyId).update({ status: 'cover_error' });
  }

  // Step 3: finalize — all pages and audio are ready
  async finalize(
    uid: string,
    storyId: string,
    data: Omit<StoryDoc, 'storyId' | 'readCount' | 'lastReadAt' | 'favorite' | 'createdAt'>
  ): Promise<StoryDoc> {
    const doc: StoryDoc = {
      storyId,
      ...data,
      readCount: 0,
      lastReadAt: null,
      favorite: false,
      createdAt: Timestamp.now(),
    };

    await this.col(uid).doc(storyId).set(doc);
    await this.db.collection('users').doc(uid).update({
      totalStoriesCreated: FieldValue.increment(1),
    });

    return doc;
  }

  async get(uid: string, storyId: string): Promise<StoryDoc | null> {
    const snap = await this.col(uid).doc(storyId).get();
    return snap.exists ? (snap.data() as StoryDoc) : null;
  }

  async listForHero(uid: string, heroId: string): Promise<StoryDoc[]> {
    const snap = await this.col(uid)
      .where('heroId', '==', heroId)
      .orderBy('createdAt', 'desc')
      .get();
    return snap.docs.map((d) => d.data() as StoryDoc);
  }

  async listForUser(uid: string): Promise<StoryDoc[]> {
    const snap = await this.col(uid).orderBy('createdAt', 'desc').get();
    return snap.docs.map((d) => d.data() as StoryDoc);
  }

  async updatePage(
    uid: string,
    storyId: string,
    pageNumber: number,
    pageData: Pick<StoryPage, 'imageUrl' | 'imagePrompt'>
  ): Promise<void> {
    const snap = await this.col(uid).doc(storyId).get();
    if (!snap.exists) throw new Error('story_not_found');

    const story = snap.data() as StoryDoc;
    const pages = story.pages.map((p) =>
      p.pageNumber === pageNumber ? { ...p, ...pageData } : p
    );

    const metaUpdate: Partial<GenerationMetadata> = {
      retryCount: story.generationMetadata.retryCount + 1,
    };

    await this.col(uid).doc(storyId).update({
      pages,
      'generationMetadata.retryCount': metaUpdate.retryCount,
    });
  }
}
