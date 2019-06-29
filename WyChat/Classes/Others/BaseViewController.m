//
//  BaseViewController.m
//  WWYTopBarView
//
//  Created by 吴伟毅 on 17/7/1.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end
@implementation BaseViewController
-(instancetype)init
{
    self = [super init];
    if(self)
    {
        _topBar = [[BaseTopBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavBarAndStatusBarHeight)];
        _topBar.delegate = self;
        [self.view addSubview:_topBar];
    
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - topBar

-(void )setTopTitle:(NSString *)title
{
    [_topBar setTopTitle:title];
}
-(void)setTopTitleColor:(UIColor *)color
{
    [_topBar setTopTitleColor:color];
}
-(void)setLeftBtnHide:(BOOL)hide
{
    [_topBar setLeftBtnHide:hide];
}
-(void)setTopBgColor:(UIColor *)color
{
    [_topBar setTopBgColor:color];
    [_topBar setLeftBtnBgColor:color];
}
-(void)setTopBarHide:(BOOL)hide
{
    _topBar.hidden = hide;
}
-(void )setTopTitleFont:(CGFloat)font
{
    [_topBar setTopTitleFont:font];
}
-(void)setTopLineHide:(BOOL)hide
{
    [_topBar setTopLineHide:hide];
}
-(void )setSelfBgColor:(UIColor *)color
{
    self.view.backgroundColor = color;
}
-(void )setBgViewImg:(UIImage *)img {
    [_topBar setBgViewImg:img];
}

#pragma mark - 左边按钮

-(void)setLeftBtnImage:(UIImage *)image
{
    [_topBar setLeftBtnImage:image];
}
-(void )setLeftBtnBgColor:(UIColor *)color
{
    [_topBar setLeftBtnBgColor:color];
}
-(void)setLeftBtnTitle:(NSString *)title
{
    [_topBar setLeftBtnTitle:title];
}
-(void)setLeftBtnFont:(CGFloat)font
{
    [_topBar setLeftBtnFont:font];
}

#pragma mark - 右边按钮

-(void)setRightBtnBgColor:(UIColor *)color
{
    [_topBar setRightBtnBgColor:color];
}
-(void)setRightBtnFont:(CGFloat)font
{
    [_topBar setRightBtnFont:font];
}
-(void)setRightBtnHide:(BOOL)hide
{
    [_topBar setRightBtnHide:hide];
}
-(void)setRightBtnImage:(UIImage *)image
{
    [_topBar setRightBtnImage:image];
}
-(void)setRightBtnTitle:(NSString *)title
{
    [_topBar setRightBtnTitle:title];
}

#pragma mark - delegate

-(void )setTopBarDelegate:(id<TopBarViewDelegate>)delegate {
    _topBar.delegate = delegate;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)leftActionOfDelegate
{
    //判断视图是以模态或者进栈方式进入
    if(self.presentingViewController)//模态则销毁
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else//进栈则出栈
    {
        [[ViewManager shareInstance].NavigationController popViewControllerAnimated:YES];
    }
}

-(void)rightActionOfDelegate
{
    NSLog(@"右边按钮点击");
}


@end
