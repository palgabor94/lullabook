import { getFirestore, FieldValue, Timestamp } from 'firebase-admin/firestore';

export interface BuddyDoc {
  buddyId: string;
  type: string;
  name?: string;
  photoUrl?: string;
  photoThumbUrl?: string;
  photoStoragePath?: string;
  createdAt: Timestamp;
}

export class BuddyRepository {
  private db = getFirestore();

  private col(uid: string) {
    return this.db.collection('users').doc(uid).collection('buddies');
  }

  async upsert(uid: string, buddy: Omit<BuddyDoc, 'createdAt'>): Promise<void> {
    const ref = this.col(uid).doc(buddy.buddyId);
    const snap = await ref.get();
    if (snap.exists) {
      await ref.update({ ...buddy });
    } else {
      await ref.set({ ...buddy, createdAt: FieldValue.serverTimestamp() });
    }
  }

  async get(uid: string, buddyId: string): Promise<BuddyDoc | null> {
    const snap = await this.col(uid).doc(buddyId).get();
    return snap.exists ? (snap.data() as BuddyDoc) : null;
  }
}
