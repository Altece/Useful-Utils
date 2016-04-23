#import "UUSubscription.h"

@implementation UUSubscription {
    id _originator;
    void (^_cancellationBlock)();
}

- (instancetype)initWithOriginator:(id)originator cancellationBlock:(void (^)())cancellationBlock {
    self = [super init];
    if (!self) return nil;
    _originator = originator;
    _cancellationBlock = [cancellationBlock copy];
    return self;
}

- (void)dealloc {
    @synchronized (self) {
        if (_cancellationBlock) {
            _cancellationBlock();
        }
    }
}

- (void)cancel {
    @synchronized (self) {
        if (_cancellationBlock) {
            _cancellationBlock();
            _cancellationBlock = nil;
            _originator = nil;
        }
    }
}

+ (UUSubscription *)coalesceSubscriptions:(NSArray<UUSubscription *> *)subscriptions {
    return [[[self class] alloc] initWithOriginator:nil terminationBlock:^{
        for (UUSubscription *subscription in subscriptions) {
            [subscription cancel];
        }
    }];
}

@end
