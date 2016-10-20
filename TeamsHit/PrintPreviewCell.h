//
//  PrintPreviewCell.h
//  TeamsHit
//
//  Created by 仙林 on 16/10/18.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrintPreviewCell : UITableViewCell
@property (nonatomic, strong)UIImageView * photoImageView;
@property (nonatomic, strong)UIImage * image;
- (void)creatSubView:(CGFloat)width;

@end
