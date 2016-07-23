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
    _width = [[UUILayoutAttribute alloc] initWithItem:item attribute:NSLayoutAttributeWidth];
    _height = [[UUILayoutAttribute alloc] initWithItem:item attribute:NSLayoutAttributeHeight];
    _top = [[UUILayoutAttribute alloc] initWithItem:item attribute:NSLayoutAttributeTop];
    _bottom = [[UUILayoutAttribute alloc] initWithItem:item attribute:NSLayoutAttributeBottom];
    _leading = [[UUILayoutAttribute alloc] initWithItem:item attribute:NSLayoutAttributeLeading];
    _trailing = [[UUILayoutAttribute alloc] initWithItem:item attribute:NSLayoutAttributeTrailing];
    _left = [[UUILayoutAttribute alloc] initWithItem:item attribute:NSLayoutAttributeLeft];
    _right = [[UUILayoutAttribute alloc] initWithItem:item attribute:NSLayoutAttributeRight];
    _baseline = [[UUILayoutAttribute alloc] initWithItem:item attribute:NSLayoutAttributeBaseline];
    return self;
}

@end
