//
//  CDChatListController.m
//  LeanChat
//
//  Created by Qihe Bian on 7/25/14.
//  Copyright (c) 2014 LeanCloud. All rights reserved.
//

#import "CDChatListVC.h"
#import "LZStatusView.h"
#import "UIView+XHRemoteImage.h"
#import "CDChatManager.h"
#import "AVIMConversation+Custom.h"
#import "UIView+XHRemoteImage.h"
#import "CDEmotionUtils.h"
#import "CDMessageHelper.h"
#import <DateTools/DateTools.h>
#import "CDConversationStore.h"
#import "CDChatManager_Internal.h"
#import "CDMacros.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "WBPopMenuModel.h"
#import "WBPopMenuSingleton.h"
#import "XBContactViewController.h"
#import "UIViewController+category.h"
#import "CDUserManager.h"
#import "CDAddFriendVC.h"
#import "GetUserListReq.h"
#import "HCScanQRViewController.h"
#import "SystemFunctions.h"
#import "XBUserInfoVC.h"
#import "XBCodeCrowdToJoinVC.h"
#import "GetCrowdListReq.h"
@interface CDChatListVC ()<HCScanQRViewControllerDelegate>

@property (nonatomic, strong) LZStatusView *clientStatusView;

@property (nonatomic, strong) NSMutableArray *conversations;
@property (nonatomic,assign)BOOL isRefreshing;
@property (nonatomic, strong) NSArray* listFriend;
@property (nonatomic, strong) NSArray* accentConversationArray;
@property (nonatomic, strong)NSMutableArray *objIdArray;//用来保存联系人列表的objid
@property (nonatomic,strong)NSArray  *crowdArray;
@property (nonatomic,strong)NSMutableArray *crowdArrayConversation;
@property (nonatomic,strong)NSMutableArray *userArray;
@property (nonatomic,strong)LZConversationCell *cell;
@end

static NSMutableArray *cacheConvs;

@implementation CDChatListVC

static NSString *cellIdentifier = @"ContactCell";

/**
 *  lazy load conversations
 *
 *  @return NSMutableArray
 */
