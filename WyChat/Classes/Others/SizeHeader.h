//
//  SizeHeader.h
//  projectBase
//
//  Created by chenjianying on 15-9-11.
//  Copyright (c) 2015年 chenjianying. All rights reserved.
//

#ifndef projectBase_SizeHeader_h
#define projectBase_SizeHeader_h
// 环信   
#define EMAPPKEY @"1132190530181851#wychat"

// 收到新的好友同意
#define kGetNewFriendAgreeNotification @"NewFriendAgree"

// 收到信的好友申请
#define kGetNewFriendApplyNotification @"NewFriendApply"

// 应用程序即将关闭，用于通知各个控制器
#define kContactWillAppear @"ContactWillAppear"

// 应用程序即将关闭，用于通知各个控制器
#define kApplicationWillCloseNotification @"ApplicationWillClose"


#define kIs_iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define kIs_iPhoneX kScreenWidth >=375.0f && kScreenHeight >=812.0f&& kIs_iphone

/*状态栏高度*/
#define kStatusBarHeight (CGFloat)(kIs_iPhoneX?(44.0):(20.0))
/*导航栏高度*/
#define kNavBarHeight (44)
/*状态栏和导航栏总高度*/
#define kNavBarAndStatusBarHeight (CGFloat)(kIs_iPhoneX?(88.0):(64.0))
/*TabBar高度*/
#define kTabBarHeight (CGFloat)(kIs_iPhoneX?(49.0 + 34.0):(49.0))
/*顶部安全区域远离高度*/
#define kTopBarSafeHeight (CGFloat)(kIs_iPhoneX?(44.0):(0))
/*底部安全区域远离高度*/
#define kBottomSafeHeight (CGFloat)(kIs_iPhoneX?(34.0):(0))
/*iPhoneX的状态栏高度差值*/
#define kTopBarDifHeight (CGFloat)(kIs_iPhoneX?(24.0):(0))
/*导航条和Tabbar总高度*/
#define kNavAndTabHeight (kNavBarAndStatusBarHeight + kTabBarHeight)

#define kScreenWidth            [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight            [[UIScreen mainScreen] bounds].size.height

#define ScaleW(n)   kScreenWidth * n/414
#define ScaleH(n)   kScreenHeight * n/736

#define SCREEN_width self.frame.size.width
#define SCREEN_height self.frame.size.height

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

/* 颜色 */
#define MainColor    ColorRGB(96, 170, 252)

#define ColorRGBAll(Value) [UIColor colorWithRed:Value/255.0 green:Value/255.0 blue:Value/255.0 alpha:1]
#define ColorRGBA(Value1,Value2,Value3,Value4) [UIColor colorWithRed:Value1/255.0 green:Value2/255.0 blue:Value3/255.0 alpha:Value4]

#define ColorRGB(Value1,Value2,Value3) [UIColor colorWithRed:Value1/255.0 green:Value2/255.0 blue:Value3/255.0 alpha:1]

#define COLOR_WHITE [UIColor whiteColor]

/*设置view圆角和边框*/
#define ViewBorder(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

/*字体设置*/
#define FontL(value)             [UIFont systemFontOfSize:value weight:UIFontWeightLight]
#define FontR(value)             [UIFont systemFontOfSize:value weight:UIFontWeightRegular]
#define FontB(value)             [UIFont systemFontOfSize:value weight:UIFontWeightBold]
#define FontT(value)             [UIFont systemFontOfSize:value weight:UIFontWeightThin]
#define FontSW(s,w)              [UIFont systemFontOfSize:s weight:w]
#define Font(value)              [UIFont systemFontOfSize:ScaleW(value)]


/* 调试 */
#if DEBUG
/* 自定义输出 */
#define FILENAME strrchr(__FILE__,'/')?strrchr(__FILE__,'/')+1:__FILE__
#define WYLog(fmt, ...) NSLog(@"\n%s \n%s %d行\n"fmt"\n",FILENAME,__func__,__LINE__,##__VA_ARGS__)
#else
#define WYLog(...)
#endif

#endif
