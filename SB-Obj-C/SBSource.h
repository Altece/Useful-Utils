#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SBSignal;
@class SBSubscription;

@interface SBSource<T> : NSObject

#pragma mark Initializing a new Source

- (instancetype)init;

- (instancetype)initWithValue:(T)value NS_DESIGNATED_INITIALIZER;

- (id)initWithSignal:(SBSignal *)signal transformationBlock:(id (^)())block;

#pragma mark Pushing and Revoking Values from Sources

- (void)pushValue:(T)value;

- (void)revokeValue;

#pragma mark Subscribing to Sources

- (SBSubscription *)subscribe:(void (^)(T value))block;

- (SBSubscription *)subscribeNext:(void (^)(T value))block;

#pragma mark Creating Derived Sources

- (SBSource *)sourceWithActionableBlock:(void (^)(SBSource *derivedSource, T value))block;

- (SBSource<T> *)filter:(BOOL (^)(T value))condition;

- (SBSource *)map:(id (^)(T value))transformation;

@end

NS_ASSUME_NONNULL_END
