import type { ConfigureParams, NativeLog } from './types';
declare const AppLogsEvents: {
    registerHandler: ({ handler, filter, }: {
        handler: (params: {
            logs: NativeLog[];
            filter: string;
        }) => void;
        filter?: string;
    }) => {
        remove: () => void;
    };
    configure: (params: ConfigureParams) => void;
};
export default AppLogsEvents;
//# sourceMappingURL=bindings.ios.d.ts.map