#import <Foundation/Foundation.h>

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

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
