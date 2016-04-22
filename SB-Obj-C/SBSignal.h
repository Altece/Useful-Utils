#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SBSource<T>;
@class SBSubscription;

@interface SBSignal : NSObject

- (instancetype)init NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithSource:(SBSource *)source;

- (void)notify;

- (SBSubscription *)subscribeNext:(void (^)())block;

+ (SBSignal *)coalesceSignals:(NSArray<SBSignal *> *)signals;

@end

NS_ASSUME_NONNULL_END
