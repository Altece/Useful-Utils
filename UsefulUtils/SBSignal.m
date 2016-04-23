#import "SBSignal.h"

#import "SBSource.h"
#import "SBSubscription.h"

@implementation SBSignal {
    NSMutableArray<void (^)()> *_subscribers;
    SBSubscription *_internalSubscription;
}

- (id)init {
    self = [super init];
    if (!self) return nil;
    _subscribers = [[NSMutableArray alloc] init];
    return self;
}

- (id)initWithSource:(SBSource *)source {
    self = [self init];
    if (!self) return nil;
    __weak SBSignal *weakSelf = self;
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

- (SBSubscription *)subscribeNext:(void (^)())block {
    block = [block copy];
    [_subscribers addObject:block];
    return [[SBSubscription alloc] initWithOriginator:self terminationBlock:^{
        [_subscribers removeObject:block];
    }];
}

+ (SBSignal *)coalesceSignals:(NSArray<SBSignal *> *)signals {
    SBSignal *resultingSignal = [[[self class] alloc] init];
    NSMutableArray *subscriptions = [[NSMutableArray alloc] init];
    for (SBSignal *signal in signals) {
        SBSubscription *subscription = [signal subscribeNext:^{
            [resultingSignal notify];
        }];
        [subscriptions addObject:subscription];
    }
    resultingSignal->_internalSubscription = [SBSubscription coalesceSubscriptions:subscriptions];
    return resultingSignal;
}

@end
