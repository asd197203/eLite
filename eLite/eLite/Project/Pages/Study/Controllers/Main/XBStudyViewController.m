//
//  XBStudyViewController.m
//  eLite
//
//  Created by 常小哲 on 16/4/13.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBStudyViewController.h"
#import "XBStudyPageModel.h"
#import "XBCellRightView.h"

@interface XBStudyViewController ()<UITableViewDelegate, UITableViewDataSource> {
    __weak IBOutlet UITableView *_tableView;
    XBStudyPageModel *_pageModel;
}

@end

@implementation XBStudyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _pageModel = [[XBStudyPageModel alloc] init];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    _pageModel = nil;
}

#pragma mark- Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _pageModel.titles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.imageView.image = _pageModel.images[indexPath.section];
    cell.textLabel.text = _pageModel.titles[indexPath.section];
    cell.accessoryView = [XBCellRightView defaultView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

#pragma mark-  table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:_pageModel.controllers[indexPath.section] animated:YES];
}

@end
