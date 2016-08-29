//
//  SearchBarView.m
//  TeamsHit
//
//  Created by 仙林 on 16/8/9.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "SearchBarView.h"

@interface SearchBarView ()

@property (nonatomic, strong)UIImageView * searchImageView;
@property (nonatomic, strong)UIView * bottomLineView;

@end

@implementation SearchBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    self.searchImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 20, 20)];
    self.searchImageView.image = [UIImage imageNamed:@"icon_search"];
    [self addSubview:self.searchImageView];
    
    self.searchTextView = [[UITextField alloc]initWithFrame:CGRectMake(25, 10, self.hd_width - 30, 20)];
    self.searchTextView.backgroundColor = [UIColor clearColor];
    self.searchTextView.font = [UIFont systemFontOfSize:16];
    self.searchTextView.textColor = [UIColor colorWithWhite:.2 alpha:1];
    self.searchTextView.placeholder = @"搜索";
    [self addSubview:self.searchTextView];
    
    self.placeholdLabel = [[UILabel alloc]initWithFrame:CGRectMake(32, 14, 33, 16)];
    self.placeholdLabel.font = [UIFont systemFontOfSize:16];
    self.placeholdLabel.textColor = UIColorFromRGB(0xCCCCCC);
    self.placeholdLabel.backgroundColor = [UIColor clearColor];
    self.placeholdLabel.userInteractionEnabled = YES;
    self.placeholdLabel.text = @"搜索";
//    [self addSubview:self.placeholdLabel];
    
    self.bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchImageView.frame) + 5, self.hd_width - 10, 1)];
    self.bottomLineView.backgroundColor = UIColorFromRGB(0xFD5B35);
    [self addSubview:self.bottomLineView];
    
}

- (void)setBottomColor:(UIColor *)bottomColor
{
    self.bottomLineView.backgroundColor = bottomColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
