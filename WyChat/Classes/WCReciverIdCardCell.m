//
//  WCReciverIdCardCell.m
//  WyChat
//
//  Created by 吴伟毅 on 19/6/17.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "WCReciverIdCardCell.h"


@interface WCReciverIdCardCell()

/** 头像. */
@property (nonatomic,strong) UIImageView *iconIV;

/** 名片背景图片. */
@property (nonatomic,strong) UIImageView *bgIV;

/** 发送的名片头像. */
@property (nonatomic,strong) UIImageView *idCardIV;

/** 名片. */
@property (nonatomic,strong) UILabel *idCardLab;

/** 名片ID. */
@property (nonatomic,strong) UILabel *idLab;

@end

@implementation WCReciverIdCardCell

+(instancetype)reciverIdCardCellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"reciverCellID";
    WCReciverIdCardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell) {
         cell = [[WCReciverIdCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        [cell setupUI];
        // 必须刷新布局，否则有些控件显示异常
        [cell layoutSubviews];
    }
    return cell;
    
}

- (void)setupUI {
    [self addSubview:self.iconIV];
    [self addSubview:self.bgIV];
    [self addSubview:self.idCardIV];
    [self addSubview:self.idCardLab];
    [self addSubview:self.idLab];
    
    [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(ScaleH(10));
        make.left.mas_equalTo(self).offset(ScaleW(10));
        make.width.mas_equalTo(ScaleW(40));
        make.height.mas_equalTo(ScaleH(40));
    }];
    
    [self layoutIfNeeded];
    _iconIV.layer.masksToBounds = YES;
    _iconIV.layer.cornerRadius = _iconIV.width/2.0;
    
    [_bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_iconIV).offset(ScaleH(5));
        make.left.mas_equalTo(_iconIV.mas_right).offset(ScaleW(15));
        make.width.mas_equalTo(ScaleW(250));
        make.height.mas_equalTo(ScaleH(80));
    }];
    // 拉伸图片
    _bgIV.image =  [_bgIV.image stretchableImageWithLeftCapWidth:_bgIV.image.size.width * 0.7 topCapHeight:_bgIV.image.size.width * 0.7];
    
    [_idCardIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bgIV).offset(ScaleH(15));
        make.left.mas_equalTo(_bgIV).offset(ScaleW(15));
        make.width.mas_equalTo(ScaleW(50));
        make.height.mas_equalTo(ScaleH(50));
    }];
    
    [_idCardLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_idCardIV);
        make.left.mas_equalTo(_idCardIV.mas_right).offset(ScaleW(15));
        make.width.mas_equalTo(ScaleW(50));
        make.height.mas_equalTo(ScaleH(20));
    }];
    
    [_idLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_idCardIV);
        make.left.mas_equalTo(_idCardLab);
        make.width.mas_equalTo(ScaleW(150));
        make.height.mas_equalTo(ScaleH(17));
    }];
    
    [_idLab setText:@"JXH"];
    [_iconIV setImage:[UIImage imageNamed:@"user"]];
}


#pragma mark - lazy load

-(UIImageView *)iconIV {
    if(!_iconIV) {
        _iconIV = [UIImageView new];
    }
    return _iconIV;
}

-(UIImageView *)bgIV {
    if(!_bgIV) {
        _bgIV = [UIImageView new];
        [_bgIV setImage:[UIImage imageNamed:@"chat_receiver_bg"]];
    }
    return _bgIV;
}

-(UIImageView *)idCardIV {
    if(!_idCardIV) {
        _idCardIV = [UIImageView new];
        [_idCardIV setImage:[UIImage imageNamed:@"placeHolderIcon"]];
    }
    return _idCardIV;
}

-(UILabel *)idCardLab {
    if(!_idCardLab) {
        _idCardLab =  [UILabel new];
        [_idCardLab setText:@"名片"];
        [_idCardLab setFont:Font(20)];
    }
    return _idCardLab;
}

-(UILabel *)idLab {
    if(!_idLab) {
        _idLab =  [UILabel new];
        [_idLab setFont:Font(17)];
    }
    return _idLab;
}
@end
