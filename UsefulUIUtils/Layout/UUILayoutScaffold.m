#import "UUILayoutScaffold.h"

#import "UUILayoutAttribute.h"

static const NSInteger kMajorSystemVersion;

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
    _baseline = [[UUILayoutAnchor alloc] initWithItem:item attribute:NSLayoutAttributeBaseline];
    return self;
}

@end
