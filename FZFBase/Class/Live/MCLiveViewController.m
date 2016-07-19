//
//  MCFindViewController.m
//  FZFBase
//
//  Created by fengzifeng on 16/7/7.
//  Copyright © 2016年 fengzifeng. All rights reserved.
//

#import "MCLiveViewController.h"

@interface MCLiveViewController ()

@end

@implementation MCLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.parentViewController.title = @"直播";
}@end
