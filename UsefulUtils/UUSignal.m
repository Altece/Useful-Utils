#import "UUSignal.h"

#import "UUSource.h"
#import "UUSubscription.h"

@implementation UUSignal {
    NSMutableArray<void (^)()> *_subscribers;
    UUSubscription *_internalSubscription;
}

- (id)init {
    self = [super init];
    if (!self) return nil;
    _subscribers = [[NSMutableArray alloc] init];
    return self;
}

- (id)initWithSource:(UUSource *)source {
    self = [self init];
    if (!self) return nil;
    __weak UUSignal *weakSelf = self;
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

- (UUSubscription *)subscribeNext:(void (^)())block {
    block = [block copy];
    [_subscribers addObject:block];
    return [[UUSubscription alloc] initWithOriginator:self terminationBlock:^{
        [_subscribers removeObject:block];
    }];
}

+ (UUSignal *)coalesceSignals:(NSArray<UUSignal *> *)signals {
    UUSignal *resultingSignal = [[[self class] alloc] init];
    NSMutableArray *subscriptions = [[NSMutableArray alloc] init];
    for (UUSignal *signal in signals) {
        UUSubscription *subscription = [signal subscribeNext:^{
            [resultingSignal notify];
        }];
        [subscriptions addObject:subscription];
    }
    resultingSignal->_internalSubscription = [UUSubscription coalesceSubscriptions:subscriptions];
    return resultingSignal;
}

@end
