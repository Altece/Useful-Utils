#import "UUTask.h"

#import "UUDispatch.h"

#pragma mark - Task

@implementation UUTask {
    UUTaskBlock _block;
    id<UUDispatch> _dispatcher;
}

- (instancetype)initWithBlock:(UUTaskBlock)block on:(id<UUDispatch>)dispatcher {
    self = [super init];
    if (!self) return nil;
    _block = block;
    _dispatcher = dispatcher;
    return self;
}

- (void)performTask {
    [_dispatcher dispatchBlock:_block];
}

@end

#pragma mark - Value Task

@implementation UUValueTask {
    UUValueTaskBlock _block;
    id<UUDispatch> _dispatcher;
}

- (instancetype)initWithBlock:(void (^)(id))block on:(id<UUDispatch>)dispatcher {
    self = [super init];
    if (!self) return nil;
    _block = block;
    _dispatcher = dispatcher;
    return self;
}

- (void)performTaskWithValue:(id)value {
    [_dispatcher dispatchBlock:^{
        _block(value);
    }];
}

@end
