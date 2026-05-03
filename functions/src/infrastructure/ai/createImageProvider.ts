import { IImageProvider } from './IImageProvider';
import { RunningHubClient } from './RunningHubClient';
import { NanoBananaClient } from './NanoBananaClient';

export function createImageProvider(
  provider: string,
  runningHubKey: string,
  nanoBananaKey: string,
): IImageProvider {
  if (provider === 'nanobanana') {
    return new NanoBananaClient(nanoBananaKey);
  }
  return new RunningHubClient(runningHubKey);
}
