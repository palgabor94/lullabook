import { getFirestore, FieldValue } from 'firebase-admin/firestore';
import { UserDoc } from '../../domain/entities/User';

export class UserRepository {
  private db = getFirestore();
  private col = this.db.collection('users');

  async get(uid: string): Promise<UserDoc | null> {
    const snap = await this.col.doc(uid).get();
    return snap.exists ? (snap.data() as UserDoc) : null;
  }

  async create(uid: string, email: string, displayName: string | null): Promise<void> {
    await this.col.doc(uid).set({
      uid,
      email,
      displayName,
      locale: 'en-US',
      contentLanguage: 'en-US',
      timezone: 'UTC',
      createdAt: FieldValue.serverTimestamp(),
      lastActiveAt: FieldValue.serverTimestamp(),
      subscription: {
        tier: 'free',
        purchaseSource: null,
        subscriptionId: null,
        expiresAt: null,
        isInTrial: false,
        cancelledAt: null,
      },
      dailyUsage: {
        date: '',
        storiesGenerated: 0,
      },
      totalStoriesCreated: 0,
      totalHeroesCreated: 0,
      previewsUsed: 0,
      hasVoiceModel: false,
      voiceModelId: null,
    } satisfies Omit<UserDoc, 'createdAt' | 'lastActiveAt'> & {
      createdAt: ReturnType<typeof FieldValue.serverTimestamp>;
      lastActiveAt: ReturnType<typeof FieldValue.serverTimestamp>;
    });
  }

  async updateLastActive(uid: string): Promise<void> {
    await this.col.doc(uid).update({
      lastActiveAt: FieldValue.serverTimestamp(),
    });
  }
}
