//
//  DBUtil.h
//  WyChat
//
//  Created by 吴伟毅 on 19/6/7.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBUtil : NSObject

/**
 *  @brief 将新的好友申请存入数据库
 *
 *  @param username 发送申请的用户ID
 *  @param mark     发送申请的备注
 */
+ (BOOL)saveFriendApplyWithUseranem:(NSString *)username mark:(NSString *)mark;

/**
 *  @brief 查询好友申请数据库中的每一记录
 */
+ (NSMutableArray *)queryFriendApplyData;

/**
 *  @brief 查询好友申请数据库的记录总数
 *
 *  @return NSInteger 记录总数
 */
+ (NSInteger)queryFriendApplyCount;

/**
 *  @brief 设置会话置顶
 *
 *  @param username 会话对象ID
 *  @return result 结果
 */
+ (BOOL)updateRoofAbleWithUsername:(NSString *)username;

/**
 *  @brief 读取会话置顶
 *
 *  @param username 会话对象ID
 *  @return result 结果
 */
+ (BOOL)readRoofAbleWithUsername:(NSString *)username;

/**
 *  @brief 删除friendApply表中的记录
 *
 *  @param username 对象ID
 *  @return result 结果
 */
+ (BOOL)deleteFriendApplyWithUsername:(NSString *)username;

/**
 *  @brief 查询群组ID对应的群组昵称
 *
 *  @param groupId 群组ID
 *  @return result 结果
 */
+ (NSString *)queryGroupNameWithGroupId:(NSString *)groupId;
@end
