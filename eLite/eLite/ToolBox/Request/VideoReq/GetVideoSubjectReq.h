//
//  GetVideoSubjectReq.h
//  eLite
//
//  Created by lxx on 16/5/19.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "SBaseReq.h"

@interface GetVideoSubjectReq : SBaseReq<GET>
@property(nonatomic,copy)NSString *userid;
@end
@protocol GetVideoSubjectModel <NSObject>
@end
@interface GetVideoSubjectModel : JSONModel
@property (nonatomic,copy)NSString <Optional>*_id;
@property (nonatomic,copy)NSString <Optional>*title;
@end
@interface GetVideoSubjectRes : SBaseRes
@property(nonatomic,strong)NSArray <GetVideoSubjectModel,Optional>*data;
@end