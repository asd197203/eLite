//
//  XBHelperDetailVC.m
//  eLite
//
//  Created by lxx on 16/6/3.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBHelperDetailVC.h"

@interface XBHelperDetailVC ()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation XBHelperDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = self.title;
    if (self.type==1) {
        
    }
    else
    {
        self.contentLabel.text = @"创建群聊是没有数量限制";
    }
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
