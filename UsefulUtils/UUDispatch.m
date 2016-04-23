#import "UUDispatch.h"

#import <libkern/OSAtomic.h>

#import "UUCancellable.h"

///
/// A convenience function for creating a cancellable dispatch
/// from a normal dispatcher.
///
static UUCancellable *cancellableDispatch(id<UUDispatch> dispatcher,
                                          dispatch_block_t block) {
    NSLock *lock = [[NSLock alloc] init];
    __block BOOL shouldContinue = YES;
    [dispatcher dispatchBlock:^{
        [lock lock];
        BOOL willContinue = shouldContinue;
        [lock unlock];
        if (willContinue) {
            block();
        }
    }];
    return [[UUCancellable alloc] initWithCancellationBlock:^{
        [lock lock];
        shouldContinue = NO;
        [lock unlock];
    }];
}

#pragma mark - Dispatch Immediately

@implementation UUDispatchImmediately

- (void)dispatchBlock:(dispatch_block_t)block {
    block();
}

+ (instancetype)sharedDispatcher {
    static UUDispatchImmediately *sharedDispatch;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDispatch = [[UUDispatchImmediately alloc] init];
    });
    return sharedDispatch;
}

@end

#pragma mark - Dispatch Sync

@implementation UUDispatchSync {
    dispatch_queue_t _queue;
    BOOL _isMainQueue;
}

- (instancetype)initWithQueue:(dispatch_queue_t)queue {
    self = [super init];
    if (!self) return nil;
    _queue = queue;
    _isMainQueue = (queue == dispatch_get_main_queue());
    return self;
}

- (void)dispatchBlock:(dispatch_block_t)block {
    if (_isMainQueue && [NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(_queue, block);
    }
}

+ (instancetype)mainQueueDispatcher {
    return [[self alloc] initWithQueue:dispatch_get_main_queue()];
}

@end

#pragma mark - Dispatch Async

@implementation UUDispatchAsync {
    dispatch_queue_t _queue;
}

- (instancetype)initWithQueue:(dispatch_queue_t)queue {
    self = [super init];
    if (!self) return nil;
    _queue = queue;
    return self;
}

- (void)dispatchBlock:(dispatch_block_t)block {
    dispatch_async(_queue, block);
}

- (UUCancellable *)dispatchCancellableBlock:(dispatch_block_t)block {
    return cancellableDispatch(self, block);
}

+ (instancetype)mainQueueDispatcher {
    return [[self alloc] initWithQueue:dispatch_get_main_queue()];
}

+ (instancetype)sharedDispatcher {
    static UUDispatchAsync *dispatcher;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *name = @"com.altece.UsefulUtils.DispatchAsync";
        dispatch_queue_t queue = [UUDispatchQueue concurrentQueueWithName:name];
        dispatcher = [[self alloc] initWithQueue:queue];
    });
    return dispatcher;
}

@end

#pragma mark - Dispatch After

@implementation UUDispatchAfter {
    NSTimeInterval _delay;
    dispatch_queue_t _queue;
}

- (instancetype)initWithQueue:(dispatch_queue_t)queue timeDelay:(NSTimeInterval)delay {
    self = [super init];
    if (!self) return nil;
    _queue = queue;
    _delay = delay;
    return self;
}

- (void)dispatchBlock:(dispatch_block_t)block {
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_delay * NSEC_PER_SEC));
    dispatch_after(time, _queue, block);
}

- (UUCancellable *)dispatchCancellableBlock:(dispatch_block_t)block {
    return cancellableDispatch(self, block);
}

+ (instancetype)mainQueueDispatcher {
    return [[self alloc] initWithQueue:dispatch_get_main_queue()];
}

+ (instancetype)sharedDispatcher {
    static UUDispatchAfter *dispatcher;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *name = @"com.altece.UsefulUtils.DispatchAfter";
        dispatch_queue_t queue = [UUDispatchQueue concurrentQueueWithName:name];
        dispatcher = [[self alloc] initWithQueue:queue];
    });
    return dispatcher;
}

@end

#pragma mark - Dispatch Once

@implementation UUDispatchOnce {
    dispatch_once_t _onceToken;
}

- (instancetype)init {
    self = [super init];
    OSMemoryBarrier();
    return self;
}

- (void)dispatchBlock:(dispatch_block_t)block {
    dispatch_once(&_onceToken, block);
}

@end

#pragma mark - Dispatch Qeue

@implementation UUDispatchQueue

+ (dispatch_queue_t)concurrentQueueWithName:(NSString *)name {
    return dispatch_queue_create([name UTF8String] ?: "", DISPATCH_QUEUE_CONCURRENT);
}

+ (dispatch_queue_t)serialQueueWithName:(NSString *)name {
    return dispatch_queue_create([name UTF8String] ?: "", DISPATCH_QUEUE_SERIAL);
}

+ (nullable dispatch_queue_t)globalQueueWithPriority:(dispatch_queue_priority_t)priority {
    return dispatch_get_global_queue(priority, 0);
}

@end
