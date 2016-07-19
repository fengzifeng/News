//
//  MCNewAccostViewController.m
//  MCFriends
//
//  Created by leslie on 15/7/15.
//  Copyright (c) 2015年 marujun. All rights reserved.
//

#import "MCNewsViewController.h"
#import "SwitchView.h"
#import "MCNewsBaseViewController.h"
#import "HMSegmentedControl.h"

@interface MCNewsViewController ()<UIScrollViewDelegate>

{
    NSArray *_sourseArray;
    NSInteger _currentPage;

}

@property (strong, nonatomic) NSMutableArray *reusableViewControllers; //重用数组
@property (strong, nonatomic) NSMutableArray *visibleViewControllers;  //可见的数组
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) SwitchView *switchView;
@property (nonatomic, strong) HMSegmentedControl *subjectSC;
@property (nonatomic, assign) NSInteger selectedSubjectIndex;// 目前选择的科目

@end

@implementation MCNewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
          }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _sourseArray = @[@"游戏新闻",@"赛事新闻",@"战队新闻",@"行业新闻"];
    
    [self.view addSubview:self.scrollView];
//    [self.view addSubview:self.switchView];
    [self.view addSubview:self.subjectSC];

//    [self.switchView endMoveToIndex:1];

    [self loadPage:0];
    [self.scrollView scrollRectToVisible:CGRectMake(0*self.scrollView.frame.size.width, 0.0, self.scrollView.frame.size.width,self.scrollView.frame.size.height) animated:NO];

 }

- (HMSegmentedControl *)subjectSC{
    
    if (!_subjectSC) {
        _subjectSC = [[HMSegmentedControl alloc] initWithSectionTitles: @[@"游戏新闻",@"赛事新闻",@"战队新闻",@"行业新闻"]];
        [_subjectSC setTextColor:HexColor(0x333333)];
        [_subjectSC setFont: kFont_14];
        if (IS_IPHONE_6P){
            [_subjectSC setFont: kFont_16];
        }
        [_subjectSC setSelectionIndicatorColor:HexColor(0x6bbd3d)];
        [_subjectSC setSelectionIndicatorMode: HMSelectionIndicatorFillsSegment];
        [_subjectSC setFrame: CGRectMake(0,64, SCREEN_WIDTH, 44)];
        [_subjectSC setSelectedIndex:0];
        [_subjectSC addTarget: self
                       action: @selector(selectedSubjectIndex:)
             forControlEvents: UIControlEventValueChanged];
    }
    
    return _subjectSC;
}

-(void)selectedSubjectIndex:(id)sender
{
    HMSegmentedControl *theSC = (HMSegmentedControl *)sender;
    NSInteger curIndex = theSC.selectedIndex;
    
    if (curIndex == self.selectedSubjectIndex) return;
    self.selectedSubjectIndex = curIndex;
    [self loadPage:curIndex];
    [_scrollView scrollRectToVisible:CGRectMake(self.selectedSubjectIndex*_scrollView.frame.size.width, 0.0, _scrollView.frame.size.width,_scrollView.frame.size.height) animated:NO];
}

- (void)setSegmentViewSlectedIndex:(NSInteger)index{
    if (index == self.selectedSubjectIndex) return;
    
    self.selectedSubjectIndex = index;
    [self.subjectSC setSelectedIndex:index animated:YES];
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,44 + 64, SCREEN_WIDTH, SCREEN_HEIGHT - 44 - 64 - 49)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollsToTop = NO;
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*_sourseArray.count, SCREEN_HEIGHT - 44 - 64 - 49);
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        for (int i = 0; i<_sourseArray.count; i++) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44 - 64 - 49)];
            view.backgroundColor = i%2?[UIColor yellowColor]:[UIColor whiteColor];
            
            [_scrollView addSubview:view];
        }
    }
    
    return _scrollView;
}

- (NSMutableArray *)visibleViewControllers
{
    if (!_visibleViewControllers) _visibleViewControllers = [NSMutableArray array];
    
    return _visibleViewControllers;
}

- (NSMutableArray *)reusableViewControllers
{
    if (!_reusableViewControllers) _reusableViewControllers = [NSMutableArray array];
    
    return _reusableViewControllers;
}

