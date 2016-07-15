//
//  MLSelectPhotoPickerBrowserPhotoView.h
//  TeamsHit
//
//  Created by 仙林 on 16/7/14.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol ZLPhotoPickerBrowserPhotoViewDelegate;

@interface MLSelectPhotoPickerBrowserPhotoView : UIView
@property (nonatomic, weak) id <ZLPhotoPickerBrowserPhotoViewDelegate> tapDelegate;
@end

@protocol ZLPhotoPickerBrowserPhotoViewDelegate <NSObject>

@optional

- (void)view:(UIView *)view singleTapDetected:(UITouch *)touch;
- (void)view:(UIView *)view doubleTapDetected:(UITouch *)touch;

@end