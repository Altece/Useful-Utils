#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SJBSubscription : NSObject

- (instancetype)initWithOriginator:(nullable id)originator
                  terminationBlock:(void (^)())terminationBlock NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

- (void)cancel;

+ (SJBSubscription *)coalesceSubscriptions:(NSArray<SJBSubscription *> *)subscriptions;

@end

NS_ASSUME_NONNULL_END
