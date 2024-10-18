import type { TurboModule } from 'react-native';
import type { Int32 } from 'react-native/Libraries/Types/CodegenTypes';
type ConfigureParams = Readonly<{
    appGroupName: string | undefined;
    interval: Int32;
}>;
export interface Spec extends TurboModule {
    addFilterCondition(filter: string): void;
    removeFilterCondition(filter: string): void;
    configure(params: ConfigureParams): void;
}
declare const _default: Spec;
export default _default;
//# sourceMappingURL=NativeAppLogs.d.ts.map