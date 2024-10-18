import type { ConfigureParams, NativeLog } from './types';

const AppLogsEvents = {
  registerHandler: (_fn: {
    handler: (params: { logs: NativeLog[]; filter: string }) => void;
    filter?: string;
  }) => {
    // no-op
    return { remove: () => {} };
  },
  configure: (_params: ConfigureParams) => {
    // no-op
  },
};

export default AppLogsEvents;
