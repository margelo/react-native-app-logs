import { useEffect, useState } from 'react';
import {
  Alert,
  SafeAreaView,
  ScrollView,
  StyleSheet,
  Text,
} from 'react-native';
import AppLogs, { type NativeLog } from 'react-native-app-logs';

AppLogs.registerHandler({
  filter: '[AppName]',
  handler: ({ logs }) => {
    if (logs.length !== 0) {
      Alert.alert(logs.map((log) => log.message).join('\n'));
    }
  },
});

export default function App() {
  const [history, setHistory] = useState<NativeLog[]>([]);

  useEffect(() => {
    AppLogs.configureAppGroupName('group.applogs.example');

    const listener = AppLogs.registerHandler({
      filter: '[AppName]',
      handler: ({ logs }) => {
        if (logs.length !== 0) {
          setHistory((prev) => [...prev, ...logs]);
        }
      },
    });

    return () => {
      listener.remove();
    };
  }, []);

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView style={styles.container}>
        {history.map((log, i) => (
          <Text key={i}>
            {i}. {log.timestamp} {log.pid}-{log.tid}::{log.process}|{log.level}|
            {' -> '}
            {log.message}
          </Text>
        ))}
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
  },
});
