#import "UUMaybe.h"

@implementation UUMaybe

+ (id)none {
    return [[UUMaybe alloc] initWithValue:nil];
}

+ (instancetype)some:(id)value {
    return [[UUMaybe alloc] initWithValue:value];
}

- (id)initWithValue:(id)value {
    self = [super init];
    if (!self) return nil;
    _value = value;
    return self;
}

@end
