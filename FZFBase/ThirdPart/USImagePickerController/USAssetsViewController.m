//
//  USAssetsViewController.m
//  CollectionView
//
//  Created by marujun on 16/7/1.
//  Copyright © 2016年 marujun. All rights reserved.
//

#import "USAssetsViewController.h"
#import "USAssetCollectionCell.h"
#import "USAssetsPageViewController.h"
#import "USAssetsPreviewViewController.h"
#import "AssetsLibrary+PhotoAlbum.h"
#import "RSKImageCropper.h"

#define MinAssetItemLength     100.f
#define AssetItemSpace         4.f

@interface USAssetsViewController () <USAssetCollectionCellDelegate, USAssetsPreviewViewControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,RSKImageCropViewControllerDelegate, RSKImageCropViewControllerDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

//底部状态栏
@property (weak, nonatomic) IBOutlet UIView *bottomBar;
@property (weak, nonatomic) IBOutlet UIButton *previewButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countWidthConstraint;

@property (nonatomic, strong) NSMutableArray *allAssets;

@property (nonatomic, assign) BOOL isCameraRollGroup;

//PHAsset 生成缩略图及缓存时需要的数据
@property (nonatomic, assign) CGRect previousPreheatRect;
@property (nonatomic, assign) CGSize thumbnailTargetSize;
@property (nonatomic, strong) PHImageRequestOptions *thumbnailRequestOptions;

@property (nonatomic, assign) BOOL didLayoutSubviews;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation USAssetsViewController

- (USImagePickerController *)picker {
    return (USImagePickerController *)self.navigationController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupViews];
    
    [self setupAssets];
    [self resetCachedAssetImages];
    
    [self refreshTitle];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (!self.didLayoutSubviews && self.allAssets.count){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
        
        self.didLayoutSubviews = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self updateCachedAssetImages];
}

- (void)refreshTitle
{
    if (self.assetCollection) self.title = self.assetCollection.localizedTitle;
    else self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    
    NSInteger count = self.selectedAssets.count;
    self.countLabel.text = [NSString stringWithFormat:@"%zd",count];
    self.countLabel.hidden = count?NO:YES;
    self.sendButton.alpha = count?1:0.5;
    self.previewButton.alpha = count?1:0.5;
    self.bottomBar.userInteractionEnabled = count?YES:NO;
}

- (void)setAssetsGroup:(ALAssetsGroup *)assetsGroup
{
    _assetsGroup = assetsGroup;
    
    ALAssetsGroupType assetType = [[_assetsGroup valueForProperty:ALAssetsGroupPropertyType] intValue];
    _isCameraRollGroup = assetType == ALAssetsGroupSavedPhotos;
}

- (void)setAssetCollection:(PHAssetCollection *)assetCollection
{
    _assetCollection = assetCollection;
    
    _isCameraRollGroup = _assetCollection.assetCollectionSubtype==PHAssetCollectionSubtypeSmartAlbumUserLibrary;
}

#pragma mark - Setup

