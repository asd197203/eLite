//
//  XBAddessBookCell.h
//  eLite
//
//  Created by lxx on 16/6/2.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBAddessBookCell;
@protocol XBAddessBookCellButtonClickDelegate <NSObject>

-(void)XBAddessBookCellButtonClick:(XBAddessBookCell*)cell;

@end
@interface XBAddessBookCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UILabel *phoneLable;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (nonatomic,copy)NSString *userid;
@property (assign,nonatomic)id<XBAddessBookCellButtonClickDelegate>delegate;

@end
