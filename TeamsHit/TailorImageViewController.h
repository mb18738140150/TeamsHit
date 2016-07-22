//
//  TailorImageViewController.h
//  TeamsHit
//
//  Created by 仙林 on 16/7/20.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TailorImageBlock)(NSDictionary * imageDic);

@interface TailorImageViewController : UIViewController

@property (nonatomic, copy)TailorImageBlock doneBlock;

- (void)done:(TailorImageBlock)done;
- (instancetype)initWithImage:(UIImage *)image;

@end
