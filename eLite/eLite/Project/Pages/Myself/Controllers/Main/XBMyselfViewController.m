//
//  XBMyselfViewController.m
//  eLite
//
//  Created by 常小哲 on 16/4/13.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBMyselfViewController.h"
#import "XBMyselfPageModel.h"
#import "XBPersonalTableViewCell.h"
#import "XBCellRightView.h"

@interface XBMyselfViewController ()<UITableViewDataSource, UITableViewDelegate> {
    
    __weak IBOutlet UITableView *_tableView;
    XBMyselfPageModel *_pageModel;
}

@end

@implementation XBMyselfViewController

- (void)dealloc {
    NSLog(@"%@ 被销毁了", NSStringFromClass([self class]));
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _pageModel = [[XBMyselfPageModel alloc] init];
    [_tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // 这里将model置空 释放其中的controller 不置空会导致界面不释放
    _pageModel = nil;
}

#pragma mark- Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!section)  return 1;
    return _pageModel.images.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (!indexPath.section) {
        XBPersonalTableViewCell *customCell = LoadXibWithClass(XBPersonalTableViewCell);
        cell = customCell;
    }else {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.imageView.image = _pageModel.images[indexPath.row];
        cell.textLabel.text = _pageModel.titles[indexPath.section][indexPath.row];
    }
    cell.accessoryView = [XBCellRightView defaultView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark-  table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *controller;
    if (!indexPath.section)  controller = _pageModel.controllers[indexPath.section];
    
    else controller = _pageModel.controllers[indexPath.section][indexPath.row];
 
    [self.navigationController pushViewController:controller animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) return 80;
    return 44;
}

@end
