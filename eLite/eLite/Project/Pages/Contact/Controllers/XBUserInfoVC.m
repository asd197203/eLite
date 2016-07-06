//
//  XBUserInfoVC.m
//  eLite
//
//  Created by lxx on 16/4/18.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBUserInfoVC.h"
#import "CDUserManager.h"
#import "CDChatManager.h"
#import "GetUserInfoReq.h"
#import "XBUserDefault.h"
#import "DeleteFriendReq.h"
#import "XBShowViewOnce.h"
#import "UIColor+category.h"
#import "Util.h"
#import "AddFriendReq.h"
#import "UIImageView+WebCache.h"
#import "XBCommonDefines.h"
#import "CDConvNameVC.h"
#import "XBRecommendCheckPicController.h"
@interface XBUserInfoVC ()<UIAlertViewDelegate>
@property (nonatomic, assign) BOOL needRefreshFriendListVC;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentViewConstraintTop;
@property (strong, nonatomic) NSDictionary *userDic;
@end
@implementation XBUserInfoVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"个人详情";
    self.deleteFriendButton.hidden =YES;
    self.addFriendButton.hidden = YES;
    self.sendMessageButton.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoSetRemark)];
    [self.setRemarkView addGestureRecognizer:tap];
    self.hearImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapHeader = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoBigHeaderView)];
    [self.hearImageView addGestureRecognizer:tapHeader];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.hearImageView.cornerRadius = 4;
    self.deleteFriendButton.backgroundColor = [UIColor hexStringToColor:@"#f34510"];
    self.deleteFriendButton.cornerRadius = 5;
    self.addFriendButton.backgroundColor = [UIColor hexStringToColor:@"#08ba04"];
    self.addFriendButton.cornerRadius = 5;
    self.sendMessageButton.cornerRadius =5;
    self.sendMessageButton.backgroundColor = [UIColor hexStringToColor:@"#08ba04"];
    self.nichengLabel.textColor = [UIColor hexStringToColor:@"#999999"];
     self.brithDayLabel.textColor = [UIColor hexStringToColor:@"#999999"];
     self.schoolLabel.textColor = [UIColor hexStringToColor:@"#999999"];
     self.classLabel.textColor = [UIColor hexStringToColor:@"#999999"];
    WEAKSELF
    [GetUserInfoReq do:^(id req) {
        GetUserInfoReq*re =req;
        re.userid = [XBUserDefault sharedInstance].resModel.userid;
        re.friendid = _userID;
    } Res:^(id res) {
        GetUserInfoRes *resq = res;
        if (resq.code==0) {
            _userDic = resq.data;
            if ([_userDic[@"isfriend"] integerValue]==1) {
                if([_userDic[@"remark"] isEqualToString:@""])
                {
                    self.remarkNameLabelWidth.constant = [Util getSizeWithText:_userDic[@"name"] font:[UIFont systemFontOfSize:15]].width+1;
                   self.remarkNameLabel.text = _userDic[@"name"];
                }
                else
                {
                    self.remarkNameLabelWidth.constant = [Util getSizeWithText:[NSString stringWithFormat:@"%@(%@)",_userDic[@"remark"],_userDic[@"name"]] font:[UIFont systemFontOfSize:15]].width+1;
                   self.remarkNameLabel.text = [NSString stringWithFormat:@"%@(%@)",_userDic[@"remark"],_userDic[@"name"]];
                }
                self.deleteFriendButton.hidden =NO;
                self.sendMessageButton.hidden=NO;
            }
            else
            {
                self.addFriendButton.hidden = NO;
                self.setRemarkView.hidden =YES;
                self.contentViewConstraintTop.constant = 10;
                self.remarkNameLabelWidth.constant = [Util getSizeWithText:[NSString stringWithFormat:@"%@",_userDic[@"name"]] font:[UIFont systemFontOfSize:15]].width+1;
                self.addFriendButtonTopConstraint.constant = 25;
                self.remarkNameLabel.text = [NSString stringWithFormat:@"%@",_userDic[@"name"]];
            }
            if ([_userDic[@"sex"] isEqualToString:@"男"]) {
                self.sexIImageView.image = [UIImage imageNamed:@"sex_boy"];
            }
            else
            {
                self.sexIImageView.image = [UIImage imageNamed:@"sex_girl"];
            }
            if (![_userDic[@"school"]isEqualToString:@""]) {
                self.schoolLabelWidth.constant =[Util getSizeWithText:_userDic[@"school"] font:[UIFont systemFontOfSize:15]].width+1;
                self.schoolLabel.text = _userDic[@"school"];
            }
            else
            {
                self.schoolLabel.text = @"未填写";
            }
            if (![_userDic[@"cls"]isEqualToString:@""]) {
                self.schoolLabelWidth.constant =[Util getSizeWithText:_userDic[@"cls"] font:[UIFont systemFontOfSize:15]].width+1;
                self.schoolLabel.text = _userDic[@"cls"];
            }
            else
            {
                self.schoolLabel.text = @"未填写";
            }
            self.nichengLabel.text = [NSString stringWithFormat:@"%@",_userDic[@"sign"]];
            self.brithDayLabel.text =_userDic[@"birthday"]==nil?@"未填写":_userDic[@"birthday"];
            [self.hearImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",serverUrl,_userDic[@"photo"]]] placeholderImage:[UIImage imageNamed:@"tabbar_selected_3"]];
            [[CDUserManager manager] findUsersByPartname:[NSString stringWithFormat:@"%@",_userDic[@"userid"]] withBlock: ^(NSArray *objects, NSError *error) {
                if (!error) {
                    if (objects) {
                        if(objects.count==0)
                        {
                            [XBShowViewOnce showHUDText:@"未找到该用户" inVeiw:weakSelf.view];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [self.navigationController popToRootViewControllerAnimated:YES];
                            });
                        }
                        else
                        {
                            self.user = objects[0];
                        }
                    }
                }
            }];
        }
        else
        {
            [XBShowViewOnce showHUDText:@"查询失败" inVeiw:weakSelf.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }
    } ShowHud:YES];
    [self.sendMessageButton addTarget:self action:@selector(sendMessageClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteFriendButton addTarget:self action:@selector(deleteFriendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
      [self.addFriendButton addTarget:self action:@selector(addFriendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)gotoBigHeaderView
{
    XBRecommendCheckPicController *vc = [[XBRecommendCheckPicController alloc] init];
    vc.imageURL = [NSString stringWithFormat:@"%@%@",serverUrl,_userDic[@"photo"]];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.needRefreshFriendListVC) {
        [self.friendListVC refresh];
    }
}
- (void)gotoSetRemark
{
    CDConvNameVC *remarkVC = [[CDConvNameVC alloc]init];
    if([_userDic[@"remark"] isEqualToString:@""])
    {
        remarkVC.remark = _userDic[@"name"];
    }
    else
    {
      remarkVC.remark = _userDic[@"remark"];
    }
    remarkVC.friendid = _userID;
    [self.navigationController pushViewController:remarkVC animated:YES];
}
-(void)sendMessageClick:(UIButton*)sender
{
    sender.userInteractionEnabled =NO;
    if (self.user.objectId==nil) {
        [XBShowViewOnce showHUDText:@"请检查网络" inVeiw:self.view];
    }
    else
    {
        [[CDIMService service] createChatRoomByUserId:self.user.objectId fromViewController:self completion:nil];
    }
}
-(void)deleteFriendButtonClick:(UIButton*)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"解除好友关系吗" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    WEAKSELF
    if (!buttonIndex) {
        [self showProgress];
        [DeleteFriendReq do:^(id req) {
            DeleteFriendReq*re = req;
            re.userid =[[XBUserDefault sharedInstance].resModel.userid integerValue];
            re.friendid =[_userID integerValue];
        } Res:^(id res) {
            DeleteFriendRes *resq = res;
            if (resq.code ==0) {
                [[CDUserManager manager]removeFriend:weakSelf.user callback:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        [self hideProgress];
                         self.needRefreshFriendListVC = YES;
                        [[CDChatManager manager] sendWelcomeMessageToOther:self.user.objectId text:@"我已将你删除####" block:^(BOOL succeeded, NSError *error) {
                            if(succeeded)
                            {
                                [XBShowViewOnce showHUDText:@"删除成功" inVeiw:self.view];
                                [[NSNotificationCenter defaultCenter]postNotificationName:kCDNotificationDeleteFriendConversationUpdated object:nil userInfo:@{@"deleteUser":self.user}];
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [self.navigationController popToRootViewControllerAnimated:YES];
                                });
                            }
                        }];
                        
                    }
                }];
            }
            else
            {
                [XBShowViewOnce showHUDText:@"删除失败" inVeiw:self.view];
            }
        } ShowHud:NO];
    }
}
-(void)addFriendButtonClick:(UIButton*)sender
{
        [self showProgress];
        if(!self.user)
        {
           [XBShowViewOnce showHUDText:@"请检查网络" inVeiw:self.view];
        }
        else
        {
            [[CDUserManager manager] tryCreateAddRequestWithToUser:self.user callback: ^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSString *text = [NSString stringWithFormat:@"%@ 申请加你为好友", [XBUserDefault sharedInstance].resModel.name];
                    [[LZPushManager manager] pushMessage:text userIds:@[self.user.objectId] block:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            [self hideProgress];
                            [XBShowViewOnce showHUDText:@"申请成功" inVeiw:self.view];
                        }
                        
                    }];
                }
            }];
        }
}
-(void)showProgress {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)hideProgress {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)alert:(NSString*)msg {
    UIAlertView *alertView=[[UIAlertView alloc]
                            initWithTitle:nil message:msg delegate:nil
                            cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

- (BOOL)alertError:(NSError *)error {
    if (error) {
        [AVAnalytics event:@"Alert Error" attributes:@{@"desc": error.description}];
    }
    if (error) {
        if (error.code == kAVIMErrorConnectionLost) {
            [self alert:@"未能连接聊天服务"];
        }
        else if ([error.domain isEqualToString:NSURLErrorDomain]) {
            [self alert:@"网络连接发生错误"];
        }
        else {
#ifndef DEBUG
            [self alert:[NSString stringWithFormat:@"%@", error]];
#else
            NSString *info = error.localizedDescription;
            [self alert:info ? info : [NSString stringWithFormat:@"%@", error]];
#endif
        }
        return YES;
    }
    return NO;
}

- (BOOL)filterError:(NSError *)error {
    return [self alertError:error] == NO;
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
