import type { NativeLog } from './types';

const AppLogsEvents = {
  registerHandler: (_fn: {
    handler: (params: { logs: NativeLog[]; filter: string }) => void;
    filter?: string;
  }) => {
    // no-op
    return { remove: () => {} };
  },
  configureAppGroupName: (_appGroupName: string) => {
    // no-op
  },
};

export default AppLogsEvents;
