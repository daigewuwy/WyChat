//
//  WCLoginVC.h
//  WyChat
//
//  Created by 吴伟毅 on 19/5/30.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCLoginVC : UIViewController
/** 登录状态改变通知LoginWindow isLogin-已登录 NO-未登录. */
@property (nonatomic,strong) void (^loginState)(BOOL isLogin);
@end
