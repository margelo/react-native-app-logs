import type { TurboModule } from 'react-native';
export interface Spec extends TurboModule {
    addFilterCondition(filter: string): void;
    removeFilterCondition(filter: string): void;
    configureAppGroupName(appGroupName: string): void;
}
declare const _default: Spec;
export default _default;
//# sourceMappingURL=NativeAppLogs.d.ts.map