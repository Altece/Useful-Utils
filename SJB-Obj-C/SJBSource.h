#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SJBSignal;
@class SJBSubscription;

@interface SJBSource<T> : NSObject

#pragma mark Initializing a new Source

- (instancetype)init;

- (instancetype)initWithValue:(T)value NS_DESIGNATED_INITIALIZER;

- (id)initWithSignal:(SJBSignal *)signal transformationBlock:(id (^)())block;

#pragma mark Pushing and Revoking Values from Sources

- (void)pushValue:(T)value;

- (void)revokeValue;

#pragma mark Subscribing to Sources

- (SJBSubscription *)subscribe:(void (^)(T value))block;

- (SJBSubscription *)subscribeNext:(void (^)(T value))block;

#pragma mark Creating Derived Sources

- (SJBSource *)sourceWithActionableBlock:(void (^)(SJBSource *derivedSource, T value))block;

- (SJBSource<T> *)filter:(BOOL (^)(T value))condition;

- (SJBSource *)map:(id (^)(T value))transformation;

@end

NS_ASSUME_NONNULL_END
