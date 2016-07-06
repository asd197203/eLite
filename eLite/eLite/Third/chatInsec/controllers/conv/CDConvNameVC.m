//
//  CDConvNameVC.m
//  LeanChat
//
//  Created by lzw on 15/2/5.
//  Copyright (c) 2015年 LeanCloud. All rights reserved.
//

#import "CDConvNameVC.h"
#import "EditCrowdNameReq.h"
#import "SetFriendRemarkReq.h"
@interface CDConvNameVC ()

@property (strong, nonatomic) IBOutlet UITableViewCell *tableCell;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end

@implementation CDConvNameVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tableViewStyle = UITableViewStyleGrouped;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (!self.remark) {
        self.title = @"群聊名称";
    }
    else
    {
        self.title = @"备注信息";
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveName:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backPressed)];
    self.nameTextField.text = self.conv.displayName;
    self.tableView.scrollEnabled = NO;
    //FIXME:修改 tableView 的高度
}

- (void)backPressed {
    if (!self.remark) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)saveName:(id)sender {
 WEAKSELF
    if(!self.remark)
    {
        if (self.nameTextField.text.length > 0) {
            [self showProgress];
            AVIMConversationUpdateBuilder *updateBuilder = [self.conv newUpdateBuilder];
            [updateBuilder setName:self.nameTextField.text];
           
            [self.conv update:[updateBuilder dictionary] callback: ^(BOOL succeeded, NSError *error) {
                
                if ([self filterError:error]) {
                    [EditCrowdNameReq do:^(id req) {
                        EditCrowdNameReq *re = req;
                        re.groupid = self.conv.conversationId;
                        re.userid =[NSString stringWithFormat:@"%@",[XBUserDefault sharedInstance].resModel.userid];
                        re.name = self.nameTextField.text;
                    } Res:^(id res) {
                        EditCrowdNameRes *resq = res;
                        if (resq.code==0) {
                            [self hideProgress];
                            [[NSNotificationCenter defaultCenter] postNotificationName:kCDNotificationConversationUpdated object:nil];
                            [XBShowViewOnce showHUDText:@"修改成功" inVeiw:weakSelf.view];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [self backPressed];
                            });
                        }
                        else
                        {
                            [XBShowViewOnce showHUDText:resq.msg inVeiw:weakSelf.view];
                        }
                    } ShowHud:NO];
                }
            }];
        }
    }
    else
    {
        //修改好友备注
        [SetFriendRemarkReq do:^(id req) {
            SetFriendRemarkReq *re  =req;
            re.userid = [NSString stringWithFormat:@"%@",[XBUserDefault sharedInstance].resModel.userid];
            re.friendid = self.friendid;
            re.remark = self.nameTextField.text;
        } Res:^(id res) {
            SetFriendRemarkRes*resq = res;
            if (resq.code==0) {
                [XBShowViewOnce showHUDText:@"修改成功" inVeiw:weakSelf.view];
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
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(!self.remark)
    {
        self.nameTextField.text = self.conv.displayName;
    }
    else
    {
         self.nameTextField.text = self.remark;
    }
    return self.tableCell;
}

@end
