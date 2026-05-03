import { getFirestore, FieldValue } from 'firebase-admin/firestore';
import { UserDoc } from '../entities/User';


export class DailyCapManager {
  private db = getFirestore();

  constructor(private uid: string) {}

  async canGenerate(): Promise<{ allowed: boolean; reason?: string }> {
    // TODO: re-enable cap enforcement before launch
    return { allowed: true };
  }

  async incrementUsage(): Promise<void> {
    const snap = await this.db.collection('users').doc(this.uid).get();
    const user = snap.data() as UserDoc | undefined;
    if (!user) return;

    const today = this.todayString(user.timezone ?? 'UTC');

    if (!user.dailyUsage || user.dailyUsage.date !== today) {
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
