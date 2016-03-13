//
//  SMMoreBlogTableViewCell.m
//  CNBlog
//
//  Created by zzZgHhui on 16/3/13.
//  Copyright © 2016年 zzZgHhui. All rights reserved.
//

#import "SMMoreBlogTableViewCell.h"
#import "SMMoreBlogModel.h"
#import "NSString+SMDateStringFormatter.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define kPadding 8
#define kImageW 40
#define kImageH 40
#define kFontPadding 4
#define kFontW 200
#define kFontH 18
#define kDetailFontW kFontW
#define kDetailFontH 16

@interface SMMoreBlogTableViewCell ()

@property (nonatomic, strong) UIView *middleLine;

@property (nonatomic, strong) UILabel *postCountLabel;

@end

@implementation SMMoreBlogTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.imageView.clipsToBounds = YES;
        self.imageView.layer.cornerRadius = kImageW/2;
        
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.textColor = [UIColor darkGrayColor];
        
        self.detailTextLabel.font = [UIFont systemFontOfSize:10];
        self.detailTextLabel.textColor = [UIColor lightGrayColor];
        
        self.postCountLabel = [[UILabel alloc] init];
        self.postCountLabel.font = [UIFont boldSystemFontOfSize:12];
        self.postCountLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:self.postCountLabel];
        
        self.middleLine = [[UIView alloc] init];
        self.middleLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:self.middleLine];
    }
    
    return self;
}

// 重新布局控件位置
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(kPadding*2+kFontPadding, kPadding, kImageW, kImageH);
    self.textLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + kPadding + kFontPadding, self.imageView.frame.origin.y + kFontPadding, kFontW, kFontH);
    self.detailTextLabel.frame = CGRectMake(self.textLabel.frame.origin.x, CGRectGetMaxY(self.textLabel.frame), kDetailFontW, kDetailFontH);
    
    // 分割线
    self.middleLine.frame = CGRectMake(kScreenW/2, self.textLabel.y, 1, CGRectGetMaxY(self.detailTextLabel.frame)-self.textLabel.y);
    
    // 发表博客数目
    self.postCountLabel.frame = CGRectMake(self.middleLine.x + kPadding*6, self.textLabel.y, kScreenW/2, self.textLabel.height);
}

// 设置数据
- (void)setBlogModel:(SMMoreBlogModel *)blogModel {
    _blogModel = blogModel;
    
    // 头像url转码处理
    NSString *urlString = [blogModel.avatar stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"tabBar_me_click_icon"] options:SDWebImageRefreshCached];
    
    self.textLabel.text = blogModel.title;
    
    // 发布日期格式转换
    //    blogModel.published = [NSString sm_stringFromUTCString:blogModel.published];
//    self.detailTextLabel.text = [NSString sm_timeBetweenDate:[NSString sm_dateFromUTCString:blogModel.updated] andDate:[NSDate date] formatterType:SMDateStringFormatterTypeUTC];
    
    self.postCountLabel.text = [NSString stringWithFormat:@"已发表%@篇博文", blogModel.postcount];
}

@end
