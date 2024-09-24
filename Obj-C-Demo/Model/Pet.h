//
//  Pet.h
//  Obj-C-Demo
//
//  Created by Ricol Wang on 2024/2/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Pet : NSObject

@property (strong) NSString *name;
@property (strong) Pet *other;

@end

NS_ASSUME_NONNULL_END
