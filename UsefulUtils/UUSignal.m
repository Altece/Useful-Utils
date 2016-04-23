#import "UUSignal.h"

#import "UUDispatch.h"
#import "UUSource.h"
#import "UUSubscription.h"
#import "UUTask.h"

@implementation UUSignal {
    NSMutableArray<UUTask *> *_subscribers;
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
    for (UUTask *subscriber in _subscribers) {
        [subscriber performTask];
    }
}

- (UUSubscription *)subscribeNext:(void (^)())block {
    return [self subscribeNext:block on:[UUDispatchImmediately sharedDispatcher]];
}

- (UUSubscription *)subscribeNext:(void (^)())block on:(id<UUDispatch>)dispatcher {
    UUTask *subscriber = [[UUTask alloc] initWithBlock:block on:dispatcher];
    [_subscribers addObject:subscriber];
    return [[UUSubscription alloc] initWithOriginator:self cancellationBlock:^{
        [_subscribers removeObject:subscriber];
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
