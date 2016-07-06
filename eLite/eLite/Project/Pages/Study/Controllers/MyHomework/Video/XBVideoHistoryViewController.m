//
//  XBVideoHistoryViewController.m
//  eLite
//
//  Created by 常小哲 on 16/5/26.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBVideoHistoryViewController.h"
#import "XBVideoHistoryCell.h"
#import "XBPlayVideoController.h"

@interface XBVideoHistoryViewController ()<UITableViewDelegate, UITableViewDataSource> {

    XBVideoHistoryCell *_protypeCell;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIView *tableViewHead;
@end

@implementation XBVideoHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"历史记录";
    _tableView.tableHeaderView = self.tableViewHead;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XBVideoHistoryCell *cell = LoadXibWithClass(XBVideoHistoryCell);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.commentLabel.text = _infoModel.comment;
    _protypeCell = cell;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    _protypeCell.commentLabel.text = _infoModel.comment;
    CGSize size = [_protypeCell.commentLabel sizeThatFits:CGSizeMake(_protypeCell.commentLabel.width, FLT_MAX)];
    CGFloat height = size.height + 15*2;
    return MAX(height, 50);
}

- (void)playVideo {
    XBPlayVideoController *vc = [[XBPlayVideoController alloc] init];
    [vc addRemoteURL:[SERVER_IP stringByAppendingPathComponent:_infoModel.path]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)tableViewHead {
    if (!_tableViewHead) {
        _tableViewHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 260)];
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, _tableViewHead.width, _tableViewHead.height-20*2)];
        [_tableViewHead addSubview:contentView];;

        UIImageView *videoPlaceholdeer = [[UIImageView alloc] initWithImage:Image_Named(@"tabbar_contacts_active")];
        videoPlaceholdeer.frame = CGRectMake(20, 20, contentView.width - 20*2, contentView.height-20*2);
        videoPlaceholdeer.cornerRadius = 5;
        [contentView addSubview:videoPlaceholdeer];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((contentView.width -50)/2, (contentView.height-50)/2, 50, 50);
        [button setImage:Image_Named(@"homework_playVideo_button") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:button];
    }
    return _tableViewHead;
}

@end
