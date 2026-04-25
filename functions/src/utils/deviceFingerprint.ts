import { createHash } from 'crypto';

export function hashFingerprint(deviceId: string): string {
  return createHash('sha256').update(deviceId).digest('hex');
}

export function hashIp(ip: string): string {
  return createHash('sha256').update(ip).digest('hex');
}
