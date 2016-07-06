//
//  CXZGlobalFunctions.h
//  RPAntus
//
//  Created by Crz on 15/11/20.
//  Copyright © 2015年 Ranger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/** 主线程运行 */
CXZ_EXTERN void Run_Main(dispatch_block_t RunMain);

/** 异步加载 回到主线程 */
CXZ_EXTERN void Run_Async(dispatch_block_t RunAsync, dispatch_block_t RunMain);

/** 延迟加载 */
CXZ_EXTERN void Run_Delay(CGFloat Seconds ,dispatch_block_t RunDelay);

/** 使用GCD加线程锁 */
CXZ_EXTERN void Run_Lock_GCD(void (^RunLock)(dispatch_semaphore_t sema));

/** 使用OSSpinLock加线程锁 */
CXZ_EXTERN void Run_Lock_OSSpin(dispatch_block_t RunLock);

/** block内代码块执行所花费的时间 */
CXZ_EXTERN inline void Run_TakeTime (dispatch_block_t block, NSString *message);
