#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UUILayoutAttribute;

@interface UUILayoutScaffold : NSObject

@property (nonatomic, readonly, strong) UUILayoutAttribute *width;

@property (nonatomic, readonly, strong) UUILayoutAttribute *height;

@property (nonatomic, readonly, strong) UUILayoutAttribute *top;

@property (nonatomic, readonly, strong) UUILayoutAttribute *bottom;

@property (nonatomic, readonly, strong) UUILayoutAttribute *leading;

@property (nonatomic, readonly, strong) UUILayoutAttribute *trailing;

@property (nonatomic, readonly, strong) UUILayoutAttribute *left;

@property (nonatomic, readonly, strong) UUILayoutAttribute *right;

@property (nonatomic, readonly, strong) UUILayoutAttribute *baseline;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithItem:(id)item;

@end

NS_ASSUME_NONNULL_END
