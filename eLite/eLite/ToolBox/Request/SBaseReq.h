//
//  BaseRequest.h
//  Study
//
//  Created by lxx on 16/3/30.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol GET
@end
@protocol POST
@end
@protocol PUT
@end
@protocol DELETE
@end
@interface SBaseReq : JSONModel
@property (strong,nonatomic) NSString *url;
+(void)do:(void (^)(id req))reqBlock Res:(void (^)(id res))resBlock ShowHud:(BOOL)bHud;
@end

@interface SBaseRes : JSONModel
@property (assign,nonatomic) NSInteger  code;
@property (strong,nonatomic) NSString<Optional> *msg;
@end
