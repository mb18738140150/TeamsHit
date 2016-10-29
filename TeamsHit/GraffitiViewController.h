//
//  GraffitiViewController.h
//  TeamsHit
//
//  Created by 仙林 on 16/7/21.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ GraffitiImageBlock)(UIImage * image);

@interface GraffitiViewController : UIViewController
@property (nonatomic, strong)NSNumber * userId;
@property (nonatomic, strong)UIImage *sourceimage;
- (void)graffitiImage:(GraffitiImageBlock)processImage;
@end
