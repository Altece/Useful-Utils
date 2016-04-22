#import "SBCancellable.h"

@implementation SBCancellable {
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

+ (SBCancellable *)coalesceCancellables:(NSArray<SBCancellable *> *)cancellables {
    return [[[self class] alloc] initWithCancellationBlock:^{
        for (SBCancellable *cancellable in cancellables) {
            [cancellable cancel];
        }
    }];
}

@end
