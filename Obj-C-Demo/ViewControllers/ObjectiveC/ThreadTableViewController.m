//
//  ThreadTableViewController.m
//  Obj-C-Demo
//
//  Created by Ricol Wang on 2024/3/27.
//

#import "ThreadTableViewController.h"
#import "Person.h"
#import "MyTimer.h"
#import "MyTimerProxy.h"
#import "Obj_C_Demo-Swift.h"
#import "MyObjcThread.h"
#import "MyHeavyObject.h"
#import "MyOperation.h"
#import "MyOperationQueue.h"
#import "MyTimertarget.h"
#import "NSTimer+MyTimerBlockSupport.h"
#import "Pair.h"

@interface ThreadTableViewController ()
{
    MyThread *thread;
}

@end

@implementation ThreadTableViewController

- (void)testThread {
    [NSThread detachNewThreadSelector:@selector(printInbackgroundThread:) toTarget:self withObject:@"this is another new text in a sperate thread."];
    [self performSelectorInBackground:@selector(printInbackgroundThread:) withObject:@"this should happen in a seperate background thread"];
    NSLog(@"Done.");
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(printInbackgroundThread:) object:@"new text without runloop"];
    [thread start];
}

- (void)testPerformSelectorOnThread {
    NSThread *thread = [[MyObjcThread alloc] initWithTarget:self selector:@selector(runInThread) object:nil];
    [thread start];
    NSLog(@"perform selector on the thread...");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self performSelector:@selector(runInThreadFromMain) onThread:thread withObject:nil waitUntilDone:true];
    });
    NSLog(@"perform selector on the thread...end");
}

- (void)printInbackgroundThread:(NSString *)text {
    sleep(3);
    NSLog(@"[%@]%@", NSThread.currentThread, text);
    NSLog(@"[%@] runloop: %@", NSThread.currentThread, [NSRunLoop currentRunLoop]);
}

- (void)runInThread {
    NSLog(@"[%@]%s begin...", [NSThread currentThread], __FUNCTION__);
//    [[NSRunLoop currentRunLoop] addPort:[NSMachPort new] forMode:NSDefaultRunLoopMode]; //no need to add a port
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:5]];
    NSLog(@"[%@]%s end.", [NSThread currentThread], __FUNCTION__);
}

- (void)testLock {
    {
        NSConditionLock *conditionLock = [[NSConditionLock alloc] init];
        NSMutableArray *arrayM = [NSMutableArray array];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [conditionLock lock];
            for (int i = 0; i < 6; i++) {
                sleep(1);
                [arrayM addObject:@(i)];
                NSLog(@"异步下载第 %d 张图片",i);
                if (arrayM.count == 4) {// 当下载四张图片就回到主线程刷新
                    [conditionLock unlockWithCondition:4];
                }
            }
        });
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"lockwhencondition...");
            [conditionLock lockWhenCondition:4];
            NSLog(@"已经下载4张图片%@",arrayM);
            [conditionLock unlock];
        });
    }
    {
        NSConditionLock *lock = [[NSConditionLock alloc] initWithCondition:0];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [lock lockWhenCondition:1];
            NSLog(@"线程1");
            sleep(2);
            [lock unlock];
        });
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if ([lock tryLockWhenCondition:0]) {
                NSLog(@"线程2");
                [lock unlockWithCondition:3];
                NSLog(@"线程2解锁成功");
            }else {
                NSLog(@"线程2尝试加锁失败");
            }
        });
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if ([lock tryLockWhenCondition:3]) {
                NSLog(@"线程3");
                [lock unlockWithCondition:4];
                NSLog(@"线程3解锁成功");
            }else {
                NSLog(@"线程3尝试加锁失败");
            }
            
            [lock lockWhenCondition:3];
            NSLog(@"线程3");
            [lock unlockWithCondition:4];
            NSLog(@"线程3解锁成功");
        });
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [lock lockWhenCondition:4];
            NSLog(@"线程4");
            [lock unlockWithCondition:1];
            NSLog(@"线程4解锁成功");
        });
    }
}

- (void)testSemaphore {
    {
        // 创建信号量并初始化信号量的值为0
         dispatch_semaphore_t semaphone = dispatch_semaphore_create(0);
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{     // 线程1
            sleep(2);
            NSLog(@"async1.... %@",[NSThread currentThread]);
            dispatch_semaphore_signal(semaphone);//信号量+1
        });
         
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{     // 线程1
             sleep(2);
             NSLog(@"async2.... %@",[NSThread currentThread]);
             dispatch_semaphore_signal(semaphone);//信号量+1
             dispatch_semaphore_signal(semaphone);//信号量+1
         });
         
        NSLog(@"waiting...");
         dispatch_semaphore_wait(semaphone, DISPATCH_TIME_FOREVER);//信号量减1
        NSLog(@"1...");
        dispatch_semaphore_wait(semaphone, DISPATCH_TIME_FOREVER);//信号量减1
        NSLog(@"2...");
        dispatch_semaphore_wait(semaphone, DISPATCH_TIME_FOREVER);//信号量减1
        NSLog(@"3...");

         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
             // 线程2
             sleep(2);
             NSLog(@"async3.... %@",[NSThread currentThread]);
             dispatch_semaphore_signal(semaphone);//信号量+1
         });

    }
    {
        // 创建信号量并初始值为5，最大并发量5
        dispatch_semaphore_t semaphore =  dispatch_semaphore_create(10);
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        for (int i = 0;i < 100 ; i ++) {
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            dispatch_async(queue, ^{
                NSLog(@"i = %d  %@",i,[NSThread currentThread]);
                //此处模拟一个 异步下载图片的操作
                sleep(arc4random()%6);
                dispatch_semaphore_signal(semaphore);
            });
        }
    }
}

