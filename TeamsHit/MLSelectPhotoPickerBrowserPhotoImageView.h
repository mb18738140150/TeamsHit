//
//  MLSelectPhotoPickerBrowserPhotoImageView.h
//  TeamsHit
//
//  Created by 仙林 on 16/7/14.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol ZLPhotoPickerBrowserPhotoImageViewDelegate;

@interface MLSelectPhotoPickerBrowserPhotoImageView : UIImageView
@property (nonatomic, weak) id <ZLPhotoPickerBrowserPhotoImageViewDelegate> tapDelegate;
@property (assign,nonatomic) CGFloat progress;
@end

@protocol ZLPhotoPickerBrowserPhotoImageViewDelegate <NSObject>

@optional

- (void)imageView:(UIImageView *)imageView singleTapDetected:(UITouch *)touch;
- (void)imageView:(UIImageView *)imageView doubleTapDetected:(UITouch *)touch;

@end