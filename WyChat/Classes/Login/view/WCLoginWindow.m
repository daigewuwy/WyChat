//
//  WCLoginWindow.m
//  WyChat
//
//  Created by 吴伟毅 on 19/5/30.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "WCLoginWindow.h"
#import "WCLoginVC.h"

@implementation WCLoginWindow

+(instancetype)shareInstance {
    
    static WCLoginWindow *_sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //不能再使用alloc方法
        //因为已经重写了allocWithZone方法，所以这里要调用父类的分配空间的方法
        _sharedSingleton = [[super allocWithZone:NULL] init];
        
        WCLoginVC *loginVC = [WCLoginVC new];
        _sharedSingleton.rootViewController = loginVC;
        // 根据登录状态控制显示LoginWindow
        loginVC.loginState = ^(BOOL isLogin) {
            if(NO == isLogin) {
                [[WCLoginWindow shareInstance] showWindow];
            }else
            {
                [[WCLoginWindow shareInstance] hideWindow];
            }
        };
    });
    return _sharedSingleton;
}

-(void)showWindow {
    self.hidden = NO;
    [self makeKeyAndVisible];
}

-(void)hideWindow {
    self.hidden = YES;
    [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
}

// 防止外部调用alloc 或者 new
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [WCLoginWindow shareInstance];
}

// 防止外部调用copy
- (id)copyWithZone:(nullable NSZone *)zone {
    return [WCLoginWindow shareInstance];
}

// 防止外部调用mutableCopy
- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    return [WCLoginWindow shareInstance];
}
@end
