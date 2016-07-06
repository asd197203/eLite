//
//  ChangePhoneReq.h
//  eLite
//
//  Created by lxx on 16/5/26.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "SBaseReq.h"

@interface ChangePhoneReq : SBaseReq<PUT>
@property (nonatomic,copy)NSString *userid;
@property (nonatomic,copy)NSString *phone;
@end
@interface ChangePhoneRes : SBaseRes
@end