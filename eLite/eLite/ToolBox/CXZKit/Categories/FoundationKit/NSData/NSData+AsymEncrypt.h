//
//  NSData+AsymEncrypt.h
//  RPAntus
//
//  Created by Crz on 15/11/24.
//  Copyright © 2015年 Ranger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AsymEncrypt)

+(NSData *)MD5Digest:(NSData *)input;
-(NSData *)MD5Digest;

+(NSString *)MD5HexDigest:(NSData *)input;
-(NSString *)MD5HexDigest;

@end
