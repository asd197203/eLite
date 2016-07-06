//
//  CDNewFriendTableViewController.m
//  LeanChat
//
//  Created by lzw on 14-10-23.
//  Copyright (c) 2014年 LeanCloud. All rights reserved.
//

#import "CDNewFriendVC.h"
#import "CDUserInfoVC.h"
#import "CDUtils.h"
#import "CDLabelButtonTableCell.h"
#import "CDAddRequest.h"
#import "CDUserManager.h"
#import "CDChatManager.h"
#import "AddFriendReq.h"
#import "GetUserListReq.h"
#import "CDAddFriendVC.h"
@interface CDNewFriendVC ()

@property (nonatomic, strong) NSArray *addRequests;
@property (nonatomic, assign) BOOL needRefreshFriendListVC;
@property (nonatomic, strong) NSMutableSet *fromUserSet;
@property (nonatomic, strong) NSArray *fromUserArray;
@end

@implementation CDNewFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"新的朋友";
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"contact_IconAdd"] style:UIBarButtonItemStylePlain target:self action:@selector(goAddFriend:)];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    [self refresh:nil];
}
- (void)goAddFriend:(id)sender {
    CDAddFriendVC *controller = [[CDAddFriendVC alloc] init];
    [[self navigationController] pushViewController:controller animated:YES];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.needRefreshFriendListVC) {
        [self.friendListVC refresh];
    }
}
- (void)refresh:(UIRefreshControl *)refreshControl {
    [self showProgress];
    WEAKSELF
    [[CDUserManager manager] findAddRequestsWithBlock : ^(NSArray *objects, NSError *error) {
        [self hideProgress];
        if (refreshControl) {
            [refreshControl endRefreshing];
        }
        if (error.code == kAVErrorObjectNotFound || error.code == kAVErrorCacheMiss) {
        }
        else {
            if ([self filterError:error]) {
                [self showProgress];
                [[CDUserManager manager] markAddRequestsAsRead:objects block:^(BOOL succeeded, NSError *error) {
                    [self hideProgress];
                    if (!error && objects.count > 0) {
                        self.needRefreshFriendListVC = YES;
                    }
                    _addRequests = objects;
                    NSMutableArray *array = [[NSMutableArray alloc]init];
                    for (CDAddRequest *request in _addRequests) {
                        [array addObject:request.fromUser];
                    }
                    self.fromUserSet = [[NSMutableSet alloc]initWithArray:array];
                    NSString *users  =@"";
                    for (AVUser *user in self.fromUserSet) {
                        if (!users) {
                            users = user.username;
                        }
                        else
                        {
                            users = [NSString stringWithFormat:@"%@,%@",users,user.username];
                        }
                    }
                    [GetUserListReq do:^(id req) {
                        GetUserListReq *re = req;
                        re.userid = [NSString stringWithFormat:@"%@",[XBUserDefault sharedInstance].resModel.userid];
                        re.users = users;
                    } Res:^(id res) {
                        [self hideProgress];
                        GetUserListRes *resq = res;
                        if (resq.code ==0) {
                            self.fromUserArray = resq.data;
                            [weakSelf.tableView reloadData];
                        }
                    } ShowHud:NO];
                  
                }];
            }
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _addRequests.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static BOOL isRegNib = NO;
    if (!isRegNib) {
        [tableView registerNib:[UINib nibWithNibName:@"CDLabelButtonTableCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    }
    CDLabelButtonTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    CDAddRequest *addRequest = [_addRequests objectAtIndex:indexPath.row];
    for (GetUerLisyModel *model in self.fromUserArray) {
        if ([[NSString stringWithFormat:@"%@",model.userid]isEqualToString:addRequest.fromUser.username]) {
            cell.nameLabel.text = [NSString stringWithFormat:@"%@(%@)",addRequest.fromUser.username,model.name];
            [cell.leftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",serverUrl,model.photo]] placeholderImage:nil];
        }
    }
    if (addRequest.status == CDAddRequestStatusWait) {
        cell.actionBtn.enabled = true;
        cell.actionBtn.tag = indexPath.row;
        [cell.actionBtn setTitle:@"添加" forState:UIControlStateNormal];
        cell.actionBtn.layer.cornerRadius = 4;
        cell.actionBtn.backgroundColor = [UIColor hexStringToColor:@"#08ba04"];
        [cell.actionBtn addTarget:self action:@selector(actionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else {
        cell.actionBtn.enabled = false;
        [cell.actionBtn setTitle:@"已添加" forState:UIControlStateNormal];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    return cell;
}

- (void)actionBtnClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    CDAddRequest *addRequest = [_addRequests objectAtIndex:btn.tag];
    [self showProgress];
    [[CDUserManager manager] agreeAddRequest : addRequest callback : ^(BOOL succeeded, NSError *error) {
        [self hideProgress];
        if ([self filterError:error]) {
            [self showProgress];
            [AddFriendReq do:^(id req) {
                AddFriendReq *re = req;
                re.userid = [XBUserDefault sharedInstance].resModel.userid;
                re.friendid = addRequest.fromUser.username;
            } Res:^(id res) {
                AddFriendRes *resq = res;
                if (resq.code==0) {
                    [[CDChatManager manager] sendWelcomeMessageToOther:addRequest.fromUser.objectId text:@"我们已经是好友了，来聊天吧" block:^(BOOL succeeded, NSError *error) {
                        [self hideProgress];
                        [self showHUDText:@"添加成功"];
                        [self refresh:nil];
                    }];
                }
            } ShowHud:NO];
        }
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    CDAddRequest *addRequest = self.addRequests[indexPath.row];
//    CDUserInfoVC *userInfoVC = [[CDUserInfoVC alloc] initWithUser:addRequest.fromUser];
//    [self.navigationController pushViewController:userInfoVC animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CDAddRequest *addRequest = self.addRequests[indexPath.row];
        [self showProgress];
        WEAKSELF
        [addRequest deleteInBackgroundWithBlock : ^(BOOL succeeded, NSError *error) {
            [weakSelf hideProgress];
            if ([weakSelf filterError:error]) {
                [weakSelf refresh:nil];
            }
        }];
    }
}

@end
