//
//  MyTimertarget.m
//  Obj-C-Demo
//
//  Created by Ricol Wang on 2024/3/25.
//

#import "MyTimertarget.h"

@interface MyTimertarget ()

@property (assign) SEL selector;
@property (weak) id target;

@end

@implementation MyTimertarget

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo {
    MyTimertarget *timertarget = [[MyTimertarget alloc] init];
    timertarget.target = aTarget;
    timertarget.selector = aSelector;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:interval target:timertarget selector:@selector(execute:) userInfo:userInfo repeats:yesOrNo];
    return timer;
}

- (void)execute:(NSTimer *)timer {
    if (self.target && [self.target respondsToSelector:self.selector]) {
        [self.target performSelector:self.selector withObject:timer.userInfo];
    }else {
        [timer invalidate];
    }
}

- (void)dealloc {
    NSLog(@"[%@]dealloc...", self);
}

@end
