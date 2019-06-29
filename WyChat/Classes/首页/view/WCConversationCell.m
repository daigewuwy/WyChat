//
//  RecentMsgCell.m
//  WyChat
//
//  Created by 吴伟毅 on 19/5/31.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "WCConversationCell.h"

@interface WCConversationCell()
{
    CGFloat  kCellHeight;
    CGFloat  kPadding;
}

/** 头像. */
@property (nonatomic,strong) UIImageView *iconIV;

/** 昵称. */
@property (nonatomic,strong) UILabel *nickNameLab;

/** 消息时间. */
@property (nonatomic,strong) UILabel *msgTimeLab;

/** 消息. */
@property (nonatomic,strong) UILabel *msgLab;

/**  角标.*/
@property (nonatomic,strong) UILabel *cornerLab;

@end

@implementation WCConversationCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] ) {
        
        kCellHeight = ScaleW(75);
        kPadding = ScaleW(20);
        
        [self setupUI];
        // 必须刷新布局，否则有些控件显示异常
        [self layoutSubviews];
    }
    return self;
}

#pragma mark - 设置数据


- (void)setConversation:(EMConversation *)conversation {
    
    
    if(EMConversationTypeChat == conversation.type) {
        [_nickNameLab setText:conversation.conversationId];
          [_iconIV setImageByBezierPathWithImage:[UIImage imageNamed:@"user"] radius:_iconIV.frame.size.width/2];
    }
    else if(EMConversationTypeGroupChat == conversation.type) {
        [_nickNameLab setText:[NSString stringWithFormat:@"群组:%@",[DBUtil queryGroupNameWithGroupId:conversation.conversationId]]];
          [_iconIV setImageByBezierPathWithImage:[UIImage imageNamed:@"group"] radius:_iconIV.frame.size.width/2];
    }else;
    
    // 获取最新的一条消息
    EMMessage *lastedMsg = [conversation lastReceivedMessage];
    
    EMMessageBody *body = lastedMsg.body;
    NSMutableDictionary *dict = @{
                           [NSString stringWithFormat:@"%d",EMMessageBodyTypeImage]:@"[图片]",
                           [NSString stringWithFormat:@"%d",EMMessageBodyTypeVideo]:@"[视频]",
                           [NSString stringWithFormat:@"%d",EMMessageBodyTypeLocation]:@"[位置]",
                           [NSString stringWithFormat:@"%d",EMMessageBodyTypeVoice]:@"语音",
                           [NSString stringWithFormat:@"%d",EMMessageBodyTypeFile]:@"[文件]",
                           [NSString stringWithFormat:@"%d",EMMessageBodyTypeCmd]:@"[命令]",
                           }.mutableCopy;
    
    if(EMMessageBodyTypeText == body.type) {
        EMTextMessageBody *textBody = (EMTextMessageBody *)body;
        [_msgLab setText:textBody.text];
    }else
    {
         [_msgLab setText:[dict objectForKey:[NSString stringWithFormat:@"%d",body.type]]];
    }
    
    // 更新时间
    NSString *timeStr = [NSDate formattedTimeFromTimeInterval:conversation.lastReceivedMessage.timestamp];
    [_msgTimeLab setText:timeStr];
    [_msgTimeLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(timeStr.length * 13);
    }];
    
    // 更新未读数
    NSString *unReadCount = [NSString stringWithFormat:@"%zd",conversation.unreadMessagesCount];
    CGFloat cornerLabWidth = unReadCount.length <= 1 ? ScaleW(20) : unReadCount.length * ScaleW(13);
    
    [_cornerLab setText:unReadCount];
    [_cornerLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_msgLab.mas_bottom);
        make.width.mas_equalTo(cornerLabWidth);
        make.right.mas_equalTo(_msgTimeLab.mas_right);
        make.height.mas_equalTo(ScaleH(20));
    }];
    _cornerLab.center = CGPointMake(kScreenWidth - ScaleW(35), _msgLab.bottom - ScaleH(10));
    _cornerLab.layer.cornerRadius = 10;
    
    _cornerLab.hidden = NO;
    if(0 == unReadCount.integerValue) {
        _cornerLab.hidden = YES;
    }
}

#pragma mark - setupUI

- (void)setupUI {
    
    [self addSubview:self.iconIV];
    [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(ScaleH(15));
        make.left.mas_equalTo(self).offset(ScaleW(15));
        make.height.mas_equalTo(kCellHeight - ScaleH(30));
        make.width.mas_equalTo(kCellHeight - ScaleH(30));
    }];
    
    [self addSubview:self.nickNameLab];
    [_nickNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_iconIV.mas_right).offset(kPadding);
        make.top.mas_equalTo(_iconIV);
        make.height.mas_equalTo(ScaleH(15));
        make.width.mas_equalTo(ScaleW(150));
    }];
    
    [self addSubview:self.msgLab];
    [_msgLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nickNameLab);
        make.top.mas_equalTo(_nickNameLab.mas_bottom).offset(ScaleH(15));
        make.width.mas_equalTo(ScaleW(260));
        make.height.height.mas_equalTo(ScaleH(15));
    }];
   
    [self addSubview:self.msgTimeLab];
    [_msgTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nickNameLab);
        make.right.mas_equalTo(self).offset(-kPadding);
        make.width.mas_equalTo(ScaleW(70));
        make.height.mas_equalTo(ScaleH(15));
    }];
    
    [self addSubview:self.cornerLab];
}

#pragma mark - laze load

-(UIImageView *)iconIV {
    if(!_iconIV) {
        _iconIV = [UIImageView new];
    }
    return _iconIV;
}   

-(UILabel *)nickNameLab {
    if(!_nickNameLab) {
        _nickNameLab = [UILabel new];
        [_nickNameLab setFont:FontB(15)];
        [_nickNameLab setTextColor:ColorRGBAll(76)];
    }
    return _nickNameLab;
}

-(UILabel *)msgLab {
    if(!_msgLab) {
        _msgLab = [UILabel new];
        [_msgLab setFont:FontB(15)];
        [_msgLab setTextColor:ColorRGBAll(165)];
    }
    return _msgLab;
}

-(UILabel *)msgTimeLab {
    if(!_msgTimeLab) {
        _msgTimeLab = [UILabel new];
        [_msgTimeLab setFont:FontB(13)];
        _msgTimeLab.textAlignment = NSTextAlignmentRight;
        [_msgTimeLab setTextColor:ColorRGBAll(208)];
    }
    return _msgTimeLab;
}

-(UILabel *)cornerLab {
    if(!_cornerLab) {
        _cornerLab = [UILabel new];
        [_cornerLab setFont:FontB(13)];
        [_cornerLab setTextAlignment:NSTextAlignmentCenter];
        [_cornerLab setTextColor:[UIColor whiteColor]];
        _cornerLab.layer.backgroundColor = MainColor.CGColor;
        _cornerLab.layer.masksToBounds = YES;
    }
    return _cornerLab;
}

@end
