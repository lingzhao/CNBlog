//
//  SMNewsModel.h
//  CNBlog
//
//  Created by zzZgHhui on 16/3/7.
//  Copyright © 2016年 zzZgHhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMNewsModel : NSObject

/**
 *  新闻id
 */
@property (nonatomic, strong) NSString *postID;

/**
 *  新闻标题
 */
@property (nonatomic, strong) NSString *title;

/**
 *  新闻概述
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

/**
 *  配图
 */
@property (nonatomic, strong) NSString *topicIcon;

// 
@property (nonatomic, strong) NSString *sourceName;

//  提供设置方法
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;

/**
 *  上一条新闻id
 */
@property (nonatomic, strong) NSString *PrevNews;

/**
 *  下一条新闻id
 */
@property (nonatomic, strong) NSString *NextNews;

/**
 *  新闻图片url
 */
@property (nonatomic, strong) NSString *ImageUrl;

/**
 *  新闻Html
 */
@property (nonatomic, strong) NSString *Content;

/**
 *  发布时间
 */
@property (nonatomic, strong) NSString *SubmitDate;

@end
