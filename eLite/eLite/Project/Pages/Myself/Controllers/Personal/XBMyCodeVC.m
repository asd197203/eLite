//
//  XBMyCodeVC.m
//  eLite
//
//  Created by lxx on 16/5/13.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBMyCodeVC.h"
#import "HCCreateQRCode.h"
@interface XBMyCodeVC ()

@end

@implementation XBMyCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的二维码";
    _CodeImageView.image = [HCCreateQRCode createQRCodeWithString:[NSString stringWithFormat:@"person##%@",[XBUserDefault sharedInstance].resModel.userid] ViewController:self];
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
