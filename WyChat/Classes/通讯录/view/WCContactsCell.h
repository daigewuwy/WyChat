//
//  WCContactsCell.h
//  WyChat
//
//  Created by 吴伟毅 on 19/6/4.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCContactModel.h"

@interface WCContactsCell : UITableViewCell
- (void)setStatus:(WCContactModel *)model;

/** 删除好友按钮点击回调. */
@property (nonatomic,strong) void(^delContactBtnClickedCallBack)(void);
@end
