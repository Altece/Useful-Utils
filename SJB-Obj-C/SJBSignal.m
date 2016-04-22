#import "SJBSignal.h"

#import "SJBSource.h"
#import "SJBSubscription.h"

@implementation SJBSignal {
    NSMutableArray<void (^)()> *_subscribers;
    SJBSubscription *_internalSubscription;
}

- (id)init {
    self = [super init];
    if (!self) return nil;
    _subscribers = [[NSMutableArray alloc] init];
    return self;
}

- (id)initWithSource:(SJBSource *)source {
    self = [self init];
    if (!self) return nil;
    __weak SJBSignal *weakSelf = self;
    _internalSubscription = [source subscribeNext:^(id value) {
        [weakSelf notify];
    }];
    return self;
}

- (void)notify {
    for (void (^block)() in _subscribers) {
        block();
    }
}

- (SJBSubscription *)subscribeNext:(void (^)())block {
    block = [block copy];
    [_subscribers addObject:block];
    return [[SJBSubscription alloc] initWithOriginator:self terminationBlock:^{
        [_subscribers removeObject:block];
    }];
}

+ (SJBSignal *)coalesceSignals:(NSArray<SJBSignal *> *)signals {
    SJBSignal *resultingSignal = [[[self class] alloc] init];
    NSMutableArray *subscriptions = [[NSMutableArray alloc] init];
    for (SJBSignal *signal in signals) {
        SJBSubscription *subscription = [signal subscribeNext:^{
            [resultingSignal notify];
        }];
        [subscriptions addObject:subscription];
    }
    resultingSignal->_internalSubscription = [SJBSubscription coalesceSubscriptions:subscriptions];
    return resultingSignal;
}

@end
