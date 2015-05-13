//
//  DynamicNavigationController.m
//  DynamicKitDemo
//
//  Created by 朱 俊健 on 15/5/13.
//  Copyright (c) 2015年 朱 俊健. All rights reserved.
//

#import "DynamicNavigationController.h"

#import "DynaKitWebViewController.h"

@implementation DynamicNavigationController

+ (DynamicNavigationController *)sharedInstance
{
    static DynamicNavigationController * sharedNaviController;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedNaviController = [[DynamicNavigationController alloc] init];
    });
    
    return sharedNaviController;
}

- (void)pushWebViewWithUrl:(NSString *)theUrl
{
    DynaKitWebViewController * theWebVC = [[DynaKitWebViewController alloc] initWithUrl:theUrl];
    [self pushViewController:theWebVC animated:YES];
    
    // 导航栏出现
    if (self.navigationBarHidden == YES) {
        [self setNavigationBarHidden:NO animated:YES];
    }
}
@end
