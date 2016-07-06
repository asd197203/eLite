//
//  XBRegistNextVC.h
//  eLite
//
//  Created by lxx on 16/4/22.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "BaseViewController.h"

@interface XBRegistNextVC : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *getCodeButton;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (strong, nonatomic) IBOutlet UITextField *codeField;
@property(nonatomic,strong)NSMutableDictionary  *registUserDic;//保存上个界面带过来的注册信息
@end
