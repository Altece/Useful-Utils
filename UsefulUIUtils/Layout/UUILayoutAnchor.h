#import <UIKit/UIKit.h>

#import "UUILayoutAttribute.h"

NS_ASSUME_NONNULL_BEGIN

@interface UUILayoutAnchor : UUILayoutAttribute

- (id<UUILayoutPrototype>)plus:(CGFloat)constant;

@end

NS_ASSUME_NONNULL_END
