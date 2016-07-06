//
//  XBRecommendVideoCell.h
//  eLite
//
//  Created by 常小哲 on 16/5/17.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XBRecommendVideoCellDelegate <NSObject>

- (void)clickPlayVideoCallBack:(NSString *)url;

@end

@interface XBRecommendVideoCell : UITableViewCell

@property (nonatomic, strong) XBRecommendListModel *cellModel;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (nonatomic, weak) id<XBRecommendVideoCellDelegate> delegate;

@end