- (void)setupViews
{
    NSInteger lineMaxCount = 1;
    while ((lineMaxCount*MinAssetItemLength+(lineMaxCount+1)*AssetItemSpace) <= SCREEN_WIDTH) {
        lineMaxCount ++;
    }
    CGFloat itemLength = (SCREEN_WIDTH-AssetItemSpace*lineMaxCount)/(lineMaxCount-1);
    
    self.flowLayout.itemSize = CGSizeMake(itemLength, itemLength);
    self.flowLayout.minimumInteritemSpacing = AssetItemSpace;
    self.flowLayout.minimumLineSpacing = AssetItemSpace;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(AssetItemSpace, AssetItemSpace, AssetItemSpace, AssetItemSpace);
    
    if (PHPhotoLibraryClass) {
        _thumbnailRequestOptions = [[PHImageRequestOptions alloc] init];
        _thumbnailRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
        _thumbnailRequestOptions.resizeMode   = PHImageRequestOptionsResizeModeExact;
        
        NSInteger retinaMultiplier  = MIN([UIScreen mainScreen].scale, 2);
        _thumbnailTargetSize = CGSizeMake(self.flowLayout.itemSize.width * retinaMultiplier, self.flowLayout.itemSize.height * retinaMultiplier);
    }
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    NSString *identifier = NSStringFromClass([USAssetCollectionCell class]);
    UINib *cellNib = [UINib nibWithNibName:identifier bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:identifier];
    
    if(self.picker.allowsMultipleSelection){
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [self.collectionView addGestureRecognizer:_tapGestureRecognizer];
        
        self.countLabel.backgroundColor = USPickerTintColor;
        self.countLabel.layer.cornerRadius = self.countLabel.frame.size.height/2.f;
        self.countLabel.layer.masksToBounds = YES;
        [self.sendButton setTitleColor:USPickerTintColor forState:UIControlStateNormal];
        [_collectionView autoSetDimension:ALDimensionWidth toSize:SCREEN_WIDTH];
        [_collectionView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(64, 0, self.bottomBar.frame.size.height, 0) excludingEdge:ALEdgeRight];

//        [self.collectionView setContentInset:UIEdgeInsetsMake(64, 0, self.bottomBar.frame.size.height, 0)];
    }
    else {
        self.bottomBar.hidden = YES;
        [_collectionView autoSetDimension:ALDimensionWidth toSize:SCREEN_WIDTH];
        [_collectionView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(64, 0, 0, 0) excludingEdge:ALEdgeRight];
//        [self.collectionView setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
    }
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(rightNavButtonAction:)];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = 2;  //向左移动2个像素
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,buttonItem];
}

- (void)rightNavButtonAction:(UIButton *)sender
{
    if (self.picker.delegate && [self.picker.delegate respondsToSelector:@selector(imagePickerControllerDidCancel:)]) {
        [self.picker.delegate imagePickerControllerDidCancel:self.picker];
    } else {
        [self.picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)setupAssets
{
    self.allAssets = [[NSMutableArray alloc] init];
    
    if (self.assetCollection) {
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeImage];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:NO]];
        
        PHAssetCollection *assetCollection = (PHAssetCollection *)self.assetCollection;
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
        NSArray *fetchArray = [fetchResult objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, fetchResult.count)]];
        [self.allAssets addObjectsFromArray:fetchArray];
        
        return;
    }
    
    [self.indicatorView startAnimating];
    
    ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop) {
        if (asset) {
            if ([[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                [self.allAssets insertObject:asset atIndex:0];
            }
        }
        else {
            [self.indicatorView stopAnimating];
            [self.collectionView reloadData];
        }
    };
    
    [self.assetsGroup enumerateAssetsUsingBlock:resultsBlock];
}

- (NSArray *)selectedAssetsArray
{
    NSMutableArray *tmpArray= [NSMutableArray array];
    [_allAssets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([_selectedAssets containsObject:obj]) [tmpArray addObject:obj];
    }];
    return tmpArray;
}

- (CGRect)imageRectWithIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    if (_isCameraRollGroup) {
        indexPath = [NSIndexPath indexPathForRow:index+1 inSection:0];
    }
    
    CGRect rect = [_flowLayout layoutAttributesForItemAtIndexPath:indexPath].frame;
    
    return [self.collectionView convertRect:rect toView:self.view];
}

- (void)scrollIndexToVisible:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    if (_isCameraRollGroup) {
        indexPath = [NSIndexPath indexPathForRow:index+1 inSection:0];
    }

    NSArray *visibleArray = [self.collectionView indexPathsForVisibleItems];
    if (![visibleArray containsObject:indexPath]) {
        [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
    }
}

#pragma mark - BottomBar button action
- (IBAction)previewButtonAction:(UIButton *)sender
{
    USAssetsPreviewViewController *previewVC = [[USAssetsPreviewViewController alloc] initWithAssets:self.selectedAssetsArray];
    previewVC.selectedAssets = self.selectedAssets;
    previewVC.delegate = self;
    [self.navigationController pushViewController:previewVC animated:YES];
}

