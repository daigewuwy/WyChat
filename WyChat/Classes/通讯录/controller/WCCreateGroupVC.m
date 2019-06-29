//
//  WCCreateGroupVC.m
//  WyChat
//
//  Created by 吴伟毅 on 19/6/10.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "WCCreateGroupVC.h"

@interface WCCreateGroupVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *groupNameTF;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 好友数据源. */
@property (nonatomic,strong) NSMutableArray *contactsDataList;

/** 勾选的好友. */
@property (nonatomic,strong) NSMutableArray *selectedContacts;

/** 菊花. */
@property (nonatomic,strong) MBProgressHUD *hud;
@end

@implementation WCCreateGroupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLeftBtnHide:NO];
    [self setRightBtnHide:NO];
    [self setRightBtnTitle:@"创建"];
    [self setTopTitle:@"创建群组"];
    
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.editing = YES;
    
    _contactsDataList = [[EMClient sharedClient].contactManager getContacts].mutableCopy;
    _selectedContacts = @[].mutableCopy;
}

#pragma mark - Action
-(void)rightActionOfDelegate {
    
//    *  @param aSubject         群组名称
//    *  @param aDescription     群组描述
//    *  @param aInvitees        群组成员（不包括创建者自己）
//    *  @param aMessage         邀请消息
//    *  @param aSetting         群组属性
//    *  @param aCompletionBlock 完成的回调
//    
    EMGroupOptions *options = [[EMGroupOptions alloc] init];
    options.style = EMGroupStylePublicJoinNeedApproval;
    options.maxUsersCount = 250;
    options.IsInviteNeedConfirm = NO;
    options.ext = @"我是扩展";
    
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[EMClient sharedClient].groupManager createGroupWithSubject:_groupNameTF.text description:@"群组" invitees:_selectedContacts message:@"来加入吧" setting:options completion:^(EMGroup *aGroup, EMError *aError) {
        [_hud hide:YES];
        if(aError) {
            WYLog(@"创建群组失败");
        }
        
    }];
}

#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _contactsDataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        UILabel *lab = [UILabel new];
        [lab setFrame:CGRectMake(40, 0, 50, 44)];
        lab.tag = 111;
        [cell addSubview:lab];
    }
    UILabel *lab = [cell viewWithTag:111];
    [lab setText:_contactsDataList[indexPath.row]];
    return cell;
}

// 实现系统自带可勾选样式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_selectedContacts addObject:_contactsDataList[indexPath.row]];
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_selectedContacts removeObject:_contactsDataList[indexPath.row]];
}

@end
