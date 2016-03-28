//
//  SMCoreDataTool.h
//  CoreDataTest
//
//  Created by zzZgHhui on 16/3/25.
//  Copyright © 2016年 zzZgHhui. All rights reserved.
//

#import <Foundation/Foundation.h>

// 增删改查操作枚举
typedef enum : NSUInteger {
    SMCoreDataToolOperationTypeAdd,
    SMCoreDataToolOperationTypeDelegate,
    SMCoreDataToolOperationTypeUpdate,
    SMCoreDataToolOperationTypeSearch
} SMCoreDataToolOperationType;

@interface SMCoreDataTool : NSObject

/**
 *  mainBundle下所有entity
 */
@property (nonatomic, strong, readonly) NSArray *sm_entitys;

/**
 *  单例
 */
+ (instancetype)shareSMTool;

/**
 *  增删改查操作
 */
+ (void)sm_toolAddDataWithEntity:(NSString *)entity attributeNames:(NSArray *)names attributeValues:(NSArray *)values;
+ (void)sm_toolDeleteDataWithEntity:(NSString *)entity andPredicate:(NSString *)predicate;
+ (void)sm_toolUpdateDataWithEntity:(NSString *)entity attributeName:(NSString *)name predicate:(NSString *)predicate andUpdateValue:(NSString *)value;
+ (NSArray *)sm_toolSearchDataWithEntity:(NSString *)entity andPredicate:(NSString *)predicate;

/**
 *  运行时 增加数据操作
 */
+ (void)sm_toolAddDataWithEntity:(NSString *)entity attributeModel:(id)model;

/**
 *  清除coredata
 */
+ (void)sm_toolClearCoraDataWithEntiy:(NSString *)entity;

@end
