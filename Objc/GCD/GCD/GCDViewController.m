//
//  GCDViewController.m
//  GCD
//
//  Created by 高刘通 on 2021/4/11.
//
//微信公众号：技术大咖社
//关注公众号并回复："GCD"获取原文介绍
//如有任何疑问也可直接回复内容即可
//

#import "GCDViewController.h"

@interface GCDViewController ()
{
    dispatch_semaphore_t _semaphore;
}
@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self gcdCreateQueue];
//    [self gcdCreateTask];
//    [self syncSerial];
//    [self syncConcurrent];
//    [self asyncSerial];
//    [self asyncConcurrent];
//    [self syncMain];
//    [self asyncMain];
//    [self syncGlobal];
//    [self asyncGlobal];
//    [self concurrentSyncAsync];
//    [self gcdMessage];
//    [self barrierTask];
//    [self gcdAfter];
//    [self gcdOnce];
//    [self gcdApply];
//    [self gcdGroup];
    [self gcdSemaphoreSync];

    [self gcdSemaphoreLock];
    [self gcdSemaphoreLock];
    [self gcdSemaphoreLock];
}

- (void)gcdCreateQueue {
    dispatch_queue_t queue1 = dispatch_queue_create("com.glt.test.queue1", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue2 = dispatch_queue_create("com.glt.test.queue2", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue3 = dispatch_queue_create("com.glt.test.queue3", NULL);
    dispatch_queue_t queue4 = dispatch_get_main_queue();
    dispatch_queue_t queue5 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSLog(@"%@", queue1);
    NSLog(@"%@", queue2);
    NSLog(@"%@", queue3);
    NSLog(@"%@", queue4);
    NSLog(@"%@", queue5);
}

- (void)gcdCreateTask {
    dispatch_queue_t queue = dispatch_queue_create("com.glt.test.queue1", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(queue, ^{
        NSLog(@"同步任务队列");
    });
    dispatch_async(queue, ^{
        NSLog(@"异步任务队列");
    });
}

- (void)syncSerial {
    dispatch_queue_t queue = dispatch_queue_create("com.glt.test", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        NSLog(@"任务1");
        NSLog(@"当前线程: %@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        sleep(2);
        NSLog(@"任务2");
        NSLog(@"当前线程: %@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"任务3");
        NSLog(@"当前线程: %@", [NSThread currentThread]);
    });
}

- (void)syncConcurrent {
    dispatch_queue_t queue = dispatch_queue_create("com.glt.test", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(queue, ^{
        NSLog(@"任务1");
        NSLog(@"当前线程: %@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        sleep(2);
        NSLog(@"任务2");
        NSLog(@"当前线程: %@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"任务3");
        NSLog(@"当前线程: %@", [NSThread currentThread]);
    });
}

- (void)asyncSerial {
    dispatch_queue_t queue = dispatch_queue_create("com.glt.test", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        NSLog(@"任务1");
        NSLog(@"当前线程: %@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        sleep(2);
        NSLog(@"任务2");
        NSLog(@"当前线程: %@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"任务3");
        NSLog(@"当前线程: %@", [NSThread currentThread]);
    });
}

- (void)asyncConcurrent {
    dispatch_queue_t queue = dispatch_queue_create("com.glt.test", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"任务1 - %@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        sleep(2);
        NSLog(@"任务2 - %@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"任务3 - %@", [NSThread currentThread]);
    });
}

- (void)syncMain {
//    dispatch_queue_t queue = dispatch_queue_create("com.glt.test", DISPATCH_QUEUE_SERIAL);//不会产生死锁
    dispatch_queue_t queue = dispatch_get_main_queue();//产生死锁
    NSLog(@"1");
    dispatch_sync(queue, ^{
        NSLog(@"2");
    });
    NSLog(@"3");
}

- (void)asyncMain {
    dispatch_queue_t queue = dispatch_get_main_queue();
    NSLog(@"1");
    dispatch_async(queue, ^{
        NSLog(@"2");
    });
    NSLog(@"3");
}

- (void)syncGlobal {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(queue, ^{
        NSLog(@"任务1");
        NSLog(@"当前线程: %@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        sleep(2);
        NSLog(@"任务2");
        NSLog(@"当前线程: %@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"任务3");
        NSLog(@"当前线程: %@", [NSThread currentThread]);
    });
}

- (void)asyncGlobal {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSLog(@"任务1 - %@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        sleep(2);
        NSLog(@"任务2 - %@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"任务3 - %@", [NSThread currentThread]);
    });
}

- (void)concurrentSyncAsync {
    dispatch_queue_t queue = dispatch_queue_create("com.glt.test.queue1", DISPATCH_QUEUE_SERIAL);
    NSLog(@"1");
    dispatch_async(queue, ^{
        NSLog(@"4");
        dispatch_sync(queue, ^{
            NSLog(@"2");
        });
        NSLog(@"3");
    });
    NSLog(@"5");
}

- (void)gcdMessage {
    NSLog(@"1");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(2);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"2-刷新UI");
        });
    });
    NSLog(@"3");
}

- (void)barrierTask {
    dispatch_queue_t queue = dispatch_queue_create("com.glt.test", DISPATCH_QUEUE_CONCURRENT);//栅栏函数有效果
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);//栅栏函数无效果
//    dispatch_queue_t queue = dispatch_get_main_queue();//栅栏函数有效果、队列依次执行

    dispatch_async(queue, ^{
        NSLog(@"任务1 - %@", [NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        sleep(2);
        NSLog(@"任务2 - %@", [NSThread currentThread]);
    });
    
    dispatch_barrier_sync(queue, ^{
        sleep(4);
        NSLog(@"栅栏任务 - %@", [NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"任务3 - %@", [NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"任务4 - %@", [NSThread currentThread]);
    });
}

- (void)gcdAfter {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"延时执行任务");
    });
}

- (void)gcdOnce {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"only one");
    });
}

- (void)gcdApply {
    dispatch_queue_t queue = dispatch_queue_create("com.glt.test", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"begain");
    dispatch_apply(6, queue, ^(size_t time) {
        NSLog(@"%zu - %@", time, [NSThread currentThread]);
    });
    NSLog(@"end");
}

- (void)gcdGroup {
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("com.glt.test", DISPATCH_QUEUE_CONCURRENT);

    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        NSLog(@"任务1 - %@", [NSThread currentThread]);
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"任务2 - %@", [NSThread currentThread]);
            dispatch_group_leave(group);
        });
    });
    
