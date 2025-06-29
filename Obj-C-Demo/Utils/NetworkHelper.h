//
//  NetworkHelper.h
//  Obj-C-Demo
//
//  Created by ricolwang on 2025/6/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkHelper: NSObject

+ (void)fetchDataFromURL:(NSString *)urlString
              completion:(void (^)(NSData *data, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
