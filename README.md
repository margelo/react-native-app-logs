# react-native-app-logs

Access native logs from JS code

## Installation

```sh
npm install react-native-app-logs
```

## Usage

### Basic usage

The code snippet below will intercept all logs from the main app.

```js
import AppLogs from 'react-native-app-logs';

// ...

AppLogs.registerHandler({
  filter: '[AppName]',
  handler: ({ filter, logs }) => {
    if (logs.length !== 0) {
      Alert.alert(filter, logs.join('\n'));
    }
  },
});
```

### Intercept logs from `NotificationServiceExtension`

On iOS each process has its own logs and they live only within the process (and do not share the logs with other processes).

To intercept logs from `NotificationServiceExtension` you need to:

- give common app group;
- add new Pod to your `NotificationServiceExtension`;
- forward logs from `NotificationServiceExtension` to the main app.

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
