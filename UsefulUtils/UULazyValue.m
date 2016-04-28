#import "UULazyValue.h"

#import "UUDispatch.h"

@implementation UULazyValue {
    id _value;
    id (^_block)();
    UUDispatchOnce *_once;
}

- (instancetype)initWithBlock:(id (^)())block {
    self = [super init];
    if (!self) return nil;
    _block = block;
    _once = [[UUDispatchOnce alloc] init];
    return self;
}

- (id)value {
    [_once dispatchBlock:^{
        _value = _block();
    }];
    return _value;
}

@end
