//
//  SMMoreBlogModel.m
//  CNBlog
//
//  Created by zzZgHhui on 16/3/13.
//  Copyright © 2016年 zzZgHhui. All rights reserved.
//

#import "SMMoreBlogModel.h"

@implementation SMMoreBlogModel

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        // KVC
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"id"]) {
        self.postID = value;
    }
}

@end
