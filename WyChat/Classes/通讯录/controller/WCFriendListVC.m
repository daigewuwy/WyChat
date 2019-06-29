//
//  WCFriendListVC.m
//  WyChat
//
//  Created by 吴伟毅 on 19/6/14.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "WCFriendListVC.h"
#import "WCContactsCell.h"
#import "WCMediator.h"

@interface WCFriendListVC ()<EMContactManagerDelegate>

/** 好友ID数据源 副本－用于保存self初始化的时候从服务器中读取到的所有好友ID. */
@property (nonatomic,strong) NSMutableArray *contactsIDDataList;

/** 被删除的好友ID数据源 副本－用于在程序结束时将删除的好友从服务器中删除. */
@property (nonatomic,strong) NSMutableArray *deleteContactsIDDataList;

@end

@implementation WCFriendListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _contactsIDDataList = @[].mutableCopy;
    
    //注册好友回调
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    
    // 注册通讯录即将显示的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillAppear:) name:kContactWillAppear object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    // 请求一次好友数据
    [self fetchContactData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _contactsIDDataList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ScaleH(75);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellID = @"cellID";
    
    // 我的好友cell
    WCContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell) {
        cell = [[WCContactsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    WCContactModel *model = [WCContactModel new];
    model.contactID = _contactsIDDataList[indexPath.row];
    [cell setStatus:model];
    
    __weak typeof(self) weakSelf = self;
    
    cell.delContactBtnClickedCallBack = ^() {
        NSString *contactID = _contactsIDDataList[indexPath.row];
        [weakSelf.deleteContactsIDDataList addObject:contactID];
        [_contactsIDDataList removeObjectAtIndex:indexPath.row];
        [weakSelf.tableView reloadData];
    
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [weakSelf delContactInServerWithContactID:contactID];
        });
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UIViewController *vc = [WCMediator chatComponent_viewControllerWithChatter:_contactsIDDataList[indexPath.row] conversationType:EMConversationTypeChat];
    vc.hidesBottomBarWhenPushed = YES;
    [[ViewManager shareInstance].NavigationController pushViewController:vc animated:YES];
}

- (void)fetchContactData {
    
    // 请求本地数据库中的好友数据
    _contactsIDDataList = [[EMClient sharedClient].contactManager getContacts].mutableCopy;
    
    // 若在本地数据库中没有请求到数据，则请求服务器中的好友数据
    if(0 == _contactsIDDataList.count) {
        
        [[EMClient sharedClient].contactManager getContactsFromServerWithCompletion:^(NSArray *aList, EMError *aError) {
            if(nil == aError) {
                _contactsIDDataList = aList.mutableCopy;
            }
        }];
    }
    [self.tableView reloadData];
}


/*!
 @method
 @brief 用户A发送加用户B为好友的申请，用户B同意后，用户A会收到这个回调
 */
- (void)friendRequestDidApproveByUser:(NSString *)aUsername {
    [self fetchContactData];
}

/*!
 @method
 @brief 用户B删除与用户A的好友关系后，用户A，B会收到这个回调
 */
- (void)friendshipDidRemoveByUser:(NSString *)aUsername {
    NSLog(@"%@解除了妳们的好友关系",aUsername);
    [self fetchContactData];
}

// 从服务器中删除好友
- (void)delContactInServerWithContactID:(NSString *)contactID {

    // 删除好友
    EMError *error = [[EMClient sharedClient].contactManager deleteContact:contactID isDeleteConversation:YES];
    if (error) {
        NSLog(@"删除%@失败",contactID);
    }
}

@end
