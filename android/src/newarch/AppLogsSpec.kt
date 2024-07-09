package com.applogs

import com.facebook.react.bridge.ReactApplicationContext

abstract class AppLogsSpec internal constructor(context: ReactApplicationContext) :
  NativeAppLogsSpec(context) {
}
