//
//  CXZCoreDataTool.h
//  Test1009
//
//  Created by CXZ on 15/10/9.
//  Copyright © 2015年 Ranger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CXZCoreDataTool : NSObject

@property (nonatomic, copy) NSString *datastoreFileName;    //!< 数据库文件名 默认情况下是工程名
@property (nonatomic, strong) NSURL *appDocumentsDirectory; //!< sqlite文件的路径  默认是在Documents下
@property (nonatomic, copy) NSString *projectName; //!< 获取项目名称 默认情况下是作为coreData编辑器的名字

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (CXZCoreDataTool *)shareTool;

- (BOOL)saveContext;

// 创建实体描述对象  然后赋值 直接saveContext就可以了
- (__kindof NSManagedObject *)createModel:(Class)aClass;

//----------------------------------插入数据----------------------------------

// 这两个方法配合使用  先newEntity 获得实体对象后再构造成数组 调用第二个方法
// 这里千万不能create 不然会有问题 原因待研究
- (__kindof NSManagedObject *)newEntity:(Class)aClass;
- (BOOL)insertCoreData:(NSArray *)dataArray;

// 先构造一个字典 键值对应上模型的属性和属性值 然后调用该方法
- (BOOL)insertCoreData:(Class)aClass withDict:(NSDictionary *)dict;

// 这里block回调返回一个NSManagedObject类型的对象 然后用KVC在block里面赋值
// 或者强转成你定义的实体类来属性赋值
- (void)insertCoreData:(Class)aClass withValue:(void(^)(NSManagedObject *obj))value;


//----------------------------------查询数据----------------------------------

- (NSArray *)searchCoreData:(Class)aClass;
- (NSArray *)searchCoreData:(Class)aClass predicate:(NSString *)predicateString;


//----------------------------------删除数据----------------------------------

- (BOOL)deleteCoreData:(Class)aClass predicate:(NSString *)predicateString;

//----------------------------------更改数据----------------------------------

- (BOOL)updateCoreData:(Class)aClass
             predicate:(NSString *)predicateString
                update:(void(^)(__kindof NSManagedObject *obj))update;

@end
