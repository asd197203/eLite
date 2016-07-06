//
//  XBHomeworkViewController.m
//  eLite
//
//  Created by 常小哲 on 16/4/13.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBHomeworkViewController.h"
#import "XBHomeworkTableViewCell.h"
#import "XBHomeworkPageModel.h"

@interface XBHomeworkViewController ()<UITableViewDataSource, UITableViewDelegate> {
    
    __weak IBOutlet UITableView *_tableView;
    NSArray *_cellInfo;
    UIView *_tableViewHead;
    XBHomeworkPageModel *_pageModel;
    XBLevelInfoModel *_levelInfo;
}

@end

@implementation XBHomeworkViewController

- (void)dealloc {
    NSLog(@"%@ 被销毁了", NSStringFromClass([self class]));
}


- (void)viewDidLoad {
    [super viewDidLoad];
        
    __weak typeof(self) weakSelf = self;
    [XBHomeworkLevelReq do:^(id req) {
        XBHomeworkLevelReq *tmpReq = req;
        tmpReq.userid = USER_ID;
    } Res:^(id res) {
        XBHomeworkLevelRes *tmpRes = res;
        _levelInfo = [[XBLevelInfoModel alloc] initWithDictionary:tmpRes.data error:nil];
        Run_Main(^{
            _tableView.tableHeaderView = weakSelf.tableViewHead;
        });
    } ShowHud:NO];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _pageModel = [[XBHomeworkPageModel alloc] init];

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    _pageModel = nil;
}

#pragma mark- Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _pageModel.cellInfo.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XBHomeworkTableViewCell *cell = LoadXibWithClass(XBHomeworkTableViewCell);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellInfo = _pageModel.cellInfo[indexPath.row];
    return cell;
}

#pragma mark-  table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:_pageModel.controllers[indexPath.row]
                                         animated:YES];
}

#pragma mark-   Setter & Getter

- (UIView *)tableViewHead {
    if (!_tableViewHead) {
        _tableViewHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 50)];
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 24)];
        contentView.center = _tableViewHead.center;
        [_tableViewHead addSubview:contentView];;

        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                   5,
                                                                   contentView.width,
                                                                   contentView.height)];
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = Color_Green;
        title.font = Font_System(20);
        if (_levelInfo.level.length < 1) {
            title.text = [NSString stringWithFormat:@"第 1 关"];
        }else {
            title.text = [NSString stringWithFormat:@"第 %@ 关", _levelInfo.level];
        }
        [contentView addSubview:title];
    }
    return _tableViewHead;
}

//- (NSArray *)cellInfo {
//    if (!_cellInfo) {
//        _cellInfo = @[
//                      @[@"文字题型", @"homework_subject_word"],
//                      @[@"语音题型", @"homework_subject_voice"],
//                      @[@"视频题型", @"homework_subject_video"],
//                      ];
//    }
//    return _cellInfo;
//}

@end
