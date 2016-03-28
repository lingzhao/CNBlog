//
//  SMAttentionTableViewCell.m
//  CNBlog
//
//  Created by zzZgHhui on 16/3/27.
//  Copyright © 2016年 zzZgHhui. All rights reserved.
//

#import "SMAttentionTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CNNewsCoreData.h"
#import "NSString+SMDateStringFormatter.h"

@interface SMAttentionTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *titleIabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *newsLabel;
@end

@implementation SMAttentionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SMAttentionTableViewCell class]) owner:self options:0] lastObject];
        // 加入左滑手势
        UISwipeGestureRecognizer *swipeRecongsizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellDidSwipe)];
        swipeRecongsizer.direction = UISwipeGestureRecognizerDirectionLeft;
        
        [self.imageView sizeToFit];
    }
    
    return self;
}

// 左滑手势触发
- (void)cellDidSwipe {
    [self setEditing:YES animated:YES];
}

- (void)setCoreDataModel:(CNNewsCoreData *)coreDataModel {
    _coreDataModel = coreDataModel;
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:coreDataModel.topicIcon] placeholderImage:[UIImage imageNamed:@"cnBlogLong"] options:SDWebImageCacheMemoryOnly];
    
    self.timeLabel.text = [NSString sm_timeBetweenDate:[NSString sm_dateFromUTCString:coreDataModel.published] andDate:[NSDate date] formatterType:SMDateStringFormatterTypeNormal];
    
    self.titleIabel.text = coreDataModel.sourceName;
    
    self.newsLabel.text = coreDataModel.title;
}

@end
