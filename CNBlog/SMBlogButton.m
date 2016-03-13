//
//  SMBlogButton.m
//  CNBlog
//
//  Created by zzZgHhui on 16/3/2.
//  Copyright © 2016年 zzZgHhui. All rights reserved.
//

#import "SMBlogButton.h"

@implementation SMBlogButton

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        // 设置button属性
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:0.4] forState:UIControlStateHighlighted];
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
        
        // 注册点击事件
        [self addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return self;
    
}

// 顶按钮点击事件
- (void)btnClick:(UIButton *)btn {
    
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:10 options:UIViewAnimationOptionTransitionNone animations:^{
        
        btn.transform = CGAffineTransformMakeTranslation(-10, 0);
        
    } completion:^(BOOL finished) {
        
        btn.transform = CGAffineTransformIdentity;
        
    }];
}


@end
