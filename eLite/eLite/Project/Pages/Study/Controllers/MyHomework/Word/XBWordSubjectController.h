//
//  XBWordSubjectController.h
//  eLite
//
//  Created by 常小哲 on 16/5/16.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBPageController.h"

@interface XBWordSubjectController : XBPageController

@property (nonatomic, assign) CGFloat allSubjectCount;
@property (nonatomic, assign) NSInteger currentSubject;
@property (nonatomic, assign) CGFloat score;
@property (nonatomic, assign) NSInteger wrongNum;
@property (nonatomic, copy) NSString * wrongID;
@property (nonatomic, assign) NSInteger correctNum;
@property (nonatomic, strong) NSMutableDictionary *wrongSubjectDict;
@property (nonatomic, strong) NSMutableArray *myWorkResults;
@property (nonatomic,strong)NSArray *allData;
@end
