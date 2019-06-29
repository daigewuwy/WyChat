//
//  WCLoginVC.m
//  WyChat
//
//  Created by 吴伟毅 on 19/5/30.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "WCLoginVC.h"
#import "WCLoginWindow.h"

@interface WCLoginVC ()<UITextFieldDelegate>

/** 顶部图标. */
@property (weak, nonatomic) IBOutlet UIImageView *placeHolderImgV;
/** 顶部项目名. */
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
/** 登录按钮. */
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
/** 注册按钮. */
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
/** 用户名文本框. */
@property (weak, nonatomic) IBOutlet UITextField *usrNameTextField;
/** 用户密码文本框. */
@property (weak, nonatomic) IBOutlet UITextField *usrPwdTextField;

@end

@implementation WCLoginVC

#pragma mark - liftCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化UI
    [self setupUI];
    
    // 用于当清空内容的时候触发值改变
    [_usrNameTextField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    [_usrPwdTextField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    
    [_usrNameTextField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventAllEvents];
    [_usrPwdTextField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventAllEvents];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    
    if ([change objectForKey:NSKeyValueChangeNewKey]) {
        [self changedTextField:(UITextField *)object];
    }
}

-(void)dealloc {
    [_usrNameTextField removeObserver:self forKeyPath:@"text"];
    [_usrPwdTextField removeObserver:self forKeyPath:@"text"];
}

#pragma mark - 给每个textfield添加事件，只要值改变就调用此函数

-(void)changedTextField:(UITextField *)textField
{
    if([_usrNameTextField.text isEqualToString:@""] || [_usrPwdTextField.text isEqualToString:@""]) {
        _loginBtn.backgroundColor = ColorRGBA(96, 170, 252, 0.6);
        _loginBtn.userInteractionEnabled = NO;
    }else {
        _loginBtn.backgroundColor = MainColor;
        _loginBtn.userInteractionEnabled = YES;
    }
    _registerBtn.userInteractionEnabled = _loginBtn.userInteractionEnabled;
    _registerBtn.backgroundColor = _loginBtn.backgroundColor;
}

- (void)resetTextField {
    [_usrNameTextField becomeFirstResponder];
    [_usrPwdTextField resignFirstResponder];
    _usrNameTextField.text = @"";
    _usrPwdTextField.text = @"";
}


#pragma mark - UIOperation
- (void)setupUI {
    
    // 设置圆形图片
    [self.placeHolderImgV setImageByBezierPathWithImage:[UIImage imageNamed:@"placeHolderIcon"] radius:self.placeHolderImgV.frame.size.width/2];
    
    // 设置主调色
    _nameLab.textColor = MainColor;
    
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _loginBtn.backgroundColor = ColorRGBA(96, 170, 252, 0.6);
    _loginBtn.layer.masksToBounds = YES;
    _loginBtn.layer.cornerRadius = 10;
    
    _registerBtn.backgroundColor = _loginBtn.backgroundColor;
    _registerBtn.layer.masksToBounds = _loginBtn.layer.masksToBounds;
    _registerBtn.layer.cornerRadius = _loginBtn.layer.cornerRadius;
    
    _usrPwdTextField.secureTextEntry = YES;
}

#pragma mark - Action

// 登录按钮点击
- (IBAction)loginBtnClicked:(id)sender {
    
    NSString *usrName = [NSString removeAllBlank:_usrNameTextField.text];
    NSString *usrPwd = [NSString removeAllBlank:_usrPwdTextField.text];
    
    if(0 == usrName.length || 0 == usrPwd.length) {
        NSLog(@"用户名或密码为空，登录失败");
        return ;
    }
    
    // 显示首页homepage
    UITabBarController *tabbarVC = (UITabBarController *)[ViewManager shareInstance].NavigationController.viewControllers[0];
    tabbarVC.selectedIndex = 0;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // 调用API进行登录
    [[EMClient sharedClient] loginWithUsername:usrName password:usrPwd completion:^(NSString *aUsername, EMError *aError) {
        
        if (!aError) {
            
            [hud hide:YES];
            NSLog(@"登录成功");
            
            // 清空输入框
            [self resetTextField];
            
            // 发送登录状态改变给LoginWindow
            self.loginState(YES);
            
            // 登录成功后，设置自动登录
            [[EMClient sharedClient].options setIsAutoLogin:YES];
        }
    }];
}

// 注册按钮点击
- (IBAction)registerBtnClicked:(id)sender {
    
    NSString *usrName = [NSString removeAllBlank:_usrNameTextField.text];
    NSString *usrPwd = [NSString removeAllBlank:_usrPwdTextField.text];
    
    
    if(0 == usrName.length || 0 == usrPwd.length) {
        NSLog(@"用户名或密码为空，注册失败");
        return ;
    }
    
   [[EMClient sharedClient] registerWithUsername:usrName password:usrPwd completion:^(NSString *aUsername, EMError *aError) {
        if (aError==nil) {
            NSLog(@"注册成功");
        }else {
            NSLog(@"注册失败,%@",aError);
        }
    }];
}


@end
