//
//  XBVoiceController.m
//  eLite
//
//  Created by 常小哲 on 16/5/21.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBVoiceController.h"
#import "XBWordHistoryListController.h"
#import "XBVoiceViewController.h"
#import "XBVoiceHistoryListController.h"

@interface XBVoiceController ()<
XBPageControllerDelegate,
XBPageControllerDataSource> {
    
    NSArray *_titles;
    NSArray *_controllers;
    NSArray *_allData;
    
}

@end

@implementation XBVoiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Color_White;
    _voicePathArray = [[NSMutableArray alloc]initWithCapacity:30];
    self.scrollEnabled = YES;
    [self __init];
    [self rightBtn];
}

- (void)__init {
    
    self.datasouce = self;
    self.delegate = self;
    
    __weak typeof(self) weakSelf = self;

    [XBHomeworkVoiceReq do:^(id req) {
        XBHomeworkVoiceReq *tmpReq = req;
        tmpReq.userid = USER_ID;
    } Res:^(id res) {
        XBHomeworkVoiceRes *tmpRes = res;
        if (tmpRes.data.count > 0) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            _allData = tmpRes.data.copy;
            _allSubjectCount = tmpRes.data.count;
            NSMutableArray *vcArr = [NSMutableArray new];
            NSMutableArray *titleArr = [NSMutableArray new];
            for (int i = 0; i < tmpRes.data.count; i ++) {
                XBVoiceViewController *vc = [[XBVoiceViewController alloc] init];
                vc.parentController = strongSelf;
                vc.infoModel = [[XBHomeworkVoiceInfoModel alloc] initWithDictionary:tmpRes.data[i] error:nil];
                [strongSelf addChildViewController:vc];
                if (!weakSelf.allSubjectID) {
                    weakSelf.allSubjectID = [NSString stringWithFormat:@"%@",vc.infoModel._id];
                }
                else
                {
                  weakSelf.allSubjectID = [NSString stringWithFormat:@"%@,%@",weakSelf.allSubjectID,vc.infoModel._id];
                }
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
    [self.navigationController pushViewController:[XBVoiceHistoryListController new] animated:YES];
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
