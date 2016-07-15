//
//  MLPhotoPickImageView.h
//  TeamsHit
//
//  Created by 仙林 on 16/7/14.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MLPhotoPickerImageViewDelegate <NSObject>

@optional
// 点击图片
- (void)photoPickerClickImageView;
// 点击右上角的按钮
- (void)photoPickerClickTickButton:(UIButton *)tickButton;

@end

@interface MLPhotoPickImageView : UIImageView

@property (assign,nonatomic) NSInteger index;
@property (weak,nonatomic) id <MLPhotoPickerImageViewDelegate> delegate;
/**
 *  是否有蒙版层
 */
@property (nonatomic , assign , getter=isMaskViewFlag) BOOL maskViewFlag;
/**
 *  是否有右上角打钩的按钮
 */
@property (nonatomic , assign) BOOL animationRightTick;
/**
 *  是否视频类型
 */
@property (assign,nonatomic) BOOL isVideoType;

@end
