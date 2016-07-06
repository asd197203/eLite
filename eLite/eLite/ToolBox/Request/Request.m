//
//  Request.m
//  Study
//
//  Created by lxx on 16/3/30.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "Request.h"
#import "NSString+category.h"
#import "HudView.h"
@implementation Request
+ (void) getWithUrl:(NSString *)urlStr withParams:(NSDictionary *)params SuccessBlock:(void (^)(NSDictionary* dic))blockSucess FailBlock:(void (^)(NSError *error))blockFail ShowHud:(BOOL)bHud
{
    AFHTTPRequestOperationManager *manage=[AFHTTPRequestOperationManager manager];
    // manage.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    manage.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manage.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manage.requestSerializer.timeoutInterval=20;
    [manage.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    AFHTTPRequestOperation *operation= [manage GET:[serverUrl stringByAppendingString:urlStr] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
                                        {
                                            if(bHud)
                                            {
                                                [HudView dismiss];
                                            }
                                            if(blockSucess!=nil)
                                            {
                                                NSString *responseString=operation.responseString;
                                                NSDictionary *data = [responseString parseJson];
                                                blockSucess(data);
                                            }
                                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                            if(bHud)
                                            {
                                                [HudView dismiss];
                                            }
                                            if (blockFail != nil) {
                                                blockFail(error);
                                            }
                                        }];
    if(bHud)
    {
        [HudView showHud:@"正在卖力加载中" CancelBlock:^{
            [operation cancel];
        }];
    }
}


+ (void) postWithUrl:(NSString *)urlStr withParams:(NSDictionary *)params SuccessBlock:(void (^)(NSDictionary* dic))blockSucess FailBlock:(void (^)(NSError *error))blockFail ShowHud:(BOOL)bHud
{
    AFHTTPRequestOperationManager *manage=[AFHTTPRequestOperationManager manager];
    // manage.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    manage.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manage.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manage.requestSerializer.timeoutInterval=20;
    [manage.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    AFHTTPRequestOperation *operation= [manage POST:[serverUrl stringByAppendingString:urlStr] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
                                        {
                                            if(bHud)
                                            {
                                                [HudView dismiss];
                                            }
                                            if(blockSucess!=nil)
                                            {
                                                NSString *responseString=operation.responseString;
                                                NSDictionary *data = [responseString parseJson];
                                                blockSucess(data);
                                            }
                                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                            if(bHud)
                                            {
                                                [HudView dismiss];
                                            }
                                            if (blockFail != nil) {
                                                blockFail(error);
                                            }
                                        }];
    if(bHud)
    {
        [HudView showHud:@"正在卖力加载中" CancelBlock:^{
            [operation cancel];
        }];
    }
}

+ (void) postWithUrl:(NSString *)urlStr withParams:(NSDictionary *)params BodyBlock:(void (^)(id<AFMultipartFormData> formData))blockBody SuccessBlock:(void (^)(NSDictionary* dic))blockSucess FailBlock:(void (^)(NSError *error))blockFail ShowHud:(BOOL)bHud
{
    AFHTTPRequestOperationManager *manage=[AFHTTPRequestOperationManager manager];
    manage.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    //manage.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manage.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manage.requestSerializer.timeoutInterval=20;
    [manage.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    AFHTTPRequestOperation *operation= [manage POST:[serverUrl stringByAppendingString:urlStr] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        blockBody(formData);
    } success:^(AFHTTPRequestOperation *operation, id responseObject)
                                        {
                                            if(bHud)
                                            {
                                                [HudView dismiss];
                                            }
                                            if(blockSucess!=nil)
                                            {
                                                NSString *responseString=operation.responseString;
                                                NSDictionary *data = [responseString parseJson];
                                                blockSucess(data);
                                            }
                                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                            if(bHud)
                                            {
                                                [HudView dismiss];
                                            }
                                            if (blockFail != nil) {
                                                blockFail(error);
                                            }
                                        }];
    if(bHud)
    {
        [HudView showHud:@"正在卖力加载中" CancelBlock:^{
            [operation cancel];
        }];
    }
}


+ (void) putWithUrl:(NSString *)urlStr withParams:(NSDictionary *)params SuccessBlock:(void (^)(NSDictionary* dic))blockSucess FailBlock:(void (^)(NSError *error))blockFail ShowHud:(BOOL)bHud
{
    AFHTTPRequestOperationManager *manage=[AFHTTPRequestOperationManager manager];
    //manage.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    manage.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manage.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manage.requestSerializer.timeoutInterval=20;
    [manage.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    AFHTTPRequestOperation *operation= [manage PUT:[serverUrl stringByAppendingString:urlStr] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
                                        {
                                            if(bHud)
                                            {
                                                [HudView dismiss];
                                            }
                                            if(blockSucess!=nil)
                                            {
                                                NSString *responseString=operation.responseString;
                                                NSDictionary *data = [responseString parseJson];
                                                blockSucess(data);
                                            }
                                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                            if(bHud)
                                            {
                                                [HudView dismiss];
                                            }
                                            if (blockFail != nil) {
                                                blockFail(error);
                                            }
                                        }];
    if(bHud)
    {
        [HudView showHud:@"正在卖力加载中" CancelBlock:^{
            [operation cancel];
        }];
    }
}

+ (void) deleteWithUrl:(NSString *)urlStr withParams:(NSDictionary *)params SuccessBlock:(void (^)(NSDictionary* dic))blockSucess FailBlock:(void (^)(NSError *error))blockFail ShowHud:(BOOL)bHud
{
    AFHTTPRequestOperationManager *manage=[AFHTTPRequestOperationManager manager];
    //manage.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    manage.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manage.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manage.requestSerializer.timeoutInterval=20;
    [manage.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    AFHTTPRequestOperation* operation= [manage DELETE:[serverUrl stringByAppendingString:urlStr] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
                                        {
                                            if(bHud)
                                            {
                                                [HudView dismiss];
                                            }
                                            if(blockSucess!=nil)
                                            {
                                                NSString *responseString=operation.responseString;
                                                NSDictionary *data = [responseString parseJson];
                                                blockSucess(data);
                                            }
                                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                            if(bHud)
                                            {
                                                [HudView dismiss];
                                            }
                                            if (blockFail != nil) {
                                                blockFail(error);
                                            }
                                        }];
    if(bHud)
    {
        [HudView showHud:@"正在卖力加载中" CancelBlock:^{
            [operation cancel];
        }];
    }
}
@end
