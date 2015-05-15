//
//  DynamicKitManager.m
//  DynamicKitDemo
//
//  Created by 朱 俊健 on 15/5/12.
//  Copyright (c) 2015年 朱 俊健. All rights reserved.
//

#import "DynamicKitManager.h"

#import "NSDictionary+DynaKit.h"
#import <TMCache.h>

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


/**
 *  根据模板名得到模板对象（一般来说就是个Dict）
 *
 *  @param theName 模板名
 *
 *  @return 模板对象（NSDictionary）
 */
- (id)convertJsonObjectWithTemplateName:(NSString *)theName
{
    NSData * fileData = [self templateWithName:theName];
    
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

/**
 *  根据模板名找到想对应的模板数据
 *
 *  @param theName 模板名
 *
 *  @return 对应的模板Json数据
 */
- (NSData *)templateWithName:(NSString *)theName
{
    // 首先检查更新改模板名，然后检查Cache里面有没有，如果有就直接返回Cache
    // 如果Cache里面没有，就寻找本地文件有没有内置模板
    // 如果本地文件也没有内置模板，就返回nil
    NSData * templateData = [self cacheTemplateWithName:theName];
    [self downloadTemplateWithName:theName];
    if (templateData) {
        return templateData;
    }
    
    templateData = [self localTemplateWithName:theName];
    
    return templateData;
}

/**
 *  根据模板名下载模板，并更新Cache
 *
 *  @param theName 模板名
 */
- (void)downloadTemplateWithName:(NSString *)theName
{
    __block NSString * blockName = theName;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString * theFilePath = [NSString stringWithFormat:@"http://7xj2is.com1.z0.glb.clouddn.com/template%@.json?v=%d", blockName, arc4random() % 10000];
        
        NSData * theData = [NSData dataWithContentsOfURL:[NSURL URLWithString:theFilePath]];
        [[TMCache sharedCache] setObject:theData forKey:blockName];
    });
}

- (NSData *)cacheTemplateWithName:(NSString *)theName
{
    NSData * theData = (NSData *)[[TMCache sharedCache] objectForKey:theName];
    return theData;
}

- (NSData *)localTemplateWithName:(NSString *)theName
{
    // 使用本地模板
    NSString * filePath = [[NSBundle mainBundle]pathForResource:theName ofType:@"json"];
    
    NSString * fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    if (!fileContent) {
        return nil;
    }
    
    return [fileContent dataUsingEncoding:NSUTF8StringEncoding];
}

@end
