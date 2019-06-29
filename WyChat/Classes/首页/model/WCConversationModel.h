//
//  WCMsgModel.h
//  WyChat
//
//  Created by 吴伟毅 on 19/6/2.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCConversationModel : NSObject

/** 头像. */
@property (nonatomic,strong) UIImage *iconImg;

/** 昵称. */
@property (nonatomic,copy) NSString *nickName;

/** 时间. */
@property (nonatomic,copy) NSString *time;

/** 消息. */
@property (nonatomic,copy) NSString *msg;

/** 消息数. */
@property (nonatomic,copy) NSString *msgNum;

@end