- (NSMutableArray *)conversations
{
    if (_conversations == nil) {
        _conversations = [[NSMutableArray alloc] init];
    }
    return _conversations;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [LZConversationCell registerCellToTableView:self.tableView];
    self.objIdArray = [[NSMutableArray alloc]initWithCapacity:40];
    self.crowdArrayConversation = [[NSMutableArray alloc]initWithCapacity:40];
    self.userArray = [[NSMutableArray alloc]initWithCapacity:40];
    self.refreshControl = [self getRefreshControl];
    // 当在其它 Tab 的时候，收到消息 badge 增加，所以需要一直监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:kCDNotificationMessageReceived object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:kCDNotificationUnreadsUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStatusView) name:kCDNotificationConnectivityUpdated object:nil];
    //清空聊天记录
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteMessage) name:@"deleteMessage" object:nil];
    //监听删除好友时，将相应的对话给删除
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteConversationByDeleteFriend:) name:kCDNotificationDeleteFriendConversationUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteConversationByDeleteCrowd:) name:@"deleteCrowd" object:nil];
    [self updateStatusView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    UIButton*leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 18, 18);
    [leftButton setBackgroundImage:[UIImage imageNamed:@"更多"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(popTip) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.rightBarButtonItem = leftBarButtonItem;
    [self showProgress];
    [self findFriendsAndBadgeNumberWithBlock:^(NSArray *friends, NSInteger badgeNumber, NSError *error) {
        if ([self filterError:error]) {
            [self refreshWithFriends:friends badgeNumber:badgeNumber];
        }
    }];
}
-(void)deleteMessage
{
    for(AVIMConversation*conversation in self.conversations)
    {
     [[CDChatManager manager] deleteConversation:conversation];   
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
- (void)countNewAddRequestBadge:(AVIntegerResultBlock)block {
    [[CDUserManager manager] countUnreadAddRequestsWithBlock : ^(NSInteger number, NSError *error) {
        if (error) {
            block(0, nil);
        } else {
            block(number, nil);
        }
    }];
}
-(void)popTip
{
    NSMutableArray *obj = [NSMutableArray array];
    
    for (NSInteger i = 0; i < [self titles].count; i++) {
        
        WBPopMenuModel * info = [WBPopMenuModel new];
        info.image = [self images][i];
        info.title = [self titles][i];
        [obj addObject:info];
    }
    
    [[WBPopMenuSingleton shareManager]showPopMenuSelecteWithFrame:130
                                                             item:obj
                                                           action:^(NSInteger index) {
                                                               NSLog(@"index:%ld",(long)index);
                                                               if(index==0)
                                                               {
                                                                   //扫一扫
                                                                   HCScanQRViewController *scan = [[HCScanQRViewController alloc]init];
                                                                   //调用此方法来获取二维码信息
                                                                   scan.delegate =self;
                                                                   scan.hidesBottomBarWhenPushed = YES;
                                                                   [self.navigationController pushViewController:scan animated:YES];

                                                               }
                                                               else if (index==1)
                                                               {
                                                                   //加好友
                                                                   [self pushViewController:@"CDAddFriendVC" Param:nil];
                                                               }
                                                               else
                                                               {
                                                                   //群聊
                                                                   if (self.listFriend!=nil) {
                                                                        [self presentViewController:@"XBContactViewController" Param:@{@"listFriend":self.listFriend}];
                                                                   }
                                                                   else
                                                                   {
                                                                       MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                                                       //    hud.labelText=text;
                                                                       hud.detailsLabelFont = [UIFont systemFontOfSize:14];
                                                                       hud.detailsLabelText = @"当前没有好友，请加好友";
                                                                       hud.margin = 10.f;
                                                                       hud.removeFromSuperViewOnHide = YES;
                                                                       hud.mode = MBProgressHUDModeText;
                                                                       [hud hide:YES afterDelay:0.4];
                                                                   }
                                                                  
                                                               }
                                                           }];
}
- (NSArray *) titles {
    return @[@"扫一扫",
             @"加好友",
             @"群聊",
            ];
}

- (NSArray *) images {
    return @[@"扫一扫",
             @"添加好友",
             @"发起群聊",
            ];
}
- (void)successfulGetCodeInfo:(NSString *)info{
    if ([info containsString:@"person"]){
        XBUserInfoVC *InfoVC = [[XBUserInfoVC alloc]init];
        InfoVC.userID = [info componentsSeparatedByString:@"##"][1];
        InfoVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:InfoVC animated:YES];
    }else if([info containsString:@"group"])
    {
        XBCodeCrowdToJoinVC *vc =[[XBCodeCrowdToJoinVC alloc]init];
        vc.groupid =[info componentsSeparatedByString:@"##"][1];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else
    {
        [SystemFunctions showInSafariWithURLMessage:info Success:^(NSString *token) {
            
            
        } Failure:^(NSError *error) {
            
        }];
    }
}
//- (BOOL)checkIsUser:(NSString*)info
//{
//    NSString * MOBILE = @"^\\d{4}";
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    BOOL res1 = [regextestmobile evaluateWithObject:info];
//    if (res1)
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
//}
//-(BOOL)checkIsCrowd:(NSString*)info
//{
//    NSString * MOBILE = @"[a-z0-9]{24}";
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    BOOL res1 = [regextestmobile evaluateWithObject:info];
//    if (res1)
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
//    
//}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 刷新 unread badge 和新增的对话
    [self.userArray removeAllObjects];
    [self findFriendsAndBadgeNumberWithBlock:^(NSArray *friends, NSInteger badgeNumber, NSError *error) {
        if ([self filterError:error]) {
            [self refreshWithFriends:friends badgeNumber:badgeNumber];
        }
    }];
//    [self performSelector:@selector(refresh:) withObject:nil afterDelay:0];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCDNotificationConnectivityUpdated object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCDNotificationMessageReceived object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCDNotificationUnreadsUpdated object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCDNotificationDeleteFriendConversationUpdated object:nil];
}

#pragma mark - client status view

- (LZStatusView *)clientStatusView {
    if (_clientStatusView == nil) {
        _clientStatusView = [[LZStatusView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), kLZStatusViewHight)];
    }
    return _clientStatusView;
}

- (void)updateStatusView {
    if ([CDChatManager manager].connect) {
        self.tableView.tableHeaderView = nil ;
    }else {
        self.tableView.tableHeaderView = self.clientStatusView;
    }
}

- (UIRefreshControl *)getRefreshControl {
    UIRefreshControl *refreshConrol = [[UIRefreshControl alloc] init];
    [refreshConrol addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    return refreshConrol;
}
- (void)deleteConversationByDeleteFriend:(NSNotification*)noti
{
    AVUser *deleteUser = noti.userInfo[@"deleteUser"];
    for (AVIMConversation*conversation in self.conversations) {
        if(conversation.type == CDConversationTypeSingle)
        {
            for (NSString*objID in conversation.members) {
                if ([objID isEqualToString:deleteUser.objectId]) {
                    [[CDChatManager manager] deleteConversation:conversation];
                }
            }
        }
        else
        {

        }
    }
    [self refresh];
}
- (void)deleteConsationByDeleteFriendOrDeleteCrowd
{
    for (AVIMConversation*conversation in self.conversations) {
        if(conversation.type == CDConversationTypeSingle)
        {
            //单聊
            if (_listFriend.count==0) {
                [[CDChatManager manager] deleteConversation:conversation];
            }
            else
            {
                NSLog(@"------%@",self.objIdArray);
                NSLog(@"--------=====%@",conversation.members);
                if (![self.objIdArray containsObject:conversation.members[0]]) {
                    if(![self.objIdArray containsObject:conversation.members[1]])
                    {
                       [[CDChatManager manager] deleteConversation:conversation];
                    }
                }
            }
        }
        else
        {
            if (_crowdArray.count==0) {
                [[CDChatManager manager] deleteConversation:conversation];
            }
            else
            {
                if (![self.crowdArrayConversation containsObject:conversation.conversationId]) {
                    [[CDChatManager manager] deleteConversation:conversation];
                }
            }
        }
    }
    [self refresh];
}
- (void)deleteConversationByDeleteCrowd:(NSNotification*)noti
{
    NSString *actorID =noti.userInfo[@"actor"];
    for (AVIMConversation*conversation in self.conversations) {
        if(conversation.type == CDConversationTypeSingle)
        {
          //单聊什么都不做
            
        }
        else
        {
                if ([actorID isEqualToString:conversation.conversationId]) {
                    [[CDChatManager manager] deleteConversation:conversation];
                }
        }
    }
    [self refresh];
}
#pragma mark - refresh
- (void)refresh {
    [self refresh:nil];
}
- (void)refreshWithFriends:(NSArray *)friends badgeNumber:(NSInteger)number{
    if (number > 0) {
        [[self navigationController] tabBarItem].badgeValue = [NSString stringWithFormat:@"%ld", (long)number];
    } else {
        [[self navigationController] tabBarItem].badgeValue = nil;
    }
    [[CDChatManager manager] findGroupedConversationsWithBlock:^(NSArray *objects, NSError *error) {
        [self hideProgress];
        if ([self filterError:error]) {
            [GetCrowdListReq do:^(id req) {
                GetCrowdListReq *re =req;
                re.userid = [NSString stringWithFormat:@"%@",[XBUserDefault sharedInstance].resModel.userid];
            } Res:^(id res) {
                GetCrowdListRes *resq = res;
                if (resq.code==0) {
                    _crowdArray  =resq.data;
                    [self.crowdArrayConversation removeAllObjects];
                    for (GetCrowdListModel*model in _crowdArray) {
                        for (AVIMConversation *conv in objects) {
                            if ([conv.conversationId isEqualToString:model.groupid]) {
                                [self.crowdArrayConversation addObject:conv.conversationId];
                            }
                        }
                    }
                    [GetFriendListReq do:^(id req) {
                        GetFriendListReq *re = req;
                        re.userid = [XBUserDefault sharedInstance].resModel.userid;
                    } Res:^(id res) {
                        GetFriendListRes *resq = res;
                        if (resq.code==0) {
                            _listFriend = resq.data;
                            if (_listFriend.count==0) {
                                [self deleteConsationByDeleteFriendOrDeleteCrowd];
                            }
                            else
                            {
                                
                                for(int i=0;i<_listFriend.count;i++)
                                {
                                    GetFriendModel *model = _listFriend[i];
                                    NSLog(@"userid===%@",model.userid);
                                    [[CDUserManager manager] findUsersByPartname:[NSString stringWithFormat:@"%@",model.userid] withBlock: ^(NSArray *objects, NSError *error) {
                                        if (!error) {
                                            if (objects) {
                                                [self.userArray addObject:objects[0]];
                                                NSLog(@"userArray===%@",self.userArray);
                                                if (self.userArray.count==_listFriend.count)
                                                {
                                                    [self.objIdArray removeAllObjects];
                                                    for (AVUser *user in self.userArray) {
                                                        [self.objIdArray addObject:user.objectId];
                                                    }
                                                    NSLog(@"objIdArray===%@",self.objIdArray);
                                                    [self deleteConsationByDeleteFriendOrDeleteCrowd];
                                                }
                                            }
                                        }
                                    }];
                                }
                            }
                       }
                    } ShowHud:NO];
                }
            } ShowHud:NO];
        }
    }];
}
- (void)refresh:(UIRefreshControl *)refreshControl {
    if (self.isRefreshing) {
        return;
    }
    self.isRefreshing = YES;
    WEAKSELF
    [[CDChatManager manager] findRecentConversationsWithBlock:^(NSArray *conversations, NSInteger totalUnreadCount, NSError *error) {
        dispatch_block_t finishBlock = ^{
            [self stopRefreshControl:refreshControl];
            if ([self filterError:error]) {
                self.conversations = [NSMutableArray arrayWithArray:conversations];
                if (self.conversations.count!=0) {
                    BOOL hasSingleConversation=NO;
                    for (AVIMConversation *conv in self.conversations) {
                        if (conv.type ==CDConversationTypeSingle ) {
                            hasSingleConversation = YES;
                        }
                    }
                    if (hasSingleConversation) {
                        [GetUserListReq do:^(id req) {
                            GetUserListReq *re = req;
                            NSString *str=@"";
                            re.userid = [XBUserDefault sharedInstance].resModel.userid;
                            for (AVIMConversation*conversation in self.conversations) {
                                if(conversation.type == CDConversationTypeSingle)
                                {
                                    
                                    NSString * name = [AVIMConversation nameOfUserIds:conversation.members];
                                    if (!str) {
                                        str = name;
                                    }
                                    else
                                    {
                                        str =  [NSString stringWithFormat:@"%@,%@",str,name];
                                    }
                                    
                                }
                                else
                                {
                                    
                                }
                            }
                            re.users = [str stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@",[XBUserDefault sharedInstance].resModel.userid] withString:@""];
                        } Res:^(id res) {
                            GetUserListRes *resq = res;
                            [self hideProgress];
                            if (resq.code==0) {
                                self.accentConversationArray = resq.data;
                                [self.tableView reloadData];
                            }
                            else
                            {
                                [XBShowViewOnce showHUDText:resq.msg inVeiw:weakSelf.view];
                            }
                        } ShowHud:NO];
                    }
                    else
                    {
                        [self hideProgress];
                        [self.tableView reloadData];
                    }
                }
                else
                {
                  [self hideProgress];
                  [self.tableView reloadData];
                }
                if ([self.chatListDelegate respondsToSelector:@selector(setBadgeWithTotalUnreadCount:)]) {
                    [self.chatListDelegate setBadgeWithTotalUnreadCount:totalUnreadCount];
                }
                [self selectConversationIfHasRemoteNotificatoinConvid];
            }
            self.isRefreshing = NO;
        };
        
        if ([self.chatListDelegate respondsToSelector:@selector(prepareConversationsWhenLoad:completion:)]) {
            [self.chatListDelegate prepareConversationsWhenLoad:conversations completion:^(BOOL succeeded, NSError *error) {
                if ([self filterError:error]) {
                    finishBlock();
                } else {
                    [self stopRefreshControl:refreshControl];
                    self.isRefreshing = NO;
                }
            }];
        } else {
            finishBlock();
        }
    }];
}
- (void)selectConversationIfHasRemoteNotificatoinConvid {
    if ([CDChatManager manager].remoteNotificationConvid) {
        // 进入之前推送弹框点击的对话
        BOOL found = NO;
        for (AVIMConversation *conversation in self.conversations) {
            if ([conversation.conversationId isEqualToString:[CDChatManager manager].remoteNotificationConvid]) {
                if ([self.chatListDelegate respondsToSelector:@selector(viewController:didSelectConv:)]) {
                    [self.chatListDelegate viewController:self didSelectConv:conversation];
                    found = YES;
                }
            }
        }
        if (!found) {
            DLog(@"not found remoteNofitciaonID");
        }
        [CDChatManager manager].remoteNotificationConvid = nil;
    }
}
#pragma mark - utils

- (void)stopRefreshControl:(UIRefreshControl *)refreshControl {
    if (refreshControl != nil && [[refreshControl class] isSubclassOfClass:[UIRefreshControl class]]) {
        [refreshControl endRefreshing];
    }
}

- (BOOL)filterError:(NSError *)error {
    if (error) {
        [[[UIAlertView alloc]
          initWithTitle:nil message:[NSString stringWithFormat:@"%@", error] delegate:nil
          cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return NO;
    }
    return YES;
}
-(void)showProgress {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)hideProgress {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
#pragma mark - table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.conversations count];
}
- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LZConversationCell *cell = [LZConversationCell dequeueOrCreateCellByTableView:tableView];
    AVIMConversation *conversation = [self.conversations objectAtIndex:indexPath.row];
    if (conversation.type == CDConversationTypeSingle) {
        id<CDUserModelDelegate> user = [[CDChatManager manager].userDelegate getUserById:conversation.otherId];
        GetUerLisyModel*model=nil;
        for (int i=0;i<self.accentConversationArray.count;i++) {
            model = self.accentConversationArray[i];
            if ([user.username  isEqualToString:[NSString stringWithFormat:@"%@",model.userid]]) {
                if (![self isBlankString:model.remark]) {
                    cell.nameLabel.text = model.remark;
                }
                else
                {
                   cell.nameLabel.text = model.name;
                }
                if ([self.chatListDelegate respondsToSelector:@selector(defaultAvatarImage)] && model.photo) {
                    cell.avatarImageView.layer.cornerRadius = 4;
                    [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",serverUrl,model.photo]] placeholderImage:[self.chatListDelegate defaultAvatarImage]];
                } else {
                    [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:user.avatarUrl] placeholderImage:[UIImage imageNamed:@"lcim_conversation_placeholder_avator"]];
                }
            }
        }

    } else {
        [cell.avatarImageView setImage:[UIImage imageNamed:@"群聊"]];
        cell.avatarImageView.layer.cornerRadius = 4;
        cell.nameLabel.text = conversation.displayName;
        
    }
    if (conversation.lastMessage) {
        cell.messageTextLabel.attributedText = [[CDMessageHelper helper] attributedStringWithMessage:conversation.lastMessage conversation:conversation];
        cell.timestampLabel.text = [[NSDate dateWithTimeIntervalSince1970:conversation.lastMessage.sendTimestamp / 1000] timeAgoSinceNow];
    }
    if (conversation.unreadCount > 0) {
        if (conversation.muted) {
            cell.litteBadgeView.hidden = NO;
        } else {
            cell.badgeView.badgeText = [NSString stringWithFormat:@"%@", @(conversation.unreadCount)];
        }
    }
    if ([self.chatListDelegate respondsToSelector:@selector(configureCell:atIndexPath:withConversation:)]) {
        [self.chatListDelegate configureCell:cell atIndexPath:indexPath withConversation:conversation];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        AVIMConversation *conversation = [self.conversations objectAtIndex:indexPath.row];
        [[CDConversationStore store] deleteConversation:conversation];
        [self refresh];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.conversations[indexPath.row]==nil)
    {
        [XBShowViewOnce showHUDText:@"请刷新列表" inVeiw:self.view];
    }
    AVIMConversation *conversation = [self.conversations objectAtIndex:indexPath.row];
    [conversation markAsReadInBackground];
    [self refresh];
    if (conversation.type==CDConversationTypeSingle) {
        if ([self.chatListDelegate respondsToSelector:@selector(viewController:didSelectConv:)]) {
            [self.chatListDelegate viewController:self didSelectConv:conversation];
        }
    }
    else
    {
        if ([self.chatListDelegate respondsToSelector:@selector(viewController:didSelectConv:)]) {
            [self.chatListDelegate viewController:self didSelectConv:conversation];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [LZConversationCell heightOfCell];
}

@end
