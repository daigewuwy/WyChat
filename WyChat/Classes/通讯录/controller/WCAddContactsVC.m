//
//  WCAddContactsVC.m
//  WyChat
//
//  Created by 吴伟毅 on 19/6/2.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "WCAddContactsVC.h"

@interface WCAddContactsVC ()
@property (weak, nonatomic) IBOutlet UITextField *usrIDTextField;

@end

@implementation WCAddContactsVC


// 添加好友按钮点击
- (IBAction)senderBtnClicked:(id)sender {
    
    
    // 发送添加请求
    [[EMClient sharedClient].contactManager addContact:[NSString removeTrimmingBlank:_usrIDTextField.text] message:@"我是xjh" completion:^(NSString *aUsername, EMError *aError) {
        if(!aError) {
            NSLog(@"发送成功");
        }else
        {
            NSLog(@"发送失败");
        }
    }];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftBtnHide:NO];
    [self setTopTitle:@"添加好友"];// Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
