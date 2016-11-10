#import <Foundation/Foundation.h>

#import "UUMacros.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^UUTaskBlock)();
typedef void (^UUValueTaskBlock)(id value);

#pragma mark - Task

@protocol UUDispatcher;

///
/// A pairing of an operation to a method of executing it so that
/// the two can be passed around together.
///
@interface UUTask : NSObject

///
/// Initialize a task with the given block and dispatcher.
///
- (instancetype)initWithBlock:(UUTaskBlock)block on:(id<UUDispatcher>)dispatcher $designated;

- (instancetype)init $unavailable;

///
/// Call the block using the dispatcher provided at initialization.
///
- (void)performTask;

@end

#pragma mark - Value Task

///
/// A pairing of an operation on a value to a method of executing it
/// so that the two can be passed around together
///
@interface UUValueTask<T> : NSObject

///
/// Initialize a value task with the given block and dispatcher.
///
- (instancetype)initWithBlock:(void (^)(T value))block on:(id<UUDispatcher>)dispatcher $designated;

- (instancetype)init $unavailable;

///
/// Call the block with the given value,
/// using the dispatcher provided at initialization.
///
- (void)performTaskWithValue:(T)value;

@end

NS_ASSUME_NONNULL_END
