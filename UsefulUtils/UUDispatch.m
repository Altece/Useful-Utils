#import "UUDispatch.h"

#import <libkern/OSAtomic.h>

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

+ (instancetype)mainQueueDispatcher {
    return [[self alloc] initWithQueue:dispatch_get_main_queue()];
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

+ (instancetype)mainQueueDispatcher {
    return [[self alloc] initWithQueue:dispatch_get_main_queue()];
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
