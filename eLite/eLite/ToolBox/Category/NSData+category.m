//
//  NSData+NSData_category.m
//  eLite
//
//  Created by 孙昕 on 16/4/29.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "NSData+category.h"
#import <objc/runtime.h>
const char *g_fileType;
const char *g_fileName;
@implementation NSData (uploadType)
-(void)setFileType:(NSString *)fileType
{
    objc_setAssociatedObject(self, &g_fileType, fileType, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString*)fileType
{
    return objc_getAssociatedObject(self, &g_fileType);
}

-(void)setFileName:(NSString *)fileName
{
    objc_setAssociatedObject(self, &g_fileName, fileName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString*)fileName
{
    return objc_getAssociatedObject(self, &g_fileName);
}
@end












