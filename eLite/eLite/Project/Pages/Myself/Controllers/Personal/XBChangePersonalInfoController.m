//
//  XBChangePersonalInfoController.m
//  eLite
//
//  Created by 常小哲 on 16/4/21.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBChangePersonalInfoController.h"
#import "CXZSelectAvatarController.h"
#import "NSData+category.h"
#import "MBProgressHUD.h"
@interface XBChangePersonalInfoController () {
    NSString *_url;
}

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation XBChangePersonalInfoController

- (instancetype)initWithStyle:(ControllerStyle)style {
    if (self == [super init]) {
//        [self setup:style];
    }
    return self;
}

- (instancetype)initWithPhotoURL:(NSString *)urlStr {
    if (self == [super init]) {
        _url = urlStr;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *imgURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",serverUrl, [XBUserDefault sharedInstance].resModel.photo]];
    [self.imgView sd_setImageWithURL:imgURL];

    self.title = @"头像";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(rightButton)];
    
    self.navigationItem.rightBarButtonItem = item;
}

- (void)rightButton {
    CXZSelectAvatarController *vc = [[CXZSelectAvatarController alloc] initWithController:self];
    typeof(self) __weak weakSelf = self;
    [vc showForPicture:^(UIImage *selectedImage) {
         [self showProgress];
        [XBPersonAvatarReq do:^(id req) {
            XBPersonAvatarReq *tmpReq = req;
            tmpReq.userid = [XBUserDefault sharedInstance].resModel.userid;
            NSData *imageData = UIImageJPEGRepresentation(selectedImage, 0.5);
            imageData.fileType=@"png";
            tmpReq.photo = imageData;

        } Res:^(id res) {
            XBPersonAvatarRes *tmpRes = res;
            [self hideProgress];
            if (tmpRes.code == 0) {
                [XBShowViewOnce showHUDText:@"修改成功" inVeiw:weakSelf.view];
                self.imgView.image = selectedImage;
                XBUser *user = [XBUserDefault sharedInstance].resModel;
                user.photo = tmpRes.data;
                [XBUserDefault saveUserInfoModel:user];
                NSLog(@"data : %@", tmpRes.data);
                NSLog(@"%@", [XBUserDefault sharedInstance].resModel.photo);
            }else {
                [XBShowViewOnce showHUDText:@"修改失败" inVeiw:weakSelf.view];
            }
        } ShowHud:NO];
    }];
}
-(void)showProgress {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)hideProgress {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)setup:(ControllerStyle)style {
    switch (style) {
        case ControllerStyle_avatar:
        {
            
        }
            break;
          
        case ControllerStyle_edit:
        {
            
        }
            break;
            
        default:
            break;
    }
}

@end
