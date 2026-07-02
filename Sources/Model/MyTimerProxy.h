//
//  MyTimerProxy.h
//  Obj-C-Demo
//
//  Created by Ricol Wang on 2024/2/25.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyTimerProxy : NSProxy

@property (weak) UIViewController *vc;

+ (MyTimerProxy *)getInstance;

@end

NS_ASSUME_NONNULL_END
