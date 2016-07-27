#import "UUILayoutAnchor.h"

@implementation UUILayoutAnchor

- (id<UUILayoutValue>)plus:(CGFloat)constant {
    return [[UUILayoutValue alloc] initWithAttribute:self multiplier:1.0 constant:constant];
}

@end
