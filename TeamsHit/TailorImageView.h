//
//  TailorImageView.h
//  TeamsHit
//
//  Created by 仙林 on 16/7/20.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TailorImageView : UIView

@property (nonatomic, strong)UIImage * image;

//初始化
- (instancetype)initWithFrame:(CGRect)frame
                        image:(UIImage *)image
                    rectArray:(NSArray *)rectArray;
//截图
- (NSDictionary *)cropedImageArray;

- (void)addCropRect:(CGRect)rect;

- (void)removeCropRectByIndex:(NSInteger)index;

@end
