#import <Foundation/Foundation.h>

#import "UUMacros.h"

NS_ASSUME_NONNULL_BEGIN

@class UUCancellable;

#pragma mark - Dispatcher Protocol Definition

///
/// A protocol to abstract away implementation details when using GCD.
///
@protocol UUDispatcher <NSObject>

///
/// Dispatch the given block using a method specified by the implementation.
///
- (void)dispatchBlock:(dispatch_block_t)block;

@end

///
/// A protocol to descrive a dispatcher that is capable of being cancelled.
///
@protocol UUCancellableDispatcher <NSObject>

///
/// Dispatch the given block using the method specified by the implementation.
/// @returns A cancellable object that can be used to cancel the operation
///          if it hasn't yet begun execution.
///
- (UUCancellable *)dispatchCancellableBlock:(dispatch_block_t)block;

@end

#pragma mark - Dispatch Immediately

///
/// An instance of UUDispatch which immediately calls the passed in block.
///
@interface UUDispatchImmediately : NSObject <UUDispatcher>

+ (instancetype)sharedDispatcher;

@end

#pragma mark - Dispatch Sync

///
/// An instance of UUDispatch which synchroniously calls
/// a block on the given queue.
/// @note If the dispatch sync object was initialized with the main queue
///       and -dispatchBlock: is called from the main queue, the block
///       will be called on immediately instad of using dispatch_sync().
///
@interface UUDispatchSync : NSObject <UUDispatcher>

///
/// Initialize a new dispatch sync object with the given dispatch queue.
///
- (instancetype)initWithQueue:(dispatch_queue_t)queue $designated;

- (instancetype)init $unavailable;

///
/// Create a dispatch sync object for the main queue.
///
+ (instancetype)mainQueueDispatcher;

@end

#pragma mark - Dispatch Async

///
/// An instance of UUDispatch which asynchroniously calls
/// a block on the given queue.
///
@interface UUDispatchAsync : NSObject <UUDispatcher, UUCancellableDispatcher>

///
/// Initialize a new dispatch async object with the given dispatch queue.
///
- (instancetype)initWithQueue:(dispatch_queue_t)queue $designated;

- (instancetype)init $unavailable;

///
/// A dispatch async object for the main queue.
///
+ (instancetype)mainQueueDispatcher;

///
/// A dispatch async object for an unnamed concurrent queue.
///
+ (instancetype)sharedDispatcher;;

@end

#pragma mark - Dispatch After

///
/// An instance of UUDispatch which asynchroniously calls
/// a block on the given queue after a certain amount of time has passed.
///
@interface UUDispatchAfter : NSObject <UUDispatcher, UUCancellableDispatcher>

///
/// Initialize a new dispatch after object with the given
/// dispatch queue and time delay.
/// @param delay The amount of seconds from the time of dispatching
/// before execution should begin.
///
- (instancetype)initWithQueue:(dispatch_queue_t)queue
                    timeDelay:(NSTimeInterval)delay $designated;

- (instancetype)init $unavailable;

///
/// Create a dispatch after object for the main queue.
///
+ (instancetype)mainQueueDispatcher;

///
/// A dispatch after object for an unnamed concurrent queue.
///
+ (instancetype)sharedDispatcher;

@end

#pragma mark - Dispatch Once

///
/// An instance of UUDispatch which will only call the block passed into it once.
/// @note All subsequent calls to -dispatchBlock: will not call on the passed in block.
/// @note Initialization of this object includes a call to OSMemoryBarrier(),
///       which may cause performance issues in some specific circumstances.
///
@interface UUDispatchOnce : NSObject <UUDispatcher>

@end

#pragma mark - Dispatch Queue Factory

///
/// A convenient wrapper around the GCD function calls for creating dispatch queues.
///
@interface UUDispatchQueue : NSObject

///
/// Create a new concurrent queue with the given name.
///
+ (dispatch_queue_t)concurrentQueueWithLabel:(NSString *)label;

///
/// Create a new serial queue with the given name.
///
+ (dispatch_queue_t)serialQueueWithLabel:(NSString *)label;

///
/// Get a global queue for the given priority level, if there is one available,
///
+ (nullable dispatch_queue_t)globalQueueWithPriority:(dispatch_queue_priority_t)priority;

@end

NS_ASSUME_NONNULL_END
