const NOOP = () => {};
const AppLogsEvents = {
  registerHandler: () => ({ remove: NOOP }),
  configure: NOOP,
};

export default AppLogsEvents;
