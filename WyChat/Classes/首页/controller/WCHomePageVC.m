//
//  WCHomePageVC.m
//  WyChat
//
//  Created by 吴伟毅 on 19/5/30.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "WCHomePageVC.h"
#import "WCConversationCell.h"
#import "WCMediator.h"

@interface WCHomePageVC ()<UITableViewDelegate,UITableViewDataSource,EMChatManagerDelegate>

/** 左侧头像. */
@property (nonatomic,strong) UIImageView *avatarImgView;

/** 消息列表. */
@property (nonatomic,strong) UITableView *tableView;

/** 所有会话数据源 副本－用于保存viewdidload时获取到的所有会话. */
@property (nonatomic,strong) NSMutableArray <EMConversation *>*conversationsDataList;

/** 删除的会话数据源 副本－用于保存viewdidload时获取到的所有会话. */
@property (nonatomic,strong) NSMutableArray <EMConversation *>*deleteedConversationsDataList;

/** 当前左滑cell的index，在代理方法中设置 .*/
@property (nonatomic,strong) NSIndexPath* editingIndexPath;

@end

@implementation WCHomePageVC

#pragma mark - liftCycle



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
    // 初始化UI
    [self setupUI];
    
    // 获取一次会话数据
    [self fetchConversationData];
    
    // 设置置顶
    [self refreshRoofPlacement];
    
    // 注册应用程序即将关闭的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillClose) name:kApplicationWillCloseNotification object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // 重置tableview位置，消除tableView头部多处的空白区域
    if (self.tableView.contentOffset.y < 0 || self.tableView.contentOffset.y == 0.000000) {
        self.tableView.contentInset = UIEdgeInsetsZero;
    }
    
    if(0 == _conversationsDataList.count) {
        [self fetchConversationData];
    }
    
    // 设置角标
    [self setBadge];
    [_tableView reloadData];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (self.editingIndexPath)
    {
        [self configSwipeButtons];
    }
}

- (void)injected {
    NSLog(@"good");
}

#pragma mark - function

- (void)setupUI {
    
    // 设置badge的颜色
    self.tabBarItem.badgeColor = MainColor;
    
    // 设置标题
    [self setTopTitle:@"最近的消息"];
    
    // 隐藏nav分割线
    [self setTopLineHide:YES];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // 配置头像
    _avatarImgView = [UIImageView new];
    CGFloat widthAndHeight = kNavBarAndStatusBarHeight - ScaleH(30);
    [_avatarImgView setFrame:CGRectMake(ScaleW(20),  ScaleH(25), widthAndHeight,widthAndHeight)];
    [_avatarImgView setImageByBezierPathWithImage:[UIImage imageNamed:@"placeHolderIcon"] radius:_avatarImgView.frame.size.width/2];
    [self.topBar addSubview:_avatarImgView];
    
    // 设置表视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusBarHeight, kScreenWidth, self.view.frame.size.height - kNavBarAndStatusBarHeight - kTabBarHeight + ScaleH(20)) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    
    // 设置头部区域
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ScaleH(10))];
    
    _tableView.tableHeaderView.backgroundColor = ColorRGBAll(247);
    [self.view addSubview:_tableView];
    
}

// 设置tabBar角标
- (void)setBadge {
    
    NSInteger totalUnreadCount = 0;
    
    // 获取未读消息总数
    for(EMConversation *conversation in _conversationsDataList) {
        totalUnreadCount += conversation.unreadMessagesCount;
    }
    
    if(0 != totalUnreadCount)
    {
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%zd",totalUnreadCount];
    }else
    {
        self.tabBarItem.badgeValue = nil;
    }
}

// 接受到应用程序即将关闭的会话
- (void)applicationWillClose {
    
    // 删除服务器端的会话
    [[EMClient sharedClient].chatManager deleteConversations:self.deleteedConversationsDataList isDeleteMessages:YES completion:^(EMError *aError) {
        if(nil != aError) {
            WYLog(@"删除会话失败");
        }
    }];
}

#pragma mark - 会话有关配置

// 获取所有会话数据
- (void)fetchConversationData {
    WYLog(@"%@",NSHomeDirectory());
    // 获取会话
    self.conversationsDataList = [[EMClient sharedClient].chatManager getAllConversations].mutableCopy;
}

- (void)deleteConversationWithRow:(NSInteger)row {
    // 添加进删除的会话数组中
    [self.deleteedConversationsDataList addObject:_conversationsDataList[row]];
    // 模拟删除会话
    [_conversationsDataList removeObjectAtIndex:row];
    [_tableView reloadData];
}
#pragma mark - 置顶功能

