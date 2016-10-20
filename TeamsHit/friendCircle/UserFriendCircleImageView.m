//
//  UserFriendCircleImageView.m
//  TeamsHit
//
//  Created by 仙林 on 16/10/19.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "UserFriendCircleImageView.h"

@implementation UserFriendCircleImageView

- (instancetype)initWithFrame:(CGRect)frame imageurlArr:(NSArray *)imageUrlArr
{
    if (self = [super initWithFrame:frame]) {
        [self prepareUIWith:imageUrlArr];
    }
    return self;
}

- (void)prepareUIWith:(NSArray *)imageUrlArr
{
    switch (imageUrlArr.count) {
        case 1:
            [self creatoneImage:imageUrlArr];
            break;
        case 2:
            [self creattwoImage:imageUrlArr];
            break;
        case 3:
            [self creatthreeImage:imageUrlArr];
            break;
        case 4:
            [self creatfourImage:imageUrlArr];
            break;
            
        default:
            break;
    }
}

- (void)creatoneImage:(NSArray *)arr
{
    UIImageView * imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.hd_width, self.hd_height)];
    [imageview sd_setImageWithURL:[NSURL URLWithString:arr[0]] placeholderImage:[UIImage imageNamed:@"placeHolderImage1"]];
    
    [self addSubview:imageview];
    
}

- (void)creattwoImage:(NSArray *)arr
{
    UIImageView * imageviewleft = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (self.hd_width - 2) / 2, self.hd_height)];
    [imageviewleft sd_setImageWithURL:[NSURL URLWithString:arr[0]] placeholderImage:[UIImage imageNamed:@"placeHolderImage1"]];
    [self addSubview:imageviewleft];
    
    UIImageView * imageviewRight = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageviewleft.frame) + 2, 0, (self.hd_width - 2) / 2, self.hd_height)];
    [imageviewRight sd_setImageWithURL:[NSURL URLWithString:arr[1]] placeholderImage:[UIImage imageNamed:@"placeHolderImage1"]];
    [self addSubview:imageviewRight];
    
}

- (void)creatthreeImage:(NSArray *)arr
{
    UIImageView * imageviewleft = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (self.hd_width - 2) / 2, self.hd_height)];
    [imageviewleft sd_setImageWithURL:[NSURL URLWithString:arr[0]] placeholderImage:[UIImage imageNamed:@"placeHolderImage1"]];
    [self addSubview:imageviewleft];
    
    UIImageView * imageviewRighttop = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageviewleft.frame) + 2, 0, (self.hd_width - 2) / 2, (self.hd_height - 2) / 2)];
    [imageviewRighttop sd_setImageWithURL:[NSURL URLWithString:arr[1]] placeholderImage:[UIImage imageNamed:@"placeHolderImage1"]];
    [self addSubview:imageviewRighttop];
    
    
    UIImageView * imageviewRightbottom = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageviewleft.frame) + 2, self.hd_height / 2 + 1, (self.hd_width - 2) / 2, (self.hd_height - 2) / 2)];
    [imageviewRightbottom sd_setImageWithURL:[NSURL URLWithString:arr[2]] placeholderImage:[UIImage imageNamed:@"placeHolderImage1"]];
    [self addSubview:imageviewRightbottom];
    
}

- (void)creatfourImage:(NSArray *)arr
{
    UIImageView * imageviewleft = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (self.hd_width - 2) / 2, (self.hd_height - 2) / 2)];
    [imageviewleft sd_setImageWithURL:[NSURL URLWithString:arr[0]] placeholderImage:[UIImage imageNamed:@"placeHolderImage1"]];
    [self addSubview:imageviewleft];
    
    UIImageView * imageviewleftbottom = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.hd_height / 2 + 1, (self.hd_width - 2) / 2, (self.hd_height - 2) / 2)];
    [imageviewleftbottom sd_setImageWithURL:[NSURL URLWithString:arr[0]] placeholderImage:[UIImage imageNamed:@"placeHolderImage1"]];
    [self addSubview:imageviewleftbottom];
    
    UIImageView * imageviewRighttop = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageviewleft.frame) + 2, 0, (self.hd_width - 2) / 2, (self.hd_height - 2) / 2)];
    [imageviewRighttop sd_setImageWithURL:[NSURL URLWithString:arr[1]] placeholderImage:[UIImage imageNamed:@"placeHolderImage1"]];
    [self addSubview:imageviewRighttop];
    
    
    UIImageView * imageviewRightbottom = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageviewleft.frame) + 2, self.hd_height / 2 + 1, (self.hd_width - 2) / 2, (self.hd_height - 2) / 2)];
    [imageviewRightbottom sd_setImageWithURL:[NSURL URLWithString:arr[2]] placeholderImage:[UIImage imageNamed:@"placeHolderImage1"]];
    [self addSubview:imageviewRightbottom];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
