//
//  CDGroupDetailController.m
//  LeanChat
//
//  Created by lzw on 14/11/6.
//  Copyright (c) 2014年 LeanCloud. All rights reserved.
//

#import "CDBaseNavC.h"
#import "CDConvDetailVC.h"
#import "CDAddMemberVC.h"
#import "CDUserInfoVC.h"
#import "CDConvNameVC.h"
#import "CDConvReportAbuseVC.h"
#import "LZMembersCell.h"
#import "GetCrowdPeopleReq.h"
#import "CDCacheManager.h"
#import "CDUserManager.h"
#import "LZAlertViewHelper.h"
#import "CDChatManager.h"
#import "DeleteCrowdPeopleReq.h"
#import "ExitCrowdReq.h"
#import "DeleteCrowdReq.h"
#import "XBUserInfoVC.h"
#import "UIViewController+category.h"
#import "XBInviteToCrowdVC.h"
#import "XBCrowdCodeVC.h"
static NSString *kCDConvDetailVCTitleKey = @"title";
static NSString *kCDConvDetailVCDisclosureKey = @"disclosure";
static NSString *kCDConvDetailVCDetailKey = @"detail";
static NSString *kCDConvDetailVCSelectorKey = @"selector";
static NSString *kCDConvDetailVCSwitchKey = @"switch";

static NSString *const reuseIdentifier = @"Cell";

@interface CDConvDetailVC () <UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, LZMembersCellDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) LZMembersCell *membersCell;

@property (nonatomic, assign) BOOL own;

@property (nonatomic, strong) NSArray *displayMembers;//leancloud服务器群人员的数组

@property (nonatomic, strong) NSArray *DisMembers;//本地服务器群人员的数组

@property (nonatomic, strong) UITableViewCell *switchCell;

@property (nonatomic, strong) UISwitch *muteSwitch;

@property (nonatomic, strong) LZAlertViewHelper *alertViewHelper;

@property (nonatomic, strong, readwrite) AVIMConversation *conv;
@property (nonatomic, strong) NSString *actorID;
@property (nonatomic, strong) UIButton *manageButton;
@property (nonatomic,strong)NSMutableArray *listFriend;
@end

