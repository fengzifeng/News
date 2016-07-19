//
//  TextViewController.m
//  FZFBase
//
//  Created by fengzifeng on 16/7/7.
//  Copyright © 2016年 fengzifeng. All rights reserved.
//

#import "TextViewController.h"

@interface TextViewController ()

@end

@implementation TextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBackButtonDefault];
    self.view.backgroundColor = [UIColor blackColor];
    
     UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.frame = CGRectMake(100, 100, 30, 30);
    
    [self.view addSubview:button];
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchDown];
    
}

- (void)click
{
    TextViewController *vc = [[TextViewController alloc] init];
    //    vc.title = @"mvmmv";
    //    vc.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
