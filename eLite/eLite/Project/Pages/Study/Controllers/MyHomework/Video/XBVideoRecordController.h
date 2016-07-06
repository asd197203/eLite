//
//  XBVideoRecordController.h
//  eLite
//
//  Created by 常小哲 on 16/5/3.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XBVideoRecordControllerFinishDelegate <NSObject>

-(void)completeVideo;

@end

@interface XBVideoRecordController : UIViewController
@property(nonatomic,assign)id<XBVideoRecordControllerFinishDelegate>delagate;
@property(nonatomic,strong)NSString *subjects;
@end
