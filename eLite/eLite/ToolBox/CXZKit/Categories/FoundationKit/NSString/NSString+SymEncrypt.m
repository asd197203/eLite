//
//  NSString+SymEncrypt.m
//  RPAntus
//
//  Created by Crz on 15/11/20.
//  Copyright © 2015年 Ranger. All rights reserved.
//

#import "NSString+SymEncrypt.h"
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"

//#define gkey            @"私钥"
#define gkey            @"b0326c4f1e0e2c2970584b14a5a36d1886b4b115"
#define gIv             @"antushen"

@implementation NSString (SymEncrypt)

#pragma mark-   3des加解密
- (NSString *)des3_enc {
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    size_t plainTextBufferSize = [data length];
    const void *vplainText = (const void *)[data bytes];

    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);

    const void *vkey = (const void *) [gkey UTF8String];
    const void *vinitVec = (const void *) [gIv UTF8String]; // 可以为NULL

    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);

    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    free(bufferPtr);

    NSString *result = [[GTMBase64 stringByEncodingData:myData] stringByReplacingOccurrencesOfString:@"/"
                                                                                          withString:@"_"];
    result = [result stringByReplacingOccurrencesOfString:@"+" withString:@"."];
    return result;
}

- (NSString *)des3_dec {
    NSString *str = [self stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
    str = [str stringByReplacingOccurrencesOfString:@"." withString:@"+"];
    NSData *encryptData = [GTMBase64 decodeData:[str dataUsingEncoding:NSUTF8StringEncoding]];

    size_t plainTextBufferSize = [encryptData length];
    const void *vplainText = [encryptData bytes];

    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;

    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);

    const void *vkey = (const void *) [gkey UTF8String];
    const void *vinitVec = (const void *) [gIv UTF8String];

    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);

    NSString *result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                                     length:(NSUInteger)movedBytes]
                                             encoding:NSUTF8StringEncoding];

    free(bufferPtr);
    return result;
}

@end
