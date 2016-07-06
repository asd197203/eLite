//
//  XBRegisterViewController.m
//  eLite
//
//  Created by 常小哲 on 16/4/13.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBRegisterViewController.h"
#import "XBRegisterTableViewCell.h"
#import "CXZSelectAvatarController.h"
#import "UIColor+category.h"
#import "NSData+category.h"
#import "XBRegistNextVC.h"
#import "XBDatePickerView.h"
#import "UIViewController+category.h"

static NSInteger const BaseTag = 100;

@interface XBRegisterViewController ()<
UITableViewDelegate,
UITableViewDataSource,
UIActionSheetDelegate> {
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet UIButton *backButton;
    NSArray *_titles;
    NSArray *_placeHolderTitles;
    UIView *_tableViewHead;
    UIView *_tableViewFoot;
    
    UIImage *_avatar;
}
@property(nonatomic,strong)NSArray  *keyArr;
@end

@implementation XBRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _keyArr = @[@"name",@"pwd",@"pwdConfirm",@"birthday",@"school",@"class",@"sex"];
    _tableView.tableHeaderView = [self tableViewHead];
    _tableView.tableFooterView = [self tableViewFoot];
    [backButton setTitleColor:[UIColor hexStringToColor:@"#09bb07"] forState:UIControlStateNormal];
}

#pragma mark-   touch action

- (IBAction)pressBackButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pressNextButtonAction:(UIButton *)sender {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    NSString *psw , *confirmPsw;
    for (int i = 0; i < 7; i ++) {
        XBRegisterTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (cell.inputTextField.text.length < 1 || !cell.inputTextField.text) {
            ALERT_ONE(@"请完善资料");
            return;
        }
        if ([cell.inputTextField.text rangeOfString:@" "].location != NSNotFound) {
            ALERT_ONE(@"不允许使用空格，请重新输入");
            return;
        }
        
        if ( i == 1) {
            psw = cell.inputTextField.text;
        }
        if (i == 2){
            confirmPsw = cell.inputTextField.text;
        }
        
        dict[_keyArr[i]] = cell.inputTextField.text;
    }
    
    if (![psw isEqualToString:confirmPsw]) {
        ALERT_ONE(@"两次密码不一致");
        return;
    }
    
    if (psw.length < 6) {
        ALERT_ONE(@"密码长度小于6位");
        return;
    }
    if (!_avatar) {
        ALERT_ONE(@"请上传头像");
        return;
    }
    XBRegistNextVC *nextVC = [[XBRegistNextVC alloc] init];
    if (_avatar) {
        NSData *imageData = UIImageJPEGRepresentation(_avatar, 0.5);
        imageData.fileType=@"png";
        [dict setObject:imageData forKey:@"photo"];
    }
    nextVC.registUserDic = dict;
   [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)pressAvatarButtonAction:(UIButton *)sender {
    CXZSelectAvatarController *seletAvatar = [[CXZSelectAvatarController alloc] initWithController:self];
    [seletAvatar showForPicture:^(UIImage *selectedImage) {
        // 头像;
        _avatar = selectedImage;
        [sender setBackgroundImage:selectedImage forState:UIControlStateNormal];
    }];
}

#pragma mark- Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self titles].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * reuseIdentifier = @"cell";
    XBRegisterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = LoadXibWithClass(XBRegisterTableViewCell);
    }
    cell.tipLabel.text = _titles[indexPath.row];
    cell.inputTextField.placeholder = [self placeHolderTitles][indexPath.row];
    cell.inputTextField.tag = indexPath.row;
    
    if (indexPath.row == 1 || indexPath.row == 2) {
        cell.inputTextField.secureTextEntry = YES;
    }
    
    if (indexPath.row == 3 || indexPath.row == 6) {
        cell.inputTextField.enabled = NO;
    }
    
    return cell;
}

#pragma mark-  table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        XBDatePickerView *view = [[[NSBundle mainBundle] loadNibNamed:@"XBDatePickerView" owner:nil options:nil] firstObject];
        [self.view addSubview:view];
        
        [view flyUp];
        
        view.block = ^(NSString *date) {
            NSLog(@"%@", date);
            XBRegisterTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.inputTextField.text = date;
        };
    }
    else if (indexPath.row == 6) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男", @"女",nil];
        [sheet showInView:self.view];
    }
}

#pragma mark-  action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    XBRegisterTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
    if (buttonIndex == 0) {
        cell.inputTextField.text = @"男";

    }else if (buttonIndex == 1) {
        cell.inputTextField.text = @"女";
    }
}

#pragma mark-   Setter & Getter

- (UIView *)tableViewHead {
    if (!_tableViewHead) {
        _tableViewHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 100)];
        UIView *contentView = [[UIView alloc] initWithFrame:_tableViewHead.bounds];
        UIButton *avatarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        avatarBtn.frame = CGRectMake((contentView.width - 54) / 2, 0, 54, 54);
        [avatarBtn setBackgroundImage:Image_Named(@"upload_avatar_icon")
                             forState:UIControlStateNormal];
        
        avatarBtn.cornerRadius = 5;
        [avatarBtn addTarget:self
                       action:@selector(pressAvatarButtonAction:)
             forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:avatarBtn];
        
        UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                 avatarBtn.bottom + 10,
                                                                 contentView.width,
                                                                 20)];
        tip.textAlignment = NSTextAlignmentCenter;
        tip.textColor = [UIColor grayColor];
        tip.font = Font_System(12);
        tip.text = @"上传一张头像，让大家认识你";
        [contentView addSubview:tip];
        
        [_tableViewHead addSubview:contentView];;
    }
    return _tableViewHead;
}

- (UIView *)tableViewFoot {
    SafeRun_Return(_tableViewFoot);
    _tableViewFoot = [[UIView alloc] initWithFrame:CGRectMake(20, 10, Screen_Width - 20*2, 60)];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(0, 5, _tableViewFoot.width, kCommonButtonHeight);
    nextButton.backgroundColor = [UIColor hexStringToColor:@"#09bb07"];
    nextButton.cornerRadius = 5.f;
    nextButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton addTarget:self
                   action:@selector(pressNextButtonAction:)
         forControlEvents:UIControlEventTouchUpInside];
    [_tableViewFoot addSubview:nextButton];
    
    return _tableViewFoot;
}

- (NSArray *)titles {
    SafeRun_Return(_titles);
    _titles = @[
                @"昵称",
                @"密码",
                @"确认密码",
                @"生日",
                @"学校",
                @"班级",
                @"性别",
                ];
    return _titles;
}

- (NSArray *)placeHolderTitles {
    SafeRun_Return(_placeHolderTitles);
    _placeHolderTitles = @[
                           @"取个昵称",
                           @"请设置密码",
                           @"请设置密码",
                           @"选择您的生日",
                           @"请填写学校",
                           @"请填写班级",
                           @"选择性别",
                           ];
    return _placeHolderTitles;
}

@end
