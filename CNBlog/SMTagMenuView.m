//
//  SMTagMenuView.m
//  百思不得姐
//
//  Created by zZZ on 15/12/2.
//  Copyright (c) 2015年 zZZ. All rights reserved.
//

#import "SMTagMenuView.h"

#define TagNormalColor [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0]
#define TagSelectedColor [UIColor darkGrayColor]

@interface SMTagMenuView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) UIScrollView *tagMenu;

@end

@implementation SMTagMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
//        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [self initTagMenuAndBottomLine];
    
}

// tagButton下的横线
- (UIView *)bottomLine {
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc] init];
    }
    return _bottomLine;
}

// 创建tapMenu以及Menu下横线
- (void)initTagMenuAndBottomLine {
    
    UIScrollView *tagMenu = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    tagMenu.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0];
    tagMenu.showsHorizontalScrollIndicator = NO;
    tagMenu.showsVerticalScrollIndicator = NO;
    self.tagMenu = tagMenu;
    
    CGFloat btnW = tagMenu.bounds.size.width / self.tagNames.count;
    CGFloat btnH = tagMenu.bounds.size.height;
    CGFloat btmY = 0;
    CGFloat btnX = 0;
    
    if (self.tagNames.count > 6) {
        btnW = tagMenu.bounds.size.width / 6.5;
        tagMenu.delegate = self;
        tagMenu.contentSize = CGSizeMake(btnW * self.tagNames.count, tagMenu.bounds.size.height);
    }
    
    int tag = 0;
    for (NSString *tagName in self.tagNames) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnX, btmY, btnW, btnH);
        btn.tag = tag;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:TagNormalColor forState:UIControlStateNormal];
        [btn setTitleColor:TagSelectedColor forState:UIControlStateSelected];
        [btn setTitle:tagName forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (tag == 0) {
            [self tagBtnClick:btn];
        }
        
        tag++;
        btnX += btnW;
        [tagMenu addSubview:btn];
    }
    
    // 下划线
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(btnW/5, btnH-2, btnW*3/5, 2)];
    bottomLine.backgroundColor = TagSelectedColor;
    
    self.bottomLine = bottomLine;
    [self addSubview:tagMenu];
    [self addSubview:bottomLine];
}

// tag点击事件
- (void)tagBtnClick:(UIButton *)btn {
    if (btn.selected) return;
    
    if (self.selectedButton) {
        self.selectedButton.selected = NO;
    }
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bottomLine.x = btn.x + btn.width/5 - self.tagMenu.contentOffset.x;
        
        if ([self.delegate respondsToSelector:@selector(smTagMenu:didSelectedButtonFrom:to:)]) {
            [self.delegate smTagMenu:self.tagMenu didSelectedButtonFrom:self.selectedButton.tag to:btn.tag];
        }
        
    } completion:^(BOOL finished) {
        
    }];
    
    btn.selected = !btn.isSelected;
    self.selectedButton = btn;
    
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.bottomLine.x = self.selectedButton.x - scrollView.contentOffset.x;
}



@end
