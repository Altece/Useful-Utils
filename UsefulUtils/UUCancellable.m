#import "UUCancellable.h"

@implementation UUCancellable {
    void (^_cancellationBlock)();
}

- (id)initWithCancellationBlock:(void (^)())block {
    self = [super init];
    if (!self) return nil;
    NSAssert(block != nil, @"Cancellable with a nil cancellation block is not allowed.");
    _cancellationBlock = [block copy];
    return self;
}

- (void)cancel {
    @synchronized (self) {
        if (_cancellationBlock) {
            _cancellationBlock();
            _cancellationBlock = nil;
        }
    }
}

+ (UUCancellable *)coalesceCancellables:(NSArray<UUCancellable *> *)cancellables {
    return [[[self class] alloc] initWithCancellationBlock:^{
        for (UUCancellable *cancellable in cancellables) {
            [cancellable cancel];
        }
    }];
}

@end
