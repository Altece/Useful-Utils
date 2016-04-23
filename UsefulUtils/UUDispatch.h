#import <Foundation/Foundation.h>

#pragma mark - Dispatcher Protocol Definition

///
/// A protocol to abstract away implementation details when using GCD.
///
@protocol UUDispatch <NSObject>

///
/// Dispatch the given block using a method specified by the implementation.
///
- (void)dispatchBlock:(dispatch_block_t)block;

@end

#pragma mark - Dispatch Immediately

///
/// An instance of UUDispatch which immediately calls the passed in block.
///
@interface UUDispatchImmediately : NSObject <UUDispatch>

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
@interface UUDispatchSync : NSObject <UUDispatch>

///
/// Initialize a new dispatch sync object with the given dispatch queue.
///
- (instancetype)initWithQueue:(dispatch_queue_t)queue NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

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
@interface UUDispatchAsync : NSObject <UUDispatch>

///
/// Initialize a new dispatch async object with the given dispatch queue.
///
- (instancetype)initWithQueue:(dispatch_queue_t)queue NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

///
/// Create a dispatch async object for the main queue.
///
+ (instancetype)mainQueueDispatcher;

@end

#pragma mark - Dispatch After

///
/// An instance of UUDispatch which asynchroniously calls
/// a block on the given queue after a certain amount of time has passed.
///
@interface UUDispatchAfter : NSObject <UUDispatch>

///
/// Initialize a new dispatch after object with the given dispatch queue and time delay.
///
- (instancetype)initWithQueue:(dispatch_queue_t)queue
                    timeDelay:(NSTimeInterval)delay NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

///
/// Create a dispatch after object for the main queue.
///
+ (instancetype)mainQueueDispatcher;

@end

#pragma mark - Dispatch Once

///
/// An instance of UUDispatch which will only call the block passed into it once.
/// @note All subsequent calls to -dispatchBlock: will not call on the passed in block.
/// @note Initialization of this object includes a call to OSMemoryBarrier(),
///       which may cause performance issues in some specific circumstances.
///
@interface UUDispatchOnce : NSObject <UUDispatch>

@end
