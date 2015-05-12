//
//  DynamicKitManager.h
//  DynamicKitDemo
//
//  Created by 朱 俊健 on 15/5/12.
//  Copyright (c) 2015年 朱 俊健. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface DynamicKitManager : NSObject

/**
 *  make a view with Template Name
 *
 *  @param theName the Template Name
 *
 *  @return Template View
 */
+ (UIView *)makeViewWithTemplateName:(NSString *)theName;

@end
