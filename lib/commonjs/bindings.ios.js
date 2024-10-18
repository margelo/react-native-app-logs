"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = void 0;
var _reactNative = require("react-native");
const LINKING_ERROR = `The package 'react-native-app-logs' doesn't seem to be linked. Make sure: \n\n` + _reactNative.Platform.select({
  ios: "- You have run 'pod install'\n",
  default: ''
}) + '- You rebuilt the app after installing the package\n' + '- You are not using Expo Go\n';

// @ts-expect-error
const isTurboModuleEnabled = global.__turboModuleProxy != null;
const AppLogsModule = isTurboModuleEnabled ? require('./NativeAppLogs').default : _reactNative.NativeModules.AppLogs;
const AppLogs = AppLogsModule ? AppLogsModule : new Proxy({}, {
  get() {
    throw new Error(LINKING_ERROR);
  }
});
const eventEmitter = new _reactNative.NativeEventEmitter(AppLogs);
const AppLogsEvents = {
  registerHandler: ({
    handler,
    filter = ''
  }) => {
    AppLogs.addFilterCondition(filter);
    const subscription = eventEmitter.addListener('newLogAvailable', handler);
    return {
      remove: () => {
        AppLogs.removeFilterCondition(filter);
        subscription.remove();
      }
    };
  },
  configure: AppLogs.configure
};
var _default = exports.default = AppLogsEvents;
//# sourceMappingURL=bindings.ios.js.map