//
//  XBLoginViewController.m
//  eLite
//
//  Created by 常小哲 on 16/4/13.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBLoginViewController.h"
#import "XBTabBarController.h"
#import "UIColor+category.h"
#import "XBRegisterViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "XBLoginReq.h"
#import "AVUser.h"
#import "CDUserManager.h"
#import "AppDelegate.h"
#import "XBForgetPswVC.h"
#import "XBUser.h"
#import "XBUserDefault.h"
@interface XBLoginViewController ()

@end

@implementation XBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.segmentControl.tintColor = [UIColor hexStringToColor:@"#09bb07"];
    self.loginButton.backgroundColor = [UIColor hexStringToColor:@"#09bb07"];
    self.loginButton.cornerRadius = 5;
  [self.segmentControl addTarget:self action:@selector(didClicksegmentedControlAction:)forControlEvents:UIControlEventValueChanged];
    self.headImageView.image = Image_Named(@"登录logo");
}
-(void)didClicksegmentedControlAction:(UISegmentedControl*)segmented
{
    if (segmented.selectedSegmentIndex==1) {
        //密码登录,默认手机登陆
        self.phoneLabel.text = @"用户名";
        self.codeLabel.text = @"密码";
        self.numberTextField.placeholder = @"请输入用户名";
        self.codeTextField.placeholder = @"请输入密码";
        self.getCodeButton.hidden = YES;
         self.codeTextField.secureTextEntry = YES;
        self.codeTextFieldRightConstraint.constant = 30;
    }
    else
    {
        self.phoneLabel.text = @"手机号";
        self.codeLabel.text = @"验证码";
        self.numberTextField.placeholder = @"请输入电话";
        self.codeTextField.placeholder =@"请输入验证码";
        self.codeTextField.secureTextEntry = NO;
        self.getCodeButton.hidden = NO;
        self.codeTextFieldRightConstraint.constant = 69;
    }
}
#pragma mark-   touch action
- (IBAction)getCode:(id)sender {
    if (self.numberTextField.text.length!=0)
    {
        if ([self checkMoblieNumber:self.numberTextField.text])
        {
            self.getCodeButton.enabled = NO;
             [self countdown:30];
            //获取短信验证码接口
            /**
             *  @from                    v1.1.1
             *  @brief                   获取验证码(Get verification code)
             *
             *  @param method            获取验证码的方法(The method of getting verificationCode)
             *  @param phoneNumber       电话号码(The phone number)
             *  @param zone              区域号，不要加"+"号(Area code)
             *  @param customIdentifier  自定义短信模板标识 该标识需从官网http://www.mob.com上申请，审核通过后获得。(Custom model of SMS.  The identifier can get it  from http://www.mob.com  when the application had approved)
             *  @param result            请求结果回调(Results of the request)
             */
            [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS
                                    phoneNumber:self.numberTextField.text
                                           zone:@"86"
                               customIdentifier:nil
                                         result:^(NSError *error) {
                                             if(!error)
                                             {
                                                 //成功
                                               ALERT_ONE(@"验证码已发送，请注意查收");
                                             }
                                             else
                                             {
                                                 //失败
                                                 NSLog(@"获取验证码失败!");
                                                 
                                             }
                                         }];
        }
        else
        {
            ALERT_ONE(@"请输入正确的手机号");
        }
    }
    else
    {
       ALERT_ONE(@"请输入手机号");
    }
}
- (void)countdown:(int)time {
    self.getCodeButton.enabled = NO;
    __block int timeout = time; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(timer, ^{
        if(timeout <= 0)
        { //倒计时结束，关闭
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.getCodeButton.enabled = YES;
                [self.getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                [self.getCodeButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            });
        }
        else
        {
            int seconds = timeout / 1;
            NSString *strTime = [NSString stringWithFormat:@"%ds重新获取", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.getCodeButton setTitle:strTime forState:UIControlStateDisabled];
                [self.getCodeButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
                
            });
            
            timeout--;
        }
    });
    dispatch_resume(timer);
}

