//
//  XBAccountChangePswController.h
//  eLite
//
//  Created by lxx on 16/6/2.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBAccountChangePswController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *oldPswTextField;
@property (strong, nonatomic) IBOutlet UITextField *nwTextField;


@property (strong, nonatomic) IBOutlet UITextField *confirmPswTextField;

@property (strong, nonatomic) IBOutlet UIButton *confirmButton;

@end
