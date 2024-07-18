import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

export interface Spec extends TurboModule {
  addFilterCondition(filter: string): void;
  removeFilterCondition(filter: string): void;
  configureAppGroupName(appGroupName: string): void;
}

export default TurboModuleRegistry.getEnforcing<Spec>('AppLogs');
