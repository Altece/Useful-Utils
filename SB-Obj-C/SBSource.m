#import "SBSource.h"

#import "SBSignal.h"
#import "SBSubscription.h"

#pragma mark - Internal Source Subscription

typedef void (^SBSourceSubscriberBlock)(id value);

@interface SBSourceSubscriber : NSObject

@property (nonatomic, readonly, strong, nonnull) SBSourceSubscriberBlock subscriptionBlock;

@property (nonatomic, readonly, strong, nullable) SBSource *derivedSource;

- (instancetype)initWithSubscriptionBlock:(void (^)(id value))block;

- (instancetype)initForDerivedSource:(nullable SBSource *)derivedSoure
               withSubscriptionBlock:(SBSourceSubscriberBlock)block NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end

#pragma mark - Source Implementation

@implementation SBSource {
    NSMutableArray<SBSourceSubscriber *> *_subscribers;
    SBSubscription *_Nullable _internalSubscription;
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
    _value = value;
    return self;
}

- (id)initWithSignal:(SBSignal *)signal transformationBlock:(id (^)())block {
    self = [self init];
    if (!self) return nil;
    NSAssert(signal != nil, @"Creating a source from a nil signal is not allowed.");
    NSAssert(block != nil, @"Creating a source from a signal with a nil transformation block is not allowed.");
    __weak SBSource *weakSelf = self;
    _internalSubscription = [signal subscribeNext:^{
        [weakSelf pushValue:block()];
    }];
    return self;
}

#pragma mark Pushing and Revoking Values

- (void)pushValue:(id)value {
	if (value) {
        _value = value;
        for (SBSourceSubscriber *subscriber in _subscribers) {
            subscriber.subscriptionBlock(value);
        }
	} else {
        [self revokeValue];
	}
}

- (void)revokeValue {
    _value = nil;
    for (SBSourceSubscriber *subscriber in _subscribers) {
        [subscriber.derivedSource revokeValue];
    }
}

#pragma mark Subscribing

- (SBSubscription *)subscribe:(void (^)(id))block {
    NSAssert(block != nil, @"Subscribing with a nil block is not allowed.");
    return [self subscribeSubscriber:[[SBSourceSubscriber alloc] initWithSubscriptionBlock:block]];
}

- (SBSubscription *)subscribeNext:(void (^)(id))block {
    NSAssert(block != nil, @"Subscribing next with a nil block is not allowed.");
    return [self subscribeNextSubscriber:[[SBSourceSubscriber alloc] initWithSubscriptionBlock:block]];
}

#pragma mark Internal Subscribing

- (SBSubscription *)subscribeSubscriber:(SBSourceSubscriber *)subscriber {
    if (_value) {
        subscriber.subscriptionBlock(_value);
    }
    return [self subscribeNextSubscriber:subscriber];
}

- (SBSubscription *)subscribeNextSubscriber:(SBSourceSubscriber *)subscriber {
    [_subscribers addObject:subscriber];
    return [[SBSubscription alloc] initWithOriginator:self terminationBlock:^{
        [_subscribers removeObject:subscriber];
    }];
}

#pragma mark Derived Sources

- (SBSource *)sourceWithActionableBlock:(void (^)(SBSource *, id))block {
    NSAssert(block != nil, @"Creating a derived source with a nil actionable block is not allowed.");
    SBSource *source = [[SBSource alloc] init];
    __weak SBSource *weakSource = source;
    SBSourceSubscriber *subscriber = [[SBSourceSubscriber alloc] initForDerivedSource:source
                                                                  withSubscriptionBlock:^(id value) {
                                                                      SBSource *source = weakSource;
                                                                      if (source) {
                                                                          block(weakSource, value);
                                                                      }
                                                                  }];
    source->_internalSubscription = [self subscribeSubscriber:subscriber];
    return source;
}

- (SBSource *)filter:(BOOL (^)(id))condition {
    NSAssert(condition != nil, @"Filtering a source with a nil condition block is not allowed.");
    return [self sourceWithActionableBlock:^(SBSource *derivedSource, id value) {
        if (condition(value)) {
            [derivedSource pushValue:value];
        }
    }];
}

- (SBSource *)map:(id (^)(id))transformation {
    NSAssert(transformation != nil, @"Mapping a source with a nil transformation block is not allowed.");
    return [self sourceWithActionableBlock:^(SBSource *derivedSource, id value) {
        [derivedSource pushValue:transformation(value)];
    }];
}

@end

#pragma mark - Internal Source Subscriber Implementation

@implementation SBSourceSubscriber

- (instancetype)initWithSubscriptionBlock:(void (^)(id))block {
    return [self initForDerivedSource:nil withSubscriptionBlock:block];
}

- (instancetype)initForDerivedSource:(SBSource *)derivedSoure withSubscriptionBlock:(SBSourceSubscriberBlock)block {
    self = [super init];
    if (!self) return nil;
    _derivedSource = derivedSoure;
    _subscriptionBlock = [block copy];
    return self;
}

@end
