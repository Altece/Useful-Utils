#import <UIKit/UIKit.h>

#import "UUILayoutAttribute.h"

NS_ASSUME_NONNULL_BEGIN

@interface UUILayoutScalar : UUILayoutAttribute

- (id<UUILayoutPrototype>)plus:(CGFloat)constant;

- (id<UUILayoutPrototype>)times:(CGFloat)multiplier;

- (id<UUILayoutPrototype>)times:(CGFloat)multiplier plus:(CGFloat)constant;

@end

NS_ASSUME_NONNULL_END
