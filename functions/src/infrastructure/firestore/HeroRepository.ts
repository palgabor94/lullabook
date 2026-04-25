import { getFirestore, FieldValue } from 'firebase-admin/firestore';
import { HeroDoc } from '../../domain/entities/Hero';

export class HeroRepository {
  private db = getFirestore();

  private col(uid: string) {
    return this.db.collection('users').doc(uid).collection('heroes');
  }

  async create(uid: string, hero: Omit<HeroDoc, 'createdAt' | 'updatedAt'>): Promise<void> {
    await this.col(uid).doc(hero.heroId).set({
      ...hero,
      createdAt: FieldValue.serverTimestamp(),
      updatedAt: FieldValue.serverTimestamp(),
    });
    await this.db.collection('users').doc(uid).update({
      totalHeroesCreated: FieldValue.increment(1),
    });
  }

  async get(uid: string, heroId: string): Promise<HeroDoc | null> {
    const snap = await this.col(uid).doc(heroId).get();
    return snap.exists ? (snap.data() as HeroDoc) : null;
  }

  async updateAnchor(
    uid: string,
    heroId: string,
    anchorData: { heroAnchorStoragePath: string; heroAnchorImageUrl: string; heroAnchorThumbUrl: string }
  ): Promise<void> {
    await this.col(uid).doc(heroId).update({
      ...anchorData,
      regenCount: FieldValue.increment(1),
      updatedAt: FieldValue.serverTimestamp(),
    });
  }

  async isFirstStoryForHero(uid: string, heroId: string): Promise<boolean> {
    const snap = await this.db
      .collection('users')
      .doc(uid)
      .collection('stories')
      .where('heroId', '==', heroId)
      .limit(1)
      .get();
    return snap.empty;
  }

  async listForUser(uid: string): Promise<HeroDoc[]> {
    const snap = await this.col(uid).orderBy('createdAt', 'desc').get();
    return snap.docs.map((d) => d.data() as HeroDoc);
  }
}