- (IBAction)pressLoginButtonAction:(UIButton *)sender {
    // 验证用户
//    [CXZUserDefaults setup].isLogin = YES;
//    [CXZUserDefaults setup].currentUserAccount = @"12738123798";
    [self showProgress];
    if (self.segmentControl.selectedSegmentIndex==0) {
        if ([self checkMoblieNumber:self.numberTextField.text]) {
            //验证短信验证码接口
            if(self.codeTextField.text.length!=0)
            {
                [SMSSDK commitVerificationCode:self.codeTextField.text phoneNumber:self.numberTextField.text zone:@"86" result:^(NSError *error) {
                    if (!error) {
                        //登陆
                        [XBLoginReq do:^(id req) {
                            XBLoginReq *re = req;
                                re.type =1;
                                re.phone = self.numberTextField.text;
                                re.pwd = nil;
                                re.userid = nil;
                        } Res:^(id res) {
                            XBLoginRes *resq = res;
                            if (resq.code==0) {
                               __block XBUser *xbuser = [[XBUser alloc]init];
                                xbuser.birthday =resq.data[@"birthday"];
                                xbuser.cls =resq.data[@"class"];
                                xbuser.hobby =resq.data[@"hobby"];
                                xbuser.hometown =resq.data[@"hometown"];
                                xbuser.name =resq.data[@"name"];
                                xbuser.phone =resq.data[@"phone"];
                                xbuser.photo =resq.data[@"photo"];
                                xbuser.school =resq.data[@"school"];
                                xbuser.sex =resq.data[@"sex"];
                                xbuser.sign =resq.data[@"sign"];
                                xbuser.userid =resq.data[@"userid"];
                                [[CDUserManager manager] loginWithInput:[NSString stringWithFormat:@"%@",xbuser.userid] password:@"123456" block:^(AVUser *user, NSError *error) {
                                    [self hideProgress];
                                    if (!error) {
                                        [XBUserDefault saveUserInfoModel:xbuser];
                                        [[NSUserDefaults standardUserDefaults] setObject:self.numberTextField.text forKey:KEY_USERNAME];
                                        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                                        [delegate mainController];
                                    }
                                }];
                            }
                            else
                            {
                                [self hideProgress];
                                ALERT_ONE(resq.msg);
                            }
                            
                        } ShowHud:NO];
                    }
                    else
                    {
                        [self hideProgress];
                        ALERT_ONE(@"验证失败，请重新获取验证码");
                    }
                }];
            }
            else
            {
                [self hideProgress];
                ALERT_ONE(@"请输入验证码");
            }
        }
        else
        {
            [self hideProgress];
            ALERT_ONE(@"请输入正确的手机号码");
        }
    }
    else
    {
        [XBLoginReq do:^(id req) {
            XBLoginReq *re = req;
            re.type =2;
            re.phone = nil;
            re.pwd = self.codeTextField.text;
            re.userid = self.numberTextField.text;
        } Res:^(id res) {
            XBLoginRes *resq = res;
            if (resq.code==0) {
                XBUser *xbuser = [[XBUser alloc]init];
                xbuser.birthday =resq.data[@"birthday"];
                xbuser.cls =resq.data[@"class"];
                xbuser.hobby =resq.data[@"hobby"];
                xbuser.hometown =resq.data[@"hometown"];
                xbuser.name =resq.data[@"name"];
                xbuser.phone =resq.data[@"phone"];
                xbuser.photo =resq.data[@"photo"];
                xbuser.school =resq.data[@"school"];
                xbuser.sex =resq.data[@"sex"];
                xbuser.sign =resq.data[@"sign"];
                xbuser.userid =resq.data[@"userid"];
                xbuser.psw =self.codeTextField.text;
                [[CDUserManager manager] loginWithInput:[NSString stringWithFormat:@"%@",xbuser.userid] password:@"123456" block:^(AVUser *user, NSError *error) {
                    [self hideProgress];
                    if (user!=nil) {
                        [CXZUserDefaults setup].isLogin = YES;
                        [XBUserDefault saveUserInfoModel:xbuser];
                        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        [delegate mainController];
                    }
                    else
                    {
                       ALERT_ONE(@"登录失败");
                    }
                }];
            }
            if (resq.code==2) {
                [self hideProgress];
                ALERT_ONE(@"用户名或密码错误");
            }
            
        } ShowHud:NO];
    }
    
    
    
}
- (void)toast:(NSString *)text {
    [self toast:text duration:2];
}

- (void)toast:(NSString *)text duration:(NSTimeInterval)duration {
    [AVAnalytics event:@"toast" attributes:@{@"text": text}];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    hud.labelText=text;
    hud.detailsLabelFont = [UIFont systemFontOfSize:14];
    hud.detailsLabelText = text;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeText;
    [hud hide:YES afterDelay:duration];
}

-(void)showHUDText:(NSString*)text{
    [self toast:text];
}
//验证手机
-(BOOL)checkMoblieNumber:(NSString *)number
{
    NSString * MOBILE = @"^1[3|4|5|7|8][0-9]\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    BOOL res1 = [regextestmobile evaluateWithObject:number];
    if (res1)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
-(void)showProgress {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)hideProgress {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
#pragma mark-   touch action

#pragma mark- 隐藏键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)pressRegisterButtonAction:(id)sender {
    
    [self.navigationController pushViewController:[[XBRegisterViewController alloc] init] animated:YES];
}
- (IBAction)forgetPswButtonClick:(id)sender {
    [self.navigationController pushViewController:[[XBForgetPswVC alloc] init] animated:YES];
}

@end
