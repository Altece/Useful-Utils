#import "NSObject+NSNumber_UUILayoutValue.h"

@implementation NSNumber (UUILayoutValue)

- (UUILayoutAttribute *)uui_attribute {
    return nil;
}

- (CGFloat)uui_multiplier {
    return 1.0;
}

- (CGFloat)uui_constant {
    return [self doubleValue];
}

@end
