//
//  WCNewFriendApplyCell.m
//  WyChat
//
//  Created by 吴伟毅 on 19/6/15.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "WCNewFriendApplyCell.h"

@interface WCNewFriendApplyCell()

/** 时间文本. */
@property (nonatomic,strong) UILabel *timeLab;

/** 背景白色容器视图. */
@property (nonatomic,strong) UIView *bgView;

/** 头像. */
@property (nonatomic,strong) UIImageView *iconIV;

/** 申请的好友ID. */
@property (nonatomic,strong) UILabel *contactIDLab;

/** 备注. */
@property (nonatomic,strong) UILabel *markLab;

/** 拒绝按钮. */
@property (nonatomic,strong) UIButton *rejectBtn;

/** 同意按钮. */
@property (nonatomic,strong) UIButton *agreeBtn;

/** 分割线. */
@property (nonatomic,strong) UIView *line;

@end

@implementation WCNewFriendApplyCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = ColorRGBAll(245);
        
        [self setupUI];
        // 必须刷新布局，否则有些控件显示异常
        [self layoutSubviews];
    }
    return self;
}

- (void)setupUI {
    [self layoutIfNeeded];
    
    [self addSubview:self.timeLab];
    [self addSubview:self.bgView];
    [_bgView addSubview:self.iconIV];
    [_bgView addSubview:self.contactIDLab];
    [_bgView addSubview:self.markLab];
    [_bgView addSubview:self.rejectBtn];
    [_bgView addSubview:self.agreeBtn];
    [_bgView addSubview:self.line];
    
    
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.width.mas_equalTo(self);
        make.height.mas_equalTo(ScaleH(40));
    }];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_timeLab.mas_bottom);
        make.left.mas_equalTo(self).offset(ScaleW(15));
        make.width.mas_equalTo(kScreenWidth - ScaleW(15) * 2);
        make.height.mas_equalTo(ScaleH(120));
    }];
    
    [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bgView).offset(ScaleW(10));
        make.top.mas_equalTo(_bgView).offset(ScaleH(15));
        make.width.mas_equalTo(ScaleW(40));
        make.height.mas_equalTo(ScaleH(40));
    }];
    
    [_contactIDLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_iconIV).offset(ScaleH(5));
        make.left.mas_equalTo(_iconIV.mas_right).offset(ScaleW(15));
        make.height.mas_equalTo(ScaleH(15));
    }];
    
    [_markLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_contactIDLab);
        make.top.mas_equalTo(_contactIDLab.mas_bottom).offset(ScaleH(15));
        make.height.mas_equalTo(ScaleH(15));
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bgView);
        make.top.mas_equalTo(_markLab.mas_bottom).offset(ScaleH(10));
        make.width.mas_equalTo(_bgView);
        make.height.mas_equalTo(ScaleH(1));
    }];
    
    [self layoutIfNeeded];

    [_rejectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_line.mas_bottom);
        make.left.mas_equalTo(_bgView);
        make.width.mas_equalTo(_bgView.width/2);
        make.height.mas_equalTo(ScaleH(45));
    }];
    
    [_agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_rejectBtn);
        make.left.mas_equalTo(_rejectBtn.mas_right);
        make.width.mas_equalTo(_rejectBtn);
        make.height.mas_equalTo(_rejectBtn);
    }];
}

-(void)setStatus:(WCFriendApplyModel *)model {
    
    [self layoutIfNeeded];
    
    [_iconIV setImageByBezierPathWithImage:model.icon radius:ScaleW(40)/2];
    [_timeLab setText:@"2019-06-14"];
    [_contactIDLab setText:model.friendApplyID];
    [_markLab setText:[NSString stringWithFormat:@"备注:%@",model.friendApplyMark]];
    
    [_timeLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([_timeLab.text getWidthForFont:_timeLab.font]);
    }];
    
    [_contactIDLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([_contactIDLab.text getWidthForFont:_contactIDLab.font]);
    }];
        
    [_markLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([_markLab.text getWidthForFont:_markLab.font]);
    }];

}


#pragma mark - lazy load
-(UILabel *)timeLab {
    if(!_timeLab) {
        _timeLab = [UILabel new];
        [_timeLab setFont:Font(10)];
        [_timeLab setBackgroundColor:self.backgroundColor];
        [_timeLab setTextAlignment:NSTextAlignmentCenter];
        [_timeLab setTextColor:ColorRGBAll(187)];
    }
    return _timeLab;
}
-(UIView *)bgView {
    if(!_bgView) {
        _bgView = [UIView new];
        [_bgView setBackgroundColor:[UIColor whiteColor]];
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = ScaleH(10);
    }
    return _bgView;
}
-(UIImageView *)iconIV {
    if(!_iconIV) {
        _iconIV = [UIImageView new];
    }
    return _iconIV;
}
-(UILabel *)contactIDLab {
    if(!_contactIDLab) {
        _contactIDLab = [UILabel new];
        [_contactIDLab setFont:Font(15)];
        [_contactIDLab setBackgroundColor:_bgView.backgroundColor];
        [_contactIDLab setTextAlignment:NSTextAlignmentLeft];
    }
    return _contactIDLab;
}
-(UILabel *)markLab {
    if(!_markLab) {
        _markLab = [UILabel new];
        [_markLab setFont:Font(15)];
        [_markLab setBackgroundColor:_bgView.backgroundColor];
        [_markLab setTextAlignment:NSTextAlignmentLeft];
        [_markLab setTextColor:ColorRGBAll(179)];
    }
    return _markLab;
}
-(UIButton *)rejectBtn {
    if(!_rejectBtn) {
        _rejectBtn = [UIButton new];
        [_rejectBtn setTitle:@"拒绝" forState:UIControlStateNormal];
        [_rejectBtn setTitleColor:ColorRGBAll(132) forState:UIControlStateNormal];
        [_rejectBtn.titleLabel setFont:Font(18)];
        [_rejectBtn addTarget:self action:@selector(rejectBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_rejectBtn setBackgroundColor:_bgView.backgroundColor];
    }
    return _rejectBtn;
}
-(UIButton *)agreeBtn {
    if(!_agreeBtn) {
        _agreeBtn = [UIButton new];
        [_agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
        [_agreeBtn setTitleColor:MainColor forState:UIControlStateNormal];
        [_agreeBtn.titleLabel setFont:Font(18)];
        [_agreeBtn addTarget:self action:@selector(agreeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_agreeBtn setBackgroundColor:_bgView.backgroundColor];
    }
    return _agreeBtn;
}
-(UIView *)line {
    if(!_line) {
        _line = [UIView new];
        [_line setBackgroundColor:self.backgroundColor];
    }
    return _line;
}
#pragma mark - Action


- (void)rejectBtnClicked {
    self.rejectCallBack();
}
- (void)agreeBtnClicked {
    self.agreeCallBack();
}

@end
