
#ifdef RCT_NEW_ARCH_ENABLED
#import "RNAppLogsSpec.h"

@interface AppLogs : NSObject <NativeAppLogsSpec>
#else
#import <React/RCTBridgeModule.h>

@interface AppLogs : NSObject <RCTBridgeModule>
#endif

@end
