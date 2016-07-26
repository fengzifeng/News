//
//  MCNewsDetailViewController.h
//  FZFBase
//
//  Created by fengzifeng on 16/7/12.
//  Copyright © 2016年 fengzifeng. All rights reserved.
//

#import "MCViewController.h"
#import "WebViewJavascriptBridge.h"
#import "MCImageInfo.h"
#import "MCVideoInfo.h"

@interface MCNewsDetailViewController : MCViewController <UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *_tableView;
    
}


@end
