//
//  Request.h
//  Study
//
//  Created by lxx on 16/3/30.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "Define.h"
@interface Request : NSObject

+ (void) getWithUrl:(NSString *)urlStr withParams:(NSDictionary *)params SuccessBlock:(void (^)(NSDictionary* dic))blockSucess FailBlock:(void (^)(NSError *error))blockFail ShowHud:(BOOL)bHud;

+ (void) postWithUrl:(NSString *)urlStr withParams:(NSDictionary *)params SuccessBlock:(void (^)(NSDictionary* dic))blockSucess FailBlock:(void (^)(NSError *error))blockFail ShowHud:(BOOL)bHud;

+ (void) postWithUrl:(NSString *)urlStr withParams:(NSDictionary *)params BodyBlock:(void (^)(id<AFMultipartFormData> formData))blockBody SuccessBlock:(void (^)(NSDictionary* dic))blockSucess FailBlock:(void (^)(NSError *error))blockFail ShowHud:(BOOL)bHud;

+ (void) putWithUrl:(NSString *)urlStr withParams:(NSDictionary *)params SuccessBlock:(void (^)(NSDictionary* dic))blockSucess FailBlock:(void (^)(NSError *error))blockFail ShowHud:(BOOL)bHud;

+ (void) deleteWithUrl:(NSString *)urlStr withParams:(NSDictionary *)params SuccessBlock:(void (^)(NSDictionary* dic))blockSucess FailBlock:(void (^)(NSError *error))blockFail ShowHud:(BOOL)bHud;
@end
