#import "AppLogs.h"

#if __has_include("react_native_app_logs-Swift.h")
#import "react_native_app_logs-Swift.h"
#else
#import <react_native_app_logs/react_native_app_logs-Swift.h>
#endif

@implementation AppLogs {
    bool hasListeners;
    OSLogStoreHelper *logStoreHelper;
    NSTimer *logCheckTimer;
    NSDate *lastLogCheckTime;
    NSMutableArray<NSString *> *filters;
  }

RCT_EXPORT_MODULE()

- (instancetype)init
{
  self = [super init];

  filters = [[NSMutableArray alloc] init];
  logStoreHelper = [[OSLogStoreHelper alloc] initOnNewLogs: ^(NSArray<NSString *> *logs) {
      for (NSString *filter in self->filters) {
          NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", filter];
          NSArray *filteredLogs = [logs filteredArrayUsingPredicate:predicate];
          [self sendEvent:@"newLogAvailable" body:@{ @"filter": filter, @"logs": filteredLogs }];
      }
  }];
  // Set up a timer to check for new logs periodically
  logCheckTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                              target:self
                                                            selector:@selector(checkForNewLogs)
                                                            userInfo:nil
                                                             repeats:YES];
   lastLogCheckTime = [NSDate dateWithTimeIntervalSince1970:0]; // Start from the epoch time

  return self;
}

- (void)checkForNewLogs {
    [logStoreHelper getNewLogsSince:lastLogCheckTime];
    lastLogCheckTime = [NSDate date];
}

- (void)startObserving
{
  hasListeners = YES;
}

- (void)stopObserving
{
  hasListeners = NO;
}

- (void)sendEvent:(NSString *)name body:(id)body
{
  if (hasListeners) {
    [self sendEventWithName:name body:body];
  }
}

- (NSArray<NSString *> *)supportedEvents
{
  return @[
    @"newLogAvailable",
  ];
}

RCT_EXPORT_METHOD(addFilterCondition:(NSString *)filter
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
    [filters addObject:filter];

    resolve(filter);
}

RCT_EXPORT_METHOD(removeFilterCondition:(NSString *)filter
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
    [filters removeObject:filter];

    resolve(filter);
}

// Don't compile this code when we build for the old architecture.
#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeAppLogsSpecJSI>(params);
}
#endif

@end
