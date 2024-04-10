//
//  NSTimer+MyTimerBlockSupport.m
//  Obj-C-Demo
//
//  Created by Ricol Wang on 2024/3/26.
//

#import "NSTimer+MyTimerBlockSupport.h"

@implementation NSTimer (MyTimerBlockSupport)

+ (NSTimer *)myScheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(nonnull void (^)(NSTimer *_Nonnull))block {
    return [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(runMyblock:) userInfo:[block copy] repeats:repeats];
}

+ (void)runMyblock:(NSTimer *)timer {
    void (^block)(NSTimer *) = timer.userInfo;
    if (block) {
        block(timer);
    }
}

@end