@implementation CDConvDetailVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tableViewStyle = UITableViewStyleGrouped;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:kCDNotificationConversationUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addMember) name:@"addCrowdUser" object:nil];
    [self setupDatasource];
    [self refresh];
    [self findFriendsAndBadgeNumberWithBlock:^(NSArray *friends, NSInteger badgeNumber, NSError *error) {
        if ([self filterError:error]) {
            [self refreshWithFriends:friends badgeNumber:badgeNumber];
        }
    }];
    
}
- (void)refreshWithFriends:(NSArray *)friends badgeNumber:(NSInteger)number{
    if (number > 0) {
        [[self navigationController] tabBarItem].badgeValue = [NSString stringWithFormat:@"%ld", (long)number];
    } else {
        [[self navigationController] tabBarItem].badgeValue = nil;
    }
    self.listFriend = [friends mutableCopy];
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
- (void)countNewAddRequestBadge:(AVIntegerResultBlock)block {
    [[CDUserManager manager] countUnreadAddRequestsWithBlock : ^(NSInteger number, NSError *error) {
        if (error) {
            block(0, nil);
        } else {
            block(number, nil);
        }
    }];
}
- (void)setupDatasource {
    NSDictionary *dict1 = @{
                            kCDConvDetailVCTitleKey : @"举报",
                            kCDConvDetailVCDisclosureKey : @YES,
                            kCDConvDetailVCSelectorKey : NSStringFromSelector(@selector(goReportAbuse))
                            };
    NSDictionary *dict2 = @{
                            kCDConvDetailVCTitleKey : @"消息免打扰",
                            kCDConvDetailVCSwitchKey : @YES
                            };
    if (self.conv.type == CDConversationTypeGroup) {
        self.dataSource = [@[
                             @{
                                 kCDConvDetailVCTitleKey : @"群聊名称",
                                 kCDConvDetailVCDisclosureKey : @YES,
                                 kCDConvDetailVCDetailKey : self.conv.displayName,
                                 kCDConvDetailVCSelectorKey : NSStringFromSelector(@selector(goChangeName))
                                 },
                             dict2,
                             dict1,
                             @{
                                 kCDConvDetailVCTitleKey : @"删除并退出",
                                 kCDConvDetailVCSelectorKey:NSStringFromSelector(@selector(quitConv))
                                 }
                             ] mutableCopy];
    } else {
        self.dataSource = [@[ dict2, dict1 ] mutableCopy];
    }
}

#pragma mark - Propertys

- (UISwitch *)muteSwitch {
    if (_muteSwitch == nil) {
        _muteSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        [_muteSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_muteSwitch setOn:self.conv.muted];
    }
    return _muteSwitch;
}

/* fetch from memory cache ,it is possible be nil ,if nil, please fetch from server with `refreshCurrentConversation:`*/
- (AVIMConversation *)conv {
    return [[CDCacheManager manager] currentConversationFromMemory];
}

- (LZAlertViewHelper *)alertViewHelper {
    if (_alertViewHelper == nil) {
        _alertViewHelper = [[LZAlertViewHelper alloc] init];
    }
    return _alertViewHelper;
}

#pragma mark

- (LZMember *)memberFromUser:(AVUser *)user {
    LZMember *member = [[LZMember alloc] init];
    member.memberId = user.objectId;
    member.memberName = user.username;
    return member;
}

- (void)refresh {
    [[CDCacheManager manager] fetchCurrentConversationIfNeeded:^(AVIMConversation *conversation, NSError *error) {
        if (!error) {
            self.conv  = conversation;
            [GetCrowdPeopleReq do:^(id req) {
                GetCrowdPeopleReq*re = req;
                re.userid = [XBUserDefault sharedInstance].resModel.userid;
                re.groupid = conversation.conversationId;
            } Res:^(id res) {
                GetCrowdPeopleRes*resq =res;
                if (resq.code==0) {
                    self.actorID = [NSString stringWithFormat:@"%@",resq.data[@"createrid"]];
                    self.DisMembers = resq.data[@"member"];
                    [self setupBarButton];
                    [self unsafeRefresh];
                }
                else
                {
                    ALERT_ONE(resq.msg);
                }
            } ShowHud:YES];
        } else {
            [self alertError:error];
        }
    }];
}

/*
 * the members of conversation is possiable 0 ,so we call it unsafe
 */
- (void)unsafeRefresh {
    NSAssert(self.conv, @"the conv is nil in the method of `refresh`");
    NSSet *userIds = [NSSet setWithArray:self.conv.members];
    self.own = [self.conv.creator isEqualToString:[AVUser currentUser].objectId];
    self.title = [NSString stringWithFormat:@"详情(%ld人)", (long)self.conv.members.count];
    [self showProgress];
    [[CDCacheManager manager] cacheUsersWithIds:userIds callback: ^(BOOL succeeded, NSError *error) {
        if ([self filterError:error]) {
            [self hideProgress];
            NSMutableArray *displayMembers = [NSMutableArray array];
            for (NSString *userId in userIds) {
                [displayMembers addObject:[self memberFromUser:[[CDCacheManager manager] lookupUser:userId]]];
            }
            self.displayMembers = displayMembers;
            [self.tableView reloadData];
        }
    }];
}
- (void)setupBarButton {
    if ([self.actorID isEqualToString:[NSString stringWithFormat:@"%@",[XBUserDefault sharedInstance].resModel.userid]]) {
        _manageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _manageButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _manageButton.frame = CGRectMake(0, 0, 30, 25);
        [_manageButton setTitle:@"管理" forState:UIControlStateNormal];
        [_manageButton setTitle:@"完成" forState:UIControlStateSelected];
        [_manageButton setTitleColor:[UIColor hexStringToColor:@"#08ba04"] forState:UIControlStateNormal];
        [_manageButton addTarget:self action:@selector(manageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *addMember = [[UIBarButtonItem alloc]initWithCustomView:_manageButton];
        self.navigationItem.rightBarButtonItem = addMember;
    }
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 42)];
    backView.backgroundColor = [UIColor clearColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 0, [UIScreen mainScreen].bounds.size.width-40, 42);
    [button setBackgroundColor:[UIColor hexStringToColor:@"#f34510"]];
    [button setTitle:@"删除并退出" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(quitConv) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius =4;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [backView addSubview:button];
    self.tableView.tableFooterView = backView;
    
}
- (void)manageButtonClick:(UIButton*)sender
{
    sender.selected = !sender.selected;
    [[NSNotificationCenter defaultCenter] postNotificationName:kCDNotificationDelete object:nil userInfo:@{@"sender":sender}];
    [self.tableView reloadData];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCDNotificationConversationUpdated object:nil];
}

#pragma mark - tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.actorID isEqualToString:[NSString stringWithFormat:@"%@",[XBUserDefault sharedInstance].resModel.userid]]) {
        return 3;
    }
    else
    {
        return 3;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        LZMembersCell *cell = [LZMembersCell dequeueOrCreateCellByTableView:tableView];
        cell.members = self.displayMembers;
        cell.conMembers = self.DisMembers;
        cell.membersCellDelegate = self;
        return cell;
    }
    else
    {
        UITableViewCell *cell;
        static NSString *identifier = @"Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        if (indexPath.row==1) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"群名称";
            cell.detailTextLabel.text = self.conv.displayName;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"群二维码";
        }
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [LZMembersCell heightForMemberCount:self.displayMembers.count+1];
    } else {
        return 44;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        return;
    }
    else if (indexPath.row==1)
    {
      [self goChangeName];
    }
    else
    {
        XBCrowdCodeVC *crowdCodeVC = [[XBCrowdCodeVC alloc]init];
        crowdCodeVC.conv = self.conv;
        [self.navigationController pushViewController:crowdCodeVC animated:YES];
    }
}
#pragma mark - member cell delegate