- (IBAction)sendButtonAction:(UIButton *)sender
{
    if (self.picker.delegate && [self.picker.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingMediaWithArray:)]) {
        [self.picker.delegate imagePickerController:self.picker didFinishPickingMediaWithArray:self.selectedAssetsArray];
    } else {
        [self.picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UITapGestureRecognizer
- (void)handleTapGesture: (UITapGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    if (!indexPath) return;
    
    USAssetCollectionCell *cell = (id)[self.collectionView cellForItemAtIndexPath:indexPath];
    if (cell) {
        [cell handleTapGestureAtPoint:[recognizer locationInView:cell]];
    }
}

- (void)oneAsset:(id)asset didSelect:(BOOL)selected
{
    if (selected) [self.selectedAssets addObject:asset];
    else [self.selectedAssets removeObject:asset];
    
    [self refreshTitle];
}

#pragma mark - RSKImageCropViewControllerDelegate
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect
{
    USImagePickerController *picker = (USImagePickerController *)self.navigationController;
    if (picker.delegate && [picker.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingMediaWithImage:)]) {
        [picker.delegate imagePickerController:picker didFinishPickingMediaWithImage:[self fullScreenImage:croppedImage]];
    }
}

- (UIImage *)fullScreenImage:(UIImage *)image
{
    CGSize lastSize = CGSizeMake(1500.f, image.size.height*1500.f/image.size.width);
    if (image.size.width > image.size.height) {
        lastSize = CGSizeMake(image.size.width*1500.f/image.size.height, 1500.f);
    }
    
    if (image.size.width<=lastSize.width || image.size.height<=lastSize.height) {
        return [image fixOrientation];
    }
    return [image imageScaledToSize:lastSize];
}


#pragma mark - RSKImageCropViewControllerDataSource
- (CGRect)imageCropViewControllerCustomMaskRect:(RSKImageCropViewController *)controller
{
    CGSize ssize = self.view.size;
    USImagePickerController *picker = (USImagePickerController *)self.navigationController;
    if (picker.cropMaskAspectRatio <= 0) {
        picker.cropMaskAspectRatio = 1.f;
    }
    
    CGSize crop_size = CGSizeMake((ssize.width-40), (ssize.width-40)/picker.cropMaskAspectRatio);
    if (crop_size.height > ssize.height) {
        crop_size = CGSizeMake((ssize.height-120)*picker.cropMaskAspectRatio, (ssize.height-120));
    }
    
    return CGRectMake((ssize.width-crop_size.width)/2.f, (ssize.height-crop_size.height)/2.f, crop_size.width, crop_size.height);
}

// Returns a custom path for the mask.
- (UIBezierPath *)imageCropViewControllerCustomMaskPath:(RSKImageCropViewController *)controller
{
    CGRect rect = [self imageCropViewControllerCustomMaskRect:controller];
    CGPoint point1 = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGPoint point2 = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGPoint point3 = CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGPoint point4 = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
    
    UIBezierPath *triangle = [UIBezierPath bezierPath];
    [triangle moveToPoint:point1];
    [triangle addLineToPoint:point2];
    [triangle addLineToPoint:point3];
    [triangle addLineToPoint:point4];
    [triangle closePath];
    
    return triangle;
}

- (void)pushImageCropViewController:(UIImage *)image
{
    UIFont *labelFont = [UIFont boldSystemFontOfSize:13];
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image cropMode:RSKImageCropModeCustom];
    imageCropVC.moveAndScaleLabel.font = labelFont;
    imageCropVC.maskLayerStrokeColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8];
    imageCropVC.delegate = self;
    imageCropVC.dataSource = self;
    imageCropVC.avoidEmptySpaceAroundImage = YES;
    imageCropVC.chooseButton.titleLabel.font = labelFont;
    imageCropVC.cancelButton.titleLabel.font = labelFont;
    
    [self.navigationController pushViewController:imageCropVC animated:YES];
}

