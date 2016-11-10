#import "UUILayoutAttribute.h"

static inline NSLayoutConstraint *makeConstraint(UUILayoutAttribute *attribute,
                                                 id<UUILayoutPrototype> value,
                                                 NSLayoutRelation relation) {
    return [NSLayoutConstraint constraintWithItem:attribute.item
                                        attribute:attribute.attribute
                                        relatedBy:relation
                                           toItem:value.uui_attribute.item
                                        attribute:value.uui_attribute.attribute
                                       multiplier:value.uui_multiplier
                                         constant:value.uui_constant];
}

@implementation UUILayoutAttribute

- (instancetype)initWithItem:(id)item attribute:(NSLayoutAttribute)attribute {
    self = [super init];
    if (self == nil) return nil;
    _item = item;
    _attribute = attribute;
    return self;
}

- (NSLayoutConstraint *)constrainTo:(id<UUILayoutPrototype>)value {
    return makeConstraint(self, value, NSLayoutRelationEqual);
}

- (NSLayoutConstraint *)constrainToMaximum:(id<UUILayoutPrototype>)value {
    return makeConstraint(self, value, NSLayoutRelationLessThanOrEqual);
}

- (NSLayoutConstraint *)constrainToMinimum:(id<UUILayoutPrototype>)value {
    return makeConstraint(self, value, NSLayoutRelationGreaterThanOrEqual);
}

#pragma mark Layout Prototype

- (UUILayoutAttribute *)uui_attribute {
    return self;
}

- (CGFloat)uui_constant {
    return 0.0;
}

- (CGFloat)uui_multiplier {
    return 1.0;
}

@end
