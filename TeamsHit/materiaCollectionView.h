//
//  materiaCollectionView.h
//  TeamsHit
//
//  Created by 仙林 on 16/10/12.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^MateriaBlock)(NSString * namestring, UIImage * materiaimage);
@interface materiaCollectionView : UIView

- (void)getMateriaImage:(MateriaBlock)materiaBlock;
@end
