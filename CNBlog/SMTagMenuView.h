//
//  SMTagMenuView.h
//  百思不得姐
//
//  Created by zZZ on 15/12/2.
//  Copyright (c) 2015年 zZZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMTagMenuViewDelegate <NSObject>

@optional

- (void)smTagMenu:(UIView *)tagMenu didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to;

@end

@interface SMTagMenuView : UIView

@property (nonatomic, strong) NSArray *tagNames;
@property (nonatomic, weak) id<SMTagMenuViewDelegate> delegate;

@end
