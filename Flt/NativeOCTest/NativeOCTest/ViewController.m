//
//  ViewController.m
//  NativeOCTest
//
//  Created by 高刘通 on 2023/3/19.
//

#import "ViewController.h"
#import <Flutter/Flutter.h>

@interface ViewController ()<FlutterStreamHandler>
@property(strong, nonatomic) NSTimer *timer;
@property(strong, nonatomic) FlutterEngine *flutterEngine;
@property(strong, nonatomic) FlutterViewController *flutterVC;
@property(strong, nonatomic) FlutterBasicMessageChannel *basicMessageChannel;
@property(strong, nonatomic) FlutterEventChannel *eventChannel;
@property(copy, nonatomic) FlutterEventSink eventSink;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self startTimer];
    NSLog(@"跳转请点击屏幕");
}

static int goIndex = 0;
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    goIndex % 2 == 0 ? [self jumpOne] : [self jumpTwo];
    goIndex += 1;
}

//FlutterStreamHandler协议方法
- (FlutterError *)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events {
    _eventSink = events;
    NSLog(@"开始监听");
    return nil;
}

- (FlutterError *)onCancelWithArguments:(id)arguments {
    NSLog(@"取消监听");
    return nil;
}

- (void)startTimer {
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakSelf basicTest]; //定时向Flutter发送消息
        [weakSelf eventTest]; //定时向Flutter发送消息
    }];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)eventTest {
    [self eventChannel];
    if (self.eventSink) {
        self.eventSink(@"OC通过EventChannel向Flutter发送消息(OC参数类型是id)");
    }
}

//定时向Flutter发送消息
- (void)basicTest {
    [self.basicMessageChannel sendMessage:@"oc发送消息给fluuter"];
}

- (void)jumpOne {
    //注册FlutterMethodChannel - 并指定名称ChannelName为one
    FlutterMethodChannel *methodChannel = [FlutterMethodChannel methodChannelWithName:@"one" binaryMessenger:self.flutterVC.binaryMessenger];
    
    //调用Flutter方法，并指定method位one_title
    [methodChannel invokeMethod:@"one_title" arguments:@{} result:nil];
    
    //监听Flutter调用oc的方法
    __weak typeof(self) weakSelf = self;
    [methodChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        if ([call.method isEqualToString:@"back"]) {
            [weakSelf.flutterVC dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
    self.flutterVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:self.flutterVC animated:YES completion:nil];
}

- (void)jumpTwo {
    FlutterMethodChannel *methodChannel = [FlutterMethodChannel methodChannelWithName:@"two" binaryMessenger:self.flutterVC.binaryMessenger];
    [methodChannel invokeMethod:@"two_title" arguments:@{} result:nil];
    __weak typeof(self) weakSelf = self;
    [methodChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        if ([call.method isEqualToString:@"back"]) {
            [weakSelf.flutterVC dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    self.flutterVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:self.flutterVC animated:YES completion:nil];
}

- (FlutterEngine *)flutterEngine {
    if (!_flutterEngine) {
        FlutterEngine *engine = [[FlutterEngine alloc] init];
        if (engine.run) {
            _flutterEngine = engine;
        }
    }
    return _flutterEngine;
}

- (FlutterViewController *)flutterVC {
    if (!_flutterVC) {
        _flutterVC = [[FlutterViewController alloc] initWithEngine:self.flutterEngine nibName:nil bundle:nil];
    }
    return _flutterVC;
}


- (FlutterBasicMessageChannel *)basicMessageChannel {
    if (!_basicMessageChannel) {
        //注册FlutterBasicMessageChannel - 并指定名称messageChannelName为basicMessageChannel
        _basicMessageChannel = [FlutterBasicMessageChannel messageChannelWithName:@"basicMessageChannel" binaryMessenger:self.flutterVC.binaryMessenger];
        
        //监听Flutter发来的消息 - Flutter调用OC回调监听
        [_basicMessageChannel setMessageHandler:^(id  _Nullable message, FlutterReply  _Nonnull callback) {
            NSLog(@"OC收到Flutter的FlutterBasicMessageChannel - %@", message);
        }];
    }
    return _basicMessageChannel;
}

- (FlutterEventChannel *)eventChannel {
    if (!_eventChannel) {
        _eventChannel = [FlutterEventChannel eventChannelWithName:@"eventChannel" binaryMessenger:self.flutterVC.binaryMessenger];
        [_eventChannel setStreamHandler:self];
    }
    return _eventChannel;
}

@end

