//
//  MCNewsBaseViewController.m
//  FZFBase
//
//  Created by fengzifeng on 16/7/11.
//  Copyright © 2016年 fengzifeng. All rights reserved.
//

#import "MCNewsBaseViewController.h"
#import "MCNewsTableViewCell.h"
#import "MCNewsDetailViewController.h"
#import "SXDetailPage.h"

@interface MCNewsBaseViewController ()

@end

@implementation MCNewsBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = VIEW_BG_COLOR;
    self.navigationBar.hidden = YES;
    self.title = @"我的收藏";
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"MCNewsTableViewCell";
    
//    if (indexPath.row%20 == 0) {
//        identifier = @"TopImageCell";
//    } else if (indexPath.row%20 == 6) {
//        identifier = @"ImagesCell";
//    } else if (indexPath.row%20 == 12) {
//        identifier = @"BigImageCell";
//    } else {
//        identifier = @"NewsCell";
//    }
    MCNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil] firstObject];
    }
    
    [cell updateCell];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    MCNewsDetailViewController *vc = [MCNewsDetailViewController viewController];
    SXDetailPage *vc = [[SXDetailPage alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 0;
    if (indexPath.row%20 == 0) {
        height = 245;
    } else if (indexPath.row%20 == 6) {
        height = 130;

    } else if (indexPath.row%20 == 12) {
        height = 170;

    } else {
        height = 80;

    }

    return 100.f;
}


@end
