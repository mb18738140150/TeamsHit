//
//  MLSelectPhotoPickerGroup.h
//  TeamsHit
//
//  Created by 仙林 on 16/7/11.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface MLSelectPhotoPickerGroup : NSObject

/**
 *  组名
 */
@property (nonatomic, copy)NSString * groupName;
/**
 *  组的真实名
 */
@property (nonatomic, copy)NSString * realGroupName;
/**
 *  缩略图
 */
@property (nonatomic, strong)UIImage * thumbImage;
/**
 *  组里面的图片个数
 */
@property (nonatomic, assign)NSInteger assetsCount;
/**
 *  类型 : Saved Photos...
 */
@property (nonatomic, copy)NSString * type;

@property (nonatomic, strong)ALAssetsGroup * group;

@end
