//
//  ObjCRuntimeTableViewController.m
//  Obj-C-Demo
//
//  Created by Ricol Wang on 2024/4/15.
//

#import "ObjCRuntimeTableViewController.h"

@interface ObjCRuntimeTableViewController ()

@end

@implementation ObjCRuntimeTableViewController

- (void)testInstanceMethod {
    NSLog(@"testInstanceMethod...");
}

- (void)testClassMethod {
    NSLog(@"testClassMethod...");
}

- (void)testMethodExchange {
    NSLog(@"testMethodExchange...");
}

@end
