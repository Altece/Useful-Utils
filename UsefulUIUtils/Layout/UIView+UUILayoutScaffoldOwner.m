#import "UIView+UUILayoutScaffoldOwner.h"

@implementation UIView (UUILayoutScaffoldOwner)

- (UUILayoutScaffold *)uui_scaffold {
    return [[UUILayoutScaffold alloc] initWithItem:self];
}

@end
