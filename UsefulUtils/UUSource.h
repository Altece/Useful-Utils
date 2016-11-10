#import <Foundation/Foundation.h>

#import "UUMap.h"
#import "UUMacros.h"

NS_ASSUME_NONNULL_BEGIN

@class UUSignal;
@class UUSubscription;
@protocol UUDispatcher;

///
/// An object which represents a given value as it changes over time.
///
@interface UUSource<T> : NSObject <UUMap>

///
/// A signal to notify subscribers when this source has its value revoked.
///
@property (nonatomic, readonly) UUSignal *revokedSignal;

#pragma mark Initializing a new Source

///
/// Initialize a new source without an initial value.
///
- (instancetype)init $convenience;

///
/// Initialize a new source with the given initial value.
///
- (instancetype)initWithValue:(T)value $designated;

///
/// Initialize a source that will derive its value from the given block
/// whenever the given signal forwards a signal notification.
///
- (id)initWithSignal:(UUSignal *)signal transformationBlock:(id (^)())block $convenience;

#pragma mark Pushing and Revoking Values from Sources

///
/// Set the source's current value to the given value and call on all
/// subscribers to inform them of the new value.
/// @param value The value to send to subscribers.
/// @note Pushing a nil value will result in -revokeValue being called instead.
///
- (void)pushValue:(T)value;

///
/// Remove the source's current value, preventing future subscribers
/// through -subscribe: from immediately receiving a value.
/// @note Calling this method will result in all derived sources having
///       this method called on them as well.
///
- (void)revokeValue;

#pragma mark Subscribing to Sources

///
/// If the source has a current value, call on the given block with it immediately,
/// then have the block receive all future values pushed to the source.
/// @param block The block to be called on with the source's current and future values.
/// @returns A subscription object which must be retained in order to have
///          the subscribed block continue to receive pushed values.
/// @discussion This is a convenience method for -subscribe:on: which
///             uses the shared instance of @c UUDispatchImmediately.
///
- (UUSubscription *)subscribe:(void (^)(T value))block $convenience;

///
/// Call on the given block whenever a value is pushed to the source,
/// starting with the next value to be pushed, and continuing on until
/// the returned subscription is cancelled.
/// @param block The block to be called on with the source's future values.
/// @returns A subscription object which must be retained in order to have
///          the subscribed block continue to receive pushed values.
/// @discussion This is a convenience method for -subscribeNext:on: which
///             uses the shared instance of @c UUDispatchImmediately.
///
- (UUSubscription *)subscribeNext:(void (^)(T value))block $convenience;

///
/// If the source has a current value, call on the given block with it immediately,
/// using the given dispatcher, then have the block receive all future values
/// pushed to the source.
/// @param block The block to be called on with the source's current and future values.
/// @param dispatcher The dispatcher used to call the subscribing block with.
/// @returns A subscription object which must be retained in order to have
///          the subscribed block continue to receive pushed values.
///
- (UUSubscription *)subscribe:(void (^)(T value))block on:(id<UUDispatcher>)dispatcher;

///
/// Call on the given block using the given dispatcher whenever a value
/// is pushed to the source, starting with the next value to be pushed,
/// and continuing on until the returned subscription is cancelled.
/// @param block The block to be called on with the source's future values.
/// @param dispatcher The dispatcher used to call the subscribing block with.
/// @returns A subscription object which must be retained in order to have
///          the subscribed block continue to receive pushed values.
///
- (UUSubscription *)subscribeNext:(void (^)(T))block on:(id<UUDispatcher>)dispatcher;

#pragma mark Creating Derived Sources

///
/// Create a derived source whose values are supplied from this source.
/// @param block The block that ultimately pushes values to the derived source.
///              The block is passed in two values: the derived source that it can
///              push values to, and the value that has just been pushed to the
///              original source. This block must decide whether or not to push
///              values to the derived source, and if so, it must then carry that out.
/// @param The serived source whose values will be provided from a combination of
///        both the original source and the subblied actionable block.
///
- (UUSource *)sourceWithActionableBlock:(void (^)(UUSource *derivedSource, T value))block;

///
/// Create a derived source which contains only values that satisify the supplied condition.
/// @param A block to determine whether a given value should be pushed to the derived source.
///        Return YES to push the value, and NO to ignore the value.
/// @returns A source which contains values from the original source which statsify
///          the gven condition.
///
- (UUSource<T> *)filter:(BOOL (^)(T value))condition;

///
/// Create a derived source which contains values that are derived from the original source
/// and created using the given transformation block.
/// @param transformation A block that is used to supply a new value from the given value.
/// @returns A source which contains values that are derived from values pushed to the
///          original source.
///
- (UUSource *)map:(id (^)(T value))transformation;

@end

NS_ASSUME_NONNULL_END
