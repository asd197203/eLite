//
//  XBCodeCrowdToJoinVC.m
//  eLite
//
//  Created by lxx on 16/5/16.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBCodeCrowdToJoinVC.h"
#import "GetCrowdDetailReq.h"
#import "CDChatManager.h"
#import "JoinCrowdReq.h"
#import "CDIMService.h"
@interface XBCodeCrowdToJoinVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *button;
}
@property (nonatomic,copy)NSString  *groupname;
@property (nonatomic,assign)NSInteger count;
@property (nonatomic,assign)NSInteger isMember;
@property (nonatomic,strong)NSMutableArray *groupArray;
@end

@implementation XBCodeCrowdToJoinVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"群信息";
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    self.groupArray = [[NSMutableArray alloc]initWithCapacity:30];
    [GetCrowdDetailReq do:^(id req) {
        GetCrowdDetailReq*re =req;
        re.userid = [NSString stringWithFormat:@"%@",[XBUserDefault sharedInstance].resModel.userid];
        re.groupid = self.groupid;
    } Res:^(id res) {
        GetCrowdDetailRes*resq = res;
        if (resq.code ==0) {
            self.groupname =resq.data[@"name"];
            self.count = [resq.data[@"count"] integerValue];
            self.isMember = [resq.data[@"ismember"] integerValue];
            [[CDChatManager manager] findGroupedConversationsWithNetworkFirst:YES block:^(NSArray *objects, NSError *error) {
                if (!error) {
                    for (AVIMConversation *conv in objects) {
                        if ([conv.conversationId isEqualToString:self.groupid]) {
                            [self.groupArray addObject:conv];
                        }
                    }
                   [self.tableView reloadData];
                }
            }];
        }
    } ShowHud:YES];
}
-(void)showProgress {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)hideProgress {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)joinCrowd
{
    if (self.isMember) {
        //开始聊天
        AVIMConversation *conv= [self.groupArray objectAtIndex:0];
        [[CDIMService service] pushToChatRoomByConversation:conv fromNavigation:self.navigationController completion:nil];
    }
    else
    {
        //加入该群
        WEAKSELF
        [self showProgress];
        [[CDChatManager manager].client openWithCallback:^(BOOL succeeded, NSError *error) {
            AVIMConversationQuery *query = [[CDChatManager manager].client conversationQuery];
            [query getConversationById:self.groupid callback:^(AVIMConversation *conversation, NSError *error) {
                [conversation joinWithCallback:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        
                        [JoinCrowdReq do:^(id req) {
                            JoinCrowdReq *re =req;
                            re.userid = [NSString stringWithFormat:@"%@",[XBUserDefault sharedInstance].resModel.userid];
                            re.groupid = self.groupid;
                            
                        } Res:^(id res) {
                            JoinCrowdRes *resq =res;
                            [self hideProgress];
                            if (resq.code==0) {
                                [XBShowViewOnce showHUDText:@"已加入群" inVeiw:weakSelf.view];
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [self.navigationController popToRootViewControllerAnimated:YES];
                                });
                            }
                            else
                            {
                                [XBShowViewOnce showHUDText:resq.msg inVeiw:weakSelf.view];
                            }
                        } ShowHud:YES];
                    }
                }];
            }];
        }];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    static NSString *identifier = @"Cell";
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row==0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"群名称";
        cell.detailTextLabel.text = self.groupname;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"群人数";
        cell.detailTextLabel.text =[NSString stringWithFormat:@"%d",self.count];
    }
    return cell;
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width,200)];
    backView.backgroundColor = [UIColor clearColor];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 120, [UIScreen mainScreen].bounds.size.width-40, 40);
    [button setBackgroundColor:[UIColor hexStringToColor:@"#08ba04"]];
    if (self.isMember) {
        [button setTitle:@"开始聊天" forState:UIControlStateNormal];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(backView.frame.size.width/2-40, 165, 80, 30)];
        label.text = @"你已是群成员";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13];
        [backView addSubview:label];
    }
    else
    {
      [button setTitle:@"加入该群" forState:UIControlStateNormal];
    }
    [button addTarget:self action:@selector(joinCrowd) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius =4;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [backView addSubview:button];
    return backView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 200;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