- (void)didSelectMember:(LZMember *)member {
    AVUser *user = [[CDCacheManager manager] lookupUser:member.memberId];
    if ([[AVUser currentUser].objectId isEqualToString:user.objectId] == YES) {
        return;
    }
    XBUserInfoVC *userInfoVC = [[XBUserInfoVC alloc]init];
    userInfoVC.userID =[NSString stringWithFormat:@"%@",user.username];
    userInfoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userInfoVC animated:YES];

}
- (void)deleteMember:(LZMember *)memeber
{
    AVUser *user = [[CDCacheManager manager] lookupUser:memeber.memberId];
    WEAKSELF
    if ([user.objectId isEqualToString:self.conv.creator] == NO) {
        [self.alertViewHelper showConfirmAlertViewWithMessage:@"确定要踢走该成员吗？" block:^(BOOL confirm, NSString *text) {
            if (confirm) {
                [weakSelf showProgress];
                [weakSelf.conv removeMembersWithClientIds:@[ user.objectId ] callback : ^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        [DeleteCrowdPeopleReq do:^(id req) {
                            DeleteCrowdPeopleReq *re = req;
                            re.groupid = self.conv.conversationId;
                            re.userid = [NSString stringWithFormat:@"%@",[XBUserDefault sharedInstance].resModel.userid];
                            re.id = user.username;
                        } Res:^(id res) {
                            DeleteCrowdPeopleRes *resq =res;
                            if (resq.code==0) {
                                [weakSelf hideProgress];
                                [XBShowViewOnce showHUDText:@"踢出成功" inVeiw:weakSelf.view];
                                [self refresh];
                            };
                        } ShowHud:NO];
                    }
                }];
            }
        }];
    }
    else
    {
       [XBShowViewOnce showHUDText:@"不能提出自己" inVeiw:self.view];
    }
}
- (void)displayAvatarOfMember:(LZMember *)member atImageView:(UIImageView *)imageView {
    AVUser *user = [[CDCacheManager manager] lookupUser:member.memberId];
    [[CDUserManager manager] displayAvatarOfUser:user avatarView:imageView];
}

