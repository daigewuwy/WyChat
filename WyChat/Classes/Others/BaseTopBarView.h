//
//  WWY'sTopBarView.h
//  WWYTopBarView
//
//  Created by 吴伟毅 on 17/7/1.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TopBarViewDelegate <NSObject>
@optional
-(void)leftActionOfDelegate;
-(void)rightActionOfDelegate;
@end
@interface BaseTopBarView : UIView

@property (nonatomic,retain) id<TopBarViewDelegate>delegate;

#pragma mark - topBar配置

// 设置topBar的背景图
-(void )setBgViewImg:(UIImage *)img;
// 设置topBar的标题
-(void )setTopTitle:(NSString *)title;
// 设置topBar的标题颜色
-(void )setTopTitleColor:(UIColor *)color;
// 设置topBar的颜色
-(void )setTopBgColor:(UIColor *)color;
// 设置标题的字体大小
-(void )setTopTitleFont:(CGFloat )font;
// 设置分割线是否隐藏
-(void )setTopLineHide:(BOOL )hide;

#pragma mark - 左边按钮配置

// 设置左边按钮的隐藏
-(void )setLeftBtnHide:(BOOL )hide;
// 设置左边按钮的图片
-(void )setLeftBtnImage:(UIImage *)image;
// 设置左边按钮的颜色
-(void )setLeftBtnBgColor:(UIColor *)color;
// 设置左边按钮的标题
-(void )setLeftBtnTitle:(NSString *)title;
// 设置左边按钮标题的字体大小
-(void )setLeftBtnFont:(CGFloat )font;

#pragma mark - 右边按钮配置

// 设置右边按钮的隐藏
-(void )setRightBtnHide:(BOOL )hide;
// 设置右边按钮的图片
-(void )setRightBtnImage:(UIImage *)image;
// 设置右边按钮的颜色
-(void )setRightBtnBgColor:(UIColor *)color;
// 设置右边按钮的标题
-(void )setRightBtnTitle:(NSString *)title;
// 设置右边按钮标题的字体大小
-(void )setRightBtnFont:(CGFloat )font;

@end
