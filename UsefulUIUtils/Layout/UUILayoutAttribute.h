#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UUILayoutValue;

@interface UUILayoutAttribute : NSObject

@property (nonatomic, readonly, weak) id item;

@property (nonatomic, readonly) NSLayoutAttribute attribute;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithItem:(id)item
                   attribute:(NSLayoutAttribute)attribute NS_DESIGNATED_INITIALIZER;

- (NSLayoutConstraint *)constrainTo:(id<UUILayoutValue>)value;

- (NSLayoutConstraint *)constrainToMaximum:(id<UUILayoutValue>)value;

- (NSLayoutConstraint *)constrainToMinimum:(id<UUILayoutValue>)value;

@end

NS_ASSUME_NONNULL_END
