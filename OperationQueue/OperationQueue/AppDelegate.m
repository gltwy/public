//
//  AppDelegate.m
//  OperationQueue
//
//  Created by 高刘通 on 2021/4/11.
//
//微信公众号：技术大咖社
//关注公众号并回复："OperationQueue"获取原文介绍
//如有任何疑问也可直接回复内容即可
//

#import "AppDelegate.h"
#import "RootViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[RootViewController new]];
    [self.window makeKeyAndVisible];
    return YES;
}


@end
