import { getFirestore, FieldValue } from 'firebase-admin/firestore';
import { UserDoc } from '../entities/User';

// Free tier: 1 lifetime story. Paid tiers: daily cap.
const DAILY_CAP: Record<string, number> = {
  free: 0,      // handled separately via totalStoriesCreated
  weekly: 3,
  yearly: 1,
};

export class DailyCapManager {
  private db = getFirestore();

  constructor(private uid: string) {}

  async canGenerate(): Promise<{ allowed: boolean; reason?: string }> {
    const snap = await this.db.collection('users').doc(this.uid).get();
    if (!snap.exists) return { allowed: false, reason: 'user_not_found' };

    const user = snap.data() as UserDoc;
    const tier = user.subscription.tier;

    if (tier === 'free') {
      if (user.totalStoriesCreated > 0) {
        return { allowed: false, reason: 'free_tier_used' };
      }
      return { allowed: true };
    }

    const cap = DAILY_CAP[tier] ?? 1;
    const today = this.todayString(user.timezone ?? 'UTC');

    if (user.dailyUsage.date !== today) {
      return { allowed: true };
    }

    if (user.dailyUsage.storiesGenerated >= cap) {
      return { allowed: false, reason: 'daily_cap_reached' };
    }

    return { allowed: true };
  }

  async incrementUsage(): Promise<void> {
    const snap = await this.db.collection('users').doc(this.uid).get();
    const user = snap.data() as UserDoc;
    const today = this.todayString(user.timezone ?? 'UTC');

    if (user.dailyUsage.date !== today) {
      await this.db.collection('users').doc(this.uid).update({
        'dailyUsage.date': today,
        'dailyUsage.storiesGenerated': 1,
      });
    } else {
      await this.db.collection('users').doc(this.uid).update({
        'dailyUsage.storiesGenerated': FieldValue.increment(1),
      });
    }
  }

  private todayString(timezone: string): string {
    try {
      return new Intl.DateTimeFormat('en-CA', { timeZone: timezone }).format(new Date());
    } catch {
      return new Intl.DateTimeFormat('en-CA', { timeZone: 'UTC' }).format(new Date());
    }
  }
}
