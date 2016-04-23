#import "UUSource.h"

#import "UUSignal.h"
#import "UUSubscription.h"

#pragma mark - Internal Source Subscription

typedef void (^UUSourceSubscriberBlock)(id value);

@interface UUSourceSubscriber : NSObject

@property (nonatomic, readonly, strong, nonnull) UUSourceSubscriberBlock subscriptionBlock;

@property (nonatomic, readonly, strong, nullable) UUSource *derivedSource;

- (instancetype)initWithSubscriptionBlock:(void (^)(id value))block;

- (instancetype)initForDerivedSource:(nullable UUSource *)derivedSoure
               withSubscriptionBlock:(UUSourceSubscriberBlock)block NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end

#pragma mark - Source Implementation

@implementation UUSource {
    NSMutableArray<UUSourceSubscriber *> *_subscribers;
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
        for (UUSourceSubscriber *subscriber in _subscribers) {
            subscriber.subscriptionBlock(value);
        }
	} else {
        [self revokeValue];
	}
}

- (void)revokeValue {
    _value = nil;
    for (UUSourceSubscriber *subscriber in _subscribers) {
        [subscriber.derivedSource revokeValue];
    }
    [_revokedSignal notify];
}

#pragma mark Subscribing

- (UUSubscription *)subscribe:(void (^)(id))block {
    NSAssert(block != nil, @"Subscribing with a nil block is not allowed.");
    return [self subscribeSubscriber:[[UUSourceSubscriber alloc] initWithSubscriptionBlock:block]];
}

- (UUSubscription *)subscribeNext:(void (^)(id))block {
    NSAssert(block != nil, @"Subscribing next with a nil block is not allowed.");
    return [self subscribeNextSubscriber:[[UUSourceSubscriber alloc] initWithSubscriptionBlock:block]];
}

#pragma mark Internal Subscribing

- (UUSubscription *)subscribeSubscriber:(UUSourceSubscriber *)subscriber {
    if (_value) {
        subscriber.subscriptionBlock(_value);
    }
    return [self subscribeNextSubscriber:subscriber];
}

- (UUSubscription *)subscribeNextSubscriber:(UUSourceSubscriber *)subscriber {
    [_subscribers addObject:subscriber];
    return [[UUSubscription alloc] initWithOriginator:self terminationBlock:^{
        [_subscribers removeObject:subscriber];
    }];
}

#pragma mark Derived Sources

- (UUSource *)sourceWithActionableBlock:(void (^)(UUSource *, id))block {
    NSAssert(block != nil, @"Creating a derived source with a nil actionable block is not allowed.");
    UUSource *source = [[UUSource alloc] init];
    __weak UUSource *weakSource = source;
    UUSourceSubscriber *subscriber = [[UUSourceSubscriber alloc] initForDerivedSource:source
                                                                  withSubscriptionBlock:^(id value) {
                                                                      UUSource *source = weakSource;
                                                                      if (source) {
                                                                          block(weakSource, value);
                                                                      }
                                                                  }];
    source->_internalSubscription = [self subscribeSubscriber:subscriber];
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

#pragma mark - Internal Source Subscriber Implementation

@implementation UUSourceSubscriber

- (instancetype)initWithSubscriptionBlock:(void (^)(id))block {
    return [self initForDerivedSource:nil withSubscriptionBlock:block];
}

- (instancetype)initForDerivedSource:(UUSource *)derivedSoure withSubscriptionBlock:(UUSourceSubscriberBlock)block {
    self = [super init];
    if (!self) return nil;
    _derivedSource = derivedSoure;
    _subscriptionBlock = [block copy];
    return self;
}

@end
