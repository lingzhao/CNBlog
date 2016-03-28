//
//  SMCollectionTableViewCell.h
//  CNBlog
//
//  Created by zzZgHhui on 16/3/27.
//  Copyright © 2016年 zzZgHhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CNBlogCoreData;
@interface SMCollectionTableViewCell : UITableViewCell

@property (nonatomic, strong) CNBlogCoreData *coreDataModel;

@end
