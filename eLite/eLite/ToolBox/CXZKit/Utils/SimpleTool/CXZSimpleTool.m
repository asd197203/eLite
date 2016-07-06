//
//  CXZSimpleTool.m
//  eLite
//
//  Created by 常小哲 on 16/4/18.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import "CXZSimpleTool.h"
#import <AudioToolbox/AudioToolbox.h>

static SystemSoundID soundID;

@implementation CXZSimpleTool

#pragma mark-   创建文件夹

+ (void)createDirectory:(NSString *)directorPath {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    BOOL isDirector = NO;
    BOOL isExiting = [fileManager fileExistsAtPath:directorPath isDirectory:&isDirector];
    if (!(isExiting && isDirector)){
        BOOL createDirection = [fileManager createDirectoryAtPath:directorPath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:nil];
        if (!createDirection){
            NSLog(@"创建文件夹失败");
        }
    }
}

#pragma mark-   生成随机UUID

+ (NSString *)makeUUID {
    // 生成随机不重复的uuid
    CFUUIDRef puuid = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
    NSString *str_uuid = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
    // 将生成的uuid中的@"-"去掉
    NSString *str_name = [str_uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    CFRelease(puuid);
    CFRelease(uuidString);
    return str_name;
}

#pragma mark-  设置铃声和震动

+ (void)setRingtoneShake {
    soundID = kSystemSoundID_Vibrate;
}

+ (void)setRingtone:(NSString *)soundName {
    
    NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@",soundName];
    if (path) {
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
        if (error != kAudioServicesNoError) {
            soundID = 0;
        }
    }
}

+ (void)play {
    AudioServicesPlayAlertSound(soundID);
}

#pragma mark-   设置某个文件不经过iCloud备份

+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *)filePath {
    NSURL* URL= [NSURL fileURLWithPath:filePath];
    assert([[NSFileManager defaultManager] fileExistsAtPath:[URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue:[NSNumber numberWithBool: YES]
                                  forKey:NSURLIsExcludedFromBackupKey error: &error];
    if(!success) {
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

#pragma mark-   监听锁屏状态

+ (void)addObserverForScreenLockState {
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    screenLockStateChanged,
                                    CFSTR("com.apple.springboard.lockcomplete"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    screenLockStateChanged,
                                    CFSTR("com.apple.springboard.lockstate"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
}

// 检测完锁屏状态后回调的方法
void screenLockStateChanged(CFNotificationCenterRef center,
                            void* observer,
                            CFStringRef name,
                            const void* object,
                            CFDictionaryRef userInfo) {
    
    NSString* lockstate = (__bridge NSString*)name;
    
    if ([lockstate isEqualToString:(__bridge NSString *)CFSTR("com.apple.springboard.lockcomplete")]) {
        NSLog(@"locked.");
        [[NSUserDefaults standardUserDefaults] setObject:@"isLock" forKey:@"lockedState"];
    } else {
        NSLog(@"lock state changed.");
    }
}

#pragma mark-  获取文件夹大小

+ (NSString *)sizeOfFolder:(NSString *)folderPath {
    NSArray* filesArray =
    [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:folderPath
                                                        error:nil];
    NSEnumerator* filesEnumerator = [filesArray objectEnumerator];
    NSString* fileName;
    unsigned long long folderSize = 0;
    
    while (fileName = [filesEnumerator nextObject]) {
        NSDictionary* fileDictionary = [[NSFileManager defaultManager]
                                        attributesOfItemAtPath:[folderPath
                                                                stringByAppendingPathComponent:fileName]
                                        error:nil];
        folderSize += [fileDictionary fileSize];
    }
    
    NSString* folderSizeStr;
    if (IOS6_OR_UP) {
        folderSizeStr = [NSByteCountFormatter
                         stringFromByteCount:folderSize
                         countStyle:NSByteCountFormatterCountStyleFile];
    }
    else {
        folderSizeStr = [NSString
                         stringWithFormat:@"%.2f M", (float)folderSize / (1024 * 1024)];
    }
    
    return folderSizeStr;
}

@end
