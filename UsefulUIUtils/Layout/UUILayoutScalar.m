#import "UUILayoutScalar.h"

@implementation UUILayoutScalar

- (id<UUILayoutValue>)plus:(CGFloat)constant {
    return [self times:1.0 plus:constant];
}

- (id<UUILayoutValue>)times:(CGFloat)multiplier {
    return [self times:multiplier plus:0.0];
}

- (id<UUILayoutValue>)times:(CGFloat)multiplier plus:(CGFloat)constant {
    return [[UUILayoutValue alloc] initWithAttribute:self multiplier:multiplier constant:constant];
}

@end
