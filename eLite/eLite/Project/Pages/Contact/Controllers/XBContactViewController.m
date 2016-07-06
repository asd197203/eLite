//
//  XBContactViewController.m
//  eLite
//
//  Created by 常小哲 on 16/4/13.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBContactViewController.h"
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
#import "GetFriendListReq.h"
#import "CreatCrowdReq.h"
#import "XBCellRightView.h"
static NSString *kCellImageKey = @"image";
static NSString *kCellBadgeKey = @"badge";
static NSString *kCellTextKey = @"text";
static NSString *kCellSelectorKey = @"selector";

@interface XBContactViewController () <UIAlertViewDelegate,UISearchResultsUpdating,UITextFieldDelegate>

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSMutableArray *headerSectionDatas;
@property(nonatomic,strong)NSMutableArray *indexArray;
@property(nonatomic,strong)NSMutableArray *letterResultArr;
@property(nonnull,strong)UISearchBar *searchBar;
@property(nonatomic,strong)NSMutableArray *selectedCellArray;//记录选中的cell
@property(nonatomic,strong)NSMutableArray *selectedUserArray;//保存选中的user
@property(nonatomic,assign)NSInteger   number;//标记选人在数组的中位置
@property(nonatomic,strong)NSMutableArray *arrayUser;
@property(nonatomic,strong)NSMutableArray *friends;
@property(nonatomic,strong)NSString  *crowdName;//群名称
@property(nonatomic,strong)UITextField*crowdNameField;
@property(nonatomic,strong)NSMutableArray  *searchArray;
@property(nonatomic,strong)UISearchController *searchController;
@property (nonatomic, strong) NSArray *searchResult;
@property(nonatomic,strong)UIView  * headView;

@end

@implementation XBContactViewController

#pragma mark - Life Cycle

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"联系人";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.indexArray = [[NSMutableArray alloc]initWithCapacity:100];
    self.letterResultArr = [[NSMutableArray alloc]initWithCapacity:100];
    self.selectedCellArray = [[NSMutableArray alloc]initWithCapacity:100];
    self.selectedUserArray = [[NSMutableArray alloc]initWithCapacity:100];
    self.arrayUser = [[NSMutableArray alloc]initWithCapacity:100];
    self.searchArray = [[NSMutableArray alloc]initWithCapacity:100];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendGroupMessage)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor greenColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(selfDismiss)];
    [self setupTableView];
     [self.refreshControl removeFromSuperview];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
 
    //Do this because -- Tb Bar covers TableView cells in iOS7
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexColor = [UIColor hexStringToColor:@"#8e8e8d"];
    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:0.5];
    self.tableView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height-150);
    self.tableViewStyle =UITableViewStyleGrouped;
       self.tableView.tableHeaderView = self.searchController.searchBar;
    self.tableView.contentInset = UIEdgeInsetsMake(0., 0., CGRectGetHeight(self.tabBarController.tabBar.frame), 0);
    _headView = [[UIView alloc]initWithFrame:CGRectMake(-1,self.tableView.frame.size.height+64, self.view.frame.size.width+2, 55)];
    _headView.layer.borderWidth=0.5;
    _headView.layer.borderColor = [UIColor grayColor].CGColor;
    [self.view addSubview:_headView];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-30, 22, 20, 10);
    [button setBackgroundImage:[UIImage imageNamed:@"收起箭头灰色"] forState:UIControlStateNormal];
    [_headView addSubview:button];
    
    [GetFriendListReq do:^(id req) {
        GetFriendListReq *re = req;
        re.userid = [XBUserDefault sharedInstance].resModel.userid;
    } Res:^(id res) {
        GetFriendListRes *resq = res;
        if (resq.code==0) {
            self.dataSource = [resq.data mutableCopy];
            self.indexArray = [XBChineseString IndexArray:self.dataSource];
            self.letterResultArr = [XBChineseString LetterSortArray:self.dataSource];
            for (int i =0; i<self.letterResultArr.count; i++) {
                NSArray *array = [self.letterResultArr objectAtIndex:i];
                NSMutableArray *array1 =[NSMutableArray array];
                NSMutableArray *array2 =[NSMutableArray array];
                for (int j =0; j<array.count; j++) {
                    NSMutableDictionary*dic = [NSMutableDictionary dictionary];
                    [dic setObject:@"NO" forKeyedSubscript:@"isSelected"];
                    _number++;
                    [dic setObject:[NSString stringWithFormat:@"%d",_number] forKey:@"number"];
                    [array1  addObject:dic];
                    GetFriendModel*user = [array objectAtIndex:j];
                    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
                    [dic1 setObject:user forKey:@"user"];
                    [dic1 setObject:[NSString stringWithFormat:@"%d",_number] forKey:@"number"];
                    [array2 addObject:dic1];
                }
                [self.arrayUser addObject:array2];
                [self.selectedCellArray addObject:array1];
            }
            [self.tableView reloadData];
        }
    } ShowHud:YES];
//    [self refresh];
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
-(void)selfDismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark--群发消息---

