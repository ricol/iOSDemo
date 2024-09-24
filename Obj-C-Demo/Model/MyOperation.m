//
//  MyOperation.m
//  Obj-C-Demo
//
//  Created by Ricol Wang on 2024/3/24.
//

#import "MyOperation.h"

@implementation MyOperation

- (void)main {
    NSLog(@"[%@]calculating...[%@]", NSThread.currentThread, self.text);
    uint sum = 0;
    for (int i = 0; i <= 2e9; i += 1) {
        sum += i;
    }
    NSLog(@"[%@]sum: %u[%@]", NSThread.currentThread, sum, self.text);
}

@end
