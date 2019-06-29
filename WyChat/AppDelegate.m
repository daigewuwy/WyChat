//
//  AppDelegate.m
//  WyChat
//
//  Created by 吴伟毅 on 19/5/30.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "AppDelegate.h"
#import "WCLoginWindow.h"
#import "WCLoginVC.h"
#import "WCFriendApplyModel.h"
#import "WCLoginWindow.h"


@interface AppDelegate ()<EMClientDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 初始化IMSDK
    [self initIMSDK];
    
    self.window = [[UIWindow alloc] init];
    [self.window setFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [ViewManager shareInstance].NavigationController;    
    [self.window makeKeyAndVisible];

    // 判断是否登录过
    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
    
    if (!isAutoLogin) {
        [[WCLoginWindow shareInstance] showWindow];
    }else
    {
        [[WCLoginWindow shareInstance] hideWindow];
    }
    
    return YES;
}


- (void)initIMSDK {
    
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名
    EMOptions *options = [EMOptions optionsWithAppkey:EMAPPKEY];
    //options.apnsCertName = @"istore_dev";
    
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
}

/*!
 *  自动登录返回结果
 *
 *  @param error 错误信息
 */
- (void)autoLoginDidCompleteWithError:(EMError *)error {
    if(nil == error) {
        
    }else
    {
        [[WCLoginWindow shareInstance] showWindow];
    }
}

/*!
 *  当前登录账号在其它设备登录时会接收到该回调
 */
- (void)userAccountDidLoginFromOtherDevice {
    NSLog(@"账号在其他设备登陆");
    [[WCLoginWindow shareInstance] showWindow];
}

/*!
 *  当前登录账号已经被从服务器端删除时会收到该回调
 */
- (void)userAccountDidRemoveFromServer {
    NSLog(@"账号被服务器删除");
    [[WCLoginWindow shareInstance] showWindow];
}

// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}



- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}



- (void)applicationWillTerminate:(UIApplication *)application {
    // 应用即将关闭，给各个控制器发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kApplicationWillCloseNotification object:nil];
}

-(void)dealloc {
    //移除好友回调
    [[EMClient sharedClient].contactManager removeDelegate:self];
}

@end
