#import <Foundation/Foundation.h>

#import "UUMacros.h"

NS_ASSUME_NONNULL_BEGIN

///
/// A convenience macro for creating a lazy value out of an expression.
///
#define UULazyExpression(EXPRESSION) \
    ([[UULazyValue alloc] initWithBlock:^{ return (EXPRESSION); }])

///
/// A reusable tool to provide the means for lazy evaluation of an expression.
///
@interface UULazyValue<T> : NSObject

///
/// The value resulting from the execution of the given block.
/// @discussion When the value is first requested, the block will be called on
///             to provide it. That resulting value will then be strongly
///             retained for later access by the lazy value.
///
@property (nonatomic, readonly, strong) T value;

///
/// Initialize a lazy value with the given block that can be called on
/// to provide the desired value.
///
- (instancetype)initWithBlock:(T (^)())block $designated;

- (instancetype)init $unavailable;

@end

NS_ASSUME_NONNULL_END
