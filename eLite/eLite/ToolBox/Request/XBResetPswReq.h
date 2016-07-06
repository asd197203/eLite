//
//  XBResetPswReq.h
//  eLite
//
//  Created by lxx on 16/6/3.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "SBaseReq.h"

@interface XBResetPswReq : SBaseReq<PUT>
@property(nonatomic,copy)NSString *phone;
@property(nonatomic,copy)NSString *pwd;
@end
@interface XBResetPswRes : SBaseRes

@end
