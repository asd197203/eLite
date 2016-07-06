//
//  XBPersonalViewController.m
//  eLite
//
//  Created by 常小哲 on 16/4/14.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBPersonalViewController.h"
#import "XBCellRightView.h"
#import "XBDatePickerView.h"
#import "XBChangePersonalInfoController.h"
#import "XBMyCodeVC.h"
@interface XBPersonalViewController ()<
UITableViewDataSource,
UITableViewDelegate,
UIActionSheetDelegate,
UIAlertViewDelegate> {
    __weak IBOutlet UITableView *_tableView;
    NSArray *_titles;
}

@end

@implementation XBPersonalViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_titles[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _titles[indexPath.section][indexPath.row];
    
    if (!indexPath.section) {
        if (!indexPath.row) {
            NSURL *imgURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",serverUrl, [XBUserDefault sharedInstance].resModel.photo]];
            NSLog(@"atavar URL : %@", imgURL);

            cell.accessoryView = [[XBCellRightView alloc] initWithFrame:CGRectMake(0, 0, 120, 80) imageURL:imgURL];
        }else {
            if (indexPath.row == 1) {
                cell.accessoryView = [[XBCellRightView alloc] initWithFrame:CGRectMake(0, 0, 200, 44) withTitle:[XBUserDefault sharedInstance].resModel.name];

            }else if (indexPath.row == 2) {
                cell.accessoryView = [[XBCellRightView alloc] initWithFrame:CGRectMake(0, 0, 200, 44) withTitle:[XBUserDefault sharedInstance].resModel.school];

            }else if (indexPath.row == 3)   {
                cell.accessoryView = [[XBCellRightView alloc] initWithFrame:CGRectMake(0, 0, 200, 44) withTitle:[XBUserDefault sharedInstance].resModel.cls];

            }
            else{
                 cell.accessoryView = [[XBCellRightView alloc] initWithFrame:CGRectMake(0, 0, 200, 44) withTitle:nil];
                
            }
        }
    }else {
        if (!indexPath.row) {
                        cell.accessoryView = [[XBCellRightView alloc] initWithFrame:CGRectMake(0, 0, 200, 44) withTitle:[XBUserDefault sharedInstance].resModel.birthday];

        } else if (indexPath.row == 1) {
            cell.accessoryView = [[XBCellRightView alloc] initWithFrame:CGRectMake(0, 0, 200, 44) withTitle:[XBUserDefault sharedInstance].resModel.sex];

        } else if (indexPath.row == 2) {

            
            cell.accessoryView = [[XBCellRightView alloc] initWithFrame:CGRectMake(0, 0, 200, 44) withTitle:[XBUserDefault sharedInstance].resModel.sign];
        }
    }
    
    return cell;
}

#pragma mark-  table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section && !indexPath.row) return 80;
    else return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (!indexPath.section) {
        if (!indexPath.row) {
            XBChangePersonalInfoController *vc = [[XBChangePersonalInfoController alloc] initWithPhotoURL:[XBUserDefault sharedInstance].resModel.photo];

            [self.navigationController pushViewController:vc animated:YES];
        }else {
            NSInteger tag = 0;
            if (indexPath.row == 1) {
                tag = 1001;
            }else if (indexPath.row == 2) {
                tag = 1002;
            }else if (indexPath.row == 3) {
                tag = 1003;
            }
            
            if (indexPath.row!=4) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:_titles[indexPath.section][indexPath.row]
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确定", nil];
                alert.tag = tag;
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                [alert show];
            }
            else
            {
                [self.navigationController pushViewController:[[XBMyCodeVC alloc] init] animated:YES];
            }
        }
        
    }else {
        if (!indexPath.row) {
            XBDatePickerView *view = [[[NSBundle mainBundle] loadNibNamed:@"XBDatePickerView" owner:nil options:nil] firstObject];
            [self.view addSubview:view];
            
            [view flyUp];
            
            view.block = ^(NSString *date) {
                NSLog(@"%@", date);
                [XBPersonBirthdayReq do:^(id req) {
                    XBPersonBirthdayReq *tmpReq = req;
                    tmpReq.userid = [XBUserDefault sharedInstance].resModel.userid;
                    tmpReq.birthday = date;
                    
                } Res:^(id res) {
                    XBPersonBirthdayRes *tmpRes = res;
                    if (tmpRes.code == 0) {
                        ALERT_ONE(@"修改成功");
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"change" object:nil];
                        XBUser *user = [XBUserDefault sharedInstance].resModel;
                        user.birthday = date;
                        [XBUserDefault saveUserInfoModel:user];
                        [_tableView reloadData];
                    }else {
                        ALERT_ONE(@"修改失败");
                    }
                } ShowHud:NO];
            };
        } else if (indexPath.row == 1) {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男", @"女",nil];
            [sheet showInView:self.view];
        } else if (indexPath.row == 2) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:_titles[indexPath.section][indexPath.row]
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
            alert.tag = 1004;
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alert show];

        }
    }

}

