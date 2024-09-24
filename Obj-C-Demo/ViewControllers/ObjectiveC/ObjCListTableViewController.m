//
//  ObjCListTableViewController.m
//  Obj-C-Demo
//
//  Created by Ricol Wang on 2024/4/11.
//

#import "ObjCListTableViewController.h"

@interface ObjCListTableViewController ()

@end

@implementation ObjCListTableViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    SEL sel = NSSelectorFromString([@"test" stringByAppendingString:cell.textLabel.text]);
    if ([self respondsToSelector:sel]) {
        NSLog(@"perform selector: %@", NSStringFromSelector(sel));
        [self performSelectorOnMainThread:sel withObject:nil waitUntilDone:true];
    }else {
        NSLog(@"invalid selector.");
    }
}

@end
