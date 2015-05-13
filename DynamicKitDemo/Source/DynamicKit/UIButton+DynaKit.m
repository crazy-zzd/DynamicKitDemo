//
//  UIButton+DynaKit.m
//  DynamicKitDemo
//
//  Created by 朱 俊健 on 15/5/13.
//  Copyright (c) 2015年 朱 俊健. All rights reserved.
//

#import "UIButton+DynaKit.h"

#import "objc/runtime.h"
#import "DynamicNavigationController.h"

@implementation UIButton (DynaKit)

static NSString * kDynaKitButtonImageUrlKey = @"dynaKitButtonImageUrl";
static NSString * kDynaKitButtonUrlKey = @"dynaKitButtonUrl";

#pragma mark - public methods

- (void)setImageUrl:(NSString *)imageUrl {
    objc_setAssociatedObject(self, DK_BRIDGE(kDynaKitButtonImageUrlKey), imageUrl, OBJC_ASSOCIATION_COPY);
    
    //TODO: 图片渐变效果
    
    [self sd_setImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:[self placeHolderImageName]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];

}

- (NSString *)imageUrl{
  return  objc_getAssociatedObject(self, DK_BRIDGE(kDynaKitButtonImageUrlKey));
}

- (void)setUrl:(NSString *)url
{
    objc_setAssociatedObject(self, DK_BRIDGE(kDynaKitButtonUrlKey), url, OBJC_ASSOCIATION_COPY);
    
    [self addTarget:self action:@selector(jumpToUrl) forControlEvents:UIControlEventTouchUpInside];
}

- (NSString *)url{
    return objc_getAssociatedObject(self, DK_BRIDGE(kDynaKitButtonUrlKey));
}

#pragma mark - private methods

- (NSString *)placeHolderImageName
{
    return @"2.pic.jpg";
}

- (void)jumpToUrl
{
    NSLog(@"jump to url:%@", self.url);
    DynamicNavigationController * sharedNaviController = [DynamicNavigationController sharedInstance];
    [sharedNaviController pushWebViewWithUrl:self.url];
}
@end
