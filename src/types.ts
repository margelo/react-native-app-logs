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
export type ConfigureParams = {
  /** common `appGroupName` shared between targets (iOS only) */
  appGroupName?: string;
  /** interval (in seconds) to fetch logs (iOS only). Specify `-1` if you don't want to run periodic checks */
  interval: number;
};