// 实现置顶功能,即改变数据在数组中的位置而后刷新视图
- (void)setRoofPlacementWithRow:(NSInteger)row {
    
    EMConversation *conversation = _conversationsDataList[row];
    // 更新数据库的置顶

    if(![DBUtil readRoofAbleWithUsername:conversation.conversationId])
    {
        // 将置顶写入数据库
        [DBUtil updateRoofAbleWithUsername:conversation.conversationId];

        // 重新获取会话获得最新的置顶记录
        [self fetchConversationData];
        // 刷新界面的置顶
        [self refreshRoofPlacement];
    }else {
        // 取消置顶，放到所有置顶后一个
        int index = 0;
        for (EMConversation *con in _conversationsDataList) {
            if([DBUtil readRoofAbleWithUsername:con.conversationId]) {
                index++;
            }else {
                break;
            }
        }
        [_conversationsDataList exchangeObjectAtIndex:row withObjectAtIndex:index - 1];
        // 将取消置顶写入数据库
        [DBUtil updateRoofAbleWithUsername:conversation.conversationId];
    }
    [_tableView reloadData];
}

// 程序刚进来初始化置顶
- (void)refreshRoofPlacement {
    
    NSMutableArray *indexs = @[].mutableCopy;
    // 获取数据库中有置顶的记录的下标
    for (EMConversation *conversation in _conversationsDataList) {
        if([DBUtil readRoofAbleWithUsername:conversation.conversationId]) {
            NSNumber *index = [NSNumber numberWithInteger:[_conversationsDataList indexOfObject:conversation]];
            [indexs addObject:index];
        }
    }
    // 实现置顶
    for(int i = 0; i < indexs.count; i++) {
        NSNumber *index = indexs[i];
        [_conversationsDataList exchangeObjectAtIndex:i withObjectAtIndex:index.integerValue];
    }
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _conversationsDataList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ScaleH(75);
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return ScaleH(20);
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UILabel *footLab = [UILabel new];
    [footLab setFrame:CGRectMake(0, 0, kScreenWidth, ScaleH(20))];
    [footLab setText:@"没有更多消息了哦~"];
    [footLab setFont:Font(15)];
    [footLab setTextColor:ColorRGBAll(160)];
    [footLab setTextAlignment:NSTextAlignmentCenter];
    [footLab setBackgroundColor:[UIColor whiteColor]];
    
    return footLab;
    
}
#pragma mark - UITableViewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *const cellID = @"cellID";
    
    WCConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell) {
        cell = [[WCConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    EMConversation *conversation = _conversationsDataList[indexPath.row];
    [cell setConversation:conversation];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 进入聊天
    EMConversation *conversation = _conversationsDataList[indexPath.row];
    
    UIViewController *vc = [WCMediator chatComponent_viewControllerWithChatter:conversation.conversationId conversationType:conversation.type];
    vc.hidesBottomBarWhenPushed = YES;
    [[ViewManager shareInstance].NavigationController pushViewController:vc animated:YES];
}

// 自定义cell左滑样式
- (NSArray*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{

    // delete action
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [tableView setEditing:NO animated:YES];  // 这句很重要，退出编辑模式，隐藏左滑菜单
          [self deleteConversationWithRow:indexPath.row];
    }];

    NSString *roofPlaceMent;
    EMConversation *conversation = _conversationsDataList[indexPath.row];
    if([DBUtil readRoofAbleWithUsername:conversation.conversationId]){
         roofPlaceMent = @"取消置顶";
    }else {
        roofPlaceMent = @"置顶";
    }
    
    // 创建action
    UITableViewRowAction *roofAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:roofPlaceMent handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [tableView setEditing:NO animated:YES];  // 这句很重要，退出编辑模式，隐藏左滑菜单
        [self setRoofPlacementWithRow:indexPath.row];
    }];
    
    deleteAction.backgroundColor = [UIColor orangeColor];
    roofAction.backgroundColor = [UIColor blueColor];
    return @[deleteAction, roofAction];
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.editingIndexPath = indexPath;
    [self.view setNeedsLayout];   // 触发-(void)viewDidLayoutSubviews
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.editingIndexPath = nil;
}

/* 以下两个注释方法用于实现：防止开启cell左滑功能时，cell上的按钮，左滑的同时触发了cell上的按钮造成误操作 */
//- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *tableCell = [tableView cellForRowAtIndexPath:indexPath];
//    // disable button touch event during swipe
//    for (UIView *view in [tableCell.contentView subviews])
//    {
//        if ([view isKindOfClass:[UIButton class]]) {
//            [view setUserInteractionEnabled:NO];
//        }
//    }
//}
//
//- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *tableCell = [tableView cellForRowAtIndexPath:indexPath];
//    for (UIView *view in [tableCell.contentView subviews])
//    {
//        if ([view isKindOfClass:[UIButton class]]) {
//            [view setUserInteractionEnabled:YES];
//        }
//    }
//}

#pragma mark - EMChatManagerDelegate

