//
//  ViewController.h
//  新闻类界面框架
//
//  Created by 吴伟毅 on 18/12/1.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideViewController : UIViewController

/** 顶部标题. */
@property (nonatomic,strong) NSString *topTitle;

/** 字体缩放比例. 注意:该值默认为1.3,最大为2,否则出现渲染异常 */
@property (nonatomic,assign) CGFloat scalingRatio;

/**
 *  @brief 设置子控制器
 *
 *  @param childControllers 子控制器数组
 *
 */
- (void)setupChildControllers:(NSArray *)childControllers Titles:(NSArray *)titles;

/**
 *  @brief 获取视图的总高度
 *  @return 当前视图的总高度
 */
- (CGFloat)getTotalHeight;
@end

