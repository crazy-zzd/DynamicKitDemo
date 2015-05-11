//
//  AppDelegate.h
//  DynamicKitDemo
//
//  Created by 朱 俊健 on 15/5/11.
//  Copyright (c) 2015年 朱 俊健. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//for the main page
@property (strong, nonatomic) UIViewController *viewController;

//for the navigation
@property (strong, nonatomic) UINavigationController *navController;

@end

