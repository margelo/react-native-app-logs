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
