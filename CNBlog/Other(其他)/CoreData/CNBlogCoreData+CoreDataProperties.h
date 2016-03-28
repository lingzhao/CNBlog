//
//  CNBlogCoreData+CoreDataProperties.h
//  CNBlog
//
//  Created by zzZgHhui on 16/3/26.
//  Copyright © 2016年 zzZgHhui. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CNBlogCoreData.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNBlogCoreData (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *postID;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *summary;
@property (nullable, nonatomic, retain) NSString *published;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *uri;
@property (nullable, nonatomic, retain) NSString *avatar;

@end

NS_ASSUME_NONNULL_END
