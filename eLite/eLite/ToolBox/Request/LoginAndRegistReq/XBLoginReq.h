//
//  XBLoginReq.h
//  eLite
//
//  Created by lxx on 16/4/26.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "SBaseReq.h"

@interface XBLoginReq : SBaseReq<GET>
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,copy)NSString *phone;
@property(nonatomic,copy)NSString *userid;
@property(nonatomic,copy)NSString *pwd;
@end
@interface XBLoginRes : SBaseRes
@property(strong,nonatomic)NSDictionary<Optional>*data;
@end