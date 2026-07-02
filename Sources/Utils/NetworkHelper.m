//
//  NetworkHelper.m
//  Obj-C-Demo
//
//  Created by ricolwang on 2025/6/29.
//

#import "NetworkHelper.h"

// NetworkHelper.m
@implementation NetworkHelper

+ (void)fetchDataFromURL:(NSString *)urlString
              completion:(void (^)(NSData *data, NSError *error))completion {
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url
                                                            completionHandler:^(NSData *data,
                                                                                NSURLResponse *response,
                                                                                NSError *error) {
        if (completion) {
            completion(data, error);
        }
    }];
    [task resume];
}

@end

