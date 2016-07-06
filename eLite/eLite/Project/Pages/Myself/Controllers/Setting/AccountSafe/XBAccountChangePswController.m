//
//  XBAccountChangePswController.m
//  eLite
//
//  Created by lxx on 16/6/2.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBAccountChangePswController.h"
#import "XBChangePswReq.h"
#import "MBProgressHUD.h"
@interface XBAccountChangePswController ()

@end

@implementation XBAccountChangePswController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.confirmButton.layer.cornerRadius = 4.0;
    [self.confirmButton setBackgroundColor:[UIColor hexStringToColor:@"#08ba04"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)confirmButtonClick:(UIButton *)sender {
    if (![self.oldPswTextField.text isEqualToString:[NSString stringWithFormat:@"%@",[XBUserDefault sharedInstance].resModel.psw]]) {
        ALERT_ONE(@"旧密码不正确");
        return;
    }
    if (self.nwTextField
        .text.length==0) {
        ALERT_ONE(@"请填写新密码");
        return;
    }
    if (![self.nwTextField.text isEqualToString:self.confirmPswTextField.text]) {
        ALERT_ONE(@"两次密码不一致");
        return;
    }
    [self showProgress];
    [XBChangePswReq do:^(id req) {
        XBChangePswReq *re = req;
        re.userid = [NSString stringWithFormat:@"%@",[XBUserDefault sharedInstance].resModel.userid];
        re.pwd =[XBUserDefault sharedInstance].resModel.psw;
        re.newpwd = self.confirmPswTextField.text;
    } Res:^(id res) {
        [self hideProgress];
        XBChangePswRes *resq = res;
        if (resq.code==0) {
            XBUser *user = [XBUserDefault sharedInstance].resModel;
            user.psw = _nwTextField.text;
            [XBUserDefault saveUserInfoModel:user];
            [XBShowViewOnce showHUDText:@"修改成功" inVeiw:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        else
        {
            [XBShowViewOnce showHUDText:resq.msg inVeiw:self.view];
        }
    } ShowHud:NO];
    
}
-(void)showProgress {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)hideProgress {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
