#import "UUILayoutScalar.h"

@implementation UUILayoutScalar

- (id<UUILayoutPrototype>)plus:(CGFloat)constant {
    return [self times:1.0 plus:constant];
}

- (id<UUILayoutPrototype>)times:(CGFloat)multiplier {
    return [self times:multiplier plus:0.0];
}

- (id<UUILayoutPrototype>)times:(CGFloat)multiplier plus:(CGFloat)constant {
    return [[UUILayoutPrototype alloc] initWithAttribute:self multiplier:multiplier constant:constant];
}

@end
