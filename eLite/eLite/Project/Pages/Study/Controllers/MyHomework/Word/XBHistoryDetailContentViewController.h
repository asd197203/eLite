//
//  XBHistoryDetailContentViewController.h
//  
//
//  Created by 常小哲 on 16/5/25.
//
//

#import <UIKit/UIKit.h>
@class XBHsitoryDetailController;


@interface XBHistoryDetailContentViewController : UIViewController

@property (nonatomic, weak) XBHsitoryDetailController *parentController;
@property (nonatomic, strong) XBHomeworkHistoryItemInfoModel *infoModel;

@end
