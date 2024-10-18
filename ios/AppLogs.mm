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
    NSMutableDictionary<NSString *, NSNumber *> *filters;
  }

RCT_EXPORT_MODULE()

- (instancetype)init
{
  self = [super init];

  filters = [[NSMutableDictionary alloc] init];
  logStoreHelper = [[OSLogStoreHelper alloc] initOnNewLogs: ^(NSArray<NSDictionary *> *logs) {
      for (NSString *filter in self->filters) {
          NSPredicate *predicate = [NSPredicate predicateWithFormat:@"message CONTAINS[c] %@", filter];
          NSArray *filteredLogs = [logs filteredArrayUsingPredicate:predicate];
          [self sendEvent:@"newLogAvailable" body:@{ @"filter": filter, @"logs": filteredLogs }];
      }
  }];

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
    NSNumber *count = [filters objectForKey:filter];
    if (count) {
        [filters setObject:@([count integerValue] + 1) forKey:filter];
    } else {
        [filters setObject:@1 forKey:filter];
    }
    
    resolve(filter);
}

RCT_EXPORT_METHOD(removeFilterCondition:(NSString *)filter
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
    NSNumber *count = [filters objectForKey:filter];
    if (count) {
        NSInteger newCount = [count integerValue] - 1;
        if (newCount > 0) {
            [filters setObject:@(newCount) forKey:filter];
        } else {
            [filters removeObjectForKey:filter];
        }
    }
    
    resolve(filter);
}

RCT_EXPORT_METHOD(configure:(NSDictionary *)params
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
    NSString *appGroupName = params[@"appGroupName"];
    if (appGroupName != nil) {
      [logStoreHelper setAppGroupName: params[@"appGroupName"]];
    }
    NSNumber *interval = params[@"interval"];
  
    if ([interval compare:@-1] != NSOrderedSame) {
      // Set up a timer to check for new logs periodically
      dispatch_async(dispatch_get_main_queue(), ^{
          [NSTimer scheduledTimerWithTimeInterval:[interval doubleValue]
                                           target:self
                                         selector:@selector(checkForNewLogs)
                                         userInfo:nil
                                          repeats:YES];
      });
    }

    resolve(appGroupName);
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
