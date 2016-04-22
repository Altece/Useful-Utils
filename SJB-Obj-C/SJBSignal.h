#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SJBSource<T>;
@class SJBSubscription;

@interface SJBSignal : NSObject

- (instancetype)init NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithSource:(SJBSource *)source;

- (void)notify;

- (SJBSubscription *)subscribeNext:(void (^)())block;

+ (SJBSignal *)coalesceSignals:(NSArray<SJBSignal *> *)signals;

@end

NS_ASSUME_NONNULL_END
