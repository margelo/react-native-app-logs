import type { NativeLog } from './types';
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
    configureAppGroupName: (_appGroupName: string) => void;
};
export default AppLogsEvents;
//# sourceMappingURL=bindings.d.ts.map