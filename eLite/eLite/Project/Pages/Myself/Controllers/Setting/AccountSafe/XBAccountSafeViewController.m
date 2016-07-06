//
//  XBAccountSafeViewController.m
//  eLite
//
//  Created by 常小哲 on 16/4/14.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBAccountSafeViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "ChangePhoneReq.h"
@interface XBAccountSafeViewController () {
    
    IBOutlet UIView *view1;
    IBOutlet UIView *view2;
    IBOutlet NSLayoutConstraint *buttonConstraintTop;
    IBOutlet UIButton *GetCodeButton;
    IBOutlet UITextField *codeField;
    IBOutlet UITextField *numberTextField;
    IBOutlet UIButton *changeButton;
}

@end

@implementation XBAccountSafeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    NSRange range = NSMakeRange(3, 4);
    NSMutableString *string = [NSMutableString stringWithFormat:@"%@",[XBUserDefault sharedInstance].resModel.phone];
    [string replaceCharactersInRange:range withString:@"****"];
    numberTextField.text = string;
    view2.hidden = YES;
    buttonConstraintTop.constant = 0;
    [GetCodeButton addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
}
-(void)getCode
{
            GetCodeButton.enabled = NO;
            [self countdown:30];
            [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS
                                    phoneNumber:[NSString stringWithFormat:@"%@",[XBUserDefault sharedInstance].resModel.phone]
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
                                                ALERT_ONE(@"获取失败，请重新获取");
                                                 
                                             }
                                         }];

}
#pragma mark-   touch action
// 更换手机号
- (IBAction)changePhoneNum:(UIButton*)sender {
    view2.hidden = NO;
    buttonConstraintTop.constant = 50;
    sender.selected = !sender.selected;
    if (sender.selected&&codeField.text.length==0) {
        GetCodeButton.enabled = NO;
        numberTextField.text = @"";
        sender.enabled = NO;
        [self countdown:30];
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS
                                phoneNumber:[NSString stringWithFormat:@"%@",[XBUserDefault sharedInstance].resModel.phone]
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
                                             ALERT_ONE(@"获取验证码失败!30s请重新获取");
                                             
                                         }
                                     }];
        
    }
    else
    {
        if (codeField.text.length!=0&&[self checkMoblieNumber:numberTextField.text]) {
            [SMSSDK commitVerificationCode:codeField.text phoneNumber:[NSString stringWithFormat:@"%@",[XBUserDefault sharedInstance].resModel.phone] zone:@"86" result:^(NSError *error) {
                if (!error) {
                    [ChangePhoneReq do:^(id req) {
                        ChangePhoneReq *re =req;
                        re.userid =[NSString stringWithFormat:@"%@",[XBUserDefault sharedInstance].resModel.userid];
                        re.phone = numberTextField.text;
                    } Res:^(id res) {
                        ChangePhoneRes *resq = res;
                        if (resq.code) {
                            ALERT_ONE(@"更换号码成功");
                        }
                        else
                        {
                          ALERT_ONE(@"更换失败，请重新更换");
                        }
                    } ShowHud:YES];
                }
                else
                {
                  ALERT_ONE(@"验证失败，请重新获取验证");
                }
            }];
        }
        else
        {
            ALERT_ONE(@"请正确的填写验证码或者手机号");
        }
    }
    
}
- (void)countdown:(int)time {
    GetCodeButton.enabled = NO;
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
                GetCodeButton.enabled = YES;
                changeButton.enabled = YES;
                [GetCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                [GetCodeButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            });
        }
        else
        {
            int seconds = timeout / 1;
            NSString *strTime = [NSString stringWithFormat:@"%ds重新获取", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [GetCodeButton setTitle:strTime forState:UIControlStateDisabled];
                [GetCodeButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
                
            });
            
            timeout--;
        }
    });
    dispatch_resume(timer);
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



@end
