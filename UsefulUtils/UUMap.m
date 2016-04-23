#import "UUMap.h"

@implementation NSArray (UUMap)

- (id)map:(id (^)(id))transformation {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (id value in self) {
        [result addObject:transformation(value)];
    }
    return result;
}

@end
