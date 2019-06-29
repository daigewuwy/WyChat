//
//  WCNewFriendApplyCell.h
//  WyChat
//
//  Created by 吴伟毅 on 19/6/15.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCFriendApplyModel.h"

typedef void (^AgreeBtnClickedCallBack)();
typedef void (^RejectBtnClickedCallBack)();

@interface WCNewFriendApplyCell : UITableViewCell
/** 确定按钮点击回调. */
@property (nonatomic,strong) AgreeBtnClickedCallBack agreeCallBack;

/** 确定按钮点击回调. */
@property (nonatomic,strong) RejectBtnClickedCallBack rejectCallBack;

- (void)setStatus:(WCFriendApplyModel *)model;
@end
