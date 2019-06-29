//
//  ViewManager.h
//  WWYTopBarView
//
//  Created by 吴伟毅 on 17/7/2.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ViewManager : NSObject
{
    @private
    UINavigationController *_navigationController;
}

@property (nonatomic, readonly) UINavigationController *NavigationController;

+ (ViewManager*)shareInstance;

@end
