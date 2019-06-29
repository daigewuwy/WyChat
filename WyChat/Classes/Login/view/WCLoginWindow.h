//
//  WCLoginWindow.h
//  WyChat
//
//  Created by 吴伟毅 on 19/5/30.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCLoginWindow : UIWindow

/** 暴露单例给外部调用者. */
+ (instancetype)shareInstance;

/** 显示登录界面. */
- (void)showWindow;

/** 隐藏登录界面. */
- (void)hideWindow;
@end
