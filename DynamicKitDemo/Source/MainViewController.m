//
//  MainViewController.m
//  DynamicKitDemo
//
//  Created by 朱 俊健 on 15/5/12.
//  Copyright (c) 2015年 朱 俊健. All rights reserved.
//

#import "MainViewController.h"

#import "DynamicKitManager.h"
#import "MJRefresh.h"


@interface MainViewController ()

@property (nonatomic, strong) UIScrollView * mainScrollView;

@property (nonatomic, strong) UIView * statusBarView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.mainScrollView];
    [self.view addSubview:self.statusBarView];
    
    [self addDynamicViewWithTemplateName:@"test"];
    
    __weak MainViewController * weakSelf = self;
    [self.mainScrollView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf addDynamicViewWithTemplateName:@"test"];
    }];
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

- (UIView *)statusBarView
{
    if (!_statusBarView) {
        _statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        _statusBarView.backgroundColor = [UIColor whiteColor];
    }
    
    return _statusBarView;
}

- (void)addDynamicViewWithTemplateName:(NSString *)theName
{
    const NSInteger viewTag = 111;
    UIView * theDynaView = [DynamicKitManager makeViewWithTemplateName:theName];
    theDynaView.tag = viewTag;
    
    self.mainScrollView.contentSize = CGSizeMake(theDynaView.width, theDynaView.height);
    
    UIView * oldView = [self.mainScrollView viewWithTag:viewTag];
    if (oldView) {
        [oldView removeFromSuperview];
    }
    [self.mainScrollView addSubview:theDynaView];
    
    [self.mainScrollView.header endRefreshing];
}
@end
