#import "UUILayoutScaffold.h"

#import "UUILayoutAttribute.h"

static NSInteger kMajorSystemVersion;

@implementation UUILayoutScaffold

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kMajorSystemVersion = [[[UIDevice currentDevice] systemVersion] integerValue];
    });
}

- (instancetype)initWithItem:(id)item {
    self = [super init];
    if (self == nil) return nil;
    _width = [[UUILayoutScalar alloc] initWithItem:item attribute:NSLayoutAttributeWidth];
    _height = [[UUILayoutScalar alloc] initWithItem:item attribute:NSLayoutAttributeHeight];
    _top = [[UUILayoutAnchor alloc] initWithItem:item attribute:NSLayoutAttributeTop];
    _bottom = [[UUILayoutAnchor alloc] initWithItem:item attribute:NSLayoutAttributeBottom];
    _leading = [[UUILayoutAnchor alloc] initWithItem:item attribute:NSLayoutAttributeLeading];
    _trailing = [[UUILayoutAnchor alloc] initWithItem:item attribute:NSLayoutAttributeTrailing];
    _left = [[UUILayoutAnchor alloc] initWithItem:item attribute:NSLayoutAttributeLeft];
    _right = [[UUILayoutAnchor alloc] initWithItem:item attribute:NSLayoutAttributeRight];
    _firstBaseline = [[UUILayoutAnchor alloc] initWithItem:item attribute:NSLayoutAttributeFirstBaseline];
    _lastBaseline = [[UUILayoutAnchor alloc] initWithItem:item attribute:NSLayoutAttributeLastBaseline];
    return self;
}

@end
