//
//  XBWordDoneController.h
//  eLite
//
//  Created by 常小哲 on 16/5/1.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBWordDoneController : UIViewController
@property (nonatomic,copy) NSString *wrongID;
@property (nonatomic, assign) NSInteger wrongNum;
@property (nonatomic, assign) NSInteger correctNum;
@property (nonatomic, assign) CGFloat correctRate;
@property (nonatomic, assign) CGFloat allSubjectCount;
@property (nonatomic, strong) NSMutableDictionary *wrongSubjectDict;
@property (nonatomic, strong) NSMutableArray *myWorkResults;
@property (nonatomic, assign) CGFloat score;

@end
