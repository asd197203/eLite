//
//  XBHelperAndFeedBackVC.m
//  eLite
//
//  Created by 常小哲 on 16/4/19.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBHelperAndFeedBackVC.h"
#import "XBCellRightView.h"
#import "XBSuggestionsViewController.h"
#import "XBHelperDetailVC.h"
@interface XBHelperAndFeedBackVC ()<UITableViewDelegate,
UITableViewDataSource,
UISearchBarDelegate> {
    
    NSArray *_searchResult;

}

@property (nonatomic, strong) NSArray *titles;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation XBHelperAndFeedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帮助";
}

//- (IBAction)feedBack:(id)sender {
//    [self.navigationController pushViewController:[XBSuggestionsViewController new] animated:YES];
//}

#pragma mark- Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return self.titles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * reuseIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    cell.textLabel.font = Font_System(14);
    cell.accessoryView = [XBCellRightView defaultView];
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XBHelperDetailVC *vc = [[XBHelperDetailVC alloc]init];
    if (indexPath.row) {
        vc.type=2;
    }
    else
    {
        vc.type=1;
    }
    vc.title = _titles[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
- (NSArray *)titles {
    SafeRun_Return(_titles);
    _titles = @[
                @"你未发现的elite小功能",
                @"我最多可以创建多少个群聊?"
                ];
    return _titles;
}

@end
