#import <Foundation/Foundation.h>

#define $deprecated __deprecated

#define $designated NS_DESIGNATED_INITIALIZER

#define $export FOUNDATION_EXPORT

#define $nonnull(OBJECT) ({                             \
    NSString *__uu_given_expression__ = @"" #OBJECT ""; \
    id __uu_given_value__ = (OBJECT);                   \
    if (__uu_given_value__ == nil) {                    \
        NSLog(@"Expression evaluates to nil: %@",       \
              __uu_given_expression__);                 \
        __builtin_debugtrap;                            \
    }                                                   \
    __uu_given_value__;                                 \
})

#define $unavailable NS_UNAVAILABLE
