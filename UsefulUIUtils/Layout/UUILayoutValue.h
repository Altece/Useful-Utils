#import <UIKit/UIKit.h>

#import "UUILayoutAttribute.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UUILayoutValue <NSObject>

@property (nonatomic, readonly, nullable) UUILayoutAttribute *uui_attribute;

@property (nonatomic, readonly) CGFloat uui_multiplier;

@property (nonatomic, readonly) CGFloat uui_constant;

@end

@interface UUILayoutValue : NSObject <UUILayoutValue>

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithAttribute:(UUILayoutAttribute *)attribute
                       multiplier:(CGFloat)multiplier
                         constant:(CGFloat)constant NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
