//
//  NSString+Utils.m
//  RPAntus
//
//  Created by Crz on 15/11/28.
//  Copyright © 2015年 Ranger. All rights reserved.
//

#import "NSString+Utils.h"

NSString *NSStringFromInteger(NSInteger i) {
    return [NSString stringWithFormat:@"%ld",i];
}
NSString *NSStringFromFloat(CGFloat f) {
    return [NSString stringWithFormat:@"%f",f];
}
NSString *NSStringFromBool(BOOL b) {
    return [NSString stringWithFormat:@"%d",b];
}

@implementation NSString (Utils)

@end
