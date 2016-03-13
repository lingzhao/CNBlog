//
//  SMNewsTableViewCell.m
//  CNBlog
//
//  Created by zzZgHhui on 16/3/7.
//  Copyright © 2016年 zzZgHhui. All rights reserved.
//

#import "SMNewsTableViewCell.h"
#import "SMNewsButton.h"
#import "SMNewsModel.h"
#import "NSString+SMDateStringFormatter.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define kPadding 8
#define kIconW 60
#define kIconH 30
#define kFontPadding 4
#define kSummaryW kScreenW - kIconW - kPadding*4
#define kSummaryH 46
#define kTimeW 150
#define kTimeH 20
#define kButtonW kScreenW/3
#define kButtonH 25

@interface SMNewsTableViewCell ()

@property (nonatomic, strong) SMNewsButton *diggsButton;
@property (nonatomic, strong) SMNewsButton *viewsButton;
@property (nonatomic, strong) SMNewsButton *commentButton;

@end

@implementation SMNewsTableViewCell

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
        
        
        self.textLabel.numberOfLines = 0;
        
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.imageView sizeToFit];
        
        self.detailTextLabel.font = [UIFont systemFontOfSize:12];
        self.detailTextLabel.textColor = [UIColor lightGrayColor];
        self.detailTextLabel.textAlignment = NSTextAlignmentRight;
        [self.detailTextLabel sizeToFit];
        
        self.diggsButton = [[SMNewsButton alloc] init];
        self.viewsButton = [[SMNewsButton alloc] init];
        self.commentButton = [[SMNewsButton alloc] init];
        
        // 下划线
        UIView *underLine = [[UIView alloc] initWithFrame:CGRectMake(kPadding*2, 129, kScreenW-4*kPadding, 1)];
        underLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        [self addSubview:self.diggsButton];
        [self addSubview:self.viewsButton];
        [self addSubview:self.commentButton];
        [self addSubview:underLine];
    }
    
    return self;
}

// 重新布局
- (void)layoutSubviews {
    self.imageView.frame = CGRectMake(kPadding, kPadding*2, kIconW, kIconH);
    
    self.textLabel.frame = CGRectMake(kPadding*2+kIconW, self.imageView.y - kPadding, kSummaryW, kSummaryH);
    
    self.detailTextLabel.frame = CGRectMake(kScreenW - kTimeW - 3*kPadding, CGRectGetMaxY(self.textLabel.frame)+kFontPadding, kTimeW, kTimeH);
    
    self.diggsButton.frame = CGRectMake(0, CGRectGetMaxY(self.detailTextLabel.frame)+ kTimeH, kButtonW, kButtonH);
    
    self.viewsButton.frame = CGRectMake(CGRectGetMaxX(self.diggsButton.frame), self.diggsButton.y, kButtonW, kButtonH);
    self.commentButton.frame = CGRectMake(CGRectGetMaxX(self.viewsButton.frame), self.diggsButton.y, kButtonW, kButtonH);
}

// 设置内容
- (void)setNewsModel:(SMNewsModel *)newsModel {
    _newsModel = newsModel;
    NSString *urlString = [newsModel.topicIcon stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
//    NSLog(@"%@", urlString);
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"tabBar_me_click_icon"] options:SDWebImageRefreshCached];
    [self.textLabel setText:newsModel.title];
    [self.detailTextLabel setText:[NSString sm_timeBetweenDate:[newsModel.published sm_dateFromUTCString] andDate:[NSDate date] formatterType:SMDateStringFormatterTypeNormal]];
    
    self.diggsButton.highlighted = NO;
    [self.diggsButton setTitle:newsModel.diggs forState:UIControlStateNormal];
    [self.diggsButton setImage:[UIImage imageNamed:@"mainCellDing"] forState:UIControlStateNormal];
//    [self.diggsButton setTitle:@"" forState:UIControlStateHighlighted];
    [self.diggsButton setImage:[UIImage imageNamed:@"mainCellDingClick"] forState:UIControlStateHighlighted];
    
    self.viewsButton.highlighted = NO;
    [self.viewsButton setTitle:newsModel.views forState:UIControlStateNormal];
    [self.viewsButton setImage:[UIImage imageNamed:@"mainCellShare"] forState:UIControlStateNormal];
//    [self.viewsButton setTitle:@"" forState:UIControlStateHighlighted];
    [self.viewsButton setImage:[UIImage imageNamed:@"mainCellShareClick"] forState:UIControlStateHighlighted];
    
    self.commentButton.highlighted = NO;
    [self.commentButton setTitle:newsModel.comments forState:UIControlStateNormal];
    [self.commentButton setImage:[UIImage imageNamed:@"mainCellComment"] forState:UIControlStateNormal];
//    [self.commentButton setTitle:@"" forState:UIControlStateHighlighted];
    [self.commentButton setImage:[UIImage imageNamed:@"mainCellCommentClick"] forState:UIControlStateHighlighted];
    
}


@end
