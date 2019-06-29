//
//  WWY'sTopBarView.m
//  WWYTopBarView
//
//  Created by 吴伟毅 on 17/7/1.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BaseTopBarView.h"

static CGFloat kBaseScreen_width;
static CGFloat kBaseScreen_height;

@interface BaseTopBarView()

/** 标题. */
@property (nonatomic,strong) UILabel *topTitleLab;
/** 分割线. */
@property (nonatomic,strong) UIView *line;
/** 左边按钮. */
@property (nonatomic,strong) UIButton *leftBtn;
/** 右边按钮. */
@property (nonatomic,strong) UIButton *rightBtn;
/** topBar. */
@property (nonatomic,strong)  UIImageView *bgView;

@end

@implementation BaseTopBarView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        kBaseScreen_width = frame.size.width;
        kBaseScreen_height = frame.size.height;
        
        [self addSubview:self.bgView];
        [self addSubview:self.topTitleLab];
        [self addSubview:self.line];
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];
        
        [self setLeftBtnHide:YES];
        [self setRightBtnHide:YES];
    }
    return self;
}

#pragma mark - lazy load

-(UIImageView *)bgView {
    if(!_bgView) {
        _bgView = [UIImageView new];
        _bgView.frame = CGRectMake(0, 0, kScreenWidth, kBaseScreen_height);
        _bgView.backgroundColor = MainColor;
        _bgView.userInteractionEnabled = YES;
    }
    return _bgView;
}

-(UILabel *)topTitleLab {
    if(!_topTitleLab) {
        _topTitleLab = [UILabel new];
        CGFloat x = kBaseScreen_width * 76/414;
        CGFloat y = kBaseScreen_height - kBaseScreen_height * 30/64;
        CGFloat width = kBaseScreen_width - 2 * x;
        CGFloat height = kBaseScreen_height * 20/64;
        
        [_topTitleLab setFrame:CGRectMake(x, y, width, height)];
        _topTitleLab.textAlignment = NSTextAlignmentCenter;
        _topTitleLab.backgroundColor = _bgView.backgroundColor;
        _topTitleLab.text = @"主菜单";
        _topTitleLab.font = [UIFont systemFontOfSize:kBaseScreen_height * 20/64 weight:UIFontWeightBold];
        _topTitleLab.textColor = [UIColor blackColor];
    }
    return _topTitleLab;
}

-(UIView *)line {
    if(!_line) {
        _line = [UIView new];
        [_line setFrame:CGRectMake(0, kBaseScreen_height - 1,kBaseScreen_width, 1)
         ];
        _line.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.1];

    }
    return _line;
}

-(UIButton *)leftBtn {
    if(!_leftBtn) {
        
        _leftBtn = [UIButton new];
        
        CGFloat x = kBaseScreen_width * 10/414;
        CGFloat y = kBaseScreen_height - kBaseScreen_height * 28/64;
        CGFloat width = kBaseScreen_width * 66/414;
        CGFloat height = kBaseScreen_height * (64 - y - 10)/64;
        
        [_leftBtn setFrame:CGRectMake(x, y, width, height)];

        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:kBaseScreen_width * 18/414];
        _leftBtn.tag = 10086;
        [_leftBtn setTitle:@"返回" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        [_leftBtn setImage:[UIImage imageNamed:@"leftBtn"] forState:UIControlStateNormal];
        _leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        [_leftBtn setBackgroundColor:_bgView.backgroundColor];
        [_leftBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

-(UIButton *)rightBtn {
    if(!_rightBtn) {
        
        _rightBtn = [UIButton new];
        
        CGFloat width = kBaseScreen_width * 18/414;
        CGFloat height = width;
        CGFloat y = kBaseScreen_height - height - kBaseScreen_height * 10/64;
        CGFloat x = kBaseScreen_width * (414 - 15 - width)/414;
        
        [_rightBtn setFrame:CGRectMake(x, y, width, height)];
        
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:kBaseScreen_width * 18/414];
        _rightBtn.tag = 10011;
        [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
       // [_rightBtn setBackgroundImage:[UIImage imageNamed:@"rightBtn"] forState:UIControlStateNormal];
        //_rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
        [_rightBtn setBackgroundColor:_bgView.backgroundColor];
        [_rightBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}



#pragma mark - backActionOfDelegate

-(void)btnAction:(UIButton *)sender
{
    if(sender.tag == 10086)
    {
        if(_delegate &&[_delegate respondsToSelector:@selector(leftActionOfDelegate)])
        {
            [_delegate leftActionOfDelegate];
        }
    }else if(sender.tag == 10011) {
        if(_delegate &&[_delegate respondsToSelector:@selector(rightActionOfDelegate)])
        {
            [_delegate rightActionOfDelegate];
        }
    }else;
}

#pragma mark - setter

-(void )setTopTitle:(NSString *)title
{
    _topTitleLab.text = title;
}
-(void)setTopTitleColor:(UIColor *)color
{
    _topTitleLab.textColor = color;
}
-(void)setLeftBtnHide:(BOOL)hide
{
    _leftBtn.hidden = hide;
}
-(void)setTopBgColor:(UIColor *)color
{
    _bgView.backgroundColor = color;
}
-(void)setLeftBtnImage:(UIImage *)image
{
    [_leftBtn setImage:image forState:UIControlStateNormal];
}
-(void)setTopLineHide:(BOOL)hide
{
    _line.hidden = hide;
}
-(void )setLeftBtnBgColor:(UIColor *)color
{
    [_leftBtn setBackgroundColor:color];
}
-(void)setLeftBtnTitle:(NSString *)title
{
    [_leftBtn setTitle:title forState:UIControlStateNormal];
}
-(void)setTopTitleFont:(CGFloat)font
{
    _topTitleLab.font = [UIFont systemFontOfSize:font];
}
-(void)setLeftBtnFont:(CGFloat)font
{
    _leftBtn.titleLabel.font = [UIFont systemFontOfSize:font];
}
-(void)setRightBtnBgColor:(UIColor *)color
{
    [_rightBtn setBackgroundColor:color];
}
-(void)setRightBtnFont:(CGFloat)font
{
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:font];
}
-(void)setRightBtnHide:(BOOL)hide
{
    _rightBtn.hidden = hide;
}
-(void)setRightBtnImage:(UIImage *)image
{
    [_rightBtn setBackgroundImage:image forState:UIControlStateNormal];
}
-(void)setRightBtnTitle:(NSString *)title
{
    CGFloat width = [title getSizeForFont:_rightBtn.titleLabel.font].width;
    CGFloat height = kBaseScreen_height * 18/64;
    CGFloat y = kBaseScreen_height - height - kBaseScreen_height * 10/64;
    CGFloat x = kBaseScreen_width * (414 - 10 - width)/414;
    
    _rightBtn.frame = CGRectMake(x,y,width,height);
    [_rightBtn setTitle:title forState:UIControlStateNormal];
}
-(void )setBgViewImg:(UIImage *)img {
    [_bgView setImage:img];
}
@end
