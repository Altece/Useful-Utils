#import <UIKit/UIKit.h>

#import "UUILayoutValue.h"

NS_ASSUME_NONNULL_BEGIN

@interface UUILayoutAnchor : UUILayoutAttribute

- (id<UUILayoutValue>)plus:(CGFloat)constant;

@end

NS_ASSUME_NONNULL_END
