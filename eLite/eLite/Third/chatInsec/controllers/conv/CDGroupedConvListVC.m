//
//  CDGroupTableViewController.m
//
//
//  Created by lzw on 14/11/6.
//
//
#import "CDGroupedConvListVC.h"
#import "CDIMService.h"
#import "CDUtils.h"
#import "CDImageLabelTableCell.h"
#import "CDChatManager.h"
#import "GetCrowdListReq.h"
@interface CDGroupedConvListVC()
@property(nonatomic,strong)NSArray  *crowdArray;
@property(nonatomic,strong)NSMutableArray  *crowdArrayConversation;
@end
@implementation CDGroupedConvListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"群聊";
    self.crowdArrayConversation = [[NSMutableArray alloc]initWithCapacity:30];
    [CDImageLabelTableCell registerCellToTalbeView:self.tableView];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    [self loadConversationsWhenInit];
    [self refresh:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCDNotificationConversationUpdated object:nil];
}

- (void)loadConversationsWhenInit {
    [self showProgress];
    [[CDChatManager manager] findGroupedConversationsWithBlock:^(NSArray *objects, NSError *error) {
        [self hideProgress];
        if ([self filterError:error]) {
            self.dataSource = [objects mutableCopy];
            [GetCrowdListReq do:^(id req) {
                GetCrowdListReq *re =req;
                re.userid = [NSString stringWithFormat:@"%@",[XBUserDefault sharedInstance].resModel.userid];
            } Res:^(id res) {
                GetCrowdListRes *resq = res;
                if (resq.code==0) {
                    _crowdArray  =resq.data;
                    [self.crowdArrayConversation removeAllObjects];
                    for (GetCrowdListModel*model in _crowdArray) {
                        for (AVIMConversation *conv in self.dataSource) {
                            if ([conv.conversationId isEqualToString:model.groupid]) {
                                [self.crowdArrayConversation addObject:conv];
                            }
                        }
                    }
                    [self.tableView reloadData];
                }
            } ShowHud:YES];
        }
    }];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [[CDChatManager manager] findGroupedConversationsWithNetworkFirst:YES block:^(NSArray *objects, NSError *error) {
        [CDUtils stopRefreshControl:refreshControl];
        if ([self filterError:error]) {
            self.dataSource = [objects mutableCopy];
            [GetCrowdListReq do:^(id req) {
                GetCrowdListReq *re =req;
                re.userid = [NSString stringWithFormat:@"%@",[XBUserDefault sharedInstance].resModel.userid];
            } Res:^(id res) {
                GetCrowdListRes *resq = res;
                if (resq.code==0) {
                    _crowdArray  =resq.data;
                    [self.crowdArrayConversation removeAllObjects];
                    for (GetCrowdListModel*model in _crowdArray) {
                        for (AVIMConversation *conv in self.dataSource) {
                            if ([conv.conversationId isEqualToString:model.groupid]) {
                                [self.crowdArrayConversation addObject:conv];
                            }
                        }
                    }
                    [self.tableView reloadData];
                }
            } ShowHud:NO];
        }
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.crowdArrayConversation.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CDImageLabelTableCell *cell = [CDImageLabelTableCell createOrDequeueCellByTableView:tableView];
    cell.selectedImageView.hidden = YES;
    if(self.crowdArrayConversation.count!=0)
    {
        AVIMConversation *conv = [self.crowdArrayConversation objectAtIndex:indexPath.row];
        cell.myLabel.text = conv.name;
        [cell.myImageView setImage:[UIImage imageNamed:@"群聊"]];
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AVIMConversation *conv= [self.crowdArrayConversation objectAtIndex:indexPath.row];
    [[CDIMService service] pushToChatRoomByConversation:conv fromNavigation:self.navigationController completion:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        AVIMConversation *conv = [self.dataSource objectAtIndex:indexPath.row];
        WEAKSELF
        [conv quitWithCallback : ^(BOOL succeeded, NSError *error) {
            if ([self filterError:error]) {
                [weakSelf refresh:nil];
                [[CDChatManager manager] deleteConversation:conv];
            }
        }];
    }
}

@end
