//
//  XBTeacherDetailInfoViewController.m
//  eLite
//
//  Created by 常小哲 on 16/4/17.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBTeacherDetailInfoViewController.h"
#import "XBTeacherDetailInfoTableViewCell.h"
#import "XBTeacherDetailInfoTopCell.h"

@interface XBTeacherDetailInfoViewController ()<UITableViewDataSource, UITableViewDelegate> {
    
    __weak IBOutlet UITableView *_tableView;
    UIView *_topCellView;
    NSString *_tid;
    
    XBTeacherDetailInfoModel *_model;
    BOOL _isPressingButton;
}

@end

@implementation XBTeacherDetailInfoViewController

- (instancetype)initWithTeacherID:(NSString *)tid {
    if (self == [super init]) {
        _tid = tid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"教师详情";
    _isPressingButton = NO;
    
    [XBTeacherDetailInfoReq do:^(id req) {
        XBTeacherDetailInfoReq *tmpReq = req;
        tmpReq.userid = USER_ID;
        tmpReq.teacherid = _tid;
    } Res:^(id res) {
        XBTeacherDetailInfoRes *tmpRes = res;
        if (tmpRes.code==0) {
            _model = [[XBTeacherDetailInfoModel alloc] initWithDictionary:tmpRes.data error:nil];
             [self setupNavigationBarRightButton];
        }
        Run_Main(^{
            [_tableView reloadData];
        });
    } ShowHud:NO];
    
    [self settupTableView];
}

- (void)setupNavigationBarRightButton {
    UIButton *collect = [UIButton buttonWithType:UIButtonTypeCustom];
    collect.frame = CGRectMake(0,0,20,20);
    collect.adjustsImageWhenHighlighted = NO;  // 去除按下按钮的阴影效果
    [collect setImage:Image_Named(@"fav_nol")
                 forState:UIControlStateNormal];
    [collect setImage:Image_Named(@"fav_press")
                 forState:UIControlStateSelected];
    if ([_model.isfav integerValue]==1) {
        collect.selected = YES;
    }
    [collect addTarget:self
                    action:@selector(pressNavigationBarRightButtonAction:)
          forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *collectItem = [[UIBarButtonItem alloc]initWithCustomView:collect];
    UIButton *support = [UIButton buttonWithType:UIButtonTypeCustom];
    support.frame = CGRectMake(0,0,30,30);
    support.adjustsImageWhenHighlighted = NO;  // 去除按下按钮的阴影效果
    [support setImage:Image_Named(@"evaluation_support_unselected")
                 forState:UIControlStateNormal];
    [support addTarget:self action:@selector(dainzanButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *supportItem = [[UIBarButtonItem alloc]initWithCustomView:support];
    self.navigationItem.rightBarButtonItems =@[supportItem, collectItem];
}
- (void)dainzanButtonClick
{
    typeof(self) __weak weakSelf = self;
    [XBTeacherUpReq do:^(id req) {
        XBTeacherUpReq *tmpReq = req;
        tmpReq.userid = USER_ID;
        tmpReq.teacherid = _tid;
    } Res:^(id res) {
        XBTeacherUpRes*resq = res;
        if (resq.code==0) {
            [XBShowViewOnce showHUDText:@"点赞成功" inVeiw:weakSelf.view];
        }
        else
        {
            [XBShowViewOnce showHUDText:resq.msg inVeiw:weakSelf.view];
        }
    } ShowHud:NO];
    
}
- (void)settupTableView {
    // 去除顶端和底部多出来的东西
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, Screen_Width, 0.01f)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, Screen_Width, 0.01f)];
}

#pragma mark-   touch action

- (void)pressNavigationBarRightButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    typeof(self) __weak weakSelf = self;
    if (!_isPressingButton) {
        _isPressingButton = YES;
        if (sender.selected) {
            [XBTeacherFavourReq do:^(id req) {
                XBTeacherFavourReq *tmpReq = req;
                tmpReq.userid = USER_ID;
                tmpReq.teacherid = _tid;
                tmpReq.fav = YES;
            } Res:^(id res) {
                Run_Main(^{
                    XBTeacherFavourRes *tmpRes = res;
                    if (tmpRes.code == 0) {
                        [XBShowViewOnce showHUDText:@"收藏成功" inVeiw:weakSelf.view];
                        sender.selected = YES;
                    }else {
                        ALERT_ONE(tmpRes.msg);
                    }
                    _isPressingButton = NO;
                });
                
            } ShowHud:NO];
        }else {
            [XBTeacherFavourReq do:^(id req) {
                XBTeacherFavourReq *tmpReq = req;
                tmpReq.userid = USER_ID;
                tmpReq.teacherid = _tid;
                tmpReq.fav = NO;
            } Res:^(id res) {
                Run_Main(^{
                    
                    XBTeacherFavourRes *tmpRes = res;
                    if (tmpRes.code == 0) {
                        [XBShowViewOnce showHUDText:@"取消收藏成功" inVeiw:weakSelf.view];
                        sender.selected = NO;
                    }else {
                        ALERT_ONE(tmpRes.msg);
                    }
                    _isPressingButton = NO;
                });
                
            } ShowHud:NO];
        }
    }
}

#pragma mark- Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return !section ? @"简介" : nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (!indexPath.section) {
        XBTeacherDetailInfoTopCell *topCell = LoadXibWithClass(XBTeacherDetailInfoTopCell);
        topCell.cellModel = _model;
        cell = topCell;
    }else {
        XBTeacherDetailInfoTableViewCell *bottomCell = LoadXibWithClass(XBTeacherDetailInfoTableViewCell);
        bottomCell.cellModel = _model;
        cell = bottomCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark-  table view delegate 

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        return 130;
    }else return Screen_Height *2/3;
}

@end
