//
//  UIButton+DynaKit.m
//  DynamicKitDemo
//
//  Created by 朱 俊健 on 15/5/13.
//  Copyright (c) 2015年 朱 俊健. All rights reserved.
//

#import "UIButton+DynaKit.h"

#import "objc/runtime.h"

@implementation UIButton (DynaKit)

static NSString* kDynaKitButtonImageUrlKey = @"dynaKitButtonImageUrl";

#pragma mark - public methods

- (void)setImageUrl:(NSString *)imageUrl {
    objc_setAssociatedObject(self, DK_BRIDGE(kDynaKitButtonImageUrlKey), imageUrl, OBJC_ASSOCIATION_RETAIN);
    
    //TODO: 图片渐变效果
    
    [self sd_setImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:[self placeHolderImageName]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];

}


- (NSString *)imageUrl{
  return  objc_getAssociatedObject(self, DK_BRIDGE(kDynaKitButtonImageUrlKey));
}

#pragma mark - private methods

- (NSString *)placeHolderImageName
{
    return @"2.pic.jpg";
}
@end
