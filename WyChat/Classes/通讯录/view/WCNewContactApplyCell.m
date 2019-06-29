//
//  WCNewContactApplyCell.m
//  WyChat
//
//  Created by 吴伟毅 on 19/6/3.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "WCNewContactApplyCell.h"

@interface WCNewContactApplyCell()
{
    CGFloat kCellHeight;
}
/** 头像. */
@property (nonatomic,strong) UIImageView *iconIV;

/** 发送请求的ID. */
@property (nonatomic,strong) UILabel *applyIDLab;

/** 发送请求的备注. */
@property (nonatomic,strong) UILabel *applyMarkLab;

/** 同意按钮 */
@property (nonatomic,strong) UIButton *agreeBtn;

/** 拒绝按钮 */
@property (nonatomic,strong) UIButton *rejectBtn;

@end


@implementation WCNewContactApplyCell

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
    
    [self addSubview:self.applyIDLab];
    [_applyIDLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_iconIV.mas_right).offset(ScaleW(15));
        make.top.mas_equalTo(_iconIV.mas_top);
        make.height.mas_equalTo(ScaleH(20));
        make.width.mas_equalTo(ScaleW(105));
    }];
    
    
    [self addSubview:self.applyMarkLab];
    [_applyMarkLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_applyIDLab.mas_left);
        make.bottom.mas_equalTo(_iconIV.mas_bottom);
        make.height.mas_equalTo(ScaleH(20));
        make.width.mas_equalTo(ScaleW(205));
    }];
    
    [self addSubview:self.agreeBtn];
    [_agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-ScaleW(15));
        make.top.mas_equalTo(self).offset(ScaleH(20));
        make.height.mas_equalTo(kCellHeight - 2*ScaleH(20));
        make.width.mas_equalTo(ScaleW(50));
    }];
    
    [self addSubview:self.rejectBtn];
    [_rejectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_agreeBtn.mas_left).offset(-ScaleW(15));
        make.top.mas_equalTo(_agreeBtn);
        make.height.mas_equalTo(_agreeBtn);
        make.width.mas_equalTo(_agreeBtn);
    }];
    
    [self layoutIfNeeded];
    
    [_iconIV setImageByBezierPathWithImage:[UIImage imageNamed:@"placeHolderIcon"] radius:_iconIV.frame.size.width/2];
    
}

-(void)setStatus:(WCFriendApplyModel *)model {
    [_iconIV setImageByBezierPathWithImage:model.icon radius:_iconIV.frame.size.width/2];
    [_applyIDLab setText:[NSString stringWithFormat:@"申请ID:%@",model.friendApplyID]];
    [_applyMarkLab setText:[NSString stringWithFormat:@"备注:%@",model.friendApplyMark]];
}

#pragma mark - lazy load

-(UIImageView *)iconIV {
    if(!_iconIV) {
        _iconIV = [UIImageView new];
        [_iconIV setBackgroundColor:[UIColor whiteColor]];
    }
    return _iconIV;
}

-(UILabel *)applyIDLab {
    if(!_applyIDLab) {
        _applyIDLab = [UILabel new];
        [_applyIDLab setFont:Font(15)];
        [_applyIDLab setTextColor:ColorRGBAll(140)];
        [_applyIDLab setBackgroundColor:[UIColor whiteColor]];
    }
    return _applyIDLab;
}

-(UILabel *)applyMarkLab {
    if(!_applyMarkLab) {
        _applyMarkLab = [UILabel new];
        [_applyMarkLab setFont:Font(15)];
        [_applyMarkLab setTextColor:ColorRGBAll(140)];
        [_applyMarkLab setBackgroundColor:[UIColor whiteColor]];
    }
    return _applyMarkLab;
}


-(UIButton *)agreeBtn {
    if(!_agreeBtn) {
        _agreeBtn = [UIButton new];
        [_agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
        [_agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_agreeBtn setBackgroundColor:MainColor];
        [_agreeBtn addTarget:self action:@selector(agreeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        _agreeBtn.layer.masksToBounds = YES;
        _agreeBtn.layer.cornerRadius = ScaleW(5);
    }
    return _agreeBtn;
}


-(UIButton *)rejectBtn {
    if(!_rejectBtn) {
        _rejectBtn = [UIButton new];
        [_rejectBtn setTitle:@"拒绝" forState:UIControlStateNormal];
        [_rejectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rejectBtn setBackgroundColor:[UIColor redColor]];
        [_rejectBtn addTarget:self action:@selector(rejectBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        _rejectBtn.layer.masksToBounds = YES;
        _rejectBtn.layer.cornerRadius = ScaleW(5);
    }
    return _rejectBtn;
}

#pragma mark - target

- (void)agreeBtnClicked {
    self.agreeCallBack();
}

- (void)rejectBtnClicked {
    self.rejectCallBack();
}

#pragma mark - lifeCycle

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
