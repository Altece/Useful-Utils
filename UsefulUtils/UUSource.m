#import "UUSource.h"

#import "UUDispatch.h"
#import "UUSignal.h"
#import "UUSubscription.h"
#import "UUTask.h"

@implementation UUSource {
    NSMutableArray<UUValueTask *> *_subscribers;
    UUSubscription *_Nullable _internalSubscription;
    id _Nullable _value;
}

#pragma mark Initializers

- (id)init {
    id nilValue = nil;
    return [self initWithValue:nilValue];
}

- (id)initWithValue:(id)value {
    self = [super init];
    if (!self) return nil;
    _subscribers = [[NSMutableArray alloc] init];
    _revokedSignal = [[UUSignal alloc] init];
    _value = value;
    return self;
}

- (id)initWithSignal:(UUSignal *)signal transformationBlock:(id (^)())block {
    self = [self init];
    if (!self) return nil;
    NSAssert(signal != nil, @"Creating a source from a nil signal is not allowed.");
    NSAssert(block != nil, @"Creating a source from a signal with a nil transformation block is not allowed.");
    __weak UUSource *weakSelf = self;
    _internalSubscription = [signal subscribeNext:^{
        [weakSelf pushValue:block()];
    }];
    return self;
}

#pragma mark Pushing and Revoking Values

- (void)pushValue:(id)value {
	if (value) {
        _value = value;
        NSArray<UUValueTask *> *subscribers = [_subscribers copy];
        for (UUValueTask *subscriber in subscribers) {
            [subscriber performTaskWithValue:value];
        }
	} else {
        [self revokeValue];
	}
}

- (void)revokeValue {
    _value = nil;
    [_revokedSignal notify];
}

#pragma mark Subscribing

- (UUSubscription *)subscribe:(void (^)(id))block {
    return [self subscribe:block on:[UUDispatchImmediately sharedDispatcher]];
}

- (UUSubscription *)subscribeNext:(void (^)(id))block {
    return [self subscribeNext:block on:[UUDispatchImmediately sharedDispatcher]];
}

- (UUSubscription *)subscribe:(void (^)(id))block on:(id<UUDispatcher>)dispatcher {
    NSAssert(block != nil, @"Subscribing with a nil block is not allowed.");
    return [self subscribeSubscriber:({
        [[UUValueTask alloc] initWithBlock:block on:dispatcher];
    })];
}

- (UUSubscription *)subscribeNext:(void (^)(id))block on:(id<UUDispatcher>)dispatcher {
    NSAssert(block != nil, @"Subscribing next with a nil block is not allowed.");
    return [self subscribeNextSubscriber:({
        [[UUValueTask alloc] initWithBlock:block on:dispatcher];
    })];
}

#pragma mark Internal Subscribing

- (UUSubscription *)subscribeSubscriber:(UUValueTask *)subscriber {
    if (_value) {
        [subscriber performTaskWithValue:_value];
    }
    return [self subscribeNextSubscriber:subscriber];
}

- (UUSubscription *)subscribeNextSubscriber:(UUValueTask *)subscriber {
    [_subscribers addObject:subscriber];
    return [[UUSubscription alloc] initWithOriginator:self cancellationBlock:^{
        [_subscribers removeObject:subscriber];
    }];
}

#pragma mark Derived Sources

- (UUSource *)sourceWithActionableBlock:(void (^)(UUSource *, id))block {
    return [self sourceWithActionableBlock:block on:[UUDispatchImmediately sharedDispatcher]];
}

- (UUSource *)sourceWithActionableBlock:(void (^)(UUSource *, id))block
                                     on:(id<UUDispatcher>)dispatcher {
    NSAssert(block != nil,
             @"Creating a derived source without an actionable block is not allowed.");
    UUSource *source = [[UUSource alloc] init];
    __weak UUSource *weakSource = source;
    UUValueTask *subscriber = [[UUValueTask alloc] initWithBlock:^(id value) {
        UUSource *source = weakSource;
        if (source) {
            block(weakSource, value);
        }
    } on:dispatcher];
    UUSubscription *pushValueSubscription = [self subscribeSubscriber:subscriber];
    UUSubscription *revokeValueSubscription = [_revokedSignal subscribeNext:^{
        [weakSource revokeValue];
    }];
    source->_internalSubscription =
        [UUSubscription coalesceSubscriptions:@[pushValueSubscription, revokeValueSubscription]];
    return source;
}

- (UUSource *)filter:(BOOL (^)(id))condition {
    NSAssert(condition != nil, @"Filtering a source with a nil condition block is not allowed.");
    return [self sourceWithActionableBlock:^(UUSource *derivedSource, id value) {
        if (condition(value)) {
            [derivedSource pushValue:value];
        }
    }];
}

- (UUSource *)map:(id (^)(id))transformation {
    NSAssert(transformation != nil, @"Mapping a source with a nil transformation block is not allowed.");
    return [self sourceWithActionableBlock:^(UUSource *derivedSource, id value) {
        [derivedSource pushValue:transformation(value)];
    }];
}

@end
