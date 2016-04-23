#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

///
/// An object to represent a subscription to a service.
/// The subscription is kept open until the -cancel method is called,
/// or the subscription is deallocated.
///
@interface SBSubscription : NSObject

///
/// Initialize a new subscription with the given originator and termination block.
/// @param originator A strong reference to the object that is the source of this
///                   subscription. This parameter is optional.
/// @param cancellationBlock A block that, when called upon, will perform whatever
///                          operations are necessary to terminate the subscription.
///                          The block is guaranteed to be called only once.
///
- (instancetype)initWithOriginator:(nullable id)originator
                 cancellationBlock:(void (^)())cancellationBlock NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

///
/// End the subscription early.
///
- (void)cancel;

///
/// Merge a collection of subscriptions into one such that
/// they can all be retained and cancelled at once.
///
+ (SBSubscription *)coalesceSubscriptions:(NSArray<SBSubscription *> *)subscriptions;

@end

NS_ASSUME_NONNULL_END
