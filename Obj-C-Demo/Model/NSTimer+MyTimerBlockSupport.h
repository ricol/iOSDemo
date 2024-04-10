//
//  NSTimer+MyTimerBlockSupport.h
//  Obj-C-Demo
//
//  Created by Ricol Wang on 2024/3/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (MyTimerBlockSupport)

+ (NSTimer *)myScheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(nonnull void (^)(NSTimer * _Nonnull))block;

@end

NS_ASSUME_NONNULL_END
