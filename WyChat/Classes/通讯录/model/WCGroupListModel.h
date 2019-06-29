//
//  WCGroupListModel.h
//  WyChat
//
//  Created by 吴伟毅 on 19/6/10.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCGroupListModel : NSObject
/** 头像. */
@property (nonatomic,strong) UIImage *icon;

/** 群组的ID. */
@property (nonatomic,copy) NSString *groupID;

@end
