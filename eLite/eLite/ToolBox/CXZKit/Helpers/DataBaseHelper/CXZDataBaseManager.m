//
//  CXZDataBaseManager.m
//  Test0124
//
//  Created by Crz on 16/1/25.
//  Copyright © 2016年 常小哲. All rights reserved.
//

#import "CXZDataBaseManager.h"
#import "CXZDataBase.h"
#import "CocoaCracker.h"

@interface CXZDataBaseManager () {
    dispatch_queue_t _dbQueue;
    CXZDataBase *_database;
}

@end

@implementation CXZDataBaseManager

+ (instancetype)shareInstance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init {
    if (self == [super init]) {
 
    }
    return self;
}

#pragma mark-  open data base

- (void)open:(NSString *)sqliteFilePath withDict:(NSDictionary *)tableDict {
    [self open:sqliteFilePath withDict:tableDict done:nil];
}

- (void)open:(NSString *)sqliteFilePath withDict:(NSDictionary *)tableDict done:(CXZDataBaseExecutionDoneBlock)done {
    if (_database) {
        [_database close];
        _database = nil;
    }

    _dbQueue = dispatch_queue_create("com.rangerchiong.com.cxzdatabase", DISPATCH_QUEUE_SERIAL);

    _database = [CXZDataBase databaseWithPath:sqliteFilePath];
    _database.shouldCacheStatements = YES;

    if (!_database.open) {
        !done ?: done(NO);
        return;
    }
    else {
        dispatch_async(_dbQueue, ^{
            __block BOOL result = YES;
            if (tableDict) {
                [tableDict enumerateKeysAndObjectsUsingBlock:^(NSString *key, Class cls, BOOL *stop) {
                    if (![_database tableExists:key]) {
                        if (![self makeCreateSql:key tableModel:cls]) {
                            DBLog(@"数据库表格: [%@] 创建失败", key);
                            *stop = YES;
                            result = NO;
                        }
                    }
                }];
            }else {
                DBLog(@"传入的字典['modelName' : 'modelClass']不能为空");
                result = NO;
            }

            dispatch_async(dispatch_get_main_queue(), ^{
                !done ?: done(result);
            });
        });
    }
}

#pragma mark-   插入数据

- (void)insert:(NSString *)tableName models:(NSArray *)modelArr {
    [self insert:tableName models:modelArr done:nil];
}

- (void)insert:(NSString *)tableName models:(NSArray *)modelArr done:(CXZDataBaseExecutionDoneBlock)done {

    dispatch_async(_dbQueue, ^{
        [_database beginTransaction];
        BOOL bRet = NO;
        @try {
            for (id model in modelArr) {
                bRet = [self makeInsertSql:tableName model:model];
                if (!bRet) {
                    DBLog(@"向[%@] 表中插入 [%@] 的数据 失败", tableName, [model class]);
                    break;
                }
            }
        }
        @catch (NSException *exception) {
            [_database rollback];
        }
        @finally {
            if (!bRet) {
                [_database rollback];
            }
            else {
                [_database commit];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            !done ?: done(bRet);
        });
    });
}

#pragma mark-   删除数据

- (void)deleteData:(NSString *)tableName conditions:(NSArray *)conditions {
    [self deleteData:tableName conditions:conditions done:nil];
}

- (void)deleteData:(NSString *)tableName conditions:(NSArray *)conditions done:(CXZDataBaseExecutionDoneBlock)done {
    dispatch_async(_dbQueue, ^{
        [_database beginTransaction];
        BOOL bRet = NO;
        @try {
            for (NSDictionary *condition in conditions) {
                bRet = [self makeDeleteSql:tableName condition:condition];
                if (!bRet) {
                    DBLog(@"删除[%@]表的数据 失败 condition:%@", tableName, condition);
                    break;
                }
            }
        }
        @catch (NSException *exception) {
            [_database rollback];
        }
        @finally {
            if (!bRet) {
                [_database rollback];
            }
            else {
                [_database commit];
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            !done ?: done(bRet);
        });

    });
}

