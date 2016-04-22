#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SJBCancellable : NSObject

- (instancetype)initWithCancellationBlock:(void (^)())block NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

- (void)cancel;

+ (SJBCancellable *)coalesceCancellables:(NSArray<SJBCancellable *> *)cancellables;

@end

NS_ASSUME_NONNULL_END
