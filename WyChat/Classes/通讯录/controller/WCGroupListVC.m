//
//  WCGroupListVC.m
//  WyChat
//
//  Created by 吴伟毅 on 19/6/14.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "WCGroupListVC.h"
#import "WCGroupListCell.h"
#import "WCGroupListModel.h"
#import "WCMediator.h"

@interface WCGroupListVC ()

/** 群组数据源 副本－用于保存self初始化的时候从服务器中读取到的所有好友群组. */
@property (nonatomic,strong) NSMutableArray *groupListDataList;

@end

@implementation WCGroupListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _groupListDataList = @[].mutableCopy;
    [self fetchGroupData];
    
}

- (void)fetchGroupData {
    // 从本地获取群组数据
    _groupListDataList = [[EMClient sharedClient].groupManager getJoinedGroups].mutableCopy;
    
    // 如果本地没有数据
    if(0 == _groupListDataList.count) {
        [[EMClient sharedClient].groupManager getJoinedGroupsFromServerWithPage:0 pageSize:-1 completion:^(NSArray *aList, EMError *aError) {
            if(aError) {
                WYLog(@"从服务器获取数据失败");
                return;
            }
            _groupListDataList = aList.mutableCopy;
        }];
    }
    [self.tableView reloadData];
}


#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _groupListDataList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ScaleH(75);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellID = @"cellID";
    
    // 群组cell
    WCGroupListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if(!cell) {
        cell = [[WCGroupListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    EMGroup *group = _groupListDataList[indexPath.row];
    WCGroupListModel *model = [WCGroupListModel new];
    model.groupID = group.groupId;
    model.icon = [UIImage imageNamed:@"placeHolderIcon"];
    [cell setStatus:model];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EMGroup *group = _groupListDataList[indexPath.row];
    
    UIViewController *vc = [WCMediator chatComponent_viewControllerWithChatter:group.groupId conversationType:EMConversationTypeGroupChat];
    vc.hidesBottomBarWhenPushed = YES;
    [[ViewManager shareInstance].NavigationController pushViewController:vc animated:YES];
}
@end
