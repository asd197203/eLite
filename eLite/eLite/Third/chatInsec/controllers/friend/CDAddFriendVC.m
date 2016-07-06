//
//  CDAddFriendController.m
//  LeanChat
//
//  Created by lzw on 14-10-23.
//  Copyright (c) 2014年 LeanCloud. All rights reserved.
//

#import "CDAddFriendVC.h"
#import "CDUserManager.h"
#import "CDBaseNavC.h"
#import "CDUserInfoVC.h"
#import "CDImageLabelTableCell.h"
#import "CDUtils.h"
#import "XBUserInfoVC.h"
#import "CheckUserReq.h"
#import "XBUserDefault.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+category.h"
#import "XBAddressBookVC.h"
#import "HCScanQRViewController.h"
#import "XBCodeCrowdToJoinVC.h"
@interface CDAddFriendVC ()<HCScanQRViewControllerDelegate>

@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) NSDictionary *dic;

@end

static NSString *cellIndentifier = @"cellIndentifier";

@implementation CDAddFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"查找好友";
    [_searchBar setDelegate:self];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CDImageLabelTableCell class]) bundle:nil] forCellReuseIdentifier:cellIndentifier];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
     [_tableView reloadData];
    searchBar.text =@"";
    self.searchBar.showsCancelButton = NO;
    [searchBar endEditing:YES];
   
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [CheckUserReq do:^(id req) {
        CheckUserReq*re = req;
        re.userid = [XBUserDefault sharedInstance].resModel.userid;
        re.friendid = searchBar.text;
    } Res:^(id res) {
        CheckUserRes *resq = res;
        if (resq.code==0) {
            _dic = resq.data;
            NSString *content = searchBar.text;
            [self searchUser:content];
        }
        else
        {
          ALERT_ONE(@"未找到该用户");
        }
        
    } ShowHud:YES];
   
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.searchBar.showsCancelButton = YES;
}
- (void)searchUser:(NSString *)name {
    [[CDUserManager manager] findUsersByPartname:name withBlock: ^(NSArray *objects, NSError *error) {
        if ([self filterError:error]) {
            if (objects) {
                if(objects.count==0)
                {
                    ALERT_ONE(@"未找到该用户");
                }
                else
                {
                    self.users = objects;
                    [_tableView reloadData];
                }
            }
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_dic==nil) {
        return 2;
    }
    else
    {
       return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (_dic==nil) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (!indexPath.row) {
            cell.textLabel.text = @"扫一扫";
        }
        else
        {
             cell.textLabel.text = @"通讯录";
        }
        return cell;
    }
    else
    {
        CDImageLabelTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
        if (!cell) {
            cell = [[CDImageLabelTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        }
        cell.selectedImageView.hidden = YES;
        cell.myLabel.text = _dic[@"name"];
        cell.myImageView.clipsToBounds =YES;
        [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",serverUrl,_dic[@"photo"]]] placeholderImage:[UIImage imageNamed:@"tabbar_selected_3"]];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    CDUserInfoVC *controller = [[CDUserInfoVC alloc] initWithUser:self.users[indexPath.row]];
//    [self.navigationController pushViewController:controller animated:YES];
    if(_dic==nil)
    {
        if(!indexPath.row)
        {
            //扫一扫
            //扫一扫
            HCScanQRViewController *scan = [[HCScanQRViewController alloc]init];
            //调用此方法来获取二维码信息
            scan.delegate =self;
            scan.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:scan animated:YES];
        }
        else
        {
            //通讯录
                XBAddressBookVC *controller = [[XBAddressBookVC alloc] init];
                controller.hidesBottomBarWhenPushed = YES;
                [[self navigationController] pushViewController:controller animated:YES];
        }
        
    }
    else
    {
        XBUserInfoVC *userInfo = [[XBUserInfoVC alloc]init];
        userInfo.userID =_dic[@"userid"];
        [self.navigationController pushViewController:userInfo animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
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
       
    }
}



@end
