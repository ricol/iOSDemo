//
//  MyTimertarget.h
//  Obj-C-Demo
//
//  Created by Ricol Wang on 2024/3/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyTimertarget : NSObject

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval target:(nonnull id)aTarget selector:(nonnull SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo;

@end

NS_ASSUME_NONNULL_END
