#import "UUILayoutAnchor.h"

@implementation UUILayoutAnchor

- (id<UUILayoutPrototype>)plus:(CGFloat)constant {
    return [[UUILayoutPrototype alloc] initWithAttribute:self multiplier:1.0 constant:constant];
}

@end
