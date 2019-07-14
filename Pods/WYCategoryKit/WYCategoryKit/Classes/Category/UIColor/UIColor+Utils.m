//
//  UIColor+IOSUtils.m
//  Toos
//
//  Created by xiaoming on 15/12/24.
//  Copyright © 2015年 shandandan. All rights reserved.
//

#import "UIColor+Utils.h"

@implementation UIColor (IOSUtils)

#pragma mark - Color from Hex
+ (instancetype)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&rgbValue];
    
    return [[self class] colorWithR:((rgbValue & 0xFF0000) >> 16) G:((rgbValue & 0xFF00) >> 8) B:(rgbValue & 0xFF) A:1.0];
}

+ (instancetype)colorFromHexString:(NSString *)hexString alpha:(CGFloat)alpha{
    unsigned rgbValue = 0;
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&rgbValue];
    
    return [[self class] colorWithR:((rgbValue & 0xFF0000) >> 16) G:((rgbValue & 0xFF00) >> 8) B:(rgbValue & 0xFF) A:alpha];
}

#pragma mark - RGBA Helper method
+ (instancetype)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha
{
    return [[self class] colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
}

/**
 获取标题的字体颜色 262626 - 黑
 
 */
+ (UIColor *)getTitleColor {
    return [UIColor colorFromHexString:@"262626"];
}

/**
 获取默认页面背景色 #ffffff
 */
+ (UIColor *)getBackgroundColor {
    return [UIColor colorFromHexString:@"ffffff"];
}

/**
 获取表格分割线的颜色 cccaca - 淡淡的黑

 */
+ (UIColor *)getSeparatorColor {
    return [UIColor colorFromHexString:@"cccaca"];
}

/**
 获取内容的字体颜色 6b6b6b - 二级黑
  */
+ (UIColor *)getContentColor {
    return [UIColor colorFromHexString:@"6b6b6b"];
}
/**
 获取次级内容的字体颜色 aaaaaa - 最浅的黑  ----- 也可以作为按钮不可点击的颜色
 
 */
+ (UIColor *)getContentSecondColor {
    return [UIColor colorFromHexString:@"aaaaaa"];
}

/**
 获取默认文字颜色。placeHoler的颜色 cccaca
  */
+ (UIColor *)getPlaceHoderColor {
    return [UIColor colorFromHexString:@"cccaca"];
}

/**
 获取红色的颜色 #BB0D23
*/
+ (UIColor *)getRedColor {
    return [UIColor colorFromHexString:@"#d9373d"];
}

/**
 获取导航栏的背景颜色
 */
+ (UIColor *)getNavigationBarColor {
    return [UIColor colorFromHexString:@"fcfcfc"];
}

/**
 获取统一的蓝色的背景颜色
*/
+ (UIColor *)getBlueColor {
    return [UIColor blueColor];
}

/**
 获取输入框的光标颜色 blackColor
 @return 黑色
 */
+ (UIColor *)getTextFieldCursorColor {
    return [UIColor blackColor];
}
    
/*
*获取颜色的RGBA值
@return RGBA值
*/
+ (NSMutableArray *)changeUIColorToRGB:(UIColor *)color
{
        NSMutableArray *RGBStrValueArr = [[NSMutableArray alloc] init];
        NSString *RGBStr = nil;
        
        //获得RGB值描述
        NSString *RGBValue = [NSString stringWithFormat:@"%@", color];
        
        //将RGB值描述分隔成字符串
        NSArray *RGBArr = [RGBValue componentsSeparatedByString:@" "];
        
        //获取红色值
        float r = [RGBArr[0] floatValue];
        RGBStr = [NSString stringWithFormat:@"%.2lf", r];
        [RGBStrValueArr addObject:RGBStr];
        
        //获取绿色值
        float g = [RGBArr[1] floatValue];
        RGBStr = [NSString stringWithFormat:@"%.2lf", g];
        [RGBStrValueArr addObject:RGBStr];
        
        //获取蓝色值
        float b = [RGBArr[2] floatValue];
        RGBStr = [NSString stringWithFormat:@"%.2lf", b];
        [RGBStrValueArr addObject:RGBStr];
    
        
        //返回保存RGB值的数组
        return RGBStrValueArr;
}

//绘制渐变色颜色的方法
+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr{
    
    //    CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(__bridge id)[UIColor colorFromHexString:fromHexColorStr].CGColor,(__bridge id)[UIColor colorFromHexString:toHexColorStr].CGColor];
    
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    
    //  设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@0,@1];
    
    return gradientLayer;
}


@end
