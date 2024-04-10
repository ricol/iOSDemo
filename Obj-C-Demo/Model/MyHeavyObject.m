//
//  MyHeavyObject.m
//  Obj-C-Demo
//
//  Created by Ricol Wang on 2024/3/23.
//

#import "MyHeavyObject.h"

@interface MyHeavyObject ()

@property (strong) NSMutableArray *array;

@end

@implementation MyHeavyObject

static int count = 0;

- (instancetype)init {
    MyHeavyObject *r = [super init];
    self.array = [NSMutableArray new];
    for (int i = 0; i <= 1e4; i += 1) {
        NSMutableString *str = [NSMutableString new];
        for (int j = 0; j <= 1e4; j += 1) {
            [str appendString:@"test"];
        }
        [self.array addObject:str];
    }
    count += 1;
    NSLog(@"[%@]init...[%d]", self, count);
    return r;
}

- (void)dealloc {
    count -= 1;
    NSLog(@"[%@]dealloc...[%d]", self, count);
}

- (void)display {
    NSLog(@"[%@]total: %d", self, self.array.count);
}

@end
