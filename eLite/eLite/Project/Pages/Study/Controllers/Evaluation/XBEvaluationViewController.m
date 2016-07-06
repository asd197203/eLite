//
//  XBEvaluationViewController.m
//  eLite
//
//  Created by 常小哲 on 16/4/13.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBEvaluationViewController.h"
#import "XBEvaluationTableViewCell.h"
#import "XBCellRightView.h"
#import "XBTeacherDetailInfoViewController.h"
#import "XBLoadMoreFooter.h"

@interface XBEvaluationViewController ()<
UITableViewDataSource,
UITableViewDelegate,
UISearchBarDelegate> {
    
    __weak IBOutlet UITableView *_tableView;
    NSArray *_dataSource;
    NSMutableArray *_searchResults;
    NSInteger _listPage;
    NSInteger _pageSize;
    NSInteger _searchListPage;
    NSString *_lastSearchText;
}

@end

@implementation XBEvaluationViewController

- (void)dealloc {
    NSLog(@"%@ 被销毁了", NSStringFromClass([self class]));
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _pageSize = 10;
    _dataSource = [NSArray array];
    _searchResults = [NSMutableArray array];
    [self loadData:_listPage key:@"" done:^(NSArray *arr) {
        _dataSource = [_dataSource arrayByAddingObjectsFromArray:arr];
        _listPage++;
        Run_Main(^{
            [_tableView reloadData];
        });
    }];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.searchDisplayController.active = NO;
}

- (void)loadData:(NSInteger)page key:(NSString *)key done:(void(^)(NSArray *arr))done {
    [XBEvaluationReq do:^(id req) {
        XBEvaluationReq *tmpReq = req;
        tmpReq.userid = [XBUserDefault sharedInstance].resModel.userid;
        tmpReq.page = 0;
        tmpReq.key = @"";
    } Res:^(id res) {
        XBEvaluationRes *tmpRes = res;
        NSMutableArray *tmpArr = [NSMutableArray new];
        for (NSDictionary *dict in tmpRes.data) {
            XBTeacherInfoModel *model = [[XBTeacherInfoModel alloc] initWithDictionary:dict error:nil];
            [tmpArr addObject:model];
        }
        SafeRun_Block(done, tmpArr);
        
    } ShowHud:NO];
}

#pragma mark- Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _tableView) {
        return _dataSource.count;
    }else {
        return _searchResults.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellReuseID = @"cell";
    XBEvaluationTableViewCell *tmpCell = [tableView dequeueReusableCellWithIdentifier:cellReuseID];
    if (!tmpCell) {
        tmpCell = LoadXibWithClass(XBEvaluationTableViewCell);
    }
    tmpCell.selectionStyle = UITableViewCellSelectionStyleNone;
    tmpCell.accessoryView = [XBCellRightView defaultView];

    if (tableView == _tableView) {
        if (_dataSource.count)
            tmpCell.cellModel = _dataSource[indexPath.row];
    }else {
        if (_searchResults.count)
            tmpCell.cellModel = _searchResults[indexPath.row];
    }
    
    return tmpCell;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row > _dataSource.count-2) {
        if (_dataSource.count > _pageSize) {
            if (tableView == _tableView) {
                [self loadData:_listPage key:@"" done:^(NSArray *arr) {
                    _dataSource = [_dataSource arrayByAddingObjectsFromArray:arr];
                    _listPage++;
                    Run_Main(^{
                        [_tableView reloadData];
                    });
                }];
            }else {
                __weak typeof(self) weakSelf = self;
                [self loadData:_searchListPage key:_lastSearchText done:^(NSArray *arr) {
                    _searchResults = arr.mutableCopy;
                    _searchListPage++;
                    Run_Main(^{
                        [weakSelf.searchDisplayController.searchResultsTableView reloadData];
                    });
                }];
            }

        }
    }
}

#pragma mark-  table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XBTeacherInfoModel *model;
    if (tableView == _tableView) {
        if (_dataSource.count)
            model = _dataSource[indexPath.row];
        
    }else {
        if (_searchResults.count)
            model = _searchResults[indexPath.row];
        
    }
    if (model._id.length) {
        XBTeacherDetailInfoViewController *vc = [[XBTeacherDetailInfoViewController alloc] initWithTeacherID:model._id];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

#pragma mark-   search delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [_searchResults removeAllObjects];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [_searchResults removeAllObjects];
    _lastSearchText = searchBar.text;
    __weak typeof(self) weakSelf = self;
    [self loadData:_searchListPage key:searchBar.text done:^(NSArray *arr) {
        _searchResults = arr.mutableCopy;
        _searchListPage++;
        Run_Main(^{
            [weakSelf.searchDisplayController.searchResultsTableView reloadData];
        });
    }];
}

@end
