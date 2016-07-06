//
//  XBAboutUsViewController.m
//  eLite
//
//  Created by 常小哲 on 16/4/14.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBAboutUsViewController.h"
#import "XBCellRightView.h"
#import "XBHelperAndFeedBackVC.h"

@interface XBAboutUsViewController ()<UITableViewDataSource, UITableViewDelegate> {
    __weak IBOutlet UITableView *_tableView;
    NSArray *_titles;
    UIView *_tableViewHead;
}

@end

@implementation XBAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.tableHeaderView = self.tableViewHead;
}

#pragma mark-  table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _titles[indexPath.row];

//    if (indexPath.row != 2) {
//        if (indexPath.row == 1)
//            cell.accessoryView = [[XBCellRightView alloc] initWithFrame:CGRectMake(0, 0, 50, 20) withTitle:Project_ShortVersion];
//        else cell.accessoryView = [XBCellRightView defaultView];
//    }
    cell.accessoryView = [XBCellRightView defaultView];
    
    return cell;
}

#pragma mark-  table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            // 跳到apple store
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps ://itunes.apple.com/gb/app/yi-dong-cai-bian/id391945719?mt=8"]];
        }
            break;
            
//        case 1: {
//            
//        }
//            break;
//            
//        case 2: {
//            
//        }
//            break;
            
//        case 1: {
//            XBHelperAndFeedBackVC *vc = [[XBHelperAndFeedBackVC alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
            break;
        default:
            break;
    }
}


#pragma mark-   Setter & Getter

- (UIView *)tableViewHead {
    if (!_tableViewHead) {
        _tableViewHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 150)];
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 84)];
        contentView.center = _tableViewHead.center;
        
        UIImageView *logo = [[UIImageView alloc] initWithImage:Image_Named(@"登录logo")];
        logo.frame = CGRectMake((contentView.width - 54) / 2, 0, 54, 54);
        logo.cornerRadius = 5;
        [contentView addSubview:logo];
        
        UILabel *version = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                     logo.bottom + 5,
                                                                     contentView.width,
                                                                     20)];
        version.textAlignment = NSTextAlignmentCenter;
        version.textColor = [UIColor grayColor];
        version.font = Font_System(14);
        version.text = [NSString stringWithFormat:@"ELITE %@",Project_ShortVersion];
        [contentView addSubview:version];
        
        [_tableViewHead addSubview:contentView];;
    }
    return _tableViewHead;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[
                    @"去评分",
//                    @"当前版本",
//                    @"新版本更新",
//                    @"帮助"
                    ];
    }
    return _titles;
}

@end
