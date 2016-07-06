//
//  XBAddressBookVC.m
//  eLite
//
//  Created by lxx on 16/6/1.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBAddressBookVC.h"
#import <AddressBook/AddressBook.h>
#import "AddessBookReq.h"
#import "XBAddessBookCell.h"
#import "AddFriendReq.h"
#import "MBProgressHUD.h"
#import "CDUserManager.h"
#import "LZPushManager.h"
@interface XBAddressBookVC ()<UITableViewDelegate,UITableViewDataSource,XBAddessBookCellButtonClickDelegate>
@property (nonatomic,strong)NSArray *phoneArray;
@property (nonatomic,copy)NSString *phoneStr;
@property (nonatomic,strong)AVUser *user;
@end

@implementation XBAddressBookVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"通讯录";
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self loadPerson];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.phoneArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XBAddessBookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XBAddessBookCell" owner:nil options:nil]lastObject];
    }
    cell.delegate = self;
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    AddessBookModel *model = self.phoneArray[indexPath.row];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",serverUrl,model.photo]]];
    cell.phoneLable.text = model.phone;
    cell.nameLabel.text = model.name;
    cell.userid = [NSString stringWithFormat:@"%@",model.userid];
    if ([model.isfriend integerValue]==1) {
        [cell.addButton setTitle:@"已添加" forState:UIControlStateNormal];
        cell.addButton.userInteractionEnabled=NO;
    }
    else
    {
       [cell.addButton setTitle:@"添加好友" forState:UIControlStateNormal];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(void)XBAddessBookCellButtonClick:(XBAddessBookCell *)cell
{
    [self showProgress];
    WEAKSELF
    [[CDUserManager manager]findUsersByPartname:cell.userid withBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects) {
                if(objects.count==0)
                {
                    [XBShowViewOnce showHUDText:@"请重新添加" inVeiw:weakSelf.view];

                }
                else
                {
                    self.user = objects[0];
                    [[CDUserManager manager] tryCreateAddRequestWithToUser:self.user callback: ^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            NSString *text = [NSString stringWithFormat:@"%@ 申请加你为好友", [XBUserDefault sharedInstance].resModel.name];
                                [[LZPushManager manager] pushMessage:text userIds:@[self.user.objectId] block:^(BOOL succeeded, NSError *error) {
                                    if (succeeded) {
                                        [weakSelf hideProgress];
                                        [XBShowViewOnce showHUDText:@"申请成功" inVeiw:self.view];
                                    }
                                }];
                       
                        }
                    }];
                }
            }
        }
    }];
}
-(void)showProgress {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)hideProgress {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)loadPerson
{
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
            
            CFErrorRef *error1 = NULL;
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error1);
            [self copyAddressBook:addressBook];
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        
        CFErrorRef *error = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
        
        [self copyAddressBook:addressBook];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
             //更新界面
            [XBShowViewOnce showHUDText:@"请到设置>隐私>通讯录打开本应用的权限设置" inVeiw:self.view];
        });
    }
}
- (void)copyAddressBook:(ABAddressBookRef)addressBook
{
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    //读取电话多值
    
    for (int i =0; i<numberOfPeople; i++) {
        
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for (int k = 0; k<ABMultiValueGetCount(phone); k++)
        {
            //获取电话Label
            NSString * personPhoneLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, k));
            //获取該Label下的电话值
            NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
            if ([personPhone containsString:@"-"]) {
                NSArray *array = [personPhone componentsSeparatedByString:@"-"];
                
                personPhone = [NSString stringWithFormat:@"%@%@%@",array[0],array[1],array[2]];
            }
            if (!self.phoneStr) {
                self.phoneStr = [NSString stringWithFormat:@"%@",personPhone];
            }
            else
            {
               self.phoneStr = [NSString stringWithFormat:@"%@,%@",self.phoneStr,personPhone];
            }
        }
    }
    [AddessBookReq do:^(id req) {
        AddessBookReq*re =req;
        re.users =self.phoneStr;
        re.userid = [NSString stringWithFormat:@"%@",[XBUserDefault sharedInstance].resModel.userid];
    } Res:^(id res) {
        AddessBookRes *resq = res;
        if (resq.code==0) {
            self.phoneArray = resq.data;
            [self.tableView reloadData];
        }
    } ShowHud:YES];
    
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
