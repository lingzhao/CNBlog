//
//  SMBlogTableViewCell.m
//  CNBlog
//
//  Created by zzZgHhui on 16/2/29.
//  Copyright © 2016年 zzZgHhui. All rights reserved.
//

#import "SMBlogTableViewCell.h"
#import "SMBlogButton.h"
#import "SMBlogModel.h"
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
#define kTitleFontW kScreenW*2/3
#define kTitleFontH 22
#define kSummaryFontW kTitleFontW+kPadding*2
#define kSummaryFontH 100
#define kButtonFontX kScreenW - 40 - kPadding*2 - kFontPadding
#define kButtonFontW 60
#define kButtonFontH 20

@interface SMBlogTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *summaryLabel;
@property (nonatomic, strong) SMBlogButton *diggsButton;
@property (nonatomic, strong) SMBlogButton *viewsButton;
@property (nonatomic, strong) SMBlogButton *commentButton;

@end

@implementation SMBlogTableViewCell

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
        
        self.imageView.clipsToBounds = YES;
        self.imageView.layer.cornerRadius = kImageW/2;
        self.titleLabel = [[UILabel alloc] init];
        self.summaryLabel = [[UILabel alloc] init];
        self.diggsButton = [[SMBlogButton alloc] init];
        self.viewsButton = [[SMBlogButton alloc] init];
        self.commentButton = [[SMBlogButton alloc] init];
        
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.textColor = [UIColor darkGrayColor];
        
        self.detailTextLabel.font = [UIFont systemFontOfSize:10];
        self.detailTextLabel.textColor = [UIColor lightGrayColor];
        
        self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        
        self.summaryLabel.font = [UIFont systemFontOfSize:14];
        self.summaryLabel.numberOfLines = 0;
        
        // 下划线
        UIView *underLine = [[UIView alloc] initWithFrame:CGRectMake(kPadding*2, 199, kScreenW-4*kPadding, 1)];
        underLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.summaryLabel];
        [self addSubview:self.diggsButton];
        [self addSubview:self.viewsButton];
        [self addSubview:self.commentButton];
        [self addSubview:underLine];
        
    }
    
    return self;
}

// 设置内容
- (void)setBlogModel:(SMBlogModel *)blogModel {
    _blogModel = blogModel;
    
    // 头像url转码处理
    NSString *urlString = [blogModel.avatar stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"cnBlogBlack"] options:SDWebImageRefreshCached];
    
    self.textLabel.text = blogModel.name;
    
    // 发布日期格式转换
//    blogModel.published = [NSString sm_stringFromUTCString:blogModel.published];
    self.detailTextLabel.text = [NSString sm_timeBetweenDate:[NSString sm_dateFromUTCString:blogModel.published] andDate:[NSDate date] formatterType:SMDateStringFormatterTypeUTC];
    
    self.titleLabel.text = blogModel.title;
    self.summaryLabel.text = blogModel.summary;
    
    self.diggsButton.highlighted = NO;
    [self.diggsButton setTitle:@"" forState:UIControlStateNormal];
    [self.diggsButton setImage:[UIImage imageNamed:@"mainCellDing"] forState:UIControlStateNormal];
    [self.diggsButton setTitle:self.blogModel.diggs forState:UIControlStateHighlighted];
    [self.diggsButton setImage:[UIImage imageNamed:@"mainCellDingClick"] forState:UIControlStateHighlighted];
    
    self.viewsButton.highlighted = NO;
    [self.viewsButton setTitle:@"" forState:UIControlStateNormal];
    [self.viewsButton setImage:[UIImage imageNamed:@"mainCellShare"] forState:UIControlStateNormal];
    [self.viewsButton setTitle:self.blogModel.views forState:UIControlStateHighlighted];
    [self.viewsButton setImage:[UIImage imageNamed:@"mainCellShareClick"] forState:UIControlStateHighlighted];
    
    self.commentButton.highlighted = NO;
    [self.commentButton setTitle:@"" forState:UIControlStateNormal];
    [self.commentButton setImage:[UIImage imageNamed:@"mainCellComment"] forState:UIControlStateNormal];
    [self.commentButton setTitle:self.blogModel.comments forState:UIControlStateHighlighted];
    [self.commentButton setImage:[UIImage imageNamed:@"mainCellCommentClick"] forState:UIControlStateHighlighted];
    
}

// 重新布局
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(kPadding*2+kFontPadding, kPadding, kImageW, kImageH);
    self.textLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + kPadding + kFontPadding, self.imageView.frame.origin.y + kFontPadding, kFontW, kFontH);
    self.detailTextLabel.frame = CGRectMake(self.textLabel.frame.origin.x, CGRectGetMaxY(self.textLabel.frame), kDetailFontW, kDetailFontH);
    self.titleLabel.frame = CGRectMake(self.imageView.frame.origin.x + kPadding*3, CGRectGetMaxY(self.imageView.frame) + kFontPadding*3, kTitleFontW, kTitleFontH);
    self.summaryLabel.frame = CGRectMake(self.imageView.frame.origin.x + kPadding, CGRectGetMaxY(self.titleLabel.frame) + kFontPadding, kSummaryFontW, kSummaryFontH);
    
    self.diggsButton.frame = CGRectMake(kButtonFontX, CGRectGetMaxY(self.detailTextLabel.frame), kButtonFontW, kButtonFontH);
    self.viewsButton.frame = CGRectMake(kButtonFontX, CGRectGetMaxY(self.diggsButton.frame) + kPadding + kFontPadding, kButtonFontW, kButtonFontH);
    self.commentButton.frame = CGRectMake(kButtonFontX, CGRectGetMaxY(self.viewsButton.frame) + kPadding + kFontPadding, kButtonFontW, kButtonFontH);
}


@end
