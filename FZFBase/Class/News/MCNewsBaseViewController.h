//
//  MCNewsBaseViewController.h
//  FZFBase
//
//  Created by fengzifeng on 16/7/11.
//  Copyright © 2016年 fengzifeng. All rights reserved.
//

#import "MCViewController.h"

@interface MCNewsBaseViewController : MCViewController <UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *_tableView;
    
}

@property (nonatomic, assign) NSInteger page;



@end