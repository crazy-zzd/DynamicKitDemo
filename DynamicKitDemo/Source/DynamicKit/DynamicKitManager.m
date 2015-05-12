//
//  DynamicKitManager.m
//  DynamicKitDemo
//
//  Created by 朱 俊健 on 15/5/12.
//  Copyright (c) 2015年 朱 俊健. All rights reserved.
//

#import "DynamicKitManager.h"

#import "NSDictionary+DynaKit.h"

@implementation DynamicKitManager

/********************************************/
#pragma mark - Public Methods

+ (UIView *)makeViewWithTemplateName:(NSString *)theName
{
    id jsonObject = [[DynamicKitManager sharedInstance] convertJsonObjectWithTemplateName:theName];

    if (![jsonObject isKindOfClass:[NSDictionary class]]){
        NSLog(@"Not a Dictionary Json");
        return nil;
        
    }
    
    UIView * returnView = [jsonObject toViewItem];
    if ([returnView isKindOfClass:[UIView class]]) {
        return returnView;
    }
    else{
        return nil;
    }
}

/********************************************/
#pragma mark - Private Methods

+ (DynamicKitManager *)sharedInstance
{
    static DynamicKitManager * returnInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        returnInstance = [[DynamicKitManager alloc] init];
    });
    return returnInstance;
}


- (id)convertJsonObjectWithTemplateName:(NSString *)theName
{
    NSString * filePath = [[NSBundle mainBundle]pathForResource:theName ofType:@"json"];
    
    NSString * fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    if (!fileContent) {
        return nil;
    }
    
    NSData * fileData = [fileContent dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;

    id jsonObject = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingAllowFragments error:&error];
    if ([jsonObject isKindOfClass:[NSDictionary class]]){

        NSDictionary *dictionary = (NSDictionary *)jsonObject;
        
        NSLog(@"Dersialized JSON Dictionary = %@", dictionary);
        
    }else if ([jsonObject isKindOfClass:[NSArray class]]){
        
        NSArray *nsArray = (NSArray *)jsonObject;
        
        NSLog(@"Dersialized JSON Array = %@", nsArray);
        
    } else {
        
        NSLog(@"An error happened while deserializing the JSON data.");
    }

    return jsonObject;
}


@end
