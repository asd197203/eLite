//
//  CXZSimpleTool.h
//  eLite
//
//  Created by 常小哲 on 16/4/18.
//  Copyright © 2016年 lxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXZSimpleTool : NSObject

/** 创建文件夹 */
+ (void)createDirectory:(NSString *)directorPath;

/** 生成随机UUID */
+ (NSString *)makeUUID;

//----------------------------------铃声和振动----------------------------------

/** 设置振动 */
+ (void)setRingtoneShake;

/** 设置铃声名字和类型 */
+ (void)setRingtone:(NSString *)soundName;

/** 播放 */
+ (void)play;

//----------------------------------设置某文件(夹)不备份到iCloud----------------------------------

/** 设置某文件(夹)不备份到iCloud */
+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *)filePath;

//----------------------------------监听锁屏状态----------------------------------

/** 检测锁屏状态 */
+ (void)addObserverForScreenLockState;

//----------------------------------获取文件夹大小----------------------------------

/** 获取文件夹大小 */
+ (NSString *)sizeOfFolder:(NSString *)folderPath;

@end
