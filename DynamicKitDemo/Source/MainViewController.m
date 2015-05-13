//
//  MainViewController.m
//  DynamicKitDemo
//
//  Created by 朱 俊健 on 15/5/12.
//  Copyright (c) 2015年 朱 俊健. All rights reserved.
//

#import "MainViewController.h"

#import "DynamicKitManager.h"

@interface MainViewController ()

@property (nonatomic, strong) UIScrollView * mainScrollView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.mainScrollView];
    
    [self addDynamicViewWithTemplateName:@"test"];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.navigationController.navigationBar.hidden == NO) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIScrollView *)mainScrollView
{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        _mainScrollView.showsVerticalScrollIndicator = NO;
    }
    
    return _mainScrollView;
}

- (void)addDynamicViewWithTemplateName:(NSString *)theName
{
    UIView * theDynaView = [DynamicKitManager makeViewWithTemplateName:theName];
    
    self.mainScrollView.contentSize = CGSizeMake(theDynaView.width, theDynaView.height);
    
    [self.mainScrollView addSubview:theDynaView];
}
@end
