//
//  XBWordSubjectController.m
//  eLite
//
//  Created by 常小哲 on 16/5/16.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBWordSubjectController.h"
#import "XBWordSubjectContentController.h"
#import "XBWordHistoryListController.h"

@interface XBWordSubjectController ()<
XBPageControllerDelegate,
XBPageControllerDataSource> {
    
    NSArray *_titles;
    NSArray *_controllers;

}

@end

@implementation XBWordSubjectController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Color_White;
    self.scrollEnabled = NO;
    [self __init];
    [self rightBtn];
}

- (void)__init {
    
    _wrongSubjectDict = @{}.mutableCopy;
    _myWorkResults = @[].mutableCopy;
    
    self.datasouce = self;
    self.delegate = self;
    
    __weak typeof(self) weakSelf = self;
    [XBHomeworkWordReq do:^(id req) {
        XBHomeworkWordReq *tmpReq = req;
        tmpReq.userid = USER_ID;
    } Res:^(id res) {
        XBHomeworkWordRes *tmpRes = res;
        if (tmpRes.data.count > 0) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            _allData = tmpRes.data.copy;
            _allSubjectCount = tmpRes.data.count;
            NSMutableArray *vcArr = [NSMutableArray new];
            NSMutableArray *titleArr = [NSMutableArray new];
            for (int i = 0; i < tmpRes.data.count; i ++) {
                XBWordSubjectContentController *vc = [[XBWordSubjectContentController alloc] init];
                vc.parentController = strongSelf;
                vc.infoModel = [[XBHomeworkWordInfoModel alloc] initWithDictionary:tmpRes.data[i] error:nil];
                [strongSelf addChildViewController:vc];
                [vcArr addObject:vc];
                NSString *title = [NSString stringWithFormat:@"%d/%ld", i+1, tmpRes.data.count];
                vc.title = title;
                [titleArr addObject:title];
            }
            
            _titles      = titleArr.copy;
            _controllers = vcArr.copy;
            
            Run_Main(^{
                strongSelf.title = _titles[0];
                [strongSelf reloadData];
            });
        }

    } ShowHud:NO];
}

#pragma mark-  设置历史记录按钮

- (void)rightBtn {
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 60, 30);
    rightBtn.titleLabel.font = Font_System(15);
    [rightBtn setTitle:@"历史记录" forState:UIControlStateNormal];
    [rightBtn setTitleColor:ColorHex(0x00C71F) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(pressHistoryListButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
}

#pragma mark-   touch action

- (void)pressHistoryListButtonAction:(UIButton *)sender {
    [self.navigationController pushViewController:[XBWordHistoryListController new] animated:YES];
}


#pragma mark dataSouce
- (NSInteger)numberOfPageInSlidingController:(XBPageController *)slidingController{
    return _titles.count;
}
- (UIViewController *)slidingController:(XBPageController *)slidingController controllerAtIndex:(NSInteger)index{
    return _controllers[index];
}

#pragma mark delegate
- (void)slidingController:(XBPageController *)slidingController selectedIndex:(NSInteger)index{
    // presentIndex
    NSLog(@"%ld",index);
    self.title = _titles[index];
}

- (void)slidingController:(XBPageController *)slidingController selectedController:(UIViewController *)controller {
    
}

-(void)dealloc{
    NSLog(@"!dealloc!");
}

@end
