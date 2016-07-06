//
//  XBFriendListToVistingCardVC.m
//  eLite
//
//  Created by lxx on 16/5/11.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBFriendListToVistingCardVC.h"

@interface XBFriendListToVistingCardVC ()

@end

@implementation XBFriendListToVistingCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"好友列表";
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTintColor:[UIColor whiteColor]];
    button.frame = CGRectMake(0, 0, 40, 30);
    [button addTarget:self action:@selector(cancleSendVisting:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}
- (void)cancleSendVisting:(UIButton*)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section ==0) {
        self.searchController.active =NO;
        [XBShowViewOnce showHUDText:@"请选择好友" inVeiw:self.view];
        return;
    }
    if(!self.searchController.active)
        {
            GetFriendModel *model =[[self.letterResultArr objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row];
            self.searchController.active =NO;
            [self.delegate selectFriend:model];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            GetFriendModel *model =[self.searchArray objectAtIndex:indexPath.row];
            self.searchController.active =NO;
            [self.delegate selectFriend:model];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    
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
