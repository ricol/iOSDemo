//
//  ObjectiveCTableViewController.m
//  Obj-C-Demo
//
//  Created by Ricol Wang on 2024/3/23.
//

#import "ObjectiveCTableViewController.h"
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
#import "ObjcUtils.h"

@interface ObjectiveCTableViewController ()

@property (strong) MyClassForKVO *o;
@property (copy) void (^block)(void);
@property (strong) NSTimer *timer;
@property (strong) NSTimer *timerWithProxy;
@property (strong) dispatch_source_t gcdtimer;
@property int data;
@property (strong) NSThread *thread;
@property (strong) NSTimer *intermediateTimer;
@property (strong) MyTimer *mytimer;
@property (strong) NSTimer *myblocktimer;

@end

@implementation ObjectiveCTableViewController

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"keyPath: %@, object: %@, change: %@, context: %@", keyPath, object, change, context);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    [self.intermediateTimer invalidate];
    [self.mytimer invalidate];
}

- (void)dealloc
{
    [self.myblocktimer invalidate];
    [self.timerWithProxy invalidate];
}

- (void)testBlock {
    {
        //define a block variable
        int (^b)(int, int) = ^(int a, int b) {
            return a + b;
        };
        int c = b(1, 2);
        NSLog(@"%d", c);
        b = ^(int a, int b) {
            return a * b;
        };
        c = b(2, 3);
        NSLog(@"%d", c);
    }
    {
        //test block capturing outside variable
        int a = 0;
        void (^block)(void) = ^ {
            NSLog(@"block...%d", a);
        };
        a = 1;
        block();
        NSLog(@"%d", a);
    }
    {
        //use __block to alter the variable in the block
        __block int a = 0;
        void (^block)(void) = ^ {
            NSLog(@"block before...%d", a);
            a = 2;
            NSLog(@"block after...%d", a);
        };
        a = 1;
        block();
        NSLog(@"a: %d", a);
    }
    {
        //test retain cycle issue in block
        __weak ObjectiveCTableViewController *weakself = self;
        void (^block)(void) = ^{
            ObjectiveCTableViewController *strongSelf = weakself;
            NSLog(@"%@", strongSelf);
        };
        block();
        [self runBlock:block];
        _block = block;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ObjectiveCTableViewController *strongSelf = weakself;
            if (strongSelf != nil) strongSelf.block();
            else NSLog(@"weakself is nil!");
        });
    }
}

- (void)runBlock:(void (^)(void))block {
    block();
}

- (void)testTimer {
    self.timer = [[NSTimer alloc] initWithFireDate:[NSDate now] interval:1 target:self selector:@selector(timerOnRun) userInfo:nil repeats:true];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)testProxyTimer {
    MyTimerProxy *proxy = [MyTimerProxy alloc];
    proxy.vc = self;
    self.timerWithProxy = [NSTimer scheduledTimerWithTimeInterval:1 target:proxy selector:@selector(timerTriggered:) userInfo:nil repeats:true];
}

- (void)testIntermediateTimer {
    //better
    self.intermediateTimer = [MyTimertarget scheduledTimerWithTimeInterval:1 target:self selector:@selector(intermediateTimerAction) userInfo:nil repeats:true];
}

- (void)testBlockTimer {
    __weak ObjectiveCTableViewController *weakself = self;
    self.myblocktimer = [NSTimer myScheduledTimerWithTimeInterval:1 repeats:true block:^(NSTimer * _Nonnull) {
        NSLog(@"%@", weakself);
        [weakself blockTimerAction];
    }];
}

- (void)blockTimerAction {
    NSLog(@"[%@]%s...", self, __FUNCTION__);
}

- (void)intermediateTimerAction {
    NSLog(@"[%@]%s...", self, __FUNCTION__);
}

- (IBAction)btnNewVCOnTapped:(id)sender {
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ObjectiveCTableViewController *vc = [board instantiateViewControllerWithIdentifier:@"ObjectiveCTableViewController"];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)timerOnRun {
    NSLog(@"timer...%@", [NSDate date]);
}

