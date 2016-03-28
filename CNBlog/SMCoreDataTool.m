//
//  SMCoreDataTool.m
//  CoreDataTest
//
//  Created by zzZgHhui on 16/3/25.
//  Copyright © 2016年 zzZgHhui. All rights reserved.
//

#import "SMCoreDataTool.h"
#import <objc/runtime.h>
#import <CoreData/CoreData.h>

@interface SMCoreDataTool ()

// CoreData实体
@property (nonatomic, strong) NSManagedObjectModel *sm_model;
// 操作实体
@property (nonatomic, strong) NSManagedObjectContext *sm_context;
// 存储策略
@property (nonatomic, strong) NSPersistentStoreCoordinator *sm_coordinator;

@end

@implementation SMCoreDataTool

// 单例创建
+ (instancetype)shareSMTool {
    
    static SMCoreDataTool *_shareInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[SMCoreDataTool alloc] init];
    });
    
    return _shareInstance;
}

/**
 *  mainBundle下所有entity
 */
- (NSArray *)sm_entitys {
    return self.sm_model.entities;
}

// 销毁对象
- (void)dealloc {
    self.sm_context = nil;
    self.sm_coordinator = nil;
    self.sm_model = nil;
}

/**
 *  清除coredata
 */
+ (void)sm_toolClearCoraDataWithEntiy:(NSString *)entity {
    [self sm_toolDeleteDataWithEntity:entity andPredicate:nil];
}

#pragma mark - 增 删 改 查 操作

/**
 *  类方法调用对象方法
 */
+ (void)sm_toolAddDataWithEntity:(NSString *)entity attributeNames:(NSArray *)names attributeValues:(NSArray *)values {
    [[self shareSMTool] sm_toolAddDataWithEntity:entity attributeNames:names attributeValues:values];
}

+ (void)sm_toolDeleteDataWithEntity:(NSString *)entity andPredicate:(NSString *)predicate {
    [[self shareSMTool] sm_toolDeleteDataWithEntity:entity andPredicate:predicate];
}

+ (void)sm_toolUpdateDataWithEntity:(NSString *)entity attributeName:(NSString *)name predicate:(NSString *)predicate andUpdateValue:(NSString *)value {
    [[self shareSMTool] sm_toolUpdateDataWithEntity:entity attributeName:name attributeValue:value andPredicate:predicate];
}

+ (NSArray *)sm_toolSearchDataWithEntity:(NSString *)entity andPredicate:(NSString *)predicate {
    return [[self shareSMTool] sm_toolSearchDataWithEntity:entity andPredicate:predicate];
}

/**
 *  对象方法
 */
- (void)sm_toolAddDataWithEntity:(NSString *)entity attributeNames:(NSArray *)names attributeValues:(NSArray *)values {
    // 关联实体对象和实体上下文
    NSManagedObject *obj = [NSEntityDescription insertNewObjectForEntityForName:entity inManagedObjectContext:self.sm_context];
    // 绑定数据
    for (int i = 0; i < MIN(names.count, values.count); i++) {
        [obj setValue:values[i] forKey:names[i]];
    }
    // 保存上下文关联对象
    [self.sm_context save:nil];
}

- (void)sm_toolDeleteDataWithEntity:(NSString *)entity andPredicate:(NSString *)predicate {
    // 检索对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entity];
    // 设置检索条件
    request.predicate = [NSPredicate predicateWithFormat:predicate];
    // 删除操作
    for (NSManagedObject *obj in [self.sm_context executeFetchRequest:request error:nil]) {
        [self.sm_context deleteObject:obj];
    }
    // 保存上下文关联对象
    [self.sm_context save:nil];
}

- (void)sm_toolUpdateDataWithEntity:(NSString *)entity attributeName:(NSString *)name attributeValue:(NSString *)value andPredicate:(NSString *)predicate {
    // 检索对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entity];
    // 设置检索条件
    request.predicate = [NSPredicate predicateWithFormat:predicate];
    // 更新操作
    for (NSManagedObject *obj in [self.sm_context executeFetchRequest:request error:nil]) {
        [obj setValue:value forKey:name];
    }
    // 保存上下文关联对象
    [self.sm_context save:nil];
}