#pragma mark-  action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 2) {
        [XBPersonSexReq do:^(id req) {
            XBPersonSexReq *tmpReq = req;
            tmpReq.userid = [XBUserDefault sharedInstance].resModel.userid;
            tmpReq.sex = buttonIndex == 0 ? @"男" : @"女";
            
        } Res:^(id res) {
            XBPersonSexRes *tmpRes = res;
            if (tmpRes.code == 0) {
                ALERT_ONE(@"修改成功");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"change" object:nil];
                XBUser *user = [XBUserDefault sharedInstance].resModel;
                user.sex = buttonIndex == 0 ? @"男" : @"女";
                [XBUserDefault saveUserInfoModel:user];
                
                [_tableView reloadData];
                
            }else {
                ALERT_ONE(@"修改失败");
            }
        } ShowHud:NO];

    }
        NSLog(@"%ld", buttonIndex);
    
}


#pragma mark-  alert view delegate

- (void)willPresentAlertView:(UIAlertView *)alertView {
    UITextField *tf = [alertView textFieldAtIndex:0];
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;

    if (alertView.tag == 1001) {
        tf.text = [XBUserDefault sharedInstance].resModel.name;

    }else if (alertView.tag == 1002) {
        tf.text = [XBUserDefault sharedInstance].resModel.school;

    }
    else if (alertView.tag == 1003) {
        tf.text = [XBUserDefault sharedInstance].resModel.cls;
    }else {
        tf.text = [XBUserDefault sharedInstance].resModel.sign;

    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%ld", buttonIndex);
    
    if (buttonIndex) {
        UITextField * tf = [alertView textFieldAtIndex:0];
        if (!tf.text.length) {
            ALERT_ONE(@"更改不能为空");
            return;
        }
 
        if (alertView.tag == 1001) {
            [XBPersonNameReq do:^(id req) {
                XBPersonNameReq *tmpReq = req;
                tmpReq.userid = [XBUserDefault sharedInstance].resModel.userid;
                tmpReq.name = tf.text;
                
            } Res:^(id res) {
                XBPersonNameRes *tmpRes = res;
                if (tmpRes.code == 0) {
                    ALERT_ONE(@"修改成功");
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"change" object:nil];
                    XBUser *user = [XBUserDefault sharedInstance].resModel;
                    user.name =tf.text;
                    [XBUserDefault saveUserInfoModel:user];
                    [_tableView reloadData];

                }else {
                    ALERT_ONE(@"修改失败");
                }
            } ShowHud:NO];
            
        }else if (alertView.tag == 1002) {
            [XBPersonSchoolReq do:^(id req) {
                XBPersonSchoolReq *tmpReq = req;
                tmpReq.userid = [XBUserDefault sharedInstance].resModel.userid;
                tmpReq.school = tf.text;
                
            } Res:^(id res) {
                XBPersonSchoolRes *tmpRes = res;
                if (tmpRes.code == 0) {
                    ALERT_ONE(@"修改成功");
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"change" object:nil];
                    XBUser *user = [XBUserDefault sharedInstance].resModel;
                    user.school =tf.text;
                    [XBUserDefault saveUserInfoModel:user];
                    [_tableView reloadData];

                }else {
                    ALERT_ONE(@"修改失败");
                }
            } ShowHud:NO];
            
        }
        else if (alertView.tag == 1003) {
            [XBPersonClassReq do:^(id req) {
                XBPersonClassReq *tmpReq = req;
                tmpReq.userid = [XBUserDefault sharedInstance].resModel.userid;
                tmpReq.cls = tf.text;
                
            } Res:^(id res) {
                XBPersonClassRes *tmpRes = res;
                if (tmpRes.code == 0) {
                    ALERT_ONE(@"修改成功");
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"change" object:nil];
                    XBUser *user = [XBUserDefault sharedInstance].resModel;
                    user.cls =tf.text;
                    [XBUserDefault saveUserInfoModel:user];
                    [_tableView reloadData];

                }else {
                    ALERT_ONE(@"修改失败");
                }
            } ShowHud:NO];
        }else {
            [XBPersonSignReq do:^(id req) {
                XBPersonSignReq *tmpReq = req;
                tmpReq.userid = [XBUserDefault sharedInstance].resModel.userid;
                tmpReq.sign = tf.text;
                
            } Res:^(id res) {
                XBPersonSignRes *tmpRes = res;
                if (tmpRes.code == 0) {
                    ALERT_ONE(@"修改成功");
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"change" object:nil];
                    XBUser *user = [XBUserDefault sharedInstance].resModel;
                    user.sign =tf.text;
                    [XBUserDefault saveUserInfoModel:user];
                    [_tableView reloadData];

                }else {
                    ALERT_ONE(@"修改失败");
                }
            } ShowHud:NO];
        }
    }
}

#pragma mark-   Setter & Getter

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[
                    @[
                        @"头像",
                        @"昵称",
                        @"学校",
                        @"班级",
                        @"我的二维码"
                        ],
                    @[
                        @"生日",
                        @"性别",
                        @"个性签名"
                        ]
                    ];
    }
    return _titles;
}

@end
