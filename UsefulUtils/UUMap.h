#import <Foundation/Foundation.h>

@protocol UUDispatch;

NS_ASSUME_NONNULL_BEGIN

typedef id _Nonnull (^UUMapBlock)();

///
/// An abstraction over the ability to create a new container
/// with transformed versions of the original container's contents.
///
@protocol UUMap <NSObject>

///
/// Apply the given function over all the elemets within the container
/// and put the resulting values in a new container.
///
- (id)map:(UUMapBlock)transformation;

@end

@interface NSArray<T> (UUMap) <UUMap>

- (id)map:(id (^)(T))transformation;

@end

NS_ASSUME_NONNULL_END
