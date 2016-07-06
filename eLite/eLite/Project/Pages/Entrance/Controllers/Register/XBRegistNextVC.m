//
//  XBRegistNextVC.m
//  eLite
//
//  Created by lxx on 16/4/22.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBRegistNextVC.h"
#import "UIColor+category.h"
#import <SMS_SDK/SMSSDK.h>
#import "XBRegistReq.h"
#import "Request.h"
#import "Define.h"
#import "NSData+category.h"
#import "CDUserManager.h"
@interface XBRegistNextVC ()<UITextFieldDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *registCompleteButton;
@property (strong, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation XBRegistNextVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.backButton setTitleColor:[UIColor hexStringToColor:@"#09bb07"] forState:UIControlStateNormal];
    [self.registCompleteButton setBackgroundColor:[UIColor hexStringToColor:@"#09bb07"]];
    self.registCompleteButton.cornerRadius = 5.0;
    self.phoneNumberField.delegate = self;
}
- (IBAction)getCode:(id)sender {
    if (self.phoneNumberField.text.length!=0)
    {
        if ([self checkMoblieNumber:self.phoneNumberField.text])
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
                                    phoneNumber:self.phoneNumberField.text
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
                                                 ALERT_ONE(@"验证码获取失败，请重新获取");
                                                 
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
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.registUserDic setObject:textField.text forKey:@"phone"];
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
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)registCompleteButtonClick:(id)sender {
    if ([self checkMoblieNumber:self.phoneNumberField.text]) {
        //验证短信验证码接口
        if(self.codeField.text.length!=0)
        {
            [self showProgress];
            [SMSSDK commitVerificationCode:self.codeField.text phoneNumber:self.phoneNumberField.text zone:@"86" result:^(NSError *error) {
                if (!error) {
                    NSLog(@"验证成功");
                    [XBRegistReq do:^(id req) {
                        XBRegistReq *re  =req;
                        re.name = _registUserDic[@"name"];
                        re.pwd =_registUserDic[@"pwd"];
                        re.phone =_registUserDic[@"phone"];
                        re.birthday =_registUserDic[@"birthday"];
                        re.school =_registUserDic[@"school"];
                        re.cls =_registUserDic[@"class"];
                        re.hometown =@"aa";
                        re.hobby =@"ss";
                        re.sex = _registUserDic[@"sex"];
                        re.photo = _registUserDic[@"photo"];
                        re.photo.fileType =@"jpg";
                    } Res:^(id res) {
                        XBRegistRes *resq =res;
                        if (resq.code==0) {
                            [[CDUserManager manager] registerWithUsername:[NSString stringWithFormat:@"%@",resq.data[@"userid"]] phone:nil password:@"123456" block:^(BOOL succeeded, NSError *error) {
                                if (succeeded) {
                                    [self hideProgress];
                                    NSString *str =[NSString stringWithFormat:@"注册成功,您的账号是%@",resq.data[@"userid"]];
                                    ALERT_ONE(str);
                                    alert.delegate = self;
                                }
                                else
                                {
                                [self hideProgress];
                                  ALERT_ONE(@"注册失败,请重新注册");
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
                    ALERT_ONE(@"验证失败，请重新获取");;
                }
            }];
        }
        else
        {
            ALERT_ONE(@"请输入验证码");
        }
    }
    else
    {
        ALERT_ONE(@"请输入正确的手机号码");
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
-(void)showProgress {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)hideProgress {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


@end
