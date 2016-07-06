//
//  LZMemberCell.h
//  eLite
//
//  Created by lxx on 16/4/28.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZMember.h"
#import "LZMembersSubCell.h"

static CGFloat kLZMembersCellLineSpacing = 10;
static CGFloat kLZMembersCellInterItemSpacing = 20;

@protocol LZMembersCellDelegate <NSObject>

- (void)didSelectMember:(LZMember *)member;

- (void)didLongPressMember:(LZMember *)member;
- (void)deleteMember:(LZMember *)memeber;
- (void)displayAvatarOfMember:(LZMember *)member atImageView:(UIImageView *)imageView;

@end

@interface LZMembersCell : UITableViewCell

@property (nonatomic, strong) NSArray *members;
@property (nonatomic, strong) NSArray *conMembers;

@property (nonatomic, strong) id <LZMembersCellDelegate> membersCellDelegate;

+ (CGFloat)heightForMemberCount:(NSInteger )count;

+ (LZMembersCell *)dequeueOrCreateCellByTableView:(UITableView *)tableView;

@end
