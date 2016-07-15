//
//  MLSelectPhotoPickerBrowserPhoto.h
//  TeamsHit
//
//  Created by 仙林 on 16/7/11.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MLSelectPhotoAssets.h"

@interface MLSelectPhotoPickerBrowserPhoto : NSObject

/**
 *  自动适配是不是以下几种数据
 */
@property (nonatomic , strong) id photoObj;
/**
 *  保存相册模型
 */
@property (nonatomic , strong) MLSelectPhotoAssets *asset;
/**
 *  URL地址
 */
@property (nonatomic , strong) NSURL *photoURL;
/**
 *  原图
 */
@property (nonatomic , strong) UIImage *photoImage;
/**
 *  缩略图
 */
@property (nonatomic , strong) UIImage *thumbImage;
/**
 *  传入一个图片对象，可以是URL/UIImage/NSString，返回一个实例
 */
+ (instancetype)photoAnyImageObjWith:(id)imageObj;

@end
