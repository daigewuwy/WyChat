//
//  WCMailListVC.m
//  WyChat
//
//  Created by 吴伟毅 on 19/6/14.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "WCMailListVC.h"
#import "WCFriendListVC.h"
#import "WCGroupListVC.h"


@interface WCMailListVC ()

@end

@implementation WCMailListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureInterface];
}

- (void)configureInterface {
    
    WCFriendListVC *friendListVC = [WCFriendListVC new];
    WCGroupListVC *groupListVC = [WCGroupListVC new];
    
    NSArray *childControllers = @[friendListVC,groupListVC];
    NSArray *titles = [NSArray arrayWithObjects:@"我的好友",@"我的群组", nil];
    
    [self setupChildControllers:childControllers Titles:titles];
    self.scalingRatio = 1.3;
}

@end
