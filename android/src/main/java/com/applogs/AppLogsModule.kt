package com.applogs

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableMap

class AppLogsModule internal constructor(context: ReactApplicationContext) :
  AppLogsSpec(context) {

  override fun getName(): String {
    return NAME
  }

  @ReactMethod
  override fun addFilterCondition(filter: String?) {
  }

  @ReactMethod
  override fun removeFilterCondition(filter: String?) {
  }

  @ReactMethod
  override fun configure(params: ReadableMap) {}

  companion object {
    const val NAME = "AppLogs"
  }
}
