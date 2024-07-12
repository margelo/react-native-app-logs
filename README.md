# react-native-app-logs

Access native logs from JS code

## Installation

```sh
npm install react-native-app-logs
```

## Usage

```js
import AppLogs from 'react-native-app-logs';

// ...

AppLogs.registerHandler({
  filter: '[AppName]',
  handler: ({filter, logs}) => {
    console.log(logs);
  },
});
```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
