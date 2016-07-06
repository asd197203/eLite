//
//  AddessBookReq.h
//  eLite
//
//  Created by lxx on 16/6/2.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "SBaseReq.h"

@interface AddessBookReq : SBaseReq<GET>
@property (nonatomic,copy)NSString *userid;
@property (nonatomic,copy)NSString *users;
@end
@interface AddessBookModel : JSONModel
@property(nonatomic,copy)NSString <Optional>*remark;
@property(nonatomic,strong)NSNumber <Optional>*isfriend;
@property(nonatomic,strong)NSNumber <Optional>*userid;
@property(nonatomic,copy)NSString <Optional>*name;
@property(nonatomic,copy)NSString <Optional>*phone;
@property(nonatomic,copy)NSString <Optional>*photo;
@end
@protocol AddessBookModel <NSObject>

@end
@interface AddessBookRes :SBaseRes
@property(nonatomic,strong)NSArray <AddessBookModel,Optional> *data;
@end