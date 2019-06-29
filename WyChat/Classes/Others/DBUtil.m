//
//  DBUtil.m
//  WyChat
//
//  Created by 吴伟毅 on 19/6/7.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "DBUtil.h"
#import "context.h"
#import "WCFriendApplyModel.h"
@implementation DBUtil

+(FMDatabaseQueue *)shareInstanceQueue {
    
    static FMDatabaseQueue *_sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *doc = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject;
        NSString *currentUsername = [EMClient sharedClient].currentUsername;
        NSString *dbPath = [NSString stringWithFormat:@"%@/Application Support/HyphenateSDK/easemobDB/%@.db",doc,currentUsername];
        _sharedSingleton = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    });
    return _sharedSingleton;
}

+ (FMDatabase *)db {
    
    static FMDatabase *_sharedSingleton = nil;
    
    if(nil == _sharedSingleton) {
        
        // 获取数据库路径
        NSString *doc = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject;
        NSString *currentUsername = [EMClient sharedClient].currentUsername;
        NSString *dbPath = [NSString stringWithFormat:@"%@/Application Support/HyphenateSDK/easemobDB/%@.db",doc,currentUsername];
        WYLog(@"通讯录用户数据库路径:%@",dbPath);
        
        //  创建数据库
        _sharedSingleton = [FMDatabase databaseWithPath:dbPath];
        if(![_sharedSingleton open]) {
            WYLog(@"数据库打开失败");
        }
    }
    return _sharedSingleton;
}
+ (NSMutableArray <WCFriendApplyModel *>*)queryFriendApplyData {
    
    NSMutableArray *arr = [NSMutableArray new];
    
    FMDatabase *db = [DBUtil db];
    
    NSString *querySql = @"select * from friendApply";
    FMResultSet *result = [db executeQuery:querySql];
    while(result.next) {
        WCFriendApplyModel *model = [WCFriendApplyModel new];
        model.friendApplyID = [result stringForColumn:@"username"];
        model.friendApplyMark = [result stringForColumn:@"mark"];
        [arr addObject:model];
    }
    return arr;
}

+ (NSInteger)queryFriendApplyCount {
    
    FMDatabase *db = [DBUtil db];
    NSString *querySql = @"select count(*) from friendApply";
    FMResultSet *result = [db executeQuery:querySql];
    NSInteger count = 0;
    while (result.next) {
        count = [result intForColumnIndex:0];
    }
    return count;
    
}

+ (BOOL)saveFriendApplyWithUseranem:(NSString *)username mark:(NSString *)mark {
    
    FMDatabase *db = [DBUtil db];
    
    NSString *tableSql = @"create table if not exists friendApply (username text,mark text)";
    if(![db executeUpdate:tableSql]) {
        WYLog(@"建立表失败");
        return NO;
    }
    
    // 删除数据库中重复的申请记录
    [self deleteFriendApplyWithUsername:username];

    // 插入申请数据
    NSString *insertSql = @"insert into friendApply (username,mark) values(?,?)";
    if(![db executeUpdate:insertSql withArgumentsInArray:@[username,mark]]) {
        WYLog(@"插入数据失败");
        return NO;
    }
    return YES;
}

+ (BOOL)updateRoofAbleWithUsername:(NSString *)username {
    
    FMDatabase *db = [DBUtil db];

    BOOL isRoofable = [self readRoofAbleWithUsername:username];
    
    NSString *updateSql = @"update conversation set isRoofPlacement = ? where id = ?";
    
    NSNumber *isRoofPlacement = [NSNumber numberWithBool:!isRoofable];
    
    if(![db executeUpdate:updateSql withArgumentsInArray:@[isRoofPlacement,username]]) {
        WYLog(@"更新置顶失败");
        return NO;
    }
    return YES;
}

+(BOOL)readRoofAbleWithUsername:(NSString *)username {
    
    BOOL result = YES;
    
    FMDatabase *db =  [DBUtil db];

    NSString *querySql = @"select isRoofPlacement from conversation where id=?";
    
    FMResultSet *resultSet = [db executeQuery:querySql withArgumentsInArray:@[username]];
    
    while (resultSet.next) {
        result = [resultSet boolForColumnIndex:0];
    }
    return result;
}

+(BOOL)deleteFriendApplyWithUsername:(NSString *)username {
    
    FMDatabase *db = [DBUtil db];
    
    // 首先清空数据库中的所有数据
    NSString *deleteSql = @"delete from friendApply where username = ?";
    if(![db executeUpdate:deleteSql withArgumentsInArray:@[username]]) {
        WYLog(@"删除数据失败");
        return NO;
    }
    return YES;
}

+(NSString *)queryGroupNameWithGroupId:(NSString *)groupId {
    
    NSString *groupName = @"";
    
    FMDatabase *db = [DBUtil db];
    NSString *querySql = @"select groupsubject from 'group' where groupid = ?";
    FMResultSet *result = [db executeQuery:querySql withArgumentsInArray:@[groupId]];
    while (result.next) {
        groupName = [result stringForColumn:@"groupsubject"];
    }
    return groupName;
}
@end
