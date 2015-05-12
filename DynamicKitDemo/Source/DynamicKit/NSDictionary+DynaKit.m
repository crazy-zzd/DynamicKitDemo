//
//  NSDictionary+DynaKit.m
//  DynamicKitDemo
//
//  Created by 朱 俊健 on 15/5/12.
//  Copyright (c) 2015年 朱 俊健. All rights reserved.
//

#import "NSDictionary+DynaKit.h"
#import "objc/runtime.h"

@implementation NSDictionary (DynaKit)

- (UIView *)toViewItem
{
    // 首先判断是不是单个Key-Value，正确格式应该是单个
    // 同时做安全性检验，保证有Key-Value存在
    if (self.allKeys.count != 1) {
        return nil;
    }
    
    // 再判断是不是DKViewItem
    id firstKey = self.allKeys.firstObject;
    if (![firstKey isKindOfClass:[NSString class]]) {
        return nil;
    }
    NSString * firstKeyStr = (NSString *)firstKey;
    if (![firstKeyStr isEqualToString:@"DKViewItem"]) {
        return nil;
    }
    
    // 获取主要属性
    id firstValue = [self valueForKey:firstKeyStr];
    if (![firstValue isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSDictionary * contentDict = (NSDictionary *)firstValue;
    
    // 创建视图
    NSString * className = [contentDict valueForKey:@"_ItemClass"];
    if (![className isKindOfClass:[NSString class]]) {
        return nil;
    }
    Class objectClass = NSClassFromString(className);
    id generateObject = [[objectClass alloc] init];
    if (![generateObject isKindOfClass:[UIView class]]) {
        return nil;
    }
    
    UIView * returnView = (UIView *)generateObject;
    [self loadPropertiesWithDict:contentDict toView:returnView];

    
    // 加入子视图
    if ([contentDict.allKeys containsObject:@"_subviews"] && [[contentDict objectForKey:@"_subviews"] isKindOfClass:[NSArray class]]) {
        
        NSArray * subviewArray = [contentDict objectForKey:@"_subviews"];
        
        for (id theObject in subviewArray) {
            if ([theObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary * theSubviewDict = (NSDictionary *)theObject;
                [returnView addSubview:[theSubviewDict toViewItem]];
            }
        }
    }
    
    return returnView;
}

/**
 *  把Dict中的属性都动态赋值给View
 *
 *  @param theContentDict 字典中含有Key和相应的Value
 *  @param theView        需要被赋值的View
 */
- (void)loadPropertiesWithDict:(NSDictionary *)theContentDict toView:(UIView *)theView
{
    for (int i = 0; i < theContentDict.allKeys.count; i ++) {
        NSString * theKey = theContentDict.allKeys[i];
        // 下划线标识的属性为底层属性，不做处理
        if ([theKey hasPrefix:@"_"]) {
            continue;
        }
        
        
        id theValue = [theContentDict objectForKey:theKey];
        
        // 星号为特殊属性，不能通过字符串直接赋值，需要特殊处理
        if ([theKey hasPrefix:@"*"]) {
            theKey = [NSString stringWithFormat:@"%@", [theKey substringFromIndex:1]];
            theValue = [self specialKey:theKey value:theValue toView:theView];
        }
        
        // 去除空对象
        if (!theValue || [theValue isKindOfClass:[NSNull class]]) {
            continue;
        }
        
        // 赋值！
        @try {
            [theView setValue:theValue forKey:theKey];
        }
        @catch (NSException *exception) {
#if DEBUG
            NSLog(@"Set value for key[%@] with exception[%@]!", theKey, [exception reason]);
#endif
        }
    }
}

/**
 *  对特殊处理的字段进行分配处理
 */
/**
 *  对特殊处理的字段进行分配处理
 *
 *  @return <#return value description#>
 */
- (id)specialKey:(NSString *)theKey value:(id)theValue toView:(UIView *)theView
{
    if ([theKey hasSuffix:@"Color"]) {
        // ****Color情况
        return [self setBackgroundColorWith:theValue toView:theView];
    }
    
    return nil;
}

/**
 *  处理 ****Color 情况
 *
 *  @param theValue 颜色值String
 *  @param theView  需要赋值的View
 */
- (id)setBackgroundColorWith:(id)theValue toView:(UIView *)theView
{
    if (![theValue isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSString * theColorStr = (NSString *)theValue;
    
    // example : rgba_255_255_255_255
    NSArray * theWordArray = [theColorStr componentsSeparatedByString:@"_"];
    if (theWordArray.count == 5) {
        
        CGFloat red     = [theWordArray[1] integerValue] / 255.0;
        CGFloat green   = [theWordArray[2] integerValue] / 255.0;
        CGFloat blue    = [theWordArray[3] integerValue] / 255.0;
        CGFloat alpha   = [theWordArray[4] integerValue] / 255.0;
        
        return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    }
    return nil;
}

@end
