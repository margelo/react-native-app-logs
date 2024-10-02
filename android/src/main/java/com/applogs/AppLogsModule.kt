package com.applogs

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.Promise

class AppLogsModule internal constructor(context: ReactApplicationContext) :
  AppLogsSpec(context) {

  override fun getName(): String {
    return NAME
  }

  override fun addFilterCondition(filter: String?) {
  }

  override fun removeFilterCondition(filter: String?) {
  }

  override fun configureAppGroupName(appGroupName: String?) {
  }

  companion object {
    const val NAME = "AppLogs"
  }
}
