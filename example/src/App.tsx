import { useEffect, useState } from 'react';
import {
  Alert,
  SafeAreaView,
  ScrollView,
  StyleSheet,
  Text,
} from 'react-native';
import AppLogs from 'react-native-app-logs';

AppLogs.registerHandler({
  filter: '[AppName]',
  handler: ({ logs }) => {
    if (logs.length !== 0) {
      Alert.alert(logs.join('\n'));
    }
  },
});

export default function App() {
  const [logs, setLogs] = useState<string[]>([]);

  useEffect(() => {
    AppLogs.configureAppGroupName('group.applogs.example');

    const listener = AppLogs.registerHandler({
      filter: '[AppName]',
      handler: ({ logs }) => {
        if (logs.length !== 0) {
          setLogs((prev) => [...prev, ...logs]);
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
        {logs.map((log, i) => (
          <Text key={i}>
            {i}. {log}
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
