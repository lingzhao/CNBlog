//
//  SMMoreBlogModel.h
//  CNBlog
//
//  Created by zzZgHhui on 16/3/13.
//  Copyright © 2016年 zzZgHhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMMoreBlogModel : NSObject

/**
 *  文章id
 */
@property (nonatomic, strong) NSString *postID;

/**
 *  作者名
 */
@property (nonatomic, strong) NSString *title;

/**
 *  上次修改时间
 */
@property (nonatomic, strong) NSString *updated;

/**
 *  作者id
 */
@property (nonatomic, strong) NSString *blogapp;

/**
 *  发表博文数
 */
@property (nonatomic, strong) NSString *postcount;

/**
 *  作者头像url
 */
@property (nonatomic, strong) NSString *avatar;

//  提供设置方法
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;

@end