//- (SwitchView *)switchView
//{
//    if (!_switchView) {
//        _switchView = [[SwitchView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
//        _switchView.oneScreen = YES;
//        _switchView.titleArray = _sourseArray;
//        __weak typeof (self.scrollView)weakScrollView = self.scrollView;
//        __weak typeof (self)weakSelf = self;
//
//        [_switchView setTapItemWithIndex:^(NSInteger index,BOOL animation){
//            [weakSelf loadPage:index];
//            [weakScrollView scrollRectToVisible:CGRectMake(index*weakScrollView.frame.size.width, 0.0, weakScrollView.frame.size.width,weakScrollView.frame.size.height) animated:NO];
//        }];
//    }
//    
//    return _switchView;
//}

#pragma mark - Reusable重用
- (void)loadPage:(NSInteger)page
{
    if (_reusableViewControllers.count && page == _currentPage) return;
    
    _currentPage = page;
    NSMutableArray *pagesToLoad = [@[@(page - 1), @(page), @(page + 1)] mutableCopy];
    NSMutableArray *vcsToEnqueue = [NSMutableArray array];
    
    for (MCNewsBaseViewController *vc in self.visibleViewControllers) {
        if (!vc.page || ![pagesToLoad containsObject:@(vc.page)]) {
            [vcsToEnqueue addObject:vc];
        } else if (vc.page) {
            [pagesToLoad removeObject:@(vc.page)];
        }
    }
    
    for (MCNewsBaseViewController *vc in vcsToEnqueue) {
        [vc.view removeFromSuperview];
        [self.visibleViewControllers removeObject:vc];
    }
    
    for (NSNumber *page in pagesToLoad) {
        [self addViewControllerForPage:[page integerValue]];
    }
}

- (void)addViewControllerForPage:(NSInteger)page
{
    if (page < 0 || page >= _sourseArray.count) return;
    
    MCNewsBaseViewController *vc = [self dequeueReusableViewController:page];
    vc.view.frame = CGRectMake(self.scrollView.frame.size.width * page, 0.0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    
    [self.scrollView addSubview:vc.view];
    [self.visibleViewControllers addObject:vc];
}

- (MCNewsBaseViewController *)dequeueReusableViewController:(NSInteger)page
{
    for (MCNewsBaseViewController *vc in _reusableViewControllers) {
        
        if (vc.page == page) return vc;
    }
    
    
    if (page == 0) {
        MCNewsBaseViewController *vc = [MCNewsBaseViewController viewController];
        vc.page = page;
        [vc willMoveToParentViewController:self];
        [self addChildViewController:vc];
        [vc didMoveToParentViewController:self];
        [self enqueueReusableViewController:vc];
        
        return vc;
        
    }else if (page == 1) {
        MCNewsBaseViewController *vc = [MCNewsBaseViewController viewController];
        vc.page = page;
        [vc willMoveToParentViewController:self];
        [self addChildViewController:vc];
        [vc didMoveToParentViewController:self];
        [self enqueueReusableViewController:vc];
        
        return vc;
    }else if (page == 2) {
        MCNewsBaseViewController *vc = [MCNewsBaseViewController viewController];
        vc.page = page;
        [vc willMoveToParentViewController:self];
        [self addChildViewController:vc];
        [vc didMoveToParentViewController:self];
        [self enqueueReusableViewController:vc];
        
        return vc;
    }else{
        MCNewsBaseViewController *vc = [MCNewsBaseViewController viewController];
        vc.page = page;
        [vc willMoveToParentViewController:self];
        [self addChildViewController:vc];
        [vc didMoveToParentViewController:self];
        [self enqueueReusableViewController:vc];
        
        return vc;
    }
}

- (void)enqueueReusableViewController:(MCNewsBaseViewController *)viewController
{
    if (![self.reusableViewControllers containsObject:viewController]) {
        [self.reusableViewControllers addObject:viewController];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == self.scrollView) {
        NSInteger page = roundf(scrollView.contentOffset.x / scrollView.frame.size.width);
        page = MAX(page, 0);
        page = MIN(page, _sourseArray.count - 1);
        [self setSegmentViewSlectedIndex:page];

//        [_switchView endMoveToIndex:page];
        [self loadPage:page];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.parentViewController.title = @"新闻";
}

@end
