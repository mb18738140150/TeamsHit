//
//  MLSelectPhotoPickerBrowserPhoto.m
//  TeamsHit
//
//  Created by 仙林 on 16/7/11.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "MLSelectPhotoPickerBrowserPhoto.h"

@implementation MLSelectPhotoPickerBrowserPhoto

- (void)setPhotoObj:(id)photoObj
{
    _photoObj = photoObj;
    
    if ([photoObj isKindOfClass:[MLSelectPhotoAssets class]]) {
        MLSelectPhotoAssets * asset = (MLSelectPhotoAssets *)photoObj;
        self.asset = asset;
    }else if ([photoObj isKindOfClass:[NSURL class]])
    {
        self.photoURL = photoObj;
    }else if ([photoObj isKindOfClass:[UIImage class]]){
        self.photoImage = photoObj;
    }else if ([photoObj isKindOfClass:[NSString class]]){
        self.photoURL = [NSURL URLWithString:photoObj];
    }else{
        NSAssert(true == true, @"您传入的类型有问题");
    }
}
- (UIImage *)photoImage
{
    if (!_photoImage && self.asset) {
        _photoImage = [self.asset originImage];
    }
    return _photoImage;
}

- (UIImage *)thumbImage{
    if (!_thumbImage) {
        if (self.asset) {
            _thumbImage = [self.asset thumbImage];
        }else if (_photoImage){
            _thumbImage = _photoImage;
        }
    }
    return _thumbImage;
}
#pragma mark - 传入一个图片对象，可以是URL/UIImage/NSString，返回一个实例
+ (instancetype)photoAnyImageObjWith:(id)imageObj{
    MLSelectPhotoPickerBrowserPhoto *photo = [[self alloc] init];
    [photo setPhotoObj:imageObj];
    return photo;
}

@end
