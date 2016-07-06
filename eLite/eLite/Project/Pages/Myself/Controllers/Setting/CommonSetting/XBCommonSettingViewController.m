//
//  XBCommonSettingViewController.m
//  eLite
//
//  Created by 常小哲 on 16/4/14.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBCommonSettingViewController.h"
#import "XBCellRightView.h"
#import "MBProgressHUD.h"
#import "XBShowViewOnce.h"
#import "CXZSelectAvatarController.h"
@interface XBCommonSettingViewController ()<
UITableViewDataSource,
UITableViewDelegate,
UIActionSheetDelegate> {
    
    __weak IBOutlet UITableView *_tableView;
    NSArray *_titles;
}

@end

@implementation XBCommonSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark- Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == self.titles.count-1) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
        label.center = cell.center;
        label.textColor = Color_Black;
        label.text = _titles[indexPath.section];
        label.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
        
    }else {
        cell.textLabel.text = _titles[indexPath.section];
        cell.accessoryView = [XBCellRightView defaultView];;
    }
    
    return cell;
}

#pragma mark-  table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CXZSelectAvatarController *vc = [[CXZSelectAvatarController alloc] initWithController:self];
        [vc showForPicture:^(UIImage *selectedImage) {
            XBUser *user = [XBUserDefault sharedInstance].resModel;
            user.messageBgImage = selectedImage;
            [XBUserDefault saveUserInfoModel:user];
        }];
        
    }else if (indexPath.section == self.titles.count-2) {
        NSLog(@"start-------------> 清除缓存");
        UIActionSheet *actionSheet =
        [[UIActionSheet alloc] initWithTitle:@"您确认要清除缓存吗?"
                                    delegate:self
                           cancelButtonTitle:NSLocalizedString(@"取消", nil)
                      destructiveButtonTitle:NSLocalizedString(@"确定", nil)
                           otherButtonTitles:nil];
        actionSheet.tag = 110;
        [actionSheet showInView:self.view];
    }else if (indexPath.section == self.titles.count-1) {
#warning clean chat record  清空聊天记录
        //TODO:
        [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteMessage" object:nil];
        [XBShowViewOnce showHUDText:@"聊天记录已清空" inVeiw:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1) {
        return;
    }
    if (buttonIndex != [actionSheet cancelButtonIndex]) {
        switch (buttonIndex) {
            case 0:
            {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.labelText = @"正在清除缓存...";

                Run_Async(^{
                    [[SDImageCache sharedImageCache] clearMemory];
                    [[SDImageCache sharedImageCache] cleanDisk];
                    [[SDImageCache sharedImageCache] clearDisk];

                }, ^{
                    [hud hide:YES];
                    [XBShowViewOnce showHUDText:@"清除完成" inVeiw:self.view];
                });
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark-   Setter & Getter

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[
                    @"聊天背景",
                    @"清除缓存",
                    @"清空聊天记录"
                    ];
    }
    return _titles;
}


@end
