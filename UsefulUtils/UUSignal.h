#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class UUSource<T>;
@class UUSubscription;

///
/// An object which represents the occurrence of a specific event.
///
@interface UUSignal : NSObject

///
/// Initialise a new signal object.
///
- (instancetype)init NS_DESIGNATED_INITIALIZER;

///
/// Initialize a new signal object that will notify subscribers
/// whenever a new value is pushed to the given source.
///
- (instancetype)initWithSource:(UUSource *)source;

///
/// Call on all subscribed blocks to notify them that the event has occurred.
///
- (void)notify;

///
/// Subscribe a block to be notified whenever the signal notifies its subscribers.
///
- (UUSubscription *)subscribeNext:(void (^)())block;

///
/// Merge a collection of signals into one such that when any one of them
/// have their subscribers notified, subscribers to the merged signal will
/// also be notified.
/// @note Calling -notify on the resulting signal will only notify subscribers
///       to the merged signal. Subscribers to the component signals will not
///       be notified.
///
+ (UUSignal *)coalesceSignals:(NSArray<UUSignal *> *)signals;

@end

NS_ASSUME_NONNULL_END