- (void)timerTriggered:(NSTimer *)timer {
    NSLog(@"%s...%@", __FUNCTION__, [NSDate now]);
}

- (void)testGCDTimer {
    self.data = 0;
    dispatch_queue_t queue = dispatch_queue_create("timerQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_source_t gcdtimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    uint64_t start = 1.0; //2后开始执行
    uint64_t interval = 3.0;//每隔1s执行
    dispatch_source_set_timer(gcdtimer, DISPATCH_TIME_NOW, start * NSEC_PER_SEC, interval * NSEC_PER_SEC);
    dispatch_source_set_event_handler(gcdtimer, ^{
        self.data += 1;
        if (self.data > 10) {
            dispatch_source_cancel(gcdtimer);
        }
        NSLog(@"GCD----%@ [%d]",[NSThread currentThread], self.data);
    });
    dispatch_resume(gcdtimer);
    self.gcdtimer = gcdtimer;
}

- (void)testNotification {
    MyNotifClass *c = [MyNotifClass new];
    [c testNotif];
}

- (void)testKVO {
    MyClassForKVO *o = [MyClassForKVO new];
    self.o = o;
    [o observePropertyWithO:self];
    o.name = @"ricol wang";
    o.age = 21;
    [o observePropertyWithO:o];
    o.name = @"wangxinghe";
    o.age = 22;
    [o changeProperty];
    
    Person *p = [Person new];
    p.name = @"ricol";
    p.age = 41;
    p.address = @"51 cardigan street, carlton, vic, australia";
    Pet *pet = [Pet new];
    pet.name = @"xiaowanzi";
    Pet *newPet = [Pet new];
    newPet.name = @"xiaotuzi";
    p.pet = pet;
    pet.other = newPet;
    [p display];
    [p testFun];
    [p displayOthers];
    [p displayInfor];
    NSString *name = [p valueForKey:@"name"];
    NSLog(@"name: %@", name);
    name = [p valueForKeyPath:@"pet.name"];
    NSLog(@"pet.name: %@", name);
    name = [p valueForKeyPath:@"pet.other.name"];
    NSLog(@"pet.other.name: %@", name);
    [p addObserver:self forKeyPath:@"pet.other.name" options:NSKeyValueObservingOptionNew context:nil];
    p.pet.other.name = @"xiaotuzi_xiaotuzi";
    name = [p valueForKeyPath:@"pet.other.name"];
    NSLog(@"pet.other.name: %@", name);
    [p removeObserver:self forKeyPath:@"pet.other.name"];
    p.pet.other.name = @"xiaotuzi_xiaotuzi_xiaotuzi";
    [p addObserver:self forKeyPath:@"pet.other.data" options:NSKeyValueObservingOptionNew context:nil];
    [p.pet.other setValue:@(1) forKey:@"data"];
}

- (void)testCategory {
    NSObject *o = [NSObject new];
    [o display];
}

- (void)testExtension {
    
}

- (void)testObjcUtils {
    [[[ObjcUtils alloc] init] testSets];
}

- (void)testAutoReleasePool {
    [NSThread detachNewThreadSelector:@selector(testAutoReleasePoolInThread) toTarget:self withObject:nil];
//    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(testAutoReleasePoolInThread) object:nil];
//    [thread start];
}

- (void)testAutoReleasePoolInThread {
    NSLog(@"[%@]%s...begin...", [NSThread currentThread], __FUNCTION__);
    for (int i = 0; i <= 5; i++) {
        MyHeavyObject *o = [self getObject];
        [o display];
    }
    NSLog(@"[%@]%s...end", [NSThread currentThread], __FUNCTION__);
}

- (MyHeavyObject *)getObject {
    MyHeavyObject *o = [[MyHeavyObject alloc] init];
    [o display];
    return o;
}

- (void)testNotificationQueue {
    MyNotifClass *c = [MyNotifClass new];
    [c testNotificationQueue];
}

@end
