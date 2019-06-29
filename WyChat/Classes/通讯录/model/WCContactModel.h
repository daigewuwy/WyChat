//
//  WCContactModel.h
//  WyChat
//
//  Created by 吴伟毅 on 19/6/4.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCContactModel : NSObject
/** 头像. */
@property (nonatomic,strong) UIImage *icon;

/** 申请的ID. */
@property (nonatomic,strong) NSString *contactID;
@end
