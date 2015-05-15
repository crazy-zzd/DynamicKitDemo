//
//  UITextView+DynaKit.m
//  DynamicKitDemo
//
//  Created by 朱 俊健 on 15/5/13.
//  Copyright (c) 2015年 朱 俊健. All rights reserved.
//

#import "UITextView+DynaKit.h"

#import "objc/runtime.h"

@implementation UITextView (DynaKit)

static NSString * kDynaKitTextFontName = @"dynaKitTextFontName";
static NSString * kDynaKitTextFontSize = @"dynaKitTextFontSize";

#pragma mark - public methods

- (void)setFontName:(NSString *)fontName
{
    objc_setAssociatedObject(self, DK_BRIDGE(kDynaKitTextFontName), fontName, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [self resetFont];
}

- (NSString *)fontName
{
    return objc_getAssociatedObject(self, DK_BRIDGE(kDynaKitTextFontName));
}

- (void)setFontSize:(NSString *)fontSize
{
    objc_setAssociatedObject(self, DK_BRIDGE(kDynaKitTextFontSize), fontSize, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [self resetFont];
}

- (NSString *)fontSize
{
    return objc_getAssociatedObject(self, DK_BRIDGE(kDynaKitTextFontSize))? :@"0";
}

#pragma mark - private methods

- (void)resetFont
{
    self.font = [UIFont fontWithName:self.fontName size:self.fontSize.floatValue];
}

@end
