//
//  XBVoiceDoneViewController.h
//  eLite
//
//  Created by 常小哲 on 16/5/11.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBVoiceDoneViewController : UIViewController

@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) NSInteger allSubjectCount;
@property (nonatomic,strong)  NSArray *voiceArray;
@property (nonatomic, copy) NSString * allSubjectID;
@end
