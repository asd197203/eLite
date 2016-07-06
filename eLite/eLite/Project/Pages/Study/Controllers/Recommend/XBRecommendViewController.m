//
//  XBRecommendViewController.m
//  eLite
//
//  Created by 常小哲 on 16/4/13.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBRecommendViewController.h"
#import "XBRecommendAudioCell.h"
#import "XBRecommendVideoCell.h"
#import "XBRecommendWordCell.h"
#import "XBPlayVideoController.h"
#import "XBRecommendCheckPicController.h"

static NSString *const ReuseIDAudioCell = @"AudioCell";
static NSString *const ReuseIDVideoCell = @"VideoCell";
static NSString *const ReuseIDCommonCell = @"CommonCell";

@interface XBRecommendViewController ()<
UITableViewDelegate,
UITableViewDataSource,
XBRecommendVideoCellDelegate> {
    
    __weak IBOutlet UITableView *_tableView;
    NSArray *_dataSource;
    NSInteger _listPage;
    NSInteger _pageSize;
    NSInteger _searchListPage;
    NSString *_lastSearchText;
    UITableViewCell *_prototypeWordCell;
    UITableViewCell *_prototypeAudioCell;
    UITableViewCell *_prototypeVideoCell;
}

@end

@implementation XBRecommendViewController

- (void)dealloc {
    NSLog(@"%@ 被销毁了", NSStringFromClass([self class]));
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self registerCell];
    
    [XBRecommendListReq do:^(id req) {
        XBRecommendListReq *tmpReq = req;
        tmpReq.userid = [XBUserDefault sharedInstance].resModel.userid;
        tmpReq.page = 0;
    } Res:^(id res) {
        XBRecommendListRes *tmpRes = res;
        if (tmpRes.data.count > 0) {
            NSMutableArray *tmpArr = @[].mutableCopy;
            for (NSDictionary *dict in tmpRes.data) {
                XBRecommendListModel *model = [[XBRecommendListModel alloc] initWithDictionary:dict error:nil];
                [tmpArr addObject:model];
            }
            _dataSource = tmpArr.copy;
        }
        Run_Main(^{
            [_tableView reloadData];
        });
        
    } ShowHud:NO];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

}

- (void)registerCell {

    NSArray *nibNames = @[
                          @"XBRecommendWordCell",
                          @"XBRecommendAudioCell",
                          @"XBRecommendVideoCell"];
    NSArray *reuseIDs = @[@"CommonCell", @"AudioCell", @"VideoCell"];
    for (int i = 0; i < nibNames.count; i ++) {
        UINib *cellNib = [UINib nibWithNibName:nibNames[i] bundle:nil];
        [_tableView registerNib:cellNib forCellReuseIdentifier:reuseIDs[i]];
    }
    _prototypeWordCell = [_tableView dequeueReusableCellWithIdentifier:ReuseIDCommonCell];
    _prototypeAudioCell = [_tableView dequeueReusableCellWithIdentifier:ReuseIDAudioCell];
    _prototypeVideoCell = [_tableView dequeueReusableCellWithIdentifier:ReuseIDVideoCell];
}

#pragma mark- Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XBRecommendListModel *model = _dataSource[indexPath.row];
    switch (model.type) {
        case 1:  // 只有文字
        case 2: { // 图文
            XBRecommendWordCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIDCommonCell];
            [cell setCellModel:model];
            // 点击图片查看大图
            __weak typeof(self) weakSelf = self;
            [cell clickImageViewOnCell:^(NSString *url){
                XBRecommendCheckPicController *vc = [[XBRecommendCheckPicController alloc] init];
                vc.imageURL = url;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }];
            return cell;
        }
            
        case 3: { // 语音
            XBRecommendAudioCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIDAudioCell];
            [cell setCellModel:model];
            return cell;
        }
            
        case 4: {  // 视频
            XBRecommendVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIDVideoCell];
            [cell setCellModel:model];
            cell.delegate = self;
            return cell;
        }
            
        default:
            break;
    }
    
    return nil;
}

#pragma mark-  cell delegate

- (void)clickPlayVideoCallBack:(NSString *)url {
    XBPlayVideoController *vc = [[XBPlayVideoController alloc] init];
    [vc addRemoteURL:url];
    [self.navigationController pushViewController:vc animated:YES];

}

static CGFloat const HeightImageView = 175 + 10;
static CGFloat const HeightDateLabel = 21 + 5;
static CGFloat const CommonMargin = 10;


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellHeight;
    XBRecommendListModel *model = _dataSource[indexPath.row];
    switch (model.type) {
        case 1: { // 只有文字
            XBRecommendWordCell *cell = (XBRecommendWordCell *)_prototypeWordCell;
            cell.titleLbl.text = model.title;
            CGSize labelSize = [cell.titleLbl sizeThatFits:CGSizeMake(cell.titleLbl.frame.size.width, FLT_MAX)];
            cellHeight = (labelSize.height+CommonMargin+CommonMargin) + HeightDateLabel + CommonMargin;
            break;
        }
            
        case 2: { // 图文
            XBRecommendWordCell *cell = (XBRecommendWordCell *)_prototypeWordCell;
            if (model.title.length > 0) {
                cell.titleLbl.text = model.title;
                CGSize labelSize = [cell.titleLbl sizeThatFits:CGSizeMake(cell.titleLbl.frame.size.width, FLT_MAX)];
                cellHeight = (labelSize.height+CommonMargin) + CommonMargin + HeightImageView + HeightDateLabel + CommonMargin;
            }else
                cellHeight = CommonMargin + HeightImageView + HeightDateLabel + CommonMargin;
            
            break;
        }
            
        case 3: { // 语音
            cellHeight = 104;
            break;
        }
            
        case 4: {  // 视频
            XBRecommendVideoCell *cell = (XBRecommendVideoCell *)_prototypeVideoCell;
            if (model.title.length > 0) {
                cell.titleLbl.text = model.title;
                CGSize labelSize = [cell.titleLbl sizeThatFits:CGSizeMake(cell.titleLbl.frame.size.width, FLT_MAX)];
                cellHeight = (labelSize.height+CommonMargin+CommonMargin) + HeightImageView + HeightDateLabel + CommonMargin;
            }else
                cellHeight = CommonMargin + HeightImageView + HeightDateLabel + CommonMargin;

            break;
        }
            
        default:
            break;
    }
    return MAX(cellHeight, 72);
}

@end
