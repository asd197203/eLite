//
//  XBForgetPswVC.m
//  eLite
//
//  Created by lxx on 16/4/26.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBForgetPswVC.h"
#import <SMS_SDK/SMSSDK.h>
#import "MBProgressHUD.h"
#import "XBForgetNextVCViewController.h"
@interface XBForgetPswVC ()
@property(nonatomic,copy)NSString *phoneNumber;
@end

@implementation XBForgetPswVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"忘记密码";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    self.nextButton.layer.cornerRadius=5.0;
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
- (void)countdown:(int)time {
    self.codeButton.enabled = NO;
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
                self.codeButton.enabled = YES;
                [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                [self.codeButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            });
        }
        else
        {
            int seconds = timeout / 1;
            NSString *strTime = [NSString stringWithFormat:@"%ds重新获取", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.codeButton setTitle:strTime forState:UIControlStateDisabled];
                [self.codeButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
                
            });
            
            timeout--;
        }
    });
    dispatch_resume(timer);
}
- (IBAction)getCodeButtonClick:(UIButton*)sender {
    if (self.phoneTextField.text.length!=0)
    {
        if ([self checkMoblieNumber:self.phoneTextField.text])
        {
            self.codeButton.enabled = NO;
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
                                    phoneNumber:self.phoneTextField.text
                                           zone:@"86"
                               customIdentifier:nil
                                         result:^(NSError *error) {
                                             if(!error)
                                             {
                                                 //成功
                                                  [self.nextButton setBackgroundColor:[UIColor hexStringToColor:@"#08ba04"]];
                                                 self.phoneNumber = _phoneTextField.text;
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
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (IBAction)nextButtonClick:(UIButton *)sender {
    if (self.codeField.text.length==0) {
         ALERT_ONE(@"请输入验证码！");
        return;
    }
    [self showProgress];
    if ([self checkMoblieNumber:self.phoneTextField.text]) {
        //验证短信验证码接口
        if(self.codeField.text.length!=0)
        {
            [SMSSDK commitVerificationCode:self.codeField.text phoneNumber:self.phoneTextField.text zone:@"86" result:^(NSError *error) {
                if (!error) {
                    XBForgetNextVCViewController *vc = [[XBForgetNextVCViewController alloc]init];
                    vc.phone = self.phoneNumber;
                    [self.navigationController pushViewController:vc animated:YES];
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
-(void)showProgress {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)hideProgress {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