#pragma mark - Action

- (void)goReportAbuse {
    CDConvReportAbuseVC *reportAbuseVC = [[CDConvReportAbuseVC alloc] initWithConversationId:self.conv.conversationId];
    [self.navigationController pushViewController:reportAbuseVC animated:YES];
}

- (void)switchValueChanged:(UISwitch *)theSwitch {
    AVBooleanResultBlock block = ^(BOOL succeeded, NSError *error) {
        [self alertError:error];
    };
    if ([theSwitch isOn]) {
        [self.conv muteWithCallback:block];
    }
    else {
        [self.conv unmuteWithCallback:block];
    }
}

- (void)goChangeName {
    CDConvNameVC *vc = [[CDConvNameVC alloc] init];
    vc.detailVC = self;
    vc.conv = self.conv;
    CDBaseNavC *nav = [[CDBaseNavC alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
- (void)addMember {
    if (self.listFriend!=nil) {
        XBInviteToCrowdVC *vc = [[XBInviteToCrowdVC alloc]init];
        vc.listFriend = self.listFriend;
        vc.conv = self.conv;
        vc.DetailVC  =self;
        vc.isInCrowdArray = self.DisMembers;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [self.navigationController presentViewController:nav animated:YES completion:nil];

    }
    else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //    hud.labelText=text;
        hud.detailsLabelFont = [UIFont systemFontOfSize:14];
        hud.detailsLabelText = @"请检查网络";
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        hud.mode = MBProgressHUDModeText;
        [hud hide:YES afterDelay:0.4];
    }
}
- (void)quitConv {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定删除并退出群？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!buttonIndex) {
        WEAKSELF
        [self showProgress];
        if ([self.actorID isEqualToString:[NSString stringWithFormat:@"%@",[XBUserDefault sharedInstance].resModel.userid]]) {
            [self.conv removeMembersWithClientIds:self.conv.members callback:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [weakSelf.conv quitWithCallback:^(BOOL succeeded, NSError *error) {
                        if ([self filterError:error]) {
                            [DeleteCrowdReq do:^(id req) {
                                DeleteCrowdReq *re = req;
                                re.userid = [NSString stringWithFormat:@"%@",[XBUserDefault sharedInstance].resModel.userid];
                                re.groupid = self.conv.conversationId;
                            } Res:^(id res) {
                                DeleteCrowdRes *resq =res;
                                if (resq.code==0) {
                                    [self hideProgress];
                                    [XBShowViewOnce showHUDText:@"群已删除" inVeiw:weakSelf.view];
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteCrowd" object:nil userInfo:@{@"actor":weakSelf.conv.conversationId}];
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                        [self.navigationController popToRootViewControllerAnimated:YES];
                                    });
                                    
                                }
                            } ShowHud:NO];
                        }
                    }];
                }
            }];
        }
        else
        {
            [self.conv quitWithCallback:^(BOOL succeeded, NSError *error) {
                if ([self filterError:error]) {
                    [ExitCrowdReq do:^(id req) {
                        ExitCrowdReq *re =req;
                        re.userid = [NSString stringWithFormat:@"%@",[XBUserDefault sharedInstance].resModel.userid];
                        re.groupid = self.conv.conversationId;
                    } Res:^(id res) {
                        ExitCrowdRes *resq =res;
                        if (resq.code==0) {
                            [self hideProgress];
                            [XBShowViewOnce showHUDText:@"群已退出" inVeiw:weakSelf.view];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteCrowd" object:nil userInfo:@{@"actor":weakSelf.conv.conversationId}];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [self.navigationController popToRootViewControllerAnimated:YES];
                            });
                        }
                    } ShowHud:NO];
                }
            }];
        }
    }
}
@end
