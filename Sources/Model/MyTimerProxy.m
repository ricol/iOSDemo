//
//  MyTimerProxy.m
//  Obj-C-Demo
//
//  Created by Ricol Wang on 2024/2/25.
//

#import "MyTimerProxy.h"

@implementation MyTimerProxy

+ (MyTimerProxy *)getInstance {
    MyTimerProxy *instance = [MyTimerProxy alloc];
    return instance;
}

+ (BOOL)respondsToSelector:(SEL)aSelector {
    NSLog(@"%s", __FUNCTION__);
    return [super respondsToSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    NSLog(@"%s", __FUNCTION__);
    SEL sel = invocation.selector;
    if ([self.vc respondsToSelector:sel]) {
        invocation.target = self.vc;
        [invocation invoke];
    }else {
        return [super forwardInvocation:invocation];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    NSLog(@"%s", __FUNCTION__);
    if ([self.vc respondsToSelector:sel]) {
        NSMethodSignature *sig = [self.vc methodSignatureForSelector:sel];
        return sig;
    }
    return [super methodSignatureForSelector:sel];
}

@end
