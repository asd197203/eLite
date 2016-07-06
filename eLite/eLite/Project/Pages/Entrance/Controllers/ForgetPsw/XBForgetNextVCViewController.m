//
//  XBForgetNextVCViewController.m
//  eLite
//
//  Created by lxx on 16/6/3.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBForgetNextVCViewController.h"
#import "XBResetPswReq.h"
#import "MBProgressHUD.h"
@interface XBForgetNextVCViewController ()
@property (strong, nonatomic) IBOutlet UITextField *pswTextField;
@property (strong, nonatomic) IBOutlet UITextField *confirmTextField;
@property (strong, nonatomic) IBOutlet UIButton *commitButton;

@end

@implementation XBForgetNextVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.commitButton setBackgroundColor:[UIColor hexStringToColor:@"#08ba04"]];
    self.commitButton.layer.cornerRadius=5.0;
}
- (IBAction)commitButton:(id)sender {
    if(self.pswTextField.text.length==0)
    {
        ALERT_ONE(@"请输入新密码");
        return;
    }
    if(self.confirmTextField.text.length==0)
    {
        ALERT_ONE(@"请输入确认密码");
        return;
    }
    if(![self.confirmTextField.text isEqualToString:self.pswTextField.text])
    {
        ALERT_ONE(@"两次密码不一致");
        return;
    }
    [self showProgress];
    [XBResetPswReq do:^(id req) {
        XBResetPswReq *re = req;
        re.phone = self.phone;
        re.pwd = _confirmTextField.text;
    } Res:^(id res) {
        [self hideProgress];
        XBResetPswRes *resq = res;
        if (resq.code==0) {
            [XBShowViewOnce showHUDText:@"修改密码成功" inVeiw:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
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
