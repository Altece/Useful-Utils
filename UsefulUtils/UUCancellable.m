#import "UUCancellable.h"

#import "UUDispatch.h"

@implementation UUCancellable {
    void (^_cancellationBlock)();
    UUDispatchOnce *_dispatchOnce;
}

- (id)initWithCancellationBlock:(void (^)())block {
    self = [super init];
    if (!self) return nil;
    NSAssert(block != nil, @"Cancellable with a nil cancellation block is not allowed.");
    _cancellationBlock = [block copy];
    _dispatchOnce = [[UUDispatchOnce alloc] init];
    return self;
}

- (void)cancel {
    [_dispatchOnce dispatchBlock:^{
        if (_cancellationBlock) {
            _cancellationBlock();
            _cancellationBlock = nil;
        }
    }];
}

+ (UUCancellable *)coalesceCancellables:(NSArray<UUCancellable *> *)cancellables {
    return [[[self class] alloc] initWithCancellationBlock:^{
        for (UUCancellable *cancellable in cancellables) {
            [cancellable cancel];
        }
    }];
}

@end
