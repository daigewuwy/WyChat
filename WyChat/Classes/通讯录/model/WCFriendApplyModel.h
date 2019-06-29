//
//  WCFriendQuestCell.h
//  WyChat
//
//  Created by 吴伟毅 on 19/6/3.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCFriendApplyModel : NSObject
/** 头像. */
@property (nonatomic,strong) UIImage *icon;

/** 申请的ID. */
@property (nonatomic,strong) NSString *friendApplyID;

/** 申请的备注. */
@property (nonatomic,strong) NSString *friendApplyMark;

@end
