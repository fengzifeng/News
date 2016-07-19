//
//  USImagePickerController.m
//  CollectionView
//
//  Created by marujun on 16/7/1.
//  Copyright © 2016年 marujun. All rights reserved.
//

#import "USImagePickerController.h"
#import "USImagePickerController+Protect.h"
#import "USAssetGroupViewController.h"

@interface USImagePickerController ()

@property (nonatomic, strong, readonly) ALAssetsFilter *assetsFilter;

@end

@implementation USImagePickerController
@synthesize delegate;

- (instancetype)init
{
    USAssetGroupViewController *groupViewController = [[USAssetGroupViewController alloc] initWithNibName:@"USAssetGroupViewController" bundle:nil];
    if (self = [super initWithRootViewController:groupViewController]) {
        _assetsFilter                  = [ALAssetsFilter allAssets];
        _cropMaskAspectRatio           = 1.f;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)setAllowsOriginalImage:(BOOL)allowsOriginalImage
{
    _allowsOriginalImage = allowsOriginalImage;
}

#pragma mark - ALAssetsLibrary

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static id library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

- (void)dealloc
{
    NSLog(@"dealloc 释放类 %@",  NSStringFromClass([self class]));
}

@end