// Returns a custom rect in which the image can be moved.
- (CGRect)imageCropViewControllerCustomMovementRect:(RSKImageCropViewController *)controller
{
    return [self imageCropViewControllerCustomMaskRect:controller];
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //把拍摄的照片保存到相册
    UIImage *pickImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSDictionary *metadata = [info objectForKey:UIImagePickerControllerMediaMetadata];
    
    USImagePickerController *uspicker = (USImagePickerController *)self.navigationController;
    if (uspicker.allowsEditing) {
        [self pushImageCropViewController:pickImage];
    }
    
    if (uspicker.allowsMultipleSelection) {
        
    }
    
    void(^saveCompletionHandler)(id) = ^(id asset) {
//        AssetModel *mode = [AssetModel modelWithAsset:asset];
        [self oneAsset:asset didSelect:YES];

//        [_selectedAssets setObject:mode forKey:[asset localIdentifier]];
        
//        [self setupUnreadView];
        
        [self.collectionView performBatchUpdates:^{
            [self.allAssets insertObject:asset atIndex:0];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
        } completion:^(BOOL finished) {
//            [self updateSelectedModelIndex];
            [self.collectionView reloadData];
            [self resetCachedAssetImages];
        }];
    };
    
    //把图片添加到库中
    if (self.assetCollection) {
        
        //把图片存到临时路径
        NSString *tempPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        tempPath = [tempPath stringByAppendingFormat:@"/camera_%f.jpg",[[NSDate date] timeIntervalSince1970]];
        
        NSData *dest_data = [self dataWithImage:pickImage metadata:metadata];
        [dest_data writeToFile:tempPath atomically:YES];
        
        [[PHPhotoLibrary sharedPhotoLibrary] saveImageFromFilePath:tempPath toAlbum:nil completionHandler:^(PHAsset *asset, NSError *error) {
            if (asset) {
                saveCompletionHandler(asset);
            } else {
                NSLog(@"save image error: %@",error);
            }
            
            [[NSFileManager defaultManager] removeItemAtPath:tempPath error:nil];
        }];
    }
    else {
        ALAssetsLibrary *library = [USImagePickerController defaultAssetsLibrary];
        [library writeImageToSavedPhotosAlbum:pickImage.CGImage metadata:metadata completionBlock:^(NSURL *assetURL, NSError *error) {
            if (error) {
                return;
            }
            
            [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                if (asset) {
                    saveCompletionHandler(asset);
                    
                    //把拍摄的照片在us相册也保存一份
//                    [library addAssetURL:assetURL toAlbum:USAlbumName completionBlock:nil];
                }
            } failureBlock:nil];
        }];
    }
    
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (NSMutableData *)dataWithImage:(UIImage *)image metadata:(NSDictionary *)metadata
{
    NSData *jpgData = UIImageJPEGRepresentation(image, 1.0);
    
    CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)jpgData, NULL);
    CFStringRef UTI = CGImageSourceGetType(source);
    
    NSMutableData *dest_data = [NSMutableData data];
    CGImageDestinationRef destination = CGImageDestinationCreateWithData((CFMutableDataRef)dest_data, UTI, 1, NULL);
    
    if(!destination) {
        dest_data = [jpgData mutableCopy];
    } else {
        CGImageDestinationAddImageFromSource(destination, source, 0, (CFDictionaryRef) metadata);
        BOOL success = CGImageDestinationFinalize(destination);
        if(!success) {
            dest_data = [jpgData mutableCopy];
        }
    }
    
    if(destination) {
        CFRelease(destination);
    }
    CFRelease(source);
    
    return dest_data;
}


