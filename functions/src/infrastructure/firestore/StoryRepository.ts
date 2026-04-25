import { getFirestore, FieldValue, Timestamp } from 'firebase-admin/firestore';
import { StoryDoc, StoryPage, GenerationMetadata } from '../../domain/entities/Story';
import { v4 as uuidv4 } from 'uuid';

export class StoryRepository {
  private db = getFirestore();

  private col(uid: string) {
    return this.db.collection('users').doc(uid).collection('stories');
  }

  async create(
    uid: string,
    data: Omit<StoryDoc, 'storyId' | 'readCount' | 'lastReadAt' | 'favorite' | 'createdAt'>
  ): Promise<StoryDoc> {
    const storyId = uuidv4();

    const doc: StoryDoc = {
      storyId,
      heroId: data.heroId,
      title: data.title,
      language: data.language,
      setup: data.setup,
      pages: data.pages,
      durationSeconds: data.durationSeconds,
      readCount: 0,
      lastReadAt: null,
      favorite: false,
      generationMetadata: data.generationMetadata,
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
