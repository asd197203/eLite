//
//  XBWordSubjectContentController.m
//  eLite
//
//  Created by 常小哲 on 16/4/15.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBWordSubjectContentController.h"
#import "XBHomeworkWordCell.h"
#import "XBWordDoneController.h"
#import "XBWordHistoryListController.h"
#import "XBWordSubjectController.h"

@interface XBWordSubjectContentController ()<UITableViewDataSource, UITableViewDelegate> {
    
    __weak IBOutlet UITableView *_tableView;
    UIView *_tableViewHead;
    NSArray *_cellHeights;
//    NSArray *_allData;
}

@end

@implementation XBWordSubjectContentController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _tableView.tableHeaderView = self.tableViewHead;
    [_tableView reloadData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Color_White;

}

#pragma mark- 计算每行答案的文字高度
- (NSArray *)computeCellHeight:(NSArray *)option {
    NSMutableArray *tmpArr = [NSMutableArray new];
    for (NSString *str in option) {
        CGSize size = [Util sizeWithString:str font:Font_System(17) size:CGSizeMake(kHomeworkWordCellLabelMaxWidth, CGFLOAT_MAX)];
        
        [tmpArr addObject:@(size.height)];
    }
    return tmpArr;
}

#pragma mark- Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _infoModel.option.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XBHomeworkWordCell *cell = [[XBHomeworkWordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.subject = _infoModel.option[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MAX([_cellHeights[indexPath.row] floatValue] + 30, 60);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    self.parentController.currentSubject++;
    if ([_infoModel.option[indexPath.row] isEqualToString:_infoModel.answer]) {
        self.parentController.score += 100/self.parentController.allSubjectCount;
        self.parentController.correctNum ++;
    }else {
        
        self.parentController.wrongNum ++;
        self.parentController.wrongSubjectDict[self.parentController.title] = _infoModel;
        NSInteger wrongRow = indexPath.row;
        NSInteger correctRow = 0;
        for (NSInteger i; i < _infoModel.option.count; i++) {
            if ([_infoModel.option[i] isEqualToString:_infoModel.answer]) {
                correctRow = i;
                break;
            }
        }
        [self.parentController.myWorkResults addObject:@{@"YES":@(correctRow), @"NO":@(wrongRow)}];
    }
    if (self.parentController.currentSubject == self.parentController.allSubjectCount) {
        for (NSDictionary*model in self.parentController.allData) {
            if (!self.parentController.wrongID) {
                self.parentController.wrongID = [NSString stringWithFormat:@"%@",model[@"_id"]];
            }
            else
            {
                self.parentController.wrongID = [NSString stringWithFormat:@"%@,%@",self.parentController.wrongID,model[@"_id"]];
            }
        }
        XBWordDoneController *vc = [[XBWordDoneController alloc] init];
        vc.wrongNum = self.parentController.wrongNum;
        vc.wrongID = self.parentController.wrongID;
        vc.correctNum = self.parentController.correctNum;
        vc.correctRate = self.parentController.correctNum/self.parentController.allSubjectCount;
        vc.allSubjectCount = self.parentController.allSubjectCount;
        vc.wrongSubjectDict = self.parentController.wrongSubjectDict;
        vc.myWorkResults = self.parentController.myWorkResults;
        vc.score = self.parentController.score;
        [self.parentController.navigationController pushViewController:vc animated:YES];
        return;
    }
    [self.parentController selectedIndex:[self.title componentsSeparatedByString:@"/"].firstObject.integerValue];
}

#pragma mark-   Setter & Getter

- (UIView *)tableViewHead {
    if (!_tableViewHead) {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15,
                                                                   5,
                                                                   Screen_Width - 15*2,
                                                                   24)];
        title.numberOfLines = 0;
        title.textColor = Color_Black;
        title.font = Font_System(22);
        title.text = _infoModel.title;
        title.preferredMaxLayoutWidth = title.width;
        title.lineBreakMode = NSLineBreakByCharWrapping;
        [title sizeToFit];
        _tableViewHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, title.height+30)];
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, title.height+10)];
        contentView.center = _tableViewHead.center;
        [_tableViewHead addSubview:contentView];
        [contentView addSubview:title];
    }
    return _tableViewHead;
}

@end
