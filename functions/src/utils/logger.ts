import { logger as functionsLogger } from 'firebase-functions';

export const logger = {
  info: (message: string, data?: Record<string, unknown>) =>
    functionsLogger.info(message, { ...data }),

  warn: (message: string, data?: Record<string, unknown>) =>
    functionsLogger.warn(message, { ...data }),

  error: (message: string, data?: Record<string, unknown>) =>
    functionsLogger.error(message, { ...data }),
};