- (NSArray *)sm_toolSearchDataWithEntity:(NSString *)entity andPredicate:(NSString *)predicate {
    // 检索对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entity];
    // 设置检索条件
    request.predicate = [NSPredicate predicateWithFormat:predicate];
    NSLog(@"%@", request.predicate);
    // 查找操作
    return [self.sm_context executeFetchRequest:request error:nil];
}

#pragma mark - 运行时 增删改查操作

/**
 *  运行时 增删改查 类方法
 */
+ (void)sm_toolAddDataWithEntity:(NSString *)entity attributeModel:(id)model {
    // entity或model为空直接返回
    if (!entity||!model) return;
    
    [[self shareSMTool] sm_toolAddDataWithEntity:entity attributeModel:model];
}

/**
 *  运行时 增删改查 对象方法
 */
- (void)sm_toolAddDataWithEntity:(NSString *)entity attributeModel:(id)model {
    // 获取model类下所有属性名
    NSArray *modelArr = [SMCoreDataTool getAllPropertyNames:[model class]];
    // 获取entity类下所有属性名
    NSArray *entityArr = [SMCoreDataTool getAllPropertyNames:NSClassFromString(entity)];
    // 对比两个arr找出相同属性名
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF in %@", modelArr];
    NSArray *commonArr = [entityArr filteredArrayUsingPredicate:predicate];
    // 关联实体对象和实体上下文
    NSManagedObject *managedObj = [NSEntityDescription insertNewObjectForEntityForName:entity inManagedObjectContext:self.sm_context];
    // 绑定数据
    [commonArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![model valueForKey:obj]) return; // 无数据直接返回

        [managedObj setValue:[model valueForKey:obj] forKey:obj];
    }];
    // 保存上下文关联对象
    [self.sm_context save:nil];
}

#pragma mark - Core Data stack

// 懒加载
// coradata实体
- (NSManagedObjectModel *)sm_model {
    if (!_sm_model) {
        // nil表示从mainBundle加载
        _sm_model = [NSManagedObjectModel mergedModelFromBundles:nil];
    }
    return _sm_model;
}

// 存储策略
- (NSPersistentStoreCoordinator *)sm_coordinator {
    if (!_sm_coordinator) {
        
        // 通过模型和数据库持久化
        _sm_coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.sm_model];
        
        // 持久化到coredata, 默认路径为 /documents/coredata.db
        NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        document = [document stringByAppendingPathComponent:@"coredata.db"];
        NSURL *url = [NSURL fileURLWithPath:document];
        
        // 错误记录
        NSError *error;
        NSString *failureReason = @"There was an error creating or loading the application's saved data.";
        if (![_sm_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error]) {
            // Report any error we got.
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
            dict[NSLocalizedFailureReasonErrorKey] = failureReason;
            dict[NSUnderlyingErrorKey] = error;
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
    }
    return _sm_coordinator;
}

// 操作实体
- (NSManagedObjectContext *)sm_context {
    if (!_sm_context) {
        _sm_context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _sm_context.persistentStoreCoordinator = self.sm_coordinator;
    }
    return _sm_context;
}

#pragma 其他辅助方法

/**
 *  获取类的全部属性名
 */
+ (NSArray *)getAllPropertyNames:(Class)cls {
    
    // 获取cls下所有属性
    unsigned int count; // 记录属性个数
    objc_property_t *properties = class_copyPropertyList(cls, &count);
    // 遍历
    NSMutableArray *arrM = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        // objc_property_t 属性类型
        objc_property_t property = properties[i];
        // 获取属性名称 C语言字符串
        const char *cName = property_getName(property);
        // 转为oc字符串
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        [arrM addObject:name];
    }
    
    return [arrM copy];
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.sm_context;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
