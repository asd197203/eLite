//
//  CDContactListController.m
//  LeanChat
//
//  Created by Qihe Bian on 7/27/14.
//  Copyright (c) 2014 LeanCloud. All rights reserved.
//

#import "CDFriendListVC.h"
#import "CDCommon.h"
#import "CDAddFriendVC.h"
#import "CDBaseNavC.h"
#import "CDNewFriendVC.h"
#import "CDImageLabelTableCell.h"
#import "CDGroupedConvListVC.h"
#import <JSBadgeView/JSBadgeView.h>
#import "CDUtils.h"
#import "CDUserManager.h"
#import "CDIMService.h"
#import "XBChineseString.h"
#import "CDUserInfoVC.h"
#import "CDCacheManager.h"
#import "XHBaseNavigationController.h"
#import "XBUserInfoVC.h"
#import "UIColor+category.h"
#import "DeleteFriendReq.h"
#import "GetFriendListReq.h"
#import "XBAddressBookVC.h"
static NSString *kCellImageKey = @"image";
static NSString *kCellBadgeKey = @"badge";
static NSString *kCellTextKey = @"text";
static NSString *kCellSelectorKey = @"selector";

@interface CDFriendListVC () <UIAlertViewDelegate,UISearchBarDelegate,UISearchResultsUpdating>


@end

@implementation CDFriendListVC

#pragma mark - Life Cycle

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"联系人";
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self refresh];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.indexArray = [[NSMutableArray alloc]initWithCapacity:100];
    self.letterResultArr = [[NSMutableArray alloc]initWithCapacity:100];
    self.searchArray =[[NSMutableArray alloc]initWithCapacity:100];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
         self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"contact_IconAdd"] style:UIBarButtonItemStylePlain target:self action:@selector(goAddFriend:)];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexColor = [UIColor hexStringToColor:@"#8e8e8d"];
    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:0.5];
    [self setupTableView];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    self.tableView.tableHeaderView = self.searchController.searchBar;
    //Do this because -- Tab Bar covers TableView cells in iOS7
    self.tableView.contentInset = UIEdgeInsetsMake(0., 0., CGRectGetHeight(self.tabBarController.tabBar.frame), 0);
    [self refresh];

}
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = [self.searchController.searchBar text];
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    if (self.searchArray!= nil) {
        [self.searchArray removeAllObjects];
    }
    NSMutableArray *array =[[NSMutableArray alloc]initWithCapacity:100];
    for (NSArray*arrays in self.letterResultArr) {
        for (GetFriendModel *model in arrays) {
            if (![model.remark isEqualToString:@""]) {
                if ([model.remark containsString:searchString]) {
                    [array  addObject:model.remark];
                }
            }
            else
            {
                if ([model.name containsString:searchString]) {
                    [array  addObject:model.name];
                }
            }
        }
    }
    _searchResult =  [[NSArray alloc] initWithArray:[array filteredArrayUsingPredicate:preicate]];
    [self.tableView reloadData];
}
- (void)setupTableView {
    [CDImageLabelTableCell registerCellToTalbeView:self.tableView];
    self.tableView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    [self.tableView addSubview:self.refreshControl];
}

