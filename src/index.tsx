import { NativeEventEmitter, NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-app-logs' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

// @ts-expect-error
const isTurboModuleEnabled = global.__turboModuleProxy != null;

const AppLogsModule = isTurboModuleEnabled
  ? require('./NativeAppLogs').default
  : NativeModules.AppLogs;

const AppLogs = AppLogsModule
  ? AppLogsModule
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

const eventEmitter = new NativeEventEmitter(AppLogs);

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

const AppLogsEvents = {
  registerHandler: ({
    handler,
    filter = '',
  }: {
    handler: (params: { logs: NativeLog[]; filter: string }) => void;
    filter?: string;
  }) => {
    AppLogs.addFilterCondition(filter);
    const subscription = eventEmitter.addListener('newLogAvailable', handler);

    return {
      remove: () => {
        AppLogs.removeFilterCondition(filter);
        subscription.remove();
      },
    };
  },
  configureAppGroupName: AppLogs.configureAppGroupName,
};

export default AppLogsEvents;
