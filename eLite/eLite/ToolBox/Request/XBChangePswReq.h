//
//  XBChangePswReq.h
//  eLite
//
//  Created by lxx on 16/6/2.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "SBaseReq.h"

@interface XBChangePswReq : SBaseReq<PUT>
@property(nonatomic,copy)NSString *userid;
@property(nonatomic,copy)NSString *pwd;
@property(nonatomic,copy)NSString *newpwd;
@end
@interface XBChangePswRes : SBaseRes

@end
