import type { ConfigureParams, NativeLog } from './types';
declare const AppLogsEvents: {
    registerHandler: (_fn: {
        handler: (params: {
            logs: NativeLog[];
            filter: string;
        }) => void;
        filter?: string;
    }) => {
        remove: () => void;
    };
    configure: (_params: ConfigureParams) => void;
};
export default AppLogsEvents;
//# sourceMappingURL=bindings.d.ts.map