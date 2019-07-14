//
//  WCChatVC.m
//  WyChat
//
//  Created by 吴伟毅 on 19/6/7.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "WCChatVC.h"
#import "BaseTopBarView.h"
#import "WCSenderIdCardCell.h"
#import "WCReciverIdCardCell.h"

@interface WCChatVC ()<TopBarViewDelegate,EaseChatBarMoreViewDelegate,EaseMessageViewControllerDelegate>

/** 由于该控制器不是继承自BaseViewController 所以手动添加一个BaseTopBarView. */
@property (nonatomic,retain) BaseTopBarView *topBar;
@end

@implementation WCChatVC

-(instancetype)initWithConversationChatter:(NSString *)conversationChatter conversationType:(EMConversationType)conversationType {
    
    if(self = [super initWithConversationChatter:conversationChatter conversationType:conversationType]) {
        
        [self setupUI];
        
        // 根据聊天类型设置导航栏标题
        if(EMConversationTypeChat == conversationType) {
            [_topBar setTopTitle:self.conversation.conversationId];
        }else if(EMConversationTypeGroupChat == conversationType) {
            [_topBar setTopTitle:[DBUtil queryGroupNameWithGroupId:conversationChatter]];
        }else;
    }
    
    return self;
}

#pragma mark - function

- (void)setupUI {
    _topBar = [[BaseTopBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavBarAndStatusBarHeight)];
    _topBar.delegate = self;
    [_topBar setLeftBtnHide:NO];
    [self.view addSubview:_topBar];
    
    // 添加底部选择栏代理
    self.chatBarMoreView.delegate = self;
    [self.chatBarMoreView insertItemWithImage:[UIImage imageNamed:@"placeHolderIcon"] highlightedImage:nil title:@"名片"];
    self.delegate = self;
}


#pragma mark - EaseChatBarMoreViewDelegate

-(void)moreView:(EaseChatBarMoreView *)moreView didItemInMoreViewAtIndex:(NSInteger)index {
    
    
    // 发送名片构造
    NSDictionary *ext = @{
                             @"type":@"idCard",
                             @"name":@"XJH",
                             @"icon":@"placeHoderIcon",
                        };
    [self sendTextMessage:@"[名片消息]" withExt:ext];
    
}

#pragma mark - EaseMessageViewControllerDelegate

-(UITableViewCell *)messageViewController:(UITableView *)tableView cellForMessageModel:(id<IMessageModel>)messageModel {
    
    // 获取消息
    EMMessage *message = [messageModel message];
    
    // 获取扩展消息
    NSDictionary *ext = message.ext;
    if(nil == ext) return nil;
    
    UITableViewCell *cell;

    // 如果是名片消息
    if([ext[@"type"] isEqualToString:@"idCard"]) {
       
        // 当前展示方是否为发送方
        bool isSender = [message.from isEqualToString:[EMClient sharedClient].currentUsername];
        
        if(isSender) {
            cell = (WCSenderIdCardCell *)[WCSenderIdCardCell senderIdCardCellWithTableView:tableView];
        }else
        {
             cell = (WCReciverIdCardCell *)[WCReciverIdCardCell reciverIdCardCellWithTableView:tableView];
        }
    }
    
    return cell;
    
}
-(CGFloat)messageViewController:(EaseMessageViewController *)viewController heightForMessageModel:(id<IMessageModel>)messageModel withCellWidth:(CGFloat)cellWidth {
    
    // 获取消息
    EMMessage *message = [messageModel message];
    
    // 获取扩展消息
    NSDictionary *ext = message.ext;
    if(nil == ext) return 0;
    
    // 如果是名片消息
    if([ext[@"type"] isEqualToString:@"idCard"]) {
        return 100;
    }
    return 0;
}

-(void)leftActionOfDelegate {
    [[ViewManager shareInstance].NavigationController popViewControllerAnimated:YES];
}
@end
