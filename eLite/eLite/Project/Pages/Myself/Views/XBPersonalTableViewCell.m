//
//  XBPersonalTableViewCell.m
//  eLite
//
//  Created by 常小哲 on 16/4/14.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBPersonalTableViewCell.h"

@interface XBPersonalTableViewCell () {
    __weak IBOutlet UIImageView *_avatar;
    __weak IBOutlet UILabel *_userName;
    __weak IBOutlet UILabel *_userID;
    __weak IBOutlet UILabel *_signature;
}

@end

@implementation XBPersonalTableViewCell

- (void)awakeFromNib {
    NSURL *imgURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",serverUrl, [XBUserDefault sharedInstance].resModel.photo]];
    NSLog(@"atavar URL : %@", imgURL);
    [_avatar sd_setImageWithURL:imgURL];
    _userName.text = [XBUserDefault sharedInstance].resModel.name;
    _userID.text = USER_ID;
    _signature.text = [XBUserDefault sharedInstance].resModel.sign;

}

@end
