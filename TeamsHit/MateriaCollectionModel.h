//
//  MateriaCollectionModel.h
//  TeamsHit
//
//  Created by 仙林 on 16/10/12.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MateriaCollectionModel : NSObject

@property (nonatomic, copy)NSString * materiaTitle;
@property (nonatomic, strong)UIImage * materiaImage;
@property (nonatomic, copy)NSString * materiaImageStr;
@property (nonatomic, assign)CGFloat materiaImageWidth;
@property (nonatomic, assign)CGFloat materiaImageHeight;

@end