#pragma mark-   更新数据

- (void)update:(NSString *)tableName param:(NSDictionary *)param condition:(NSDictionary *)condition {
    [self update:tableName param:param condition:condition done:nil];
}

- (void)update:(NSString *)tableName
         param:(NSDictionary *)param
     condition:(NSDictionary *)condition
          done:(CXZDataBaseExecutionDoneBlock)done {
    dispatch_async(_dbQueue, ^{
        [_database beginTransaction];
        BOOL bRet = NO;
        @try {
            bRet = [self makeUpdateSql:tableName param:param condition:condition];
            if (!bRet) {
                DBLog(@"更新[%@]表的数据 失败 condition:%@", tableName, condition);
            }
        }
        @catch (NSException *exception) {
            [_database rollback];
        }
        @finally {
            if (!bRet) {
                [_database rollback];
            }
            else {
                [_database commit];
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            !done ?: done(bRet);
        });

    });
}


#pragma mark-   查找数据
// 查找表中所有数据
- (void)queryAll:(NSString *)tableName perRow:(CXZQueryPerRowDataDoneBlock)block done:(dispatch_block_t)done {
    dispatch_async(_dbQueue, ^{
        CXZResultSet *result = [_database executeQuery:[self queryAllStatement:tableName]];
        while ([result next]) {
            NSDictionary *dict = [result resultDictionary];
            !block ?: block(dict);
        }
        [result close];

        dispatch_async(dispatch_get_main_queue(), ^{
            !done ?: done();
        });
    });
}

#pragma mark-   make sql statements methods

- (BOOL)makeCreateSql:(NSString *)tableName tableModel:(Class)cls {
    __block NSString *tmpSql = @"";
    [[CocoaCracker handle:cls] copyModelPropertyInfo:^(NSString *pName, NSString *pType) {
        NSString *tmpStr = [self typeNameWithPropertyAttri:pType];
        tmpSql = [tmpSql stringByAppendingString:[NSString stringWithFormat:@" ,%@ %@", pName, tmpStr]];
    } copyAttriEntirely:NO];

    if (!tmpSql) return NO;

    NSString *sql = [self createStatement:tableName params:tmpSql];
    BOOL result = [_database executeUpdate:sql];

    return result;
}

- (BOOL)makeInsertSql:(NSString *)tableName model:(id)aModel {
    /***    INSERT INTO tableName [insertKey] VALUES [insertValue]   ***/
    __block NSString *insertKey = @"" , *insertValue = @"";

    NSMutableArray *pNamesArray = @[].mutableCopy;
    [[CocoaCracker handle:[aModel class]] copyModelPropertyName:^(NSString *pName) {
        insertKey = [insertKey stringByAppendingString:[NSString stringWithFormat:@",%@ ", pName]];
        insertValue = [insertValue stringByAppendingString:[NSString stringWithFormat:@",:%@ ", pName]];
        [pNamesArray addObject:pName];
    }];

    // 结束遍历时  将开头多余的","删掉
    if (!insertKey.length) return NO;
    insertKey = [insertKey substringFromIndex:1];

    if (!insertValue.length) return NO;
    insertValue = [insertValue substringFromIndex:1];
    NSString *sql = [self insertStatement:tableName key:insertKey value:insertValue];
    NSDictionary *paramDict = [aModel dictionaryWithValuesForKeys:pNamesArray];
    BOOL bRet = [_database executeUpdate:sql withParameterDictionary:paramDict];

    return bRet;
}

