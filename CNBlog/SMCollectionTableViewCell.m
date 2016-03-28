//
//  SMCollectionTableViewCell.m
//  CNBlog
//
//  Created by zzZgHhui on 16/3/27.
//  Copyright © 2016年 zzZgHhui. All rights reserved.
//

#import "SMCollectionTableViewCell.h"
#import "CNBlogCoreData.h"
#import "NSString+SMDateStringFormatter.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SMCollectionTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation SMCollectionTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SMCollectionTableViewCell class]) owner:self options:0] lastObject];
        // 加入左滑手势
        UISwipeGestureRecognizer *swipeRecongsizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellDidSwipe)];
        swipeRecongsizer.direction = UISwipeGestureRecognizerDirectionLeft;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 左滑手势触发
- (void)cellDidSwipe {
    [self setEditing:YES animated:YES];
}

// 设置数据
- (void)setCoreDataModel:(CNBlogCoreData *)coreDataModel {
    _coreDataModel = coreDataModel;
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:coreDataModel.avatar] placeholderImage:[UIImage imageNamed:@"cnBlog"] options:SDWebImageCacheMemoryOnly completed:nil];
    
    [self.nameLabel setText:coreDataModel.name];
    // 日期格式转换
    [self.timeLabel setText:[NSString sm_timeBetweenDate:[NSString sm_dateFromUTCString:coreDataModel.published] andDate:[NSDate  date] formatterType:SMDateStringFormatterTypeNormal]];
    [self.titleLabel setText:coreDataModel.title];
    
}

@end
