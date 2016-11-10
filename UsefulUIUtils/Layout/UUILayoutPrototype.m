#import "UUILayoutPrototype.h"

@implementation UUILayoutPrototype

@synthesize uui_attribute = _uui_attribute;
@synthesize uui_multiplier = _uui_multiplier;
@synthesize uui_constant = _uui_constant;

- (instancetype)initWithAttribute:(UUILayoutAttribute *)attribute
                       multiplier:(CGFloat)multiplier
                         constant:(CGFloat)constant {
    self = [super init];
    if (self == nil) return nil;
    _uui_attribute = attribute;
    _uui_multiplier = multiplier;
    _uui_constant = constant;
    return self;
}

@end
