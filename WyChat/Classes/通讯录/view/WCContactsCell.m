//
//  WCContactsCell.m
//  WyChat
//
//  Created by 吴伟毅 on 19/6/4.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "WCContactsCell.h"


@interface WCContactsCell()
{
    CGFloat kCellHeight;
}
/** 头像. */
@property (nonatomic,strong) UIImageView *iconIV;

/** 发送请求的ID. */
@property (nonatomic,strong) UILabel *friendIDLab;

/** 删除按钮. */
@property (nonatomic,strong) UIButton *delBtn;

@end

@implementation WCContactsCell

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
    [self addSubview:self.friendIDLab];
    [self addSubview:self.delBtn];

    [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(ScaleH(15));
        make.left.mas_equalTo(self).offset(ScaleW(15));
        make.height.mas_equalTo(kCellHeight - ScaleH(30));
        make.width.mas_equalTo(kCellHeight - ScaleH(30));
    }];
    
    [_friendIDLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_iconIV.mas_right).offset(ScaleW(15));
        make.height.mas_equalTo(ScaleH(20));
        make.centerY.mas_equalTo(_iconIV);
        make.width.mas_equalTo(ScaleW(105));
    }];
    
    [_delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-ScaleW(15));
        make.top.mas_equalTo(self).offset(ScaleH(20));
        make.height.mas_equalTo(kCellHeight - 2*ScaleH(20));
        make.width.mas_equalTo(ScaleW(50));
    }];
    
    [self layoutIfNeeded];
    
    [_iconIV setImageByBezierPathWithImage:[UIImage imageNamed:@"placeHolderIcon"] radius:_iconIV.frame.size.width/2];
}

-(void)setStatus:(WCContactModel *)model {
    
    [_iconIV setImageByBezierPathWithImage:model.icon radius:_iconIV.frame.size.width/2];
    
    [_friendIDLab setText:model.contactID];
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

-(UIButton *)delBtn {
    if(!_delBtn) {
        _delBtn = [UIButton new];
        [_delBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_delBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_delBtn setBackgroundColor:[UIColor redColor]];
        [_delBtn addTarget:self action:@selector(delBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        _delBtn.layer.masksToBounds = YES;
        _delBtn.layer.cornerRadius = ScaleW(5);

    }
    return _delBtn;
}

- (void)delBtnClicked {
    _delContactBtnClickedCallBack();
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
