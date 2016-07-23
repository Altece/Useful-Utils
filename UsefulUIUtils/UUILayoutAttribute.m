#import "UUILayoutAttribute.h"

@implementation UUILayoutAttribute

- (instancetype)initWithItem:(id)item attribute:(NSLayoutAttribute)attribute {
    self = [super init];
    if (self == nil) return nil;
    _item = item;
    _attribute = attribute;
    return self;
}

#pragma mark - NSLayoutRelationEqual

- (NSLayoutConstraint *)constrainToEqualConstant:(CGFloat)constant {
    return [self constrainToEqualAttribute:nil times:1.0 plus:constant];
}

- (NSLayoutConstraint *)constrainToEqualAttribute:(UUILayoutAttribute *)attribute {
    return [self constrainToEqualAttribute:attribute times:1.0 plus:0.0];
}

- (NSLayoutConstraint *)constrainToEqualAttribute:(UUILayoutAttribute *)attribute
                                            times:(CGFloat)multiplier
                                             plus:(CGFloat)constant {
    return [NSLayoutConstraint constraintWithItem:_item
                                        attribute:_attribute
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:attribute.item
                                        attribute:attribute.attribute
                                       multiplier:multiplier
                                         constant:constant];
}

#pragma mark - NSLayoutRelationGreaterThanOrEqual

- (NSLayoutConstraint *)constrainToAtLeastEqualConstant:(CGFloat)constant {
    return [self constrainToAtLeastEqualAttribute:nil times:1.0 plus:constant];
}

- (NSLayoutConstraint *)constrainToAtLeastEqualAttribute:(UUILayoutAttribute *)attribute {
    return [self constrainToAtLeastEqualAttribute:attribute times:1.0 plus:0.0];
}

- (NSLayoutConstraint *)constrainToAtLeastEqualAttribute:(UUILayoutAttribute *)attribute
                                                   times:(CGFloat)multiplier
                                                    plus:(CGFloat)constant {
    return [NSLayoutConstraint constraintWithItem:_item
                                        attribute:_attribute
                                        relatedBy:NSLayoutRelationGreaterThanOrEqual
                                           toItem:attribute.item
                                        attribute:attribute.attribute
                                       multiplier:multiplier
                                         constant:constant];
}

#pragma mark - NSLayoutRelationLessThanOrEqual

- (NSLayoutConstraint *)constrainToAtMostEqualConstant:(CGFloat)constant {
    return [self constrainToAtMostEqualAttribute:nil times:1.0 plus:constant];
}

- (NSLayoutConstraint *)constrainToAtMostEqualAttribute:(UUILayoutAttribute *)attribute {
    return [self constrainToAtMostEqualAttribute:attribute times:1.0 plus:0.0];
}

- (NSLayoutConstraint *)constrainToAtMostEqualAttribute:(UUILayoutAttribute *)attribute
                                                  times:(CGFloat)multiplier
                                                   plus:(CGFloat)constant {
    return [NSLayoutConstraint constraintWithItem:_item
                                        attribute:_attribute
                                        relatedBy:NSLayoutRelationLessThanOrEqual
                                           toItem:attribute.item
                                        attribute:attribute.attribute
                                       multiplier:multiplier
                                         constant:constant];
}

@end