#pragma mark - USAssetCollectionCellDelegate
- (void)photoDidClickedInCollectionCell:(USAssetCollectionCell *)cell
{
    NSInteger itemIndex = [_collectionView indexPathForCell:cell].row;
    
    //点击拍照按钮
    if (_isCameraRollGroup && itemIndex == 0) {
//        if(![HLTool cameraGranted]){
//            return;
//        }
        
        BOOL isCameraAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        if (isCameraAvailable) {
            UIImagePickerController *imagePicker = [UIImagePickerController new];
            imagePicker.delegate = self;
            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            [self presentViewController:imagePicker animated:YES completion:nil];
        } else {
//            [USSuspensionView showWithMessage:@"没有可用的相机"];
        }
        
        return;
    }

    
    if (self.picker.allowsMultipleSelection) {
        USAssetsPreviewViewController *previewVC = [[USAssetsPreviewViewController alloc] initWithAssets:_allAssets];
        previewVC.selectedAssets = self.selectedAssets;
        previewVC.delegate = self;
        previewVC.pageIndex = itemIndex;
        [self.navigationController pushViewController:previewVC animated:YES];
    }
    else if (!self.picker.allowsEditing) {
        if (self.picker.delegate && [self.picker.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingMediaWithAsset:)]) {
            [self.picker.delegate imagePickerController:self.picker didFinishPickingMediaWithAsset:_allAssets[itemIndex]];
        }
        
        if (self.picker.delegate && [self.picker.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingMediaWithImage:)]) {
            id asset = _allAssets[itemIndex];
            [self.picker.delegate imagePickerController:self.picker didFinishPickingMediaWithImage:((UIImage *)[asset fullScreenImage])];
        }
    }
    else if (self.picker.allowsEditing) {
        id asset = _allAssets[itemIndex];
        [self pushImageCropViewController:(UIImage *)[asset fullScreenImage]];
    }
    
}

- (BOOL)collectionCell:(USAssetCollectionCell *)cell canSelect:(BOOL)selected
{
    if (selected && self.selectedAssets.count >= self.picker.maxSelectNumber) {
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:[NSString stringWithFormat:@"你最多只能选择%zd张照片",self.picker.maxSelectNumber]
                                   delegate:nil
                          cancelButtonTitle:@"我知道了"
                          otherButtonTitles:nil] show];
        return NO;
    }
    return YES;
}


- (void)collectionCell:(USAssetCollectionCell *)cell didSelect:(BOOL)selected
{
    [self oneAsset:cell.asset didSelect:selected];
}

#pragma mark - USAssetsPreviewViewControllerDelegate

- (BOOL)previewViewController:(USAssetsPreviewViewController *)vc canSelect:(BOOL)selected
{
    return [self collectionCell:nil canSelect:selected];
}

- (void)sendButtonClickedInPreviewViewController:(USAssetsPreviewViewController *)vc
{
    [self sendButtonAction:_sendButton];
}

- (void)previewViewController:(USAssetsPreviewViewController *)vc didSelect:(BOOL)selected
{
    [self oneAsset:vc.asset didSelect:selected];
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.allAssets.count + (_isCameraRollGroup?1:0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = NSStringFromClass([USAssetCollectionCell class]);
    USAssetCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    

    cell.delegate = self;
    cell.imageManager = self.imageManager;
    cell.thumbnailTargetSize = self.thumbnailTargetSize;
    cell.thumbnailRequestOptions = self.thumbnailRequestOptions;
    cell.markView.hidden = !self.picker.allowsMultipleSelection;
    
    id asset = [self assetAtIndexPath:indexPath];
    if (_isCameraRollGroup && indexPath.row==0) {
        cell.isCamera = YES;

        [cell bind:nil selected:NO];
//        cell.userInteractionEnabled = YES;
    } else {
        cell.isCamera = NO;

        [cell bind:asset selected:[self.selectedAssets containsObject:asset]];

    }

    
    return cell;
}

#pragma mark - Asset images caching

- (void)resetCachedAssetImages
{
    [self.imageManager stopCachingImagesForAllAssets];
    self.previousPreheatRect = CGRectZero;
}

- (NSArray *)indexPathsForElementsInRect:(CGRect)rect
{
    NSArray *allAttributes = [self.flowLayout layoutAttributesForElementsInRect:rect];
    
    if (allAttributes.count == 0)
        return nil;
    
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:allAttributes.count];
    
    for (UICollectionViewLayoutAttributes *attributes in allAttributes) {
        NSIndexPath *indexPath = attributes.indexPath;
        [indexPaths addObject:indexPath];
    }
    
    return indexPaths;
}

