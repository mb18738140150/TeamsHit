//
//  TextEditViewController.h
//  TeamsHit
//
//  Created by 仙林 on 16/7/22.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ TextEditBlock)(UIImage * image);
@interface TextEditViewController : UIViewController

- (void)getTextEditImage:(TextEditBlock)processImage;

@end
