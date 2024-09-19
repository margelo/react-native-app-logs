export type NativeLog = {
    message: string;
    timestamp: string;
    process: string;
    /** Process ID */
    pid: number;
    /** Thread ID */
    tid: number;
    level: string;
};
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
    configureAppGroupName: (appGroupName: string) => void;
};
export default AppLogsEvents;
//# sourceMappingURL=index.ios.d.ts.map