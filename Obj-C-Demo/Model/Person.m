//
//  Person.m
//  Obj-C-Demo
//
//  Created by Ricol Wang on 2024/2/13.
//

#import "Person.h"
#import "objc/runtime.h"

@implementation Person (newMethod)

@dynamic infor;

- (NSString *)getDisplay {
    NSString *string = [NSString stringWithFormat:@"name: %@\nage: %d\naddress: %@\n", self.name, self.age, self.address];
    return string;
}

+ (BOOL)resolveClassMethod:(SEL)sel {
    NSLog(@"%s", __FUNCTION__);
    if (sel == @selector(testClassFun)) {
        Method m = class_getClassMethod([self class], @selector(myotherTestClassFun));
        class_addMethod([self class], sel, method_getImplementation(m), method_getTypeEncoding(m));
        return true;
    }
    return [super resolveClassMethod: sel];
}

+ (void)myotherTestClassFun {
    NSLog(@"%s", __FUNCTION__);
}

+(BOOL)resolveInstanceMethod:(SEL)sel{
    NSLog(@"%s", __FUNCTION__);
    if (sel == @selector(testFun)) {
        Method method = class_getInstanceMethod([self class], @selector(myotherTestFun));
        //Adds a new method to a class with a given name and implementation.
        class_addMethod([self class],
                        sel,
                        method_getImplementation(method),
                        method_getTypeEncoding(method));
        return true;
    }
    return [super resolveInstanceMethod:sel];
}

-(void)myotherTestFun{
    NSLog(@"%s",__func__);
}

- (NSString *)infor {
    return [self getDisplay];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"%s", __FUNCTION__);
    [super forwardInvocation:anInvocation];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSLog(@"%s", __FUNCTION__);
    return [super forwardingTargetForSelector:aSelector];
}

- (IMP)methodForSelector:(SEL)aSelector {
    NSLog(@"%s", __FUNCTION__);
    return [super methodForSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSLog(@"%s", __FUNCTION__);
    return [super methodSignatureForSelector:aSelector];
}

@end

@implementation Person

+ (void)load {
    NSLog(@"%s", __FUNCTION__);
    [super load];
//    Method m1 = class_getInstanceMethod(self, @selector(display));
//    Method m2 = class_getInstanceMethod(self, @selector(newDisplay));
//    method_exchangeImplementations(m1, m2);
}

- (void)display {
    NSString *string = [self infor];
    NSLog(@"%@",  string);
    Class c = objc_getClass("Person");
    NSLog(@"get ivarlists...");
    unsigned int count = 0;
    Ivar *ivarlist = class_copyIvarList(c, &count);
    for (int i = 0; i < count; i++) {
        Ivar var = ivarlist[i];
        NSString *name = [NSString stringWithUTF8String:ivar_getName(var)];
        NSLog(@"%@", name);
    }
    NSLog(@"get properties...");
    objc_property_t *properties = class_copyPropertyList(c, &count);
    for (int i = 0; i < count; i++) {
        objc_property_t p = properties[i];
        NSString *name = [NSString stringWithCString:property_getName(p) encoding:NSUTF8StringEncoding];
        NSLog(@"%@", name);
    }
}

- (void)newDisplay {
    NSLog(@"%s", __FUNCTION__);
}

- (void)displayOthers {
    NSLog(@"%@", _others);
}

- (void)displayInfor {
    NSLog(@"%@", _information);
}

@end

