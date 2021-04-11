//
//  RootViewController.m
//  OperationQueue
//
//  Created by 高刘通 on 2021/4/11.
//
//微信公众号：技术大咖社
//关注公众号并回复："OperationQueue"获取原文介绍
//如有任何疑问也可直接回复内容即可
//

#import "RootViewController.h"

@interface CustomOperation : NSOperation
@property(assign, nonatomic, getter=isFinished) BOOL finished;
@property(assign, nonatomic, getter=isExecuting) BOOL executing;
@property(assign, nonatomic, getter=isStart) BOOL start;
@end

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    [self createOperation];
//    [self addToQueue];
//    [self addDependency];
//    [self setQueuePriority];
//    [self resumeSuspend];
//    [self waitFinished];
//    [self cancelOpetaions];
//    [self maxConcurrentOpetaions];
    [self customOperation];
}

- (void)createOperation {
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationSel:) object:@"obj"];
    [op start];
    
    NSBlockOperation *blockOp = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"block - %@", [NSThread currentThread]);
    }];
    [blockOp start];
}

- (void)invocationSel:(id)object {
    NSLog(@"%@ - %@", object, [NSThread currentThread]);
}

- (void)addToQueue {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationSel:) object:@"obj"];
//    [op start];//调用start之后就不可以再入队
    
    NSBlockOperation *blockOp = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"block - %@", [NSThread currentThread]);
    }];
    //添加单个
    [queue addOperation:op];
    [queue addOperation:blockOp];
    //添加一组
//    [queue addOperations:@[op, blockOp] waitUntilFinished:NO];
    
//    [op start];
//    [op cancel];
}

- (void)addDependency {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationSel:) object:@"obj"];
    
    NSBlockOperation *blockOp = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"block - %@", [NSThread currentThread]);
    }];
    
    [op addDependency:blockOp];//添加依赖
//    [blockOp addDependency:op];//相互依赖
//    [op removeDependency:blockOp];//移除依赖
    
    [queue addOperation:op];
    [queue addOperation:blockOp];
}

- (void)setQueuePriority {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationSel:) object:@"obj"];
    
    NSBlockOperation *blockOp = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"block - %@", [NSThread currentThread]);
        sleep(3);
    }];
    
    [op setQueuePriority:NSOperationQueuePriorityHigh];
    [blockOp setQueuePriority:NSOperationQueuePriorityLow];

    [op addDependency:blockOp];
    
    [queue addOperation:op];
    [queue addOperation:blockOp];
}


- (void)resumeSuspend {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationSel:) object:@"obj"];
    
    NSBlockOperation *blockOp = [NSBlockOperation blockOperationWithBlock:^{
        sleep(3);
        NSLog(@"block - %@", [NSThread currentThread]);
    }];
    
//    [queue setSuspended:YES];//挂起
//    [queue setSuspended:NO];//恢复
    
    [queue addOperation:op];
    [queue addOperation:blockOp];
}

- (void)waitFinished {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationSel:) object:@"obj"];
    
    NSBlockOperation *blockOp = [NSBlockOperation blockOperationWithBlock:^{
        sleep(3);
        NSLog(@"block - %@", [NSThread currentThread]);
    }];
    
//    [queue waitUntilAllOperationsAreFinished];
    
    [queue addOperation:blockOp];
//    [blockOp waitUntilFinished];
//    [queue waitUntilAllOperationsAreFinished];
    
    [queue addOperation:op];
    NSLog(@"end");
}

- (void)cancelOpetaions {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationSel:) object:@"obj"];
    
    NSBlockOperation *blockOp = [NSBlockOperation blockOperationWithBlock:^{
        sleep(3);
        NSLog(@"block - %@", [NSThread currentThread]);
    }];
    
    
    [queue addOperation:blockOp];
    [queue addOperation:op];
    
    [queue cancelAllOperations];// 两个操作都不会执行
}

- (void)maxConcurrentOpetaions {
    NSLog(@"begain");
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 2;
    
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationSel:) object:@"obj"];
    
    NSBlockOperation *blockOp = [NSBlockOperation blockOperationWithBlock:^{
        sleep(5);
        NSLog(@"block - %@", [NSThread currentThread]);
    }];
    
    
    [queue addOperation:blockOp];
    [queue addOperation:op];
    
    
    NSBlockOperation *blockOp2 = [NSBlockOperation blockOperationWithBlock:^{
        sleep(1);
        NSLog(@"block - %@", [NSThread currentThread]);
    }];
    [queue addOperation:blockOp2];
}

- (void)customOperation {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 1;
    CustomOperation *op = [[CustomOperation alloc] init];
    [queue addOperation:op];
}
@end

@implementation CustomOperation

@synthesize finished = _finished, executing = _executing;

- (BOOL)isAsynchronous {
    return NO;
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"finished"];
    _finished = finished;
    [self didChangeValueForKey:@"finished"];
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"executing"];
    _executing = executing;
    [self didChangeValueForKey:@"executing"];
}

- (void)start {
    @synchronized (self) {
        self.start = YES;
        if (self.isCancelled) {
            [self completed];
            return;
        }
        @autoreleasepool {
            [self main];
        }
        self.executing = YES;
    }
}

- (void)main {//在此处做一些更复杂的操作
    NSLog(@"准备开始执行任务啦～ %@", [NSThread currentThread]);
    //模拟3s后执行doSomething
    [self performSelector:@selector(doSomething:) withObject:nil afterDelay:3.0];
    [[NSRunLoop currentRunLoop] run];//此处需要添加到Runloop，子线程默认没有开启，后期文章会具体说明
}

- (void)doSomething:(id)obj {
    NSLog(@"完成了当前的任务！ %@", [NSThread currentThread]);
    [self completed];
}

- (void)completed {
    @synchronized (self) {
        self.executing = NO;
        self.finished = YES;
    }
}

- (void)cancel {
    [super cancel];
    if (self.isStart) {
        [self completed];
    }
}

@end

