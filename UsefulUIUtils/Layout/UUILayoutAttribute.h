#import <UIKit/UIKit.h>

#import "UUILayoutPrototype.h"

@protocol UUILayoutPrototype;

NS_ASSUME_NONNULL_BEGIN

@interface UUILayoutAttribute : NSObject <UUILayoutPrototype>

@property (nonatomic, readonly, weak) id item;

@property (nonatomic, readonly) NSLayoutAttribute attribute;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithItem:(id)item
                   attribute:(NSLayoutAttribute)attribute NS_DESIGNATED_INITIALIZER;

- (NSLayoutConstraint *)constrainTo:(id<UUILayoutPrototype>)value;

- (NSLayoutConstraint *)constrainToMaximum:(id<UUILayoutPrototype>)value;

- (NSLayoutConstraint *)constrainToMinimum:(id<UUILayoutPrototype>)value;

@end

NS_ASSUME_NONNULL_END
