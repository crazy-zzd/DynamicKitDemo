//
//  DynaKitWebViewController.m
//  DynamicKitDemo
//
//  Created by 朱 俊健 on 15/5/13.
//  Copyright (c) 2015年 朱 俊健. All rights reserved.
//

#import "DynaKitWebViewController.h"

@interface DynaKitWebViewController ()

@property (nonatomic, strong)   UIWebView * webview;
@property (nonatomic, copy)     NSString *  url;

@end

@implementation DynaKitWebViewController

- (DynaKitWebViewController *)initWithUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        self.url = url;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.url) {
        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
        [self.webview loadRequest:request];
        [self.view addSubview:self.webview];
    }
}

- (UIWebView *)webview
{
    if (!_webview) {
        _webview = [[UIWebView alloc] initWithFrame:self.view.frame];
    }
    
    return _webview;
}

@end
