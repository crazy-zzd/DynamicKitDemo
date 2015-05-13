//
//  DynamicNavigationController.h
//  DynamicKitDemo
//
//  Created by 朱 俊健 on 15/5/13.
//  Copyright (c) 2015年 朱 俊健. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DynamicNavigationController : UINavigationController

+ (DynamicNavigationController *)sharedInstance;

- (void)pushWebViewWithUrl:(NSString *)theUrl;
@end
