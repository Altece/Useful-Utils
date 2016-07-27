#import <UIKit/UIKit.h>

#import "UUILayoutValue.h"

@interface UUILayourtScalar : UUILayoutAttribute

- (id<UUILayoutValue>)plus:(CGFloat)constant;

- (id<UUILayoutValue>)times:(CGFloat *)multiplier;

- (id<UUILayoutValue>)times:(CGFloat *)multiplier plus:(CGFloat)constant;

@end