- (void) testDispatchBarrier {
    {
        // 并发队列
        dispatch_queue_t queue = dispatch_queue_create("com.gcd.brrier", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(queue, ^{
            sleep(1);
            NSLog(@"任务1 -- %@",[NSThread currentThread]);
        });
        dispatch_async(queue, ^{
            sleep(2);
            NSLog(@"任务2 -- %@",[NSThread currentThread]);
        });
        
        // 栅栏函数，修改同步栅栏和异步栅栏，观察“栅栏结束”的打印位置
        dispatch_sync(queue, ^{
            for (int i = 0; i < 4; i++) {
                NSLog(@"任务3 --- log:%d -- %@",i,[NSThread currentThread]);
            }
        });
        
        // 在这里执行一个输出
        NSLog(@"栅栏结束");
        
        dispatch_async(queue, ^{
            sleep(1);
            NSLog(@"任务4 -- %@",[NSThread currentThread]);
        });
        dispatch_async(queue, ^{
            sleep(2);
            NSLog(@"任务5 -- %@",[NSThread currentThread]);
        });
    }
    
    {
        // 并发队列
        dispatch_queue_t queue = dispatch_queue_create("com.gcd.brrier", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(queue, ^{
            sleep(1);
            NSLog(@"任务1 -- %@",[NSThread currentThread]);
        });
        dispatch_async(queue, ^{
            sleep(2);
            NSLog(@"任务2 -- %@",[NSThread currentThread]);
        });
        
        // 栅栏函数，修改同步栅栏和异步栅栏，观察“栅栏结束”的打印位置
        dispatch_barrier_sync(queue, ^{
            for (int i = 0; i < 4; i++) {
                NSLog(@"任务3 --- log:%d -- %@",i,[NSThread currentThread]);
            }
        });
        
        // 在这里执行一个输出
        NSLog(@"栅栏结束");
        
        dispatch_async(queue, ^{
            sleep(1);
            NSLog(@"任务4 -- %@",[NSThread currentThread]);
        });
        dispatch_async(queue, ^{
            sleep(2);
            NSLog(@"任务5 -- %@",[NSThread currentThread]);
        });
    }
}

- (void)runInThreadFromMain {
    NSLog(@"[%@]%s", [NSThread currentThread], __FUNCTION__);
}

- (void)testOperationQueue {
    MyOperationQueue *queue = [[MyOperationQueue alloc] init];
    MyOperation *o1 = [MyOperation new];
    o1.text = @"o1";
    MyOperation *o2 = [MyOperation new];
    o2.text = @"o2";
    [o1 addDependency:o2];
    [queue addOperation:o1];
    [queue addOperation:o2];
}

- (void)testGCD {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"1");
    });

    NSLog(@"2");

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND,0);

    dispatch_sync(queue, ^{
        NSLog(@"3");
    });

    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"4");
    });

    dispatch_async(queue, ^{
        NSLog(@"5");
    });

    NSLog(@"6");

    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0];

    NSLog(@"8");
}

- (void)delayMethod {
    NSLog(@"7");
}

- (void)testThreadAsService {
    MyThread *t = [[MyThread alloc] initWithTarget:self selector:@selector(serviceThreadAction) object:nil];
    [t start];
    Pair *p = [Pair new];
    p.from = 0;
    p.to = 100;
    [t performSelector:@selector(calculateWithPairWithP:) withObject:p];
    thread = t;
//    [self performSelector:@selector(getPrimes:) onThread:thread withObject:p waitUntilDone:true];
//    [thread performSelector:@selector(calculateWithPairWithP:) withObject:p];
}
//
//- (NSArray *)getPrimes:(Pair *)p {
////    NSArray *r = [p.thread calculateFrom:p.from to:p.to];
////    NSLog(@"[%@]%s...r: %@", [NSThread currentThread], __FUNCTION__, r);
////    return r;
//}

- (void)serviceThreadAction {
    NSLog(@"[%@]%s...", [NSThread currentThread], __FUNCTION__);
    [[NSRunLoop currentRunLoop] addPort:[NSPort new] forMode:NSRunLoopCommonModes];
    [[NSRunLoop currentRunLoop] run];
    NSLog(@"[%@]%s...end", [NSThread currentThread], __FUNCTION__);
}

- (void)testThreadAsServiceRun {
    Pair *p = [Pair new];
    p.from = 0;
    p.to = 100;
    [thread performSelector:@selector(calculateWithPairWithP:) withObject:p];
    [thread performSelector:@selector(calculateWithPairWithP:) withObject:p afterDelay:5];
    [thread performSelector:@selector(calculateWithPairWithP:) onThread:thread withObject:p waitUntilDone:true];
}

@end
