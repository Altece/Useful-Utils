#import "UILayoutGuide+UILayoutScaffoldOwner.h"

@implementation UILayoutGuide (UILayoutScaffoldOwner)

- (UUILayoutScaffold *)uui_scaffold {
    return [[UUILayoutScaffold alloc] initWithItem:self];
}

@end
