#import <UIKit/UIKit.h>

@class UUILayoutAttribute;

NS_ASSUME_NONNULL_BEGIN

@protocol UUILayoutPrototype <NSObject>

@property (nonatomic, readonly, nullable) UUILayoutAttribute *uui_attribute;

@property (nonatomic, readonly) CGFloat uui_multiplier;

@property (nonatomic, readonly) CGFloat uui_constant;

@end

@interface UUILayoutPrototype : NSObject <UUILayoutPrototype>

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithAttribute:(UUILayoutAttribute *)attribute
                       multiplier:(CGFloat)multiplier
                         constant:(CGFloat)constant NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
