//
//  NSData+SymEncrypt.m
//  RPAntus
//
//  Created by Crz on 15/12/15.
//  Copyright © 2015年 Ranger. All rights reserved.
//

#import "NSData+SymEncrypt.h"
#import <CommonCrypto/CommonCryptor.h>

#define gkey            @"b0326c4f1e0e2c2970584b14a5a36d1886b4b115"
#define gIv             @"antushen"  // 可以为NULL

@implementation NSData (SymEncrypt)

- (NSData *)des3_enc {
    const void *input = self.bytes;
    size_t inputSize = self.length;

    size_t bufferSize = (inputSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    uint8_t *buffer = malloc( bufferSize * sizeof(uint8_t));
    memset((void *)buffer, 0x0, bufferSize);
    size_t movedBytes = 0;

    const void *vkey = gkey;// (由外界传入NSData *key--->) 这里就改成这样key.bytes;

    CCCryptorStatus ccStatus = CCCrypt(kCCEncrypt,
                                       kCCAlgorithmDES,
                                       kCCOptionECBMode|kCCOptionPKCS7Padding,
                                       vkey,
                                       kCCKeySizeDES,
                                       gkey,
                                       input,
                                       inputSize,
                                       (void *)buffer,
                                       bufferSize,
                                       &movedBytes);
    if (ccStatus != kCCSuccess) {
        NSLog(@"error code %d", ccStatus);
        free(buffer);
        return nil;
    }
    NSData *encrypted = [NSData dataWithBytes:(const void *)buffer length:(NSUInteger)movedBytes];
    free(buffer);
    return encrypted;
}

- (NSData *)des3_dec {
    const void *input = self.bytes;
    size_t inputSize = self.length;

    size_t bufferSize = 1024;
    uint8_t *buffer = malloc( bufferSize * sizeof(uint8_t));
    memset((void *)buffer, 0x0, bufferSize);
    size_t movedBytes = 0;

    const void *vkey = gkey;// (由外界传入NSData *key--->) 这里就改成这样key.bytes;

    CCCryptorStatus ccStatus = CCCrypt(kCCDecrypt,
                                       kCCAlgorithmDES,
                                       kCCOptionECBMode|kCCOptionPKCS7Padding,
                                       vkey,
                                       kCCKeySizeDES,
                                       gIv,
                                       input,
                                       inputSize,
                                       (void *)buffer,
                                       bufferSize,
                                       &movedBytes);

    if (ccStatus != kCCSuccess) {
        NSLog(@"error code %d", ccStatus);
        free(buffer);
        return nil;
    }

    NSData *decrypted = [NSData dataWithBytes:(const void *)buffer length:(NSUInteger)movedBytes];
    free(buffer);
    return decrypted;

}

@end