-(void)sendGroupMessage
{
    _friends =[NSMutableArray array];
    for (NSDictionary*userDic in self.selectedUserArray) {
        GetFriendModel *user = [userDic objectForKey:@"user"];
        [[CDUserManager manager] findUsersByPartname:[NSString stringWithFormat:@"%@",user.userid] withBlock: ^(NSArray *objects, NSError *error) {
            if (!error) {
                if (objects) {
                    [_friends addObject:objects[0]];
                }
            }
        }];
    }
    if(self.selectedUserArray.count!=0)
    {
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"群名称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.alertViewStyle =UIAlertViewStylePlainTextInput;
        _crowdNameField = [alert textFieldAtIndex:0];
        _crowdNameField.delegate  =self;
        _crowdNameField.placeholder = @"请输入一个群名称";
        [alert show];
    }
    else
    {
        [XBShowViewOnce showHUDText:@"请添加成员" inVeiw:self.view];
    }
    
}
#pragma mark--alertViewDelelgate---
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        //取消
        NSLog(@"群聊取消");
    }
    else
    {
        //确定
        if (_friends.count==self.selectedUserArray.count) {
            NSMutableArray *array =[[NSMutableArray alloc]init];
            for (AVUser*user in _friends) {
                [array addObject:user.objectId];
            }
            _crowdName =_crowdNameField.text;
            NSInteger  type =CDConversationTypeGroup;
            AVIMConversationOption options;
            options = AVIMConversationOptionNone;
            [self showProgress];
            [CDChatManager manager].client = [[AVIMClient alloc] initWithClientId:[CDChatManager manager].clientId];
            [[CDChatManager manager].client openWithCallback:^(BOOL succeeded, NSError *error) {
                [[CDChatManager manager].client createConversationWithName:_crowdName clientIds:array attributes:@{CONVERSATION_TYPE:@(type)} options:options callback:^(AVIMConversation *conversation, NSError *error) {
                    if ([self filterError:error]) {
                        [CreatCrowdReq do:^(id req) {
                            CreatCrowdReq*re = req;
                            re.userid = [[XBUserDefault sharedInstance].resModel.userid integerValue];
                            re.users=[XBUserDefault sharedInstance].resModel.userid;
                            for (NSDictionary*userDic in self.selectedUserArray) {
                                GetFriendModel *user = [userDic objectForKey:@"user"];
                                re.users = [NSString stringWithFormat:@"%@,%@",re.users,user.userid];
                            }
                            re.groupid = conversation.conversationId;
                            re.name =_crowdName;
                            NSDate *date = [NSDate date];
                            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                            re.createtime = [formatter stringFromDate:date];
                        } Res:^(id res) {
                            [self hideProgress];
                            CreatCrowdRes *resq = res;
                            if (resq.code==0) {
                                [self.presentingViewController dismissViewControllerAnimated:YES completion: ^{
                                    [[CDIMService service] pushToChatRoomByConversation:conversation fromNavigation:self.navigationController completion:nil];
                                }];
                            }
                            else{
                                [XBShowViewOnce showHUDText:@"建群失败" inVeiw:self.view];
                            }
                        } ShowHud:NO];
                        
                    }
                }];
            }];
        }
    }
}

#pragma mark--textFieldDelelgate---
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    _crowdName =textField.text;
    
}
- (void)setupTableView {
    self.tableView.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height);
    [CDImageLabelTableCell registerCellToTalbeView:self.tableView];
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
- (void)goGroup:(id)sender {
    CDGroupedConvListVC *controller = [[CDGroupedConvListVC alloc] init];
    [[self navigationController] pushViewController:controller animated:YES];
}

