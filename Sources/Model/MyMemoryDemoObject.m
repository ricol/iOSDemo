//
//  MyMemoryDemoObject.m
//  Obj-C-Demo
//
//  Created by ricolwang on 2025/6/29.
//

#import "MyMemoryDemoObject.h"
#import "NetworkHelper.h"
#import "Obj_C_Demo-Swift.h"

@interface MyMemoryDemoObject()

@property (strong) NSString *content;

@end

@implementation MyMemoryDemoObject

- (instancetype)init {
    self = [super init];
    [[CountVC shared] allocWithVc:self];
    return self;
}

- (void)dealloc {
    [[CountVC shared] deallocWithVc:self];
}

- (void)update {
    [NetworkHelper fetchDataFromURL:@"https://www.baidu.com" completion:^(NSData * _Nonnull data, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"Error: %@", error);
            return;
        }
            
        // Process data
        NSLog(@"[%@] response: %lu", self, (unsigned long)data.length);
        NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [self updateContent:content];
    }];
}

- (void)updateContent:(NSString *)content {
    self.content = content;
    NSLog(@"[%@] content updated. size: %lu", self, (unsigned long)self.content.length);
}

@end
