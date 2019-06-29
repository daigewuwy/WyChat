//
//  BaseViewController.h
//  WWYTopBarView
//
//  Created by 吴伟毅 on 17/7/1.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTopBarView.h"

@interface BaseViewController : UIViewController<TopBarViewDelegate>
// topBar
@property (nonatomic,retain) BaseTopBarView *topBar;
-(void )setTopBarDelegate:(id<TopBarViewDelegate>)delegate;

#pragma mark - topBar配置
-(void )setBgViewImg:(UIImage *)img;
-(void )setTopTitle:(NSString *)title;
-(void )setTopTitleColor:(UIColor *)color;
-(void )setTopBgColor:(UIColor *)color;
-(void )setTopLineHide:(BOOL )hide;
-(void )setTopBarHide:(BOOL )hide;
-(void )setTopTitleFont:(CGFloat )font;
-(void )setSelfBgColor:(UIColor *)color;

#pragma mark - 左边按钮配置
-(void )setLeftBtnHide:(BOOL )hide;
-(void )setLeftBtnFont:(CGFloat )font;
-(void )setLeftBtnImage:(UIImage *)image;
-(void )setLeftBtnBgColor:(UIColor *)color;
-(void )setLeftBtnTitle:(NSString *)title;

#pragma mark - 右边按钮配置
-(void )setRightBtnHide:(BOOL )hide;
-(void )setRightBtnImage:(UIImage *)image;
-(void )setRightBtnBgColor:(UIColor *)color;
-(void )setRightBtnTitle:(NSString *)title;
-(void )setRightBtnFont:(CGFloat )font;

@end
