//
//  XBCrowdCodeVC.m
//  eLite
//
//  Created by lxx on 16/5/16.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBCrowdCodeVC.h"

@interface XBCrowdCodeVC ()

@end

@implementation XBCrowdCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title  =@"群二位码";
    self.CodeImageView.backgroundColor = [UIColor redColor];
    self.CodeImageView.image = [HCCreateQRCode createQRCodeWithString:[NSString stringWithFormat:@"group##%@",self.conv.conversationId] ViewController:self];
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
