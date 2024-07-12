
#ifdef RCT_NEW_ARCH_ENABLED
#import "RNAppLogsSpec.h"
#endif

#import <React/RCTEventEmitter.h>

@interface AppLogs : RCTEventEmitter
- (void)sendEvent:(NSString *)name body:(id)body;
@end
