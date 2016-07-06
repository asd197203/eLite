//
//  SendVideoReq.h
//  eLite
//
//  Created by lxx on 16/5/19.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "SBaseReq.h"

@interface SendVideoReq : SBaseReq<POST>
@property(nonatomic,copy)NSString *userid;
@property(nonatomic,copy)NSString *subjects;
@property(nonatomic,strong)NSData *file1;
@end
@interface SendVideoRes :SBaseRes

@end