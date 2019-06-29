//
//  WCContactsVC.m
//  WyChat
//
//  Created by 吴伟毅 on 19/5/30.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "WCContactsVC.h"
#import "WCMailListImporter.h"
#import "WCMailListVC.h"
#import "WCNewFriendApplyVC.h"

@class EMConversation;

@interface WCContactsVC ()<EMContactManagerDelegate,UITableViewDataSource, UITableViewDelegate>

/** 滚动视图 作为底部承载容器. */
@property (nonatomic,strong) UITableView *tableView;

/** 中部视图控制器. */
@property (nonatomic,strong) WCMailListVC *mailListVC;

/** 菊花. */
@property (nonatomic,strong) MBProgressHUD *hud;

@end

@implementation WCContactsVC

#pragma mark - lifeCycle

- (void)viewDidLoad {
    
    [super viewDidLoad];

    // 初始化UI
    [self setupUI];
    
    //注册好友回调
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    // 给好友列表发送通知进行刷新
    [[NSNotificationCenter defaultCenter] postNotificationName:kContactWillAppear object:nil];
    
    // 刷新badge的值
    [self setBadgeWithValue:[DBUtil queryFriendApplyCount]];
    
    [_tableView reloadData];
}


#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (0 == section) ? 1:0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (0 == indexPath.section) ? ScaleH(45):CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (0 == section) ? ScaleH(45):ScaleH(500);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return (0 == section) ? ScaleH(15):CGFLOAT_MIN;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *v = [UIView new];
    if(0 == section) {
        // 配置顶部搜索栏
        [v setFrame:CGRectMake(0, 0, kScreenWidth, ScaleH(55))];
        [v setBackgroundColor:[UIColor whiteColor]];
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, ScaleH(10), kScreenWidth, ScaleH(35))];
        [searchBar setBackgroundImage:nil];
        searchBar.placeholder = @"请输入搜索内容";
        [searchBar setBackgroundImage:[UIImage getImageWithColor:[UIColor clearColor] andHeight:searchBar.height]];
        UITextField *searchField=[searchBar valueForKey:@"searchField"];
        searchField.backgroundColor = ColorRGBAll(237);
        [v addSubview:searchBar];
        
    }else if(1 == section) {
        // 将好友列表和群组列表添加在头部视图上
        [v setFrame:CGRectMake(0, 0, kScreenWidth, ScaleH(500))];
        [_mailListVC.view setFrame:v.frame];
        [v addSubview:_mailListVC.view];
        
    }else;
    
    return v;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *v;
    if(0 == section) {
        v = [UIView new];
        [v setFrame:CGRectMake(0, 0, kScreenWidth, ScaleH(15))];
        [v setBackgroundColor:tableView.backgroundColor];
    }
    return v;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell) {
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 提示文本
        UILabel *friendApplyLab = [[UILabel alloc] initWithFrame:CGRectMake(ScaleW(15), 0, kScreenWidth, ScaleH(45))];
        friendApplyLab.text = @"新好友申请";
        friendApplyLab.textAlignment = NSTextAlignmentLeft;
        friendApplyLab.backgroundColor = [UIColor whiteColor];
        [cell addSubview:friendApplyLab];
        
        // 角标
        UIView *corner = [UIView new];
        CGFloat width = ScaleW(9);
        CGFloat height = width;
        [corner setFrame:CGRectMake(kScreenWidth - ScaleW(15) - width, ScaleH(18), width, height)];
        [corner setBackgroundColor:MainColor];
        corner.layer.masksToBounds = YES;
        corner.layer.cornerRadius = width/2.0;
        corner.tag = 12312;
        [cell addSubview:corner];
    }
    UIView *corner = [cell viewWithTag:12312];
    if(0 == [DBUtil queryFriendApplyCount]) { corner.hidden = YES; }
    else { corner.hidden = NO; }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 如果点击了好友申请的cell
    if(0 == indexPath.section && 0 == indexPath.row) {
        WCNewFriendApplyVC *newFriendApplyVC = [WCNewFriendApplyVC new];
        newFriendApplyVC.hidesBottomBarWhenPushed = YES;
        [[ViewManager shareInstance].NavigationController
         pushViewController:newFriendApplyVC animated:YES];
    }
}

#pragma mark - Action

// 进入创建群组界面
- (void)gotoGroupVC {
    WCCreateGroupVC *createGroupVC = [WCCreateGroupVC new];
    createGroupVC.hidesBottomBarWhenPushed = YES;
    [[ViewManager shareInstance].NavigationController pushViewController:createGroupVC animated:YES];
}

// 点击导航头右侧按钮
-(void)rightActionOfDelegate {
    WCAddContactsVC *addContactsVC = [WCAddContactsVC new];
    [[ViewManager shareInstance].NavigationController pushViewController:addContactsVC animated:YES];
}

#pragma mark - EMContactManagerDelegate

/*!
 *  接受到好友添加申请
 */
- (void)friendRequestDidReceiveFromUser:(NSString *)aUsername
                                message:(NSString *)aMessage {
    [DBUtil saveFriendApplyWithUseranem:aUsername mark:aMessage];
    [self setBadgeWithValue:[DBUtil queryFriendApplyCount]];
    [_tableView reloadData];
    WYLog(@"收到%@发来的好友添加请求",aUsername);
}

/*!
 @method
 @brief 用户A发送加用户B为好友的申请，用户B拒绝后，用户A会收到这个回调
 */
- (void)friendRequestDidDeclineByUser:(NSString *)aUsername {
    NSLog(@"%@拒绝了你的添加好友申请",aUsername);
}



#pragma mark - function

// 刷新badge值
- (void)setBadgeWithValue:(NSInteger)value {
    if(0 != value)
    {
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%zd",value];
    }else
    {
        self.tabBarItem.badgeValue = nil;
    }
}

// 初始化UI
- (void)setupUI {
    
    [self setRightBtnHide:NO];
    [self setTopTitle:@"联系人"];
    [self setRightBtnImage:[UIImage imageNamed:@"addContact"]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.tabBarItem.badgeColor = MainColor;
    
    WCMailListVC *mailListVC = [WCMailListVC new];
    _mailListVC = mailListVC;
    
    [self.view addSubview:self.tableView];
}

#pragma mark - lazy load

-(UITableView *)tableView {
    if(!_tableView) {
        _tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusBarHeight, kScreenWidth, kScreenHeight - kNavAndTabHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = ColorRGBAll(237);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        // 移除顶部空白
        _tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    }
    return _tableView;
}
@end
