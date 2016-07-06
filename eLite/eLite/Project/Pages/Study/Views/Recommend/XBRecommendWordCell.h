//
//  XBRecommendWordCell.h
//  eLite
//
//  Created by 常小哲 on 16/5/17.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBRecommendWordCell : UITableViewCell
@property (nonatomic, strong) XBRecommendListModel *cellModel;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

- (void)clickImageViewOnCell:(void (^)(NSString *url))block;

@end
