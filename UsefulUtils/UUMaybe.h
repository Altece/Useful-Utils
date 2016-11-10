#import <Foundation/Foundation.h>

#import "UUMacros.h"

NS_ASSUME_NONNULL_BEGIN

///
/// An object to represent in type syntax the possibility that a value may be nil.
/// @discussion This is useful for creating a source that can send nil to subscribers.
///
@interface UUMaybe<T> : NSObject

///
/// The value, if there is one, wrapped within this maybe object.
///
@property (nonatomic, readwrite, nullable) T value;

///
/// Create a maybe object with no value.
///
+ (instancetype)none;

///
/// Create a maybe object with the given value.
///
+ (instancetype)some:(T)value;

- (instancetype)init $unavailable;

///
/// Get access to the value stored in the maybe.
/// @param defaultValue If the maybe doesn't hold a value,
///                     this will be the value that gets returned.
/// @return If this maybe is the result of @c +some: with a non-nil value,
///         that value will be returned. Otherwise, the given default value
///         will be returned.
///
- (T)valueOr:(T)defaultValue;

@end

NS_ASSUME_NONNULL_END