- (UIRefreshControl *)refreshControl {
    if (_refreshControl == nil) {
        _refreshControl = [[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}
#pragma mark - Action

- (void)goNewFriend:(id)sender {
    CDNewFriendVC *controller = [[CDNewFriendVC alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.friendListVC = self;
    [[self navigationController] pushViewController:controller animated:YES];
    self.tabBarItem.badgeValue = nil;
}
//- (void)goAddressBookVC
//{
//    XBAddressBookVC *controller = [[XBAddressBookVC alloc] init];
//    controller.hidesBottomBarWhenPushed = YES;
//    [[self navigationController] pushViewController:controller animated:YES];
//    
//}
- (void)goGroup:(id)sender {
    CDGroupedConvListVC *controller = [[CDGroupedConvListVC alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [[self navigationController] pushViewController:controller animated:YES];
}

- (void)goAddFriend:(id)sender {
    CDAddFriendVC *controller = [[CDAddFriendVC alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [[self navigationController] pushViewController:controller animated:YES];
}
#pragma mark - load data
- (void)refresh {
    [self refresh:nil];
}

- (void)refreshWithFriends:(NSArray *)friends badgeNumber:(NSInteger)number{
    if (number > 0) {
        [[self navigationController] tabBarItem].badgeValue = [NSString stringWithFormat:@"%ld", (long)number];
    } else {
        [[self navigationController] tabBarItem].badgeValue = nil;
    }
    self.headerSectionDatas = [NSMutableArray array];
    [self.headerSectionDatas addObject:@{
                                         kCellImageKey : [UIImage imageNamed:@"plugins_FriendNotify"],
                                         kCellTextKey : @"新的朋友",kCellBadgeKey:@(number),
                                         kCellSelectorKey : NSStringFromSelector(@selector(goNewFriend:))
                                         }];
    [self.headerSectionDatas addObject:@{
                                         kCellImageKey :[UIImage imageNamed:@"add_friend_icon_addgroup"],
                                         kCellTextKey : @"群聊" ,
                                         kCellSelectorKey : NSStringFromSelector(@selector(goGroup:))
                                         }];
//    [self.headerSectionDatas addObject:@{
//                                         kCellImageKey :[UIImage imageNamed:@"add_friend_icon_addgroup"],
//                                         kCellTextKey : @"通讯录" ,
//                                         kCellSelectorKey : NSStringFromSelector(@selector(goAddressBookVC))
//                                         }];
    WEAKSELF
    [GetFriendListReq do:^(id req) {
        GetFriendListReq *re = req;
        re.userid = [XBUserDefault sharedInstance].resModel.userid;
    } Res:^(id res) {
        GetFriendListRes *resq = res;
         [self hideProgress];
        if (resq.code==0) {
            self.dataSource = [resq.data mutableCopy];
            self.indexArray = [XBChineseString IndexArray:self.dataSource];
            self.letterResultArr = [XBChineseString LetterSortArray:self.dataSource];
            [self.tableView reloadData];
        }
        else
        {
            [XBShowViewOnce showHUDText:resq.msg inVeiw:weakSelf.view];
        }
    } ShowHud:NO];
}

- (void)findFriendsAndBadgeNumberWithBlock:(void (^)(NSArray *friends, NSInteger badgeNumber, NSError *error))block {
    [[CDUserManager manager] findFriendsWithBlock : ^(NSArray *objects, NSError *error) {
        // why kAVErrorInternalServer ?
        if (error && error.code != kAVErrorCacheMiss && error.code == kAVErrorInternalServer) {
            // for the first start
            block(nil, 0, error);
        } else {
            if (objects == nil) {
                objects = [NSMutableArray array];
            }
            [self countNewAddRequestBadge:^(NSInteger number, NSError *error) {
                block (objects, number, nil);
            }];
        };
    }];
}
- (void)refresh:(UIRefreshControl *)refreshControl {
//    [self showProgress];
    [self findFriendsAndBadgeNumberWithBlock:^(NSArray *friends, NSInteger badgeNumber, NSError *error) {
        [CDUtils stopRefreshControl:refreshControl];
        if ([self filterError:error]) {
            [self refreshWithFriends:friends badgeNumber:badgeNumber];
        }
    }];
}

- (void)countNewAddRequestBadge:(AVIntegerResultBlock)block {
    [[CDUserManager manager] countUnreadAddRequestsWithBlock : ^(NSInteger number, NSError *error) {
        if (error) {
            block(0, nil);
        } else {
            block(number, nil);
        }
    }];
}

#pragma mark - Table view data delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.searchController.active) {
        if (section == 0) {
            return self.headerSectionDatas.count;
        } else {
            return [[self.letterResultArr objectAtIndex:section-1] count];
        }
    }else{
        if (section == 0) {
            return self.headerSectionDatas.count;
        } else {
            return _searchResult.count;
        }
    }
}
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (!self.searchController.active) {
        return self.indexArray;
    }
    else
    {
        return nil;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.searchController.active) {
        return self.indexArray.count+1;
    }
    else
    {
        return 2;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (!self.searchController.active) {
        if (section==0) {
            return @"";
        }
        else
        {
            return self.indexArray[section-1];
        }
    }
    else
    {
        return nil;
    }
    
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return 0;
    }
    else
    {
        return 15;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
       CDImageLabelTableCell *cell = [CDImageLabelTableCell createOrDequeueCellByTableView:tableView];
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        cell.selectedImageView.hidden = YES;
        static NSInteger kBadgeViewTag = 103;
        JSBadgeView *badgeView = (JSBadgeView *)[cell viewWithTag:kBadgeViewTag];
        if (badgeView) {
            [badgeView removeFromSuperview];
        }
        if (indexPath.section == 0)
        {
            cell.selectedImageView.hidden = YES;
            NSDictionary *cellDatas = self.headerSectionDatas[indexPath.row];
            [cell.myImageView setImage:cellDatas[kCellImageKey]];
            cell.myLabel.text = cellDatas[kCellTextKey];
            NSInteger badgeNumber = [cellDatas[kCellBadgeKey] intValue];
            if (badgeNumber > 0)
            {
                badgeView = [[JSBadgeView alloc] initWithParentView:cell.myImageView alignment:JSBadgeViewAlignmentTopRight];
                badgeView.tag = kBadgeViewTag;
                badgeView.badgeText = [NSString stringWithFormat:@"%ld", badgeNumber];
            }
       }
        else if(!self.searchController.active)
       {
            GetFriendModel *model = [[self.letterResultArr objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row];
            //        [[CDUserManager manager] displayAvatarOfUser:user avatarView:cell.myImageView];
            if ([model.remark isEqualToString:@""]) {
                cell.myLabel.text = model.name;
            }
            else
            {
                cell.myLabel.text = model.remark;
            }
            cell.myImageView.clipsToBounds = YES;
            [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",serverUrl,model.photo]] placeholderImage:[UIImage imageNamed:@"tabbar_selected_3"]];
       }
    else
       {
        for (NSArray *array in self.letterResultArr) {
            for (GetFriendModel*model in array) {
                if (![model.remark isEqualToString:@""])
                {
                    if ([model.remark containsString:self.searchResult[indexPath.row]])
                    {
                        [self.searchArray addObject:model];
                    }
                }
                else
                {
                    if (self.searchController.searchBar.text.length!=0)
                    {
                        if ([model.name containsString:self.searchController.searchBar.text])
                        {
                            [self.searchArray addObject:model];
                        }
                    }
                }
            }
        }
        if (self.searchResult.count!=0) {
            GetFriendModel *model = [self.searchArray objectAtIndex:indexPath.row];
            if ([model.remark isEqualToString:@""])
            {
                cell.myLabel.text = model.name;
            }
            else
            {
                cell.myLabel.text = model.remark;
            }
            cell.myImageView.clipsToBounds = YES;
            [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",serverUrl,model.photo]] placeholderImage:[UIImage imageNamed:@"tabbar_selected_3"]];
        }
        
    }
   return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 0) {
        self.searchController.active =NO;
        SEL selector = NSSelectorFromString(self.headerSectionDatas[indexPath.row][kCellSelectorKey]);
        [self performSelector:selector withObject:nil afterDelay:0];
    } else {
        if(!self.searchController.active)
        {
            GetFriendModel *model =[[self.letterResultArr objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row];
            XBUserInfoVC *userInfoVC = [[XBUserInfoVC alloc]init];
            userInfoVC.userID =[NSString stringWithFormat:@"%@",model.userid];
            userInfoVC.friendListVC = self;
            userInfoVC.hidesBottomBarWhenPushed = YES;
            self.searchController.active =NO;
            [[self navigationController] pushViewController:userInfoVC animated:YES];
        }
        else
        {
            GetFriendModel *model =[self.searchArray objectAtIndex:indexPath.row];
            XBUserInfoVC *userInfoVC = [[XBUserInfoVC alloc]init];
            userInfoVC.userID =[NSString stringWithFormat:@"%@",model.userid];
            userInfoVC.friendListVC = self;
            userInfoVC.hidesBottomBarWhenPushed = YES;
            self.searchController.active =NO;
            [self.navigationController pushViewController:userInfoVC animated:YES];
        }
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return NO;
    }
    return NO;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
         _deleteUser = [[self.letterResultArr objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"解除好友关系吗" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alertView.tag = indexPath.row;
        [alertView show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self showProgress];
        [[NSNotificationCenter defaultCenter]postNotificationName:kCDNotificationDeleteFriendConversationUpdated object:nil userInfo:@{@"deleteUser":_deleteUser}];
        [[CDUserManager manager] removeFriend:_deleteUser callback:^(BOOL succeeded, NSError *error) {
            if ([self filterError:error]) {
                [DeleteFriendReq do:^(id req) {
                    DeleteFriendReq*re = req;
                    re.userid =[[XBUserDefault sharedInstance].resModel.userid integerValue];
                    re.friendid =[_deleteUser.username integerValue];
                } Res:^(id res) {
                    DeleteFriendRes *resq = res;
                    if (resq.code ==0) {
                        [self hideProgress];
                        [XBShowViewOnce showHUDText:@"删除成功" inVeiw:self.view];
                        [self refresh];
                    }
                    else
                    {
                        [self hideProgress];
                        [XBShowViewOnce showHUDText:@"删除失败" inVeiw:self.view];
                        
                    }
                } ShowHud:NO];
            }
        }];
    }
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
