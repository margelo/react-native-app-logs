import AppLogs from 'react-native-app-logs';

AppLogs.registerHandler({
  filter: '[AppName]',
  handler: ({filter, logs}) => {
    console.log(logs);
  },
});

export default function App() {
  return null;
}