- (BOOL)makeUpdateSql:(NSString *)tableName param:(NSDictionary *)param condition:(NSDictionary *)condition {

    __block NSString *paramStr = @"";
    [param enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL * stop) {
        paramStr = [paramStr stringByAppendingString:[NSString stringWithFormat:@",%@ = %@",key, param[key]]];
    }];
    if (!paramStr.length) return NO;
    paramStr = [paramStr substringFromIndex:1];

    __block NSString *conditionStr = @"";
    [condition enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL * stop) {
        conditionStr = [conditionStr stringByAppendingString:[NSString stringWithFormat:@" AND %@ = %@",key, condition[key]]];
    }];
    if (!conditionStr.length) return NO;
    conditionStr = [conditionStr substringFromIndex:5];

    NSString *sql = [self updateStatement:tableName params:paramStr condition:conditionStr];
    BOOL bRet = [_database executeUpdate:sql];
    return bRet;
}

- (BOOL)makeDeleteSql:(NSString *)tableName condition:(NSDictionary *)condition {
    __block NSString *keyValue = @"";
    [condition enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL * stop) {
        keyValue = [key stringByAppendingString:[NSString stringWithFormat:@" AND %@ = %@",key, value]];
    }];

    if (!keyValue.length) return NO;
    keyValue = [keyValue substringFromIndex:5];

    NSString *sql = [self deleteStatement:tableName condition:keyValue];
    BOOL result = [_database executeUpdate:sql];
    return result;
}

#pragma mark-   sql statements

// craete sql
- (NSString *)createStatement:(NSString *)tableName params:(NSString *)params {
    return [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id Integer PRIMARY KEY %@)", tableName, params];
}

// insert sql
- (NSString *)insertStatement:(NSString *)tableName key:(NSString *)key value:(NSString *)value {
    return [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)", tableName, key, value];
}

// delete sql
- (NSString *)deleteStatement:(NSString *)tableName condition:(NSString *)condition {
    return [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@", tableName, condition];
}

- (NSString *)deleteTableStatement:(NSString *)tableName {
    return [NSString stringWithFormat:@"DELETE FROM %@", tableName];
}

// update
- (NSString *)updateStatement:(NSString *)tableName params:(NSString *)params condition:(NSString *)condition {
    return [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@", tableName, params, condition];
}

// query sql
- (NSString *)queryAllStatement:(NSString *)tableName {
    return [NSString stringWithFormat:@"SELECT * FROM %@", tableName];
}

// select * from Contacts limit 15 offset 20     表示: 从Contacts表跳过20条记录选出15条记录
- (NSString *)queryStatement:(NSString *)tableName showRecords:(NSInteger)rNum stepRecords:(NSInteger)sNum {
    return [NSString stringWithFormat:@"SELECT * FROM %@ LIMIT %ld offset %ld ", tableName, rNum, sNum];
}

- (NSString *)queryStatement:(NSString *)tableName condition:(NSString *)condition {
    return [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@", tableName, condition];
}

- (NSString *)queryOrderlyStatement:(NSString *)tableName condition:(NSString *)condition {
    return [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY %@", tableName, condition];
}

#pragma mark-  property map

- (NSString *)typeNameWithPropertyAttri:(NSString *)pAttri {
    NSString *pType;

    if ([pAttri hasPrefix:@"@"]) {
        // 去除符号 @ 和 "
        pAttri = [[pAttri stringByReplacingOccurrencesOfString:@"\"" withString:@""] substringFromIndex:1];
        pType = self.propertyTypeMap[pAttri];
    }
    else pType = self.propertyTypeMap[pAttri];
    if (!pType.length) DBLog(@"%@ 不是支持的属性类型", pAttri);
    return pType;
}

- (NSDictionary *)propertyTypeMap {
    return @{
             @"NSString" : @"text",
             @"NSDate" : @"text",
             @"NSData" : @"blob",
             @"NSNumber" : @"integer",
             @"q" : @"integer",
             @"Q" : @"integer",
             @"i" : @"integer",
             @"I" : @"integer",
             @"B" : @"integer",
             @"c" : @"integer",
             @"S" : @"integer",
             @"s" : @"integer",
             @"d" : @"real",
             @"f" : @"real",
             };
}

@end





