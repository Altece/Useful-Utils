#import "SJBSource.h"

#import "SJBSignal.h"
#import "SJBSubscription.h"

#pragma mark - Internal Source Subscription

typedef void (^SJBSourceSubscriberBlock)(id value);

@interface SJBSourceSubscriber : NSObject

@property (nonatomic, readonly, strong, nonnull) SJBSourceSubscriberBlock subscriptionBlock;

@property (nonatomic, readonly, strong, nullable) SJBSource *derivedSource;

- (instancetype)initWithSubscriptionBlock:(void (^)(id value))block;

- (instancetype)initForDerivedSource:(nullable SJBSource *)derivedSoure
               withSubscriptionBlock:(SJBSourceSubscriberBlock)block NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end

#pragma mark - Source Implementation

@implementation SJBSource {
    NSMutableArray<SJBSourceSubscriber *> *_subscribers;
    SJBSubscription *_Nullable _internalSubscription;
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

- (id)initWithSignal:(SJBSignal *)signal transformationBlock:(id (^)())block {
    self = [self init];
    if (!self) return nil;
    NSAssert(signal != nil, @"Creating a source from a nil signal is not allowed.");
    NSAssert(block != nil, @"Creating a source from a signal with a nil transformation block is not allowed.");
    __weak SJBSource *weakSelf = self;
    _internalSubscription = [signal subscribeNext:^{
        [weakSelf pushValue:block()];
    }];
    return self;
}

#pragma mark Pushing and Revoking Values

- (void)pushValue:(id)value {
	if (value) {
        _value = value;
        for (SJBSourceSubscriber *subscriber in _subscribers) {
            subscriber.subscriptionBlock(value);
        }
	} else {
        [self revokeValue];
	}
}

- (void)revokeValue {
    _value = nil;
    for (SJBSourceSubscriber *subscriber in _subscribers) {
        [subscriber.derivedSource revokeValue];
    }
}

#pragma mark Subscribing

- (SJBSubscription *)subscribe:(void (^)(id))block {
    NSAssert(block != nil, @"Subscribing with a nil block is not allowed.");
    return [self subscribeSubscriber:[[SJBSourceSubscriber alloc] initWithSubscriptionBlock:block]];
}

- (SJBSubscription *)subscribeNext:(void (^)(id))block {
    NSAssert(block != nil, @"Subscribing next with a nil block is not allowed.");
    return [self subscribeNextSubscriber:[[SJBSourceSubscriber alloc] initWithSubscriptionBlock:block]];
}

#pragma mark Internal Subscribing

- (SJBSubscription *)subscribeSubscriber:(SJBSourceSubscriber *)subscriber {
    if (_value) {
        subscriber.subscriptionBlock(_value);
    }
    return [self subscribeNextSubscriber:subscriber];
}

- (SJBSubscription *)subscribeNextSubscriber:(SJBSourceSubscriber *)subscriber {
    [_subscribers addObject:subscriber];
    return [[SJBSubscription alloc] initWithOriginator:self terminationBlock:^{
        [_subscribers removeObject:subscriber];
    }];
}

#pragma mark Derived Sources

- (SJBSource *)sourceWithActionableBlock:(void (^)(SJBSource *, id))block {
    NSAssert(block != nil, @"Creating a derived source with a nil actionable block is not allowed.");
    SJBSource *source = [[SJBSource alloc] init];
    __weak SJBSource *weakSource = source;
    SJBSourceSubscriber *subscriber = [[SJBSourceSubscriber alloc] initForDerivedSource:source
                                                                  withSubscriptionBlock:^(id value) {
                                                                      SJBSource *source = weakSource;
                                                                      if (source) {
                                                                          block(weakSource, value);
                                                                      }
                                                                  }];
    source->_internalSubscription = [self subscribeSubscriber:subscriber];
    return source;
}

- (SJBSource *)filter:(BOOL (^)(id))condition {
    NSAssert(condition != nil, @"Filtering a source with a nil condition block is not allowed.");
    return [self sourceWithActionableBlock:^(SJBSource *derivedSource, id value) {
        if (condition(value)) {
            [derivedSource pushValue:value];
        }
    }];
}

- (SJBSource *)map:(id (^)(id))transformation {
    NSAssert(transformation != nil, @"Mapping a source with a nil transformation block is not allowed.");
    return [self sourceWithActionableBlock:^(SJBSource *derivedSource, id value) {
        [derivedSource pushValue:transformation(value)];
    }];
}

@end

#pragma mark - Internal Source Subscriber Implementation

@implementation SJBSourceSubscriber

- (instancetype)initWithSubscriptionBlock:(void (^)(id))block {
    return [self initForDerivedSource:nil withSubscriptionBlock:block];
}

- (instancetype)initForDerivedSource:(SJBSource *)derivedSoure withSubscriptionBlock:(SJBSourceSubscriberBlock)block {
    self = [super init];
    if (!self) return nil;
    _derivedSource = derivedSoure;
    _subscriptionBlock = [block copy];
    return self;
}

@end
