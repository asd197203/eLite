//
//  LZMerbersSubCell.h
//  eLite
//
//  Created by lxx on 16/4/28.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat kLZMembersSubCellAvatarSize = 60;
static CGFloat kLZMembersSubCellLabelHeight = 20;
static CGFloat kLZMembersSubCellSeparator = 5;

@interface LZMembersSubCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UIButton *deleteButton;
+ (CGFloat)heightForCell;

+ (CGFloat)widthForCell;

@end
