#import "SJBCancellable.h"

@implementation SJBCancellable {
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
    if (_cancellationBlock) {
        _cancellationBlock();
        _cancellationBlock = nil;
    }
}

+ (SJBCancellable *)coalesceCancellables:(NSArray<SJBCancellable *> *)cancellables {
    return [[[self class] alloc] initWithCancellationBlock:^{
        for (SJBCancellable *cancellable in cancellables) {
            [cancellable cancel];
        }
    }];
}

@end