- (void)updateCachedAssetImages
{
    BOOL isViewVisible = [self isViewLoaded] && [[self view] window] != nil;
    
    if (!isViewVisible)
        return;
    
    // The preheat window is twice the height of the visible rect
    CGRect preheatRect = self.collectionView.bounds;
    preheatRect = CGRectInset(preheatRect, 0.0f, -0.5f * CGRectGetHeight(preheatRect));
    
    // If scrolled by a "reasonable" amount...
    CGFloat delta = ABS(CGRectGetMidY(preheatRect) - CGRectGetMidY(self.previousPreheatRect));
    
    if (delta > CGRectGetHeight(self.collectionView.bounds) / 3.0f) {
        // Compute the assets to start caching and to stop caching.
        NSMutableArray *addedIndexPaths = [NSMutableArray array];
        NSMutableArray *removedIndexPaths = [NSMutableArray array];
        
        [self computeDifferenceBetweenRect:self.previousPreheatRect
                                   andRect:preheatRect
                            removedHandler:^(CGRect removedRect) {
                                NSArray *indexPaths = [self indexPathsForElementsInRect:removedRect];
                                [removedIndexPaths addObjectsFromArray:indexPaths];
                            } addedHandler:^(CGRect addedRect) {
                                NSArray *indexPaths = [self indexPathsForElementsInRect:addedRect];
                                [addedIndexPaths addObjectsFromArray:indexPaths];
                            }];
        
        [self startCachingThumbnailsForIndexPaths:addedIndexPaths];
        [self stopCachingThumbnailsForIndexPaths:removedIndexPaths];
        
        self.previousPreheatRect = preheatRect;
    }
}

- (id)assetAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row-(_isCameraRollGroup?1:0);
    if(index < 0 || index>=self.allAssets.count){
        return nil;
    }
    return [self.allAssets objectAtIndex:index];
}


- (void)startCachingThumbnailsForIndexPaths:(NSArray *)indexPaths
{
    for (NSIndexPath *indexPath in indexPaths) {
        PHAsset *asset = [self assetAtIndexPath:indexPath];
        
        if (!asset) break;
        
        [self.imageManager startCachingImagesForAssets:@[asset]
                                            targetSize:_thumbnailTargetSize
                                           contentMode:PHImageContentModeAspectFill
                                               options:_thumbnailRequestOptions];
    }
}

- (void)stopCachingThumbnailsForIndexPaths:(NSArray *)indexPaths
{
    for (NSIndexPath *indexPath in indexPaths) {
        PHAsset *asset = [self assetAtIndexPath:indexPath];
        
        if (!asset) break;
        
        [self.imageManager stopCachingImagesForAssets:@[asset]
                                           targetSize:_thumbnailTargetSize
                                          contentMode:PHImageContentModeAspectFill
                                              options:_thumbnailRequestOptions];
    }
}

- (void)computeDifferenceBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect removedHandler:(void (^)(CGRect removedRect))removedHandler addedHandler:(void (^)(CGRect addedRect))addedHandler
{
    if (CGRectIntersectsRect(newRect, oldRect)) {
        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
        CGFloat oldMinY = CGRectGetMinY(oldRect);
        CGFloat newMaxY = CGRectGetMaxY(newRect);
        CGFloat newMinY = CGRectGetMinY(newRect);
        if (newMaxY > oldMaxY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
            addedHandler(rectToAdd);
        }
        if (oldMinY > newMinY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
            addedHandler(rectToAdd);
        }
        if (newMaxY < oldMaxY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
            removedHandler(rectToRemove);
        }
        if (oldMinY < newMinY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
            removedHandler(rectToRemove);
        }
    } else {
        addedHandler(newRect);
        removedHandler(oldRect);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [self.imageManager stopCachingImagesForAllAssets];
}

- (void)dealloc
{
    [self.imageManager stopCachingImagesForAllAssets];
    
    NSLog(@"dealloc 释放类 %@",  NSStringFromClass([self class]));
}

@end
