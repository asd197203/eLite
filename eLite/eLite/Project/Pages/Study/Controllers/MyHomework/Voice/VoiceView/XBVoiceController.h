//
//  XBVoiceController.h
//  eLite
//
//  Created by 常小哲 on 16/5/21.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "XBPageController.h"

@interface XBVoiceController : XBPageController

@property (nonatomic, assign) CGFloat allSubjectCount;
@property (nonatomic, assign) CGFloat score;
@property (nonatomic, assign) NSInteger correntSubject;
@property (nonatomic,strong)NSMutableArray *voicePathArray;
@property (nonatomic,copy)NSString *allSubjectID;
@end
