//
//  SMBlogModel.h
//  CNBlog
//
//  Created by zzZgHhui on 16/2/29.
//  Copyright © 2016年 zzZgHhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMBlogModel : NSObject

/**
 *  文章id
 */
@property (nonatomic, strong) NSString *postID;

/**
 *  博客题目
 */
@property (nonatomic, strong) NSString *title;

/**
 *  文章概述
 */
@property (nonatomic, strong) NSString *summary;

/**
 *  发布时间
 */
@property (nonatomic, strong) NSString *published;

/**
 *  上次修改时间
 */
@property (nonatomic, strong) NSString *updated;

/**
 *  作者姓名
 */
@property (nonatomic, strong) NSString *name;

/**
 *  作者博客首页url
 */
@property (nonatomic, strong) NSString *uri;

/**
 *  作者头像url
 */
@property (nonatomic, strong) NSString *avatar;

/**
 *  推荐的人数
 */
@property (nonatomic, strong) NSString *diggs;

/**
 *  阅读过的人数
 */
@property (nonatomic, strong) NSString *views;

/**
 *  评论的人数
 */
@property (nonatomic, strong) NSString *comments;


//  提供设置方法
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;

@end
