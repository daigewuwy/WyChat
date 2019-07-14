//
//  WCNewFriendApplyVC.m
//  WyChat
//
//  Created by 吴伟毅 on 19/6/15.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "WCNewFriendApplyVC.h"
#import "WCNewFriendApplyCell.h"

@interface WCNewFriendApplyVC ()<UITableViewDelegate,UITableViewDataSource,EMContactManagerDelegate>

@property (nonatomic,strong) UITableView *tableView;

/** 好友申请数据源. */
@property (nonatomic,strong) NSMutableArray *friendApplyDataList;
@end

@implementation WCNewFriendApplyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    
}
-(void)viewWillAppear:(BOOL)animated {
    [self fetchApplyData];
    [_tableView reloadData];
}
- (void)fetchApplyData {
    // 查询好友申请数据
    _friendApplyDataList = [DBUtil queryFriendApplyData];
}

- (void)setupUI {
   
    [self setLeftBtnHide:NO];
    [self setTopTitle:@"新的好友申请"];

    [self.view addSubview:self.tableView];
    
    
}

#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _friendApplyDataList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ScaleH(170);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    WCNewFriendApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell) {
        cell = [[WCNewFriendApplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    WCFriendApplyModel *model = _friendApplyDataList[indexPath.row];
    [cell setStatus:model];
    
    __weak typeof(self) weakSelf = self;
    cell.rejectCallBack = ^() {
        [weakSelf rejectNewFriendApplyWithApplyInfo:model];
    };
    cell.agreeCallBack = ^() {
        [weakSelf agreeNewFriendApplyWithApplyInfo:model];
    };
    return cell;
}

#pragma mark - Action
- (void)rejectNewFriendApplyWithApplyInfo:(WCFriendApplyModel *)model {
        EMError *error = [[EMClient sharedClient].contactManager declineInvitationForUsername:model.friendApplyID];
        if (!error) {
            [_friendApplyDataList removeObject:model];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [DBUtil deleteFriendApplyWithUsername:model.friendApplyID];
            });
            [_tableView reloadData];
            NSLog(@"发送拒绝成功");
        }else
        {
            NSLog(@"发送拒绝失败");
        }
}
- (void)agreeNewFriendApplyWithApplyInfo:(WCFriendApplyModel *)model {
    EMError *error = [[EMClient sharedClient].contactManager acceptInvitationForUsername:model.friendApplyID];
    if (!error) {
        [_friendApplyDataList removeObject:model];
        [_tableView reloadData];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [DBUtil deleteFriendApplyWithUsername:model.friendApplyID];
        });
        NSLog(@"发送同意成功");
    }else
    {
        NSLog(@"发送同意失败");
    }
}


#pragma mark - lazy load

-(UITableView *)tableView {
    
    if(!_tableView) {
        _tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusBarHeight, kScreenWidth, kScreenHeight - kNavBarAndStatusBarHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = ColorRGBAll(245);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 移除顶部空白
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);

    }
    return _tableView;
}

@end
