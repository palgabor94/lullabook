import { getStorage } from 'firebase-admin/storage';

export class AssetUploader {
  private bucket = getStorage().bucket();

  async uploadTempPhoto(fingerprint: string, buffer: Buffer): Promise<string> {
    const path = `uploads/preview_temp/${fingerprint}_${Date.now()}.jpg`;
    await this.upload(path, buffer, 'image/jpeg');
    return path;
  }

  async uploadPreviewImage(previewId: string, buffer: Buffer): Promise<string> {
    const path = `previews/${previewId}/reveal.png`;
    await this.upload(path, buffer, 'image/png');
    return await this.publicUrl(path);
  }

  async uploadHeroAnchor(uid: string, heroId: string, buffer: Buffer): Promise<{ storagePath: string; imageUrl: string; thumbUrl: string }> {
    const storagePath = `heroes/${uid}/${heroId}/anchor.png`;
    await this.upload(storagePath, buffer, 'image/png');
    const imageUrl = await this.publicUrl(storagePath);
    // Thumbnail: reuse same image for MVP; resize in V1.1
    return { storagePath, imageUrl, thumbUrl: imageUrl };
  }

  async uploadBuddyPhoto(uid: string, buddyId: string, buffer: Buffer): Promise<{ storagePath: string; imageUrl: string }> {
    const storagePath = `buddies/${uid}/${buddyId}/photo.jpg`;
    await this.upload(storagePath, buffer, 'image/jpeg');
    const imageUrl = await this.publicUrl(storagePath);
    return { storagePath, imageUrl };
  }

  async uploadStoryCoverImage(uid: string, storyId: string, buffer: Buffer): Promise<{ storagePath: string; imageUrl: string }> {
    const storagePath = `stories/${uid}/${storyId}/cover.png`;
    await this.upload(storagePath, buffer, 'image/png');
    const imageUrl = await this.publicUrl(storagePath);
    return { storagePath, imageUrl };
  }

  async uploadStoryPageImage(uid: string, storyId: string, pageNum: number, buffer: Buffer): Promise<string> {
    const path = `stories/${uid}/${storyId}/page_${pageNum}.png`;
    await this.upload(path, buffer, 'image/png');
    return await this.publicUrl(path);
  }

  async uploadStoryPageAudio(uid: string, storyId: string, pageNum: number, buffer: Buffer): Promise<string> {
    const path = `stories/${uid}/${storyId}/page_${pageNum}.mp3`;
    await this.upload(path, buffer, 'audio/mpeg');
    return await this.publicUrl(path);
  }

  private async upload(path: string, buffer: Buffer, contentType: string): Promise<void> {
    const file = this.bucket.file(path);
    await file.save(buffer, { contentType, resumable: false });
  }

  private async publicUrl(path: string): Promise<string> {
    const file = this.bucket.file(path);
    const [url] = await file.getSignedUrl({
      action: 'read',
      expires: Date.now() + 365 * 24 * 60 * 60 * 1000,
    });
    return url;
  }
}
