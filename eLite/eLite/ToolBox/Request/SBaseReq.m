//
//  BaseRequest.m
//  Study
//
//  Created by lxx on 16/3/30.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "SBaseReq.h"
#import <objc/runtime.h>
#import "NSData+category.h"
#import "Request.h"
#import "HudView.h"
@implementation SBaseReq
+(NSMutableDictionary *)copyPropertyList:(id)obj
{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithCapacity:30];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([obj class], &outCount);
    for (i=0; i<outCount; i++) {
        objc_property_t property = properties[i];
        NSString * key = [[NSString alloc]initWithCString:property_getName(property)  encoding:NSUTF8StringEncoding];
        id val=[obj valueForKey:key];
        if(val!=nil)
        {
            if([val isKindOfClass:[NSData class]])
            {
                NSMutableArray *arr=[dic objectForKey:@"#FileAppendName"];
                if(arr==nil)
                {
                    arr=[[NSMutableArray alloc] initWithCapacity:30];
                    [dic setObject:arr forKey:@"#FileAppendName"];
                }
                ((NSData*)val).fileName=key;
                [arr addObject:val];
            }
            else if([val isKindOfClass:[NSArray class]])
            {
                NSMutableArray *arr=[dic objectForKey:@"#FileAppendName"];
                if(arr==nil)
                {
                    arr=[[NSMutableArray alloc] initWithCapacity:30];
                    [dic setObject:arr forKey:@"#FileAppendName"];
                }
                for(NSData* data in val)
                {
                    [arr addObject:data];
                }
            }
            else
            {
                [dic setObject:val forKey:key];
            }
        }
    }
    properties = class_copyPropertyList([[obj class] superclass], &outCount);
    for (i=0; i<outCount; i++) {
        objc_property_t property = properties[i];
        NSString * key = [[NSString alloc]initWithCString:property_getName(property)  encoding:NSUTF8StringEncoding];
        if([obj valueForKey:key]!=nil)
        {
            if(![key isEqualToString:@"url"])
            {
                [dic setObject:[obj valueForKey:key] forKey:key];
            }
        }
    }
    
    return dic;
}

+(void)do:(void (^)(id req))reqBlock Res:(void (^)(id res))resBlock ShowHud:(BOOL)bHud
{
    SBaseReq* ret=[[[self class] alloc] init];
    reqBlock(ret);
    NSString *strCls=NSStringFromClass([ret class]);
    strCls=[strCls stringByReplacingOccurrencesOfString:@"Req" withString:@"Res"];
    NSMutableDictionary *dic=[SBaseReq copyPropertyList:ret];
    if([ret conformsToProtocol:@protocol(GET)])
    {
        [Request getWithUrl:[ret valueForKey:@"url"] withParams:dic SuccessBlock:^(NSDictionary *dic) {
            Class cls=NSClassFromString(strCls);
            if(cls==nil)
            {
                cls=[SBaseReq class];
            }
            NSError *err;
            id data=[[cls alloc] initWithDictionary:dic error:&err];
            if(data==nil)
            {
                NSLog(@"%@",ret.description);
                E(@"网络数据发生异常");
                return;
            }
            if(resBlock)
            {
                resBlock(data);
            }
        } FailBlock:^(NSError *error) {
            NSLog(@"%@",ret.description);
            E(@"网络连接发生错误");
        } ShowHud:bHud];
    }
    else if([ret conformsToProtocol:@protocol(POST)])
    {
        NSMutableArray *arr=[dic objectForKey:@"#FileAppendName"];
        if(arr!=nil)
        {
            [dic removeObjectForKey:@"#FileAppendName"];
            [Request postWithUrl:[ret valueForKey:@"url"] withParams:dic BodyBlock:^(id<AFMultipartFormData> formData) {
                for(NSData *data in arr)
                {
                    if([data.fileType containsString:@"mov"])
                    {
                       [formData appendPartWithFileData:data name:data.fileName fileName:[NSString stringWithFormat:@"%@.%@",data.fileName,data.fileType] mimeType:@"video/quicktime"];
                    }
                    else if([data.fileType containsString:@"voice"])
                    {
                         [formData appendPartWithFileData:data name:data.fileName fileName:[NSString stringWithFormat:@"%@.%@",data.fileName,@"wav"] mimeType:@"audio/mpeg3"];
                    }
                    else
                    {
                       [formData appendPartWithFileData:data name:data.fileName fileName:[NSString stringWithFormat:@"%@.%@",data.fileName,data.fileType] mimeType:@"image/png"];
                    }
                }
            } SuccessBlock:^(NSDictionary *dic) {
                Class cls=NSClassFromString(strCls);
                if(cls==nil)
                {
                    cls=[SBaseReq class];
                }
                NSError *err;
                id data=[[cls alloc] initWithDictionary:dic error:&err];
                if(data==nil)
                {
                    NSLog(@"%@",ret.description);
                    E(@"网络数据发生异常");
                    return;
                }
                if(resBlock)
                {
                    resBlock(data);
                }
            } FailBlock:^(NSError *error) {
                NSLog(@"%@",ret.description);
                E(@"网络连接发生错误");
            } ShowHud:bHud];
        }
        else
        {
            [Request postWithUrl:[ret valueForKey:@"url"] withParams:dic SuccessBlock:^(NSDictionary *dic) {
                Class cls=NSClassFromString(strCls);
                if(cls==nil)
                {
                    cls=[SBaseReq class];
                }
                NSError *err;
                id data=[[cls alloc] initWithDictionary:dic error:&err];
                if(data==nil)
                {
                    NSLog(@"%@",ret.description);
                    E(@"网络数据发生异常");
                    return;
                }
                if(resBlock)
                {
                    resBlock(data);
                }
            } FailBlock:^(NSError *error) {
                NSLog(@"%@",ret.description);
                E(@"网络连接发生错误");
            } ShowHud:bHud];
        }
        
    }
    else if([ret conformsToProtocol:@protocol(PUT)])
    {
        
        [Request putWithUrl:[ret valueForKey:@"url"] withParams:dic SuccessBlock:^(NSDictionary *dic) {
            Class cls=NSClassFromString(strCls);
            if(cls==nil)
            {
                cls=[SBaseReq class];
            }
            NSError *err;
            id data=[[cls alloc] initWithDictionary:dic error:&err];
            if(data==nil)
            {
                NSLog(@"%@",ret.description);
                E(@"网络数据发生异常");
                return;
            }
            if(resBlock)
            {
                resBlock(data);
            }
        } FailBlock:^(NSError *error) {
            NSLog(@"%@",ret.description);
            E(@"网络连接发生错误");
        } ShowHud:bHud];
    }
    else if([ret conformsToProtocol:@protocol(DELETE)])
    {
        [Request deleteWithUrl:[ret valueForKey:@"url"] withParams:dic SuccessBlock:^(NSDictionary *dic) {
            Class cls=NSClassFromString(strCls);
            if(cls==nil)
            {
                cls=[SBaseReq class];
            }
            NSError *err;
            id data=[[cls alloc] initWithDictionary:dic error:&err];
            if(data==nil)
            {
                NSLog(@"%@",ret.description);
                E(@"网络数据发生异常");
                return;
            }
            if(resBlock)
            {
                resBlock(data);
            }
        } FailBlock:^(NSError *error) {
            NSLog(@"%@",ret.description);
            E(@"网络连接发生错误");
        } ShowHud:bHud];
    }
}
@end

@implementation SBaseRes

@end
