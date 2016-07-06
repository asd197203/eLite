//
//  XBVideoHistoryListController.m
//  eLite
//
//  Created by 常小哲 on 16/5/26.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBVideoHistoryListController.h"
#import "MJRefresh.h"
#import "XBVideoHistoryViewController.h"
#import "XBHomeworkHistoryCell.h"

@interface XBVideoHistoryListController ()<UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *_dataSource;
    NSInteger _page;

    __weak IBOutlet UITableView *_tableView;
}

@end

@implementation XBVideoHistoryListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"视频题";
    _dataSource = [NSMutableArray new];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _page = 0;
    [self request:0];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [self request:_page];
    }];
    
}
- (void)request:(NSInteger)page
{
    [XBHomeworkHistoryReq do:^(id req) {
        XBHomeworkHistoryReq *tmpReq = req;
        tmpReq.userid = USER_ID;
        tmpReq.type = HistorySubjectType_Video;
        tmpReq.page = page;
    } Res:^(id res) {
        XBHomeworkHistoryRes *tmpRes = res;
        [self endRefresh];
        if (tmpRes.code == 0) {
            if(_dataSource.count != 0) {
                for (XBHomeworkHistoryInfoModel *model in tmpRes.data) {
                    [_dataSource addObject:model];
                }
            }
            else {
                _dataSource = [tmpRes.data mutableCopy];
            }
            [_tableView reloadData];
        }
    } ShowHud:YES];
}

- (void)endRefresh {
    [_tableView.mj_footer endRefreshing];
}

#pragma mark- Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * reuseIdentifier = @"cell";
    XBHomeworkHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (!cell) {
        cell = LoadXibWithClass(XBHomeworkHistoryCell);
    }
    
    if (_dataSource.count) {
        cell.cellModel = _dataSource[indexPath.row];
        cell.typeStr = @"视频题";
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XBVideoHistoryViewController *vc = [[XBVideoHistoryViewController alloc] init];
    if (_dataSource.count) {
        NSArray *tmpArr = [_dataSource[indexPath.row] subjects];
        if (tmpArr.count > 0) {
            vc.infoModel = tmpArr[0];
        }
    }
    [self.navigationController pushViewController:vc animated:YES];
}

@end
