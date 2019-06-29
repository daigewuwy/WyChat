//
//  ViewManager.m
//  WWYTopBarView
//
//  Created by 吴伟毅 on 17/7/2.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ViewManager.h"
#import "WCContactsVC.h"
#import "WCMyInfoVC.h"
#import "WCHomePageVC.h"

@implementation ViewManager


@synthesize NavigationController = _navigationController;


+(instancetype)shareInstance {
    
    static ViewManager *_sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //不能再使用alloc方法
        //因为已经重写了allocWithZone方法，所以这里要调用父类的分配空间的方法
        _sharedSingleton = [[super allocWithZone:NULL] init];
    });
    return _sharedSingleton;
}

// 防止外部调用alloc 或者 new
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [ViewManager shareInstance];
}

// 防止外部调用copy
- (id)copyWithZone:(nullable NSZone *)zone {
    return [ViewManager shareInstance];
}

// 防止外部调用mutableCopy
- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    return [ViewManager shareInstance];
}

-(id)init {
    
    self = [super init];
    if(self != nil) {
        
        CGFloat scale = 0.35;
        UIImage *unConImg = [[UIImage scaleImageWithName:@"tabBar_conversation_normal" withScale:scale] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *conImg = [[UIImage scaleImageWithName:@"tabBar_conversation_highLight" withScale:scale] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *unContactImg = [[UIImage scaleImageWithName:@"tabBar_contact_normal" withScale:scale] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *contactImg = [[UIImage scaleImageWithName:@"tabBar_contact_highLight" withScale:scale] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *unMyInfoImg = [[UIImage scaleImageWithName:@"tabBar_myinfo_normal" withScale:scale] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *myInfoImg = [[UIImage scaleImageWithName:@"tabBar_myinfo_highLight" withScale:scale] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        
        WCHomePageVC *homePageVC = [WCHomePageVC new];
        [homePageVC.tabBarItem initWithTitle:@"消息" image:unConImg selectedImage:conImg];
        
        WCContactsVC *mailVC = [WCContactsVC new];
        [mailVC.tabBarItem initWithTitle:@"通讯录" image:unContactImg selectedImage:contactImg];

        WCMyInfoVC *myInfoVC = [WCMyInfoVC new];
        [myInfoVC.tabBarItem initWithTitle:@"我的" image:unMyInfoImg selectedImage:myInfoImg];
        
        UITabBarController *tabBarVC = [[UITabBarController alloc]init];
        tabBarVC.selectedIndex = 0;
        [tabBarVC setViewControllers:@[homePageVC,mailVC,myInfoVC]];
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:MainColor} forState:UIControlStateSelected];
        
        //设置首页
        _navigationController = [[UINavigationController alloc]init];
        
        _navigationController.navigationBar.hidden = YES;
        
        _navigationController.interactivePopGestureRecognizer.enabled = NO;
        
        [_navigationController setViewControllers:@[tabBarVC]];
        
    }
    
    return self;
}

@end