// 会话列表发生更新
- (void)conversationListDidUpdate:(NSArray *)aConversationList {
    
    _conversationsDataList = aConversationList.mutableCopy;
    [_tableView reloadData];
    
    // 设置tabBar角标
    [self setBadge];
}

-(void)messagesDidReceive:(NSArray *)aMessages {
    [self fetchConversationData];
    [self setBadge];
    [_tableView reloadData];
}

#pragma mark - 配置左滑按钮

- (void)configSwipeButtons
{
    UIButton *deleteButton = nil;
    UIButton *roofButton = nil;

    // 获取选项按钮的reference
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0"))
    {
        // iOS 11层级 (Xcode 8编译): UITableView -> UITableViewWrapperView -> UISwipeActionPullView
        for (UIView *subview in self.tableView.subviews)
        {
            if ([subview isKindOfClass:NSClassFromString(@"UITableViewWrapperView")])
            {
                for (UIView *subsubview in subview.subviews)
                {
                    if ([subsubview isKindOfClass:NSClassFromString(@"UISwipeActionPullView")] && [subsubview.subviews count] >= 2)
                    {
                        // 和iOS 10的按钮顺序相反
                        deleteButton = subsubview.subviews[1];
                        roofButton = subsubview.subviews[0];
                        
                    }
                }
            }
        }
    }
    else
    {
        // iOS 8-10层级: UITableView -> UITableViewCell -> UITableViewCellDeleteConfirmationView
        WCConversationCell *tableCell = [self.tableView cellForRowAtIndexPath:self.editingIndexPath];
        for (UIView *subview in tableCell.subviews)
        {
            if ([subview isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")] && [subview.subviews count] >= 2)
            {
                deleteButton = subview.subviews[0];
                roofButton = subview.subviews[1];

                [subview setBackgroundColor:[UIColor colorFromHexString:@"E5E8E8"]];
            }
        }
    }
    deleteButton.tag = 12343;
    roofButton.tag = 12342;
    [self configBtn:deleteButton Font:Font(13) titleColor:[UIColor colorFromHexString:@"D0021B"] image:[UIImage scaleImageWithName:@"placeHolderIcon" withScale:0.12] backgroundColor:[UIColor colorFromHexString:@"E5E8E8"]];
    
    [self configBtn:roofButton Font:Font(13) titleColor:[UIColor colorFromHexString:@"4A90E2"] image:[UIImage scaleImageWithName:@"placeHolderIcon" withScale:0.12] backgroundColor:[UIColor colorFromHexString:@"E5E8E8"]];
}

- (void)configBtn:(UIButton *)btn Font:(UIFont *)font titleColor:(UIColor *)titleColor image:(UIImage *)image backgroundColor:(UIColor *)bgColor {
    
    [btn layoutIfNeeded];
    [btn.titleLabel setFont:font];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    btn.imageView.layer.masksToBounds = YES;
    btn.imageView.layer.cornerRadius = btn.imageView.width/2;
    [btn setBackgroundColor:bgColor];
    // 调整按钮上图片和文字的相对位置（该方法的实现在下面）
    [self centerImageAndTextOnButton:btn];
}

// 图片在上，文字在下，整体居中
- (void)centerImageAndTextOnButton:(UIButton*)button
{
    //[button.titleLabel setFont:Font(5)];

    // this is to center the image and text on button.
    // the space between the image and text
    CGFloat spacing = 10.0;
    
    // lower the text and push it left so it appears centered below the image
    button.imageView.frame = CGRectMake(0, 0, 30, 30);
    CGSize imageSize = button.imageView.frame.size;
    button.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    
    // raise the image and push it right so it appears centered above the text
    CGSize titleSize = [button.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:button.titleLabel.font,NSFontAttributeName, nil]];
    button.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing)*2, 0.0, 0.0, - titleSize.width);
    
    // increase the content height to avoid clipping
    CGFloat edgeOffset = (titleSize.height - imageSize.height) / 2.0;
    button.contentEdgeInsets = UIEdgeInsetsMake(edgeOffset, 0.0, edgeOffset, 0.0);
    
    // move whole button down, apple placed the button too high in iOS 10
    if (SYSTEM_VERSION_LESS_THAN(@"11.0"))
    {
        CGRect btnFrame = button.frame;
        btnFrame.origin.y = 18;
        button.frame = btnFrame;
    }
}



#pragma mark - lazy load

-(NSMutableArray *)conversationsDataList {
    if(!_conversationsDataList) {
        _conversationsDataList = [NSMutableArray new];
    }
    return _conversationsDataList;
}

-(NSMutableArray *)deleteedConversationsDataList {
    if(!_deleteedConversationsDataList) {
        _deleteedConversationsDataList = [NSMutableArray new];
    }
    return _deleteedConversationsDataList;
}
@end
