//
//  BaseTableViewController.m
//  Obj-C-Demo
//
//  Created by Ricol Wang on 2024/4/6.
//

#import "BaseTableViewController.h"
#import "Obj_C_Demo-Swift.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[CountVC shared] allocWithVc:self];
}

- (void)dealloc {
    [[CountVC shared] deallocWithVc:self];
}

@end
