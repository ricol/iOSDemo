//
//  Person.h
//  Obj-C-Demo
//
//  Created by Ricol Wang on 2024/2/13.
//

#import <Foundation/Foundation.h>
#import "Pet.h"

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@property (strong) Pet *pet;
@property (strong) NSString *name;
@property int age;
@property (copy) NSString *address;

- (void)display;
- (void)newDisplay;

@end

@interface Person (newMethod)

- (NSString *)getDisplay;
@property (strong) NSString *infor;
- (void)testFun;
+ (void)testClassFun;

@end

@interface Person ()
@property (strong) NSString *others;
- (void)displayOthers;
@end

@interface Person ()
@property (strong) NSString *information;
- (void)displayInfor;
@end

@interface NSObject (Category)

@property (strong) NSString *name;
- (void)display;

@end

@implementation NSObject (Category)

@dynamic name;

- (void)display {
    NSLog(@"%@%s", self, __FUNCTION__);
}

@end

NS_ASSUME_NONNULL_END
