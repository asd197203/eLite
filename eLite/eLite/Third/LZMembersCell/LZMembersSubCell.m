//
//  LZMerbersSubCell.m
//  eLite
//
//  Created by lxx on 16/4/28.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "LZMembersSubCell.h"

@interface LZMembersSubCell ()

@end

@implementation LZMembersSubCell

+ (CGFloat)heightForCell {
    return kLZMembersSubCellAvatarSize + kLZMembersSubCellSeparator + kLZMembersSubCellLabelHeight+5;
}

+ (CGFloat)widthForCell {
    return kLZMembersSubCellAvatarSize+5;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.avatarImageView];
        [self addSubview:self.usernameLabel];
        [self addSubview:self.deleteButton];
    }
    return self;
}

- (UIImageView *)avatarImageView {
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, kLZMembersSubCellAvatarSize, kLZMembersSubCellAvatarSize)];
        _avatarImageView.layer.cornerRadius = 4;
        _avatarImageView.clipsToBounds = YES;
    }
    return _avatarImageView;
}

- (UILabel *)usernameLabel {
    if (_usernameLabel == nil) {
        _usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_avatarImageView.frame) + kLZMembersSubCellSeparator, CGRectGetWidth(_avatarImageView.frame)+5, kLZMembersSubCellLabelHeight)];
        _usernameLabel.textAlignment = NSTextAlignmentCenter;
        _usernameLabel.font = [UIFont systemFontOfSize:12];
    }
    return _usernameLabel;
}
- (UIButton *)deleteButton{
    if (_deleteButton == nil) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake(kLZMembersSubCellAvatarSize-15, 0, 20, 20);
        _deleteButton.hidden  = YES;
        [_deleteButton setBackgroundImage:[UIImage imageNamed:@"删除人"] forState:UIControlStateNormal];
    }
    return _deleteButton;
}
@end
