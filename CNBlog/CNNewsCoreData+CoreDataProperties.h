//
//  CNNewsCoreData+CoreDataProperties.h
//  CNBlog
//
//  Created by zzZgHhui on 16/3/27.
//  Copyright © 2016年 zzZgHhui. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CNNewsCoreData.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNNewsCoreData (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *postID;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *published;
@property (nullable, nonatomic, retain) NSString *topicIcon;
@property (nullable, nonatomic, retain) NSString *sourceName;

@end

NS_ASSUME_NONNULL_END
