//
//  XBSettingViewController.m
//  eLite
//
//  Created by 常小哲 on 16/4/14.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBSettingViewController.h"
#import "XBSettingPageModel.h"
#import "XBLoginViewController.h"
#import "XBCellRightView.h"
#import <AVUser.h>
#import "XBUserDefault.h"
#import "AppDelegate.h"
#import "CDChatManager.h"
#import "XBNavigationViewController.h"
@interface XBSettingViewController ()<UITableViewDataSource, UITableViewDelegate> {
    __weak IBOutlet UITableView *_tableView;
    XBSettingPageModel *_pageModel;
}

@end

@implementation XBSettingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _pageModel = [[XBSettingPageModel alloc] init];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    _pageModel = nil;
}

#pragma mark- Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) return [_pageModel.controllers[section] count];
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 3) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-50, (cell.height-21)/2, 100, 20)];
        label.textColor = Color_Red;
        label.text = @"退出";
        label.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
        
    }else {
        cell.accessoryView = [XBCellRightView defaultView];
        if (indexPath.section == 1) {
            cell.textLabel.text = _pageModel.titles[indexPath.section][indexPath.row];
        }else {
            cell.textLabel.text = _pageModel.titles[indexPath.section];
        }
    }
    
    return cell;
}

#pragma mark-  table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        [CXZUserDefaults setup].isLogin = NO;
        [XBUserDefault saveUserInfoModel:nil];
        [[CDChatManager manager] closeWithCallback:^(BOOL succeeded, NSError *error) {
            [AVUser logOut];
                AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];;
            XBNavigationViewController *nav = [[XBNavigationViewController alloc] initWithRootViewController:[[XBLoginViewController  alloc] init]];
            app.window.rootViewController = nav;

        }];
    }else {
        UIViewController *controller;
        if (indexPath.section == 1) {
            controller = _pageModel.controllers[indexPath.section][indexPath.row];
        }else {
            controller = _pageModel.controllers[indexPath.section];
        }
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
