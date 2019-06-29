//
//  WCMyInfoVC.m
//  WyChat
//
//  Created by 吴伟毅 on 19/6/2.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "WCMyInfoVC.h"
#import "WCLoginWindow.h"

@interface WCMyInfoVC ()

@property (weak, nonatomic) IBOutlet UILabel *usrNameLab;
@end

@implementation WCMyInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTopTitle:@"我的信息"];

}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    NSString *usrName = [[EMClient sharedClient] currentUsername];
    [_usrNameLab setText:usrName];
}

// 退出
- (IBAction)exitBtnClicked:(id)sender {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[EMClient sharedClient] logout:YES completion:^(EMError *aError) {
        
        [hud hide:YES];
        
        if (!aError) {
            
            // 显示登录界面
            [[WCLoginWindow shareInstance] showWindow];
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
