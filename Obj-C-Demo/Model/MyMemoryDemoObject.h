//
//  MyMemoryDemoObject.h
//  Obj-C-Demo
//
//  Created by ricolwang on 2025/6/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyMemoryDemoObject : NSObject
@property (strong) NSObject *aCopy; //do not create a self referenced copy. it will lead to memory leak.
- (void)update;

@end

NS_ASSUME_NONNULL_END
