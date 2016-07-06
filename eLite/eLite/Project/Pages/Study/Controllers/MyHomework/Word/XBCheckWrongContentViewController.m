//
//  XBCheckWrongContentViewController.m
//  eLite
//
//  Created by 常小哲 on 16/5/17.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBCheckWrongContentViewController.h"
#import "XBCheckWrongViewController.h"
#import "XBCheckWrongCell.h"

@interface XBCheckWrongContentViewController ()<
UITableViewDelegate,
UITableViewDataSource> {
    UIView *_tableViewHead;
    NSArray *_cellHeights;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
    
@end

@implementation XBCheckWrongContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _tableView.tableHeaderView = self.tableViewHead;
    [_tableView reloadData];;
}


#pragma mark-   table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _infoModel.option.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XBCheckWrongCell *cell = [[XBCheckWrongCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.subject = _infoModel.option[indexPath.row];
    if ([_resultDict[@"YES"] integerValue] == indexPath.row) {
        cell.leftImage.image = Image_Named(@"homework_text_selected");
    }else if ([_resultDict[@"NO"] integerValue] == indexPath.row) {
        cell.leftImage.image = Image_Named(@"homework_word_wrong");
        cell.bgView.backgroundColor = ColorRGB(254, 221, 221);
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MAX([_cellHeights[indexPath.row] floatValue] + 30, 60);
}


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
