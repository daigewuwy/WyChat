//
//  context.m
//  WyChat
//
//  Created by 吴伟毅 on 19/6/9.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "context.h"

@implementation context

@synthesize queue = _queue;

+ (context *)sharedInstance {
    static dispatch_once_t onceToken;
    static context *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[context alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        // 获取数据库路径
        NSString *doc = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject;
        NSString *currentUsername = [EMClient sharedClient].currentUsername;
        NSString *dbPath = [NSString stringWithFormat:@"%@/Application Support/HyphenateSDK/easemobDB/%@.db",doc,currentUsername];
        _queue          = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        
    }
    return self;
}

@end
