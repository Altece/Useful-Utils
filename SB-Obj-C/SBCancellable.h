#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SBCancellable : NSObject

- (instancetype)initWithCancellationBlock:(void (^)())block NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

- (void)cancel;

+ (SBCancellable *)coalesceCancellables:(NSArray<SBCancellable *> *)cancellables;

@end

NS_ASSUME_NONNULL_END
