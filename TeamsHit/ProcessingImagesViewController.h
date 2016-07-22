//
//  ProcessingImagesViewController.h
//  TeamsHit
//
//  Created by 仙林 on 16/7/19.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ ProcessImage)(UIImage * image);

@interface ProcessingImagesViewController : UIViewController

@property (nonatomic, strong)UIImage *image;

- (void)processImage:(ProcessImage)processImage;

@end
