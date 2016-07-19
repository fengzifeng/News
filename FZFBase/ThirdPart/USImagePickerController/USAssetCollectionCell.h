//
//  USAssetCollectionCell.h
//  CollectionView
//
//  Created by marujun on 16/7/1.
//  Copyright © 2016年 marujun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USAssetsViewController.h"

@protocol USAssetCollectionCellDelegate;

@interface USAssetCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *markView;

@property (nonatomic, weak) id <USAssetCollectionCellDelegate> delegate;

@property (nonatomic, assign, readonly) id asset;
@property (nonatomic, assign) BOOL isCamera;


@property (nonatomic, assign) CGSize thumbnailTargetSize;
@property (nonatomic, weak) PHImageRequestOptions *thumbnailRequestOptions;
@property (nonatomic, weak) PHCachingImageManager *imageManager;

- (void)bind:(id)asset selected:(BOOL)selected;

- (void)handleTapGestureAtPoint:(CGPoint)point;

@end


@protocol USAssetCollectionCellDelegate <NSObject>

@required

- (void)photoDidClickedInCollectionCell:(USAssetCollectionCell *)cell;


- (void)collectionCell:(USAssetCollectionCell *)cell didSelect:(BOOL)selected;

@optional

- (BOOL)collectionCell:(USAssetCollectionCell *)cell canSelect:(BOOL)selected;

@end