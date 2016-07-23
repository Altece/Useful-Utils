#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UUILayoutAttribute : NSObject

@property (nonatomic, readonly, strong) id item;

@property (nonatomic, readonly) NSLayoutAttribute attribute;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithItem:(id)item attribute:(NSLayoutAttribute)attribute NS_DESIGNATED_INITIALIZER;

#pragma mark - NSLayoutRelationEqual

- (NSLayoutConstraint *)constrainToEqualConstant:(CGFloat)constant;

- (NSLayoutConstraint *)constrainToEqualAttribute:(UUILayoutAttribute *)attribute;

- (NSLayoutConstraint *)constrainToEqualAttribute:(nullable UUILayoutAttribute *)attribute
                                            times:(CGFloat)multiplier
                                             plus:(CGFloat)constant;

#pragma mark - NSLayoutRelationGreaterThanOrEqual

- (NSLayoutConstraint *)constrainToAtLeastEqualConstant:(CGFloat)constant;

- (NSLayoutConstraint *)constrainToAtLeastEqualAttribute:(UUILayoutAttribute *)attribute;

- (NSLayoutConstraint *)constrainToAtLeastEqualAttribute:(nullable UUILayoutAttribute *)attribute
                                                   times:(CGFloat)multiplier
                                                    plus:(CGFloat)constant;

#pragma mark - NSLayoutRelationLessThanOrEqual

- (NSLayoutConstraint *)constrainToAtMostEqualConstant:(CGFloat)constant;

- (NSLayoutConstraint *)constrainToAtMostEqualAttribute:(UUILayoutAttribute *)attribute;

- (NSLayoutConstraint *)constrainToAtMostEqualAttribute:(nullable UUILayoutAttribute *)attribute
                                                  times:(CGFloat)multiplier
                                                   plus:(CGFloat)constant;

@end

NS_ASSUME_NONNULL_END
