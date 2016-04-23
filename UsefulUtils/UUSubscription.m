#import "UUSubscription.h"

#import "UUDispatch.h"

@implementation UUSubscription {
    id _originator;
    void (^_cancellationBlock)();
    UUDispatchOnce *_dispatchOnce;
}

- (instancetype)initWithOriginator:(id)originator cancellationBlock:(void (^)())cancellationBlock {
    self = [super init];
    if (!self) return nil;
    _originator = originator;
    _cancellationBlock = [cancellationBlock copy];
    _dispatchOnce = [[UUDispatchOnce alloc] init];
    return self;
}

- (void)dealloc {
    [_dispatchOnce dispatchBlock:^{
        if (_cancellationBlock) {
            _cancellationBlock();
        }
    }];
}

- (void)cancel {
    [_dispatchOnce dispatchBlock:^{
        if (_cancellationBlock) {
            _cancellationBlock();
            _cancellationBlock = nil;
            _originator = nil;
        }
    }];
}

+ (UUSubscription *)coalesceSubscriptions:(NSArray<UUSubscription *> *)subscriptions {
    return [[[self class] alloc] initWithOriginator:nil cancellationBlock:^{
        for (UUSubscription *subscription in subscriptions) {
            [subscription cancel];
        }
    }];
}

@end
