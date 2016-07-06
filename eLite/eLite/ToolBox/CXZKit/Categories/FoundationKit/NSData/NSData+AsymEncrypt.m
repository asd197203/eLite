//
//  NSData+AsymEncrypt.m
//  RPAntus
//
//  Created by Crz on 15/11/24.
//  Copyright © 2015年 Ranger. All rights reserved.
//

#import "NSData+AsymEncrypt.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSData (AsymEncrypt)

+(NSData *)MD5Digest:(NSData *)input {
    unsigned char result[CC_MD5_DIGEST_LENGTH];

    CC_MD5(input.bytes, (CC_LONG)input.length, result);
    return [[NSData alloc] initWithBytes:result length:CC_MD5_DIGEST_LENGTH];
}

-(NSData *)MD5Digest {
    return [NSData MD5Digest:self];
}

+(NSString *)MD5HexDigest:(NSData *)input {
    unsigned char result[CC_MD5_DIGEST_LENGTH];

    CC_MD5(input.bytes, (CC_LONG)input.length, result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for (int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

-(NSString *)MD5HexDigest {
    return [NSData MD5HexDigest:self];
}

@end
