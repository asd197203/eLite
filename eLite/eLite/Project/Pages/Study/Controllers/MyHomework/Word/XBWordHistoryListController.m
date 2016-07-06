//
//  XBWordHistoryListController.m
//  eLite
//
//  Created by 常小哲 on 16/5/11.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBWordHistoryListController.h"
#import "XBHomeworkHistoryCell.h"
#import "MJRefresh.h"
#import "XBHsitoryDetailController.h"

@interface XBWordHistoryListController ()<UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *_dataSource;
    NSInteger _page;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation XBWordHistoryListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"历史记录";
    _dataSource = [NSMutableArray new];
    self.automaticallyAdjustsScrollViewInsets = NO;
   self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _page = 0;
    [self request:0];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [self request:_page];

    }];
}
-(void)request:(NSInteger)page
{
    [XBHomeworkHistoryReq do:^(id req) {
        XBHomeworkHistoryReq *tmpReq = req;
        tmpReq.userid = USER_ID;
        tmpReq.type = HistorySubjectType_Word;
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
            NSLog(@"_dataSour====%@",_dataSource);
            [_tableView reloadData];
        }
    } ShowHud:YES];
}
-(void)endRefresh{
    [self.tableView.mj_footer endRefreshing];
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
        cell.typeStr = @"文字题";
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XBHsitoryDetailController *vc = [[XBHsitoryDetailController alloc] init];
    if (_dataSource.count) {
        vc.subjects = [_dataSource[indexPath.row] subjects];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

@end