- (void)goAddFriend:(id)sender {
    CDAddFriendVC *controller = [[CDAddFriendVC alloc] init];
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
    [self showProgress];
    [self findFriendsAndBadgeNumberWithBlock:^(NSArray *friends, NSInteger badgeNumber, NSError *error) {
        [self hideProgress];
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
            return [[self.letterResultArr objectAtIndex:section] count];
    }else{
            return _searchResult.count;
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
        return self.indexArray.count;
    }
    else
    {
        return 1;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (!self.searchController.active) {
            return self.indexArray[section];
    }
    else
    {
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
       return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        CDImageLabelTableCell *cell = [CDImageLabelTableCell createOrDequeueCellByTableView:tableView];
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        cell.myImageViewLeftConstraint.constant = 30;
        if (!self.searchController.active) {
            GetFriendModel *user = [[self.letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",serverUrl,user.photo]] placeholderImage:[UIImage imageNamed:@""]];
            cell.myImageView.clipsToBounds = YES;
            if (![user.remark isEqualToString:@""]) {
                cell.myLabel.text = user.remark;
            }
            else
            {
                cell.myLabel.text = user.name;
            }
            NSArray* array = [self.selectedCellArray objectAtIndex:indexPath.section];
            NSDictionary *dic = [array objectAtIndex:[indexPath row]];
            if ([[dic objectForKey:@"isSelected"]isEqualToString:@"NO"]) {
                [dic setValue:@"NO" forKey:@"isSelected"];
                [cell setIsSelected:NO];
            }else
            {
                [dic setValue:@"YES" forKey:@"isSelected"];
                [cell setIsSelected:YES];
            }
            return cell;
        }
        else
        {
            for (NSArray *array in self.letterResultArr) {
                for (GetFriendModel*model in array) {
                    if (![model.remark isEqualToString:@""])
                    {
                        if ([model.remark containsString:self.searchController.searchBar.text])
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
            NSArray* array = [self.selectedCellArray objectAtIndex:indexPath.section-1];
            NSDictionary *dic = [array objectAtIndex:[indexPath row]];
            if ([[dic objectForKey:@"isSelected"]isEqualToString:@"NO"]) {
                [dic setValue:@"NO" forKey:@"isSelected"];
                [cell setIsSelected:NO];
            }else
            {
                [dic setValue:@"YES" forKey:@"isSelected"];
                [cell setIsSelected:YES];
            }
            
            
            return cell;
        }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if(!self.searchController.active)
    {
        NSDictionary *userDic =[[self.arrayUser objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        NSIndexPath *index = [tableView indexPathForSelectedRow];
        CDImageLabelTableCell *cell = [tableView cellForRowAtIndexPath:index];
        NSArray*array = [self.selectedCellArray objectAtIndex:indexPath.section];
        NSMutableDictionary*dic = [array objectAtIndex:[indexPath row]];
        NSString *number = [dic objectForKey:@"number"];
        if ([[dic objectForKey:@"isSelected"]isEqualToString:@"NO"]) {
            [dic setValue:@"YES" forKey:@"isSelected"];
            NSLog(@"self.arrayUser===%@",self.arrayUser);
            [self.selectedUserArray addObject:[[self.arrayUser objectAtIndex:[number integerValue]-1]objectAtIndex:0]];
            [cell setIsSelected:YES];
        }else{
            [dic setValue:@"NO" forKey:@"isSelected"];
            for ( int i=0;i<self.selectedUserArray.count;i++) {
               NSDictionary *dic = [self.selectedUserArray objectAtIndex:i];
                NSString *number =[dic objectForKey:@"number"];
                if ([number isEqualToString:userDic[@"number"]]) {
                    [self.selectedUserArray removeObjectAtIndex:i];
                }
            }
            [cell setIsSelected:NO];
        }
        for (UIImageView *view in [_headView subviews]) {
            if ([view isKindOfClass:[UIImageView class]]) {
                [view removeFromSuperview];
            }
        }
        for (int i=0;i<self.selectedUserArray.count;i++) {
            if (i<6) {
                NSLog(@"self.selectedUserArray===%@",self.selectedUserArray);
                NSDictionary  *dic = self.selectedUserArray[i];
                GetFriendModel*user = [dic objectForKey:@"user"];
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20+(20+35)*i, 10, 35, 35)];
                [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",serverUrl,user.photo]] placeholderImage:nil];
                [_headView addSubview:imageView];
            }
            else
            {
                
            }
        }
    }
    else
    {
        NSDictionary *userDic =[[self.arrayUser objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        NSIndexPath *index = [tableView indexPathForSelectedRow];
        CDImageLabelTableCell *cell = [tableView cellForRowAtIndexPath:index];
        NSArray*array = [self.selectedCellArray objectAtIndex:indexPath.section];
        NSMutableDictionary*dic = [array objectAtIndex:[indexPath row]];
        NSString *number = [dic objectForKey:@"number"];
        NSLog(@"self.arrayUser==%@",self.arrayUser);
        if ([[dic objectForKey:@"isSelected"]isEqualToString:@"NO"]) {
            [dic setValue:@"YES" forKey:@"isSelected"];
            [self.selectedUserArray addObject:[[self.arrayUser objectAtIndex:0]objectAtIndex:[number integerValue]-1]];
            [cell setIsSelected:YES];
        }else{
            [dic setValue:@"NO" forKey:@"isSelected"];
            for ( int i=0;i<self.selectedUserArray.count;i++) {
                 NSDictionary *dic = [self.selectedUserArray objectAtIndex:i];
                NSString *number =[dic objectForKey:@"number"];
                if ([number isEqualToString:userDic[@"number"]]) {
                    [self.selectedUserArray removeObjectAtIndex:i];
                }
            }
            [cell setIsSelected:NO];
        }
        for (UIImageView *view in [_headView subviews]) {
            if ([view isKindOfClass:[UIImageView class]]) {
                [view removeFromSuperview];
            }
        }
        for (int i=0;i<self.selectedUserArray.count;i++) {
            if (i<6) {
                 NSLog(@"selectedUserArray==%@",self.selectedUserArray);
                NSDictionary *dic = self.selectedUserArray[i];
                GetFriendModel*user = [dic objectForKey:@"user"];
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20+(20+35)*i, 10, 35, 35)];
                [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",serverUrl,user.photo]] placeholderImage:nil];
                [_headView addSubview:imageView];
            }
            else
            {
                
            }
        }
    }
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 60;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
