#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

///
/// An object to represent an operation which can optionally be cancelled.
/// It is not necessary to retain a reference to this object
/// if it does not need to be cancelled.
///
@interface SBCancellable : NSObject

///
/// Initialize a new cancellable with the given cancellation block.
/// @param block The cancellation block which can be used to perform whatever
///              operations are necessary to cancel the operation.
///              This block is not guaranteed to be called, but would not
///              be called more than once.
///
- (instancetype)initWithCancellationBlock:(void (^)())block NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

///
/// End the operation associated with this cancellable.
///
- (void)cancel;

///
/// Merge a collection of cancellable objects into one such that
/// they can all be cancelled at once.
///
+ (SBCancellable *)coalesceCancellables:(NSArray<SBCancellable *> *)cancellables;

@end

NS_ASSUME_NONNULL_END
