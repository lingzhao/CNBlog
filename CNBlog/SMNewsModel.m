//
//  SMNewsModel.m
//  CNBlog
//
//  Created by zzZgHhui on 16/3/7.
//  Copyright © 2016年 zzZgHhui. All rights reserved.
//

#import "SMNewsModel.h"

@implementation SMNewsModel

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
    
    if ([key isEqualToString:@"Title"]) {
        self.title = value;
    }
    
    if ([key isEqualToString:@"SourceName"]) {
        self.sourceName = value;
    }
    
    if ([key isEqualToString:@"CommentCount"]) {
        self.comments = value;
    }
}

@end
