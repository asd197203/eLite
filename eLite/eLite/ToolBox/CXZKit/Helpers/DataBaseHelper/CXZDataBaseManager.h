//
//  CXZDataBaseManager.h
//  Test0124
//
//  Created by Crz on 16/1/25.
//  Copyright © 2016年 常小哲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef void(^CXZDataBaseExecutionDoneBlock)(BOOL success);
typedef void(^CXZQueryPerRowDataDoneBlock)(NSDictionary *dict);

@interface CXZDataBaseManager : NSObject

+ (instancetype)shareInstance;

- (void)open:(NSString *)sqliteFilePath withDict:(NSDictionary *)tableDict;
- (void)open:(NSString *)sqliteFilePath withDict:(NSDictionary *)tableDict done:(CXZDataBaseExecutionDoneBlock)done;

- (void)insert:(NSString *)tableName models:(NSArray *)modelArr;
- (void)insert:(NSString *)tableName models:(NSArray *)modelArr done:(CXZDataBaseExecutionDoneBlock)done;

- (void)deleteData:(NSString *)tableName conditions:(NSArray *)conditions;
- (void)deleteData:(NSString *)tableName conditions:(NSArray *)conditions done:(CXZDataBaseExecutionDoneBlock)done;

- (void)update:(NSString *)tableName param:(NSDictionary *)param condition:(NSDictionary *)condition;
- (void)update:(NSString *)tableName
         param:(NSDictionary *)param
     condition:(NSDictionary *)condition
          done:(CXZDataBaseExecutionDoneBlock)done;

- (void)queryAll:(NSString *)tableName perRow:(CXZQueryPerRowDataDoneBlock)block done:(dispatch_block_t)done;

@end

