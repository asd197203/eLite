//
//  XBNewMessageViewController.m
//  eLite
//
//  Created by 常小哲 on 16/4/14.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBNewMessageViewController.h"
#import "XBCellRightView.h"

@interface XBNewMessageViewController ()<UITableViewDataSource, UITableViewDelegate> {
    __weak IBOutlet UITableView *_tableView;
    NSArray *_titles;
}

@end

@implementation XBNewMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark- Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 3) return [_titles[section] count];
    return 1;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (!section) return self.acceptMsgTip;
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section != 3) {
        cell.textLabel.text = _titles[indexPath.section];
        cell.detailTextLabel.font = Font_System(14.f);
        if (!indexPath.section) cell.detailTextLabel.text = @"已开启";
        else if (indexPath.section == 2) {
            XBCellRightView *cellRightView = [[XBCellRightView alloc] initWithFrame:CGRectMake(0, 0, 120, 24) withTitle:@"只在夜间开启"];
            cell.accessoryView = cellRightView;
        }
    }
    
    if (indexPath.section == 1 || indexPath.section == 3) {
       
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 56, 28)];
        switchView.accessibilityValue = [NSString stringWithFormat:@"%ld", indexPath.section];
        switchView.accessibilityHint = [NSString stringWithFormat:@"%ld", indexPath.row];
        [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switchView;

        if (indexPath.section == 1)
            switchView.on = [CXZUserDefaults setup].showMsgDetailByNotification;
        else {
            cell.textLabel.text = _titles[indexPath.section][indexPath.row];
            if (!indexPath.row) switchView.on = [CXZUserDefaults setup].openSound;
            else  switchView.on = [CXZUserDefaults setup].openShock;
        }
    }
    
    return cell;
}

#pragma mark-  table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *controller;
    if (indexPath.section == 1) {
        
    }else if (indexPath.section == 2) {
        
    }
    
    if (controller)
        [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark-   touch action

- (void)switchAction:(UISwitch *)sender {
    if (sender.accessibilityValue.integerValue == 1)
        [CXZUserDefaults setup].showMsgDetailByNotification = sender.on;
    else {
        if (!sender.accessibilityHint.integerValue)
            [CXZUserDefaults setup].openSound = sender.on;
        else [CXZUserDefaults setup].openShock = sender.on;
    }
}


#pragma mark-   Setter & Getter

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[
                    @"接收新消息通知",
                    @"通知显示消息详情",
                    @"功能消息免打扰",
                    @[
                      @"声音",
                      @"震动"
                      ]
                    ];
    }
    return _titles;
}

- (NSString *)acceptMsgTip {
    return @"如果你要关闭或开启消息通知，请在iPhone的“设置—通知”功能中，找到应用程序“elite”更改";
}

@end