//    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        NSLog(@"任务3 - %@", [NSThread currentThread]);
        dispatch_group_leave(group);
    });
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"任务执行完毕 - %@", [NSThread currentThread]);
    });
}

- (void)gcdSemaphoreSync {
    NSInteger ret = [self gcdRet];
    NSLog(@"异步获取函数返回值 - %ld", ret);
}

- (NSInteger)gcdRet {
    __block NSInteger count = 0;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_queue_t queue = dispatch_queue_create("com.glt.test", DISPATCH_QUEUE_CONCURRENT);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{//模拟异步网络请求
        count = 999;
        dispatch_semaphore_signal(semaphore);//+1后为0则继续向下执行
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);//-1后小于0开始阻塞等待
    return count;
}

- (void)gcdSemaphoreLock {
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(1);
    }
    dispatch_queue_t queue = dispatch_queue_create("com.glt.test", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        dispatch_semaphore_wait(self->_semaphore, DISPATCH_TIME_FOREVER);//-1后等于0开始向下进行，之后再执行到这里此处会小于0，产生阻塞，会等待解锁后继续向下执行
        NSLog(@"线程锁-begain");
        sleep(3);
        NSLog(@"线程锁-end");
        dispatch_semaphore_signal(self->_semaphore);//+1后为0，解锁，则继续执行
    });
}


@end
