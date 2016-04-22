#import "SJBSubscription.h"

@implementation SJBSubscription {
    id _originator;
    void (^_terminationBlock)();
}

- (instancetype)initWithOriginator:(id)originator terminationBlock:(void (^)())terminationBlock {
    self = [super init];
    if (!self) return nil;
    _originator = originator;
    _terminationBlock = [terminationBlock copy];
    return self;
}

- (void)dealloc {
    if (_terminationBlock) {
        _terminationBlock();
    }
}

- (void)cancel {
    if (_terminationBlock) {
        _terminationBlock();
        _terminationBlock = nil;
        _originator = nil;
    }
}

+ (SJBSubscription *)coalesceSubscriptions:(NSArray<SJBSubscription *> *)subscriptions {
    return [[[self class] alloc] initWithOriginator:nil terminationBlock:^{
        for (SJBSubscription *subscription in subscriptions) {
            [subscription cancel];
        }
    }];
}

@end
