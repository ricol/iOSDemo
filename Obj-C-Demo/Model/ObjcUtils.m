//
//  ObjcUtils.m
//  Obj-C-Demo
//
//  Created by ricolwang on 2024/7/31.
//

#import "ObjcUtils.h"

@implementation ObjcUtils

- (void)testSets {
    NSMutableSet<NSString *> *sets = [NSMutableSet new];
    for (NSString *name in @[@"wang", @"xing", @"he", @"ricol", @"wang"]) {
        [sets addObject:name];
    }
    NSLog(@"sets: %@", sets);
    
    for (NSString *name in @[@"wang", @"xing", @"he", @"ricol", @"wang", @"ricolwang", @"wangxinghe"]) {
        BOOL contains = [sets containsObject:name];
        NSLog(@"sets contains %@ -> %@", name, contains ? @"yes" : @"no");
    }
}

@end
