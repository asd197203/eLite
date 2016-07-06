//
//  LZMemberCell.m
//  eLite
//
//  Created by lxx on 16/4/28.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "LZMembersCell.h"
#import "LZMember.h"
#import "LZMembersSubCell.h"
#import "GetCrowdPeopleReq.h"
#import "CDConvDetailVC.h"
#import "CDCacheManager.h"
static NSString *kMCClassMembersHeaderViewCellIndentifer = @"memberCell";

@interface LZMembersCell () <UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UICollectionView *membersCollectionView;
@property (nonatomic,strong)NSMutableArray  *memberArray;
@property (nonatomic,strong)UIButton  *button;
@end

@implementation LZMembersCell

+ (LZMembersCell *)dequeueOrCreateCellByTableView:(UITableView *)tableView {
    LZMembersCell *cell = [tableView dequeueReusableCellWithIdentifier:[[self class] reuseIdentifier]];
    if (cell == nil) {
        cell = [[LZMembersCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[[self class] reuseIdentifier]];
       
    }
    return cell;
}
- (void)isManager:(NSNotification*)noti
{
    _button = noti.userInfo[@"sender"];
    [self.membersCollectionView reloadData];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCDNotificationDelete object:nil];
}
+ (NSString *)reuseIdentifier {
    return NSStringFromClass([LZMembersCell class]);
}

+ (CGFloat)heightForMemberCount:(NSInteger )count {
    if (count == 0) {
        return 0;
    }
    NSInteger column = (CGRectGetWidth([UIScreen mainScreen].bounds) - kLZMembersCellInterItemSpacing) / ([LZMembersSubCell widthForCell] + kLZMembersCellInterItemSpacing);
    NSInteger rows = count / column + (count % column ? 1 : 0);
    return rows *[LZMembersSubCell heightForCell] + (rows + 1) * kLZMembersCellLineSpacing;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isManager:) name:kCDNotificationDelete object:nil];
        [self.contentView addSubview:self.membersCollectionView];
    }
    return self;
}

- (UICollectionView *)membersCollectionView {
    if (_membersCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = kLZMembersCellLineSpacing;
        layout.minimumInteritemSpacing = kLZMembersCellInterItemSpacing;
        layout.itemSize = CGSizeMake([LZMembersSubCell widthForCell], [LZMembersSubCell heightForCell]);
        _membersCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_membersCollectionView registerClass:[LZMembersSubCell class] forCellWithReuseIdentifier:kMCClassMembersHeaderViewCellIndentifer];
        _membersCollectionView.backgroundColor = [UIColor whiteColor];
        _membersCollectionView.showsVerticalScrollIndicator = YES;
        _membersCollectionView.delegate = self;
        _membersCollectionView.dataSource = self;
        UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressUser:)];
        gestureRecognizer.delegate = self;
        [_membersCollectionView addGestureRecognizer:gestureRecognizer];
    }
    return _membersCollectionView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.membersCollectionView.frame = CGRectMake(kLZMembersCellInterItemSpacing, kLZMembersCellLineSpacing, CGRectGetWidth(self.frame) - 2 * kLZMembersCellInterItemSpacing, CGRectGetHeight(self.frame) - 2 * kLZMembersCellLineSpacing);
}

- (void)setMembers:(NSArray *)members {
    _members = members;
    [self.membersCollectionView reloadData];
    [self setNeedsLayout];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
     return self.members.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LZMembersSubCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMCClassMembersHeaderViewCellIndentifer forIndexPath:indexPath];
   
    if (self.members.count ==0) {
        return cell;
    }
    else
    {
        if(_button.selected ==YES)
        {
            cell.deleteButton.hidden = NO;
        }
        else
        {
            cell.deleteButton.hidden = YES;
        }
        if (indexPath.row==self.members.count) {
            UIButton*button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, cell.avatarImageView.frame.size.width+5, cell.avatarImageView.frame.size.height+7.5);
            cell.usernameLabel.text = @"";
            button.layer.cornerRadius = 4;
            button.clipsToBounds = YES;
            button.backgroundColor = [UIColor whiteColor];
            [button setBackgroundImage:[UIImage imageNamed:@"suggestion_add_btn"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(addCrowdUser:) forControlEvents:UIControlEventTouchUpInside];
            button.tag =10086;
            [cell addSubview:button];
        }
        else
        {
            for (UIButton*button in cell.subviews) {
                if (button.tag ==10086) {
                    [button removeFromSuperview];
                }
            }
            LZMember *user = [self.members objectAtIndex:indexPath.row];
            self.memberArray = [NSMutableArray array];
            for (LZMember *user in self.members) {
                for (NSDictionary*dic in self.conMembers) {
                    if ([[NSString stringWithFormat:@"%@",dic[@"userid"]] isEqualToString:user.memberName]) {
                        [self.memberArray addObject:dic];
                    }
                }
            }
            NSDictionary*dic = [self.memberArray objectAtIndex:indexPath.row];
            if ([dic[@"isfriend"] integerValue]==1) {
                if (![dic[@"remark"] isEqualToString:@""]) {
                    cell.usernameLabel.text =dic[@"remark"];
                }
                else
                {
                    cell.usernameLabel.text =dic[@"name"];
                }
            }
            else
            {
                cell.usernameLabel.text =dic[@"name"];
            }
            user.memberName = [NSString stringWithFormat:@"%@",dic[@"userid"]];
            user.memberAvatarUrl = [NSString stringWithFormat:@"%@%@",serverUrl,dic[@"photo"]];
            if ([self.membersCellDelegate respondsToSelector:@selector(displayAvatarOfMember:atImageView:)]) {
                [self.membersCellDelegate displayAvatarOfMember:user atImageView:cell.avatarImageView];
            }
            cell.deleteButton.tag = indexPath.row;
            [cell.deleteButton addTarget:self action:@selector(deleteUser:) forControlEvents:UIControlEventTouchUpInside];
            [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",serverUrl,dic[@"photo"]]] placeholderImage:nil];
        }
        
        return cell;
        
    }
}
- (void)addCrowdUser:(UIButton*)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addCrowdUser" object:nil];
}
#pragma mark <UICollectionViewDelegate>

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LZMember *user = [self.members objectAtIndex:indexPath.row];
    if ([self.membersCellDelegate respondsToSelector:@selector(didSelectMember:)]) {
        [self.membersCellDelegate didSelectMember:user];
    }
    return YES;
}

#pragma mark - Gesture

- (void)longPressUser:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    CGPoint p = [gestureRecognizer locationInView:self.membersCollectionView];
    NSIndexPath *indexPath = [self.membersCollectionView indexPathForItemAtPoint:p];
    if (indexPath == nil) {
        NSLog(@"can't not find index path");
    }
    else {
        if ([self.membersCellDelegate respondsToSelector:@selector(didLongPressMember:)]) {
            [self.membersCellDelegate didLongPressMember:self.members[indexPath.row]];
        }
    }
}
-(void)deleteUser:(UIButton*)sender
{
    NSIndexPath *indexPath = [self.membersCollectionView indexPathForItemAtPoint:CGPointMake(sender.frame.origin.x, sender.frame.origin.y)];
    if (indexPath == nil) {
        NSLog(@"can't not find index path");
    }
    else {
        if ([self.membersCellDelegate respondsToSelector:@selector(deleteMember:)]) {
            [self.membersCellDelegate deleteMember:self.members[sender.tag]];
        }
    }
}
@end
