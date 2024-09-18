const NOOP = () => {};
const AppLogsEvents = {
  registerHandler: () => ({ remove: NOOP }),
  configureAppGroupName: NOOP,
};

export default AppLogsEvents;
