//
//  NSString+category.m
//  Study
//
//  Created by lxx on 16/3/30.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "NSString+category.h"

@implementation NSString (category)
- (NSDictionary *) parseJson
{
    NSData *da= [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:da options:NSJSONReadingMutableLeaves error:&error];
    return data;
}
@end
