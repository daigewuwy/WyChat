//
//  WCGroupListCell.m
//  WyChat
//
//  Created by 吴伟毅 on 19/6/10.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "WCGroupListCell.h"


@interface WCGroupListCell()
{
    CGFloat kCellHeight;
}
/** 头像. */
@property (nonatomic,strong) UIImageView *iconIV;

/** 发送请求的ID. */
@property (nonatomic,strong) UILabel *friendIDLab;

@end


@implementation WCGroupListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        kCellHeight = ScaleW(75);
        [self setupUI];
        // 必须刷新布局，否则有些控件显示异常
        [self layoutSubviews];
    }
    return self;
}

- (void)setupUI {
    
    [self addSubview:self.iconIV];
    [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(ScaleH(15));
        make.left.mas_equalTo(self).offset(ScaleW(15));
        make.height.mas_equalTo(kCellHeight - ScaleH(30));
        make.width.mas_equalTo(kCellHeight - ScaleH(30));
    }];
    
    [self addSubview:self.friendIDLab];
    [_friendIDLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_iconIV.mas_right).offset(ScaleW(15));
        make.height.mas_equalTo(ScaleH(20));
        make.centerY.mas_equalTo(_iconIV);
        make.width.mas_equalTo(ScaleW(105));
    }];
    
    [self layoutIfNeeded];
    
    [_iconIV setImageByBezierPathWithImage:[UIImage imageNamed:@"placeHolderIcon"] radius:_iconIV.frame.size.width/2];
}

-(void)setStatus:(WCGroupListModel *)model {
    
    [_iconIV setImageByBezierPathWithImage:model.icon radius:_iconIV.frame.size.width/2];
    [_friendIDLab setText:[DBUtil queryGroupNameWithGroupId:model.groupID]];
    [_friendIDLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([model.groupID getWidthForFont:Font(15)]);
    }];
}

#pragma mark - lazy load

-(UIImageView *)iconIV {
    if(!_iconIV) {
        _iconIV = [UIImageView new];
        [_iconIV setBackgroundColor:[UIColor whiteColor]];
    }
    return _iconIV;
}

-(UILabel *)friendIDLab {
    if(!_friendIDLab) {
        _friendIDLab = [UILabel new];
        [_friendIDLab setFont:Font(15)];
        [_friendIDLab setTextColor:ColorRGBAll(140)];
        [_friendIDLab setText:@"我是你大爷"];
        [_friendIDLab setBackgroundColor:[UIColor whiteColor]];
    }
    return _friendIDLab;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
