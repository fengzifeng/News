//
//  MCNewsDetailViewController.m
//  FZFBase
//
//  Created by fengzifeng on 16/7/12.
//  Copyright © 2016年 fengzifeng. All rights reserved.
//

#import "MCNewsDetailViewController.h"
#import "ImageCache.h"
#import "MCAboutMeCell.h"

@interface MCNewsDetailViewController ()

{
    NSArray *_titleArray;
    
}

@property (nonatomic, copy)NSString *detailID;
@property (nonatomic, copy)NSMutableString *requestUrlString;
@property (nonatomic, strong)UIWebView *webView;
@property (nonatomic, strong)WebViewJavascriptBridge *bridge;
@end

@implementation MCNewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"详情";
    self.view.backgroundColor = VIEW_BG_COLOR;
    [self setNavigationBackButtonDefault];
    
    [self initWebView];
    [self initJSbirdge];
    [self setupRequest];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:_topInset];
    _titleArray = @[@"个人信息",@"我的首页",@"推荐好友",@"我的收藏",@"设置"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"MCAboutMeCell";
    MCAboutMeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil] firstObject];
    }
    
    [cell updateCell:_titleArray[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.webView;
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.webView.height;
}



- (void)initWebView {
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
    
//    [self.view insertSubview:_webView belowSubview:self.navigationBar];
//    [_webView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(_topInset, 0, 0, 0)];
    
    _webView.opaque = NO;
    _webView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.95];
//    [self.view addSubview:_webView];
}

- (void)initJSbirdge {
    
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"ObjC received message from JS: %@", data);
        responseCallback(@"Response for message from ObjC");
    }];
    
    [_bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        responseCallback(@"Response from testObjcCallback");
    }];
}

- (void)setupRequest {
    
    self.detailID = @"AQ72N9QG00051CA1";//一张图片
    self.detailID = @"AQ4RPLHG00964LQ9";//多张图片
    NSMutableString *urlStr = [NSMutableString stringWithString:@"http://c.m.163.com/nc/article/xukunhenwuliao/full.html"];
    [urlStr replaceOccurrencesOfString:@"xukunhenwuliao" withString:_detailID options:NSCaseInsensitiveSearch range:[urlStr rangeOfString:@"xukunhenwuliao"]];
    [NetManager getRequestToUrl:urlStr params:nil complete:^(BOOL successed, HttpResponse *response) {
        if (successed) {
            [self setupWebViewByData:response.payload];
        } else {
        }
    }];
    
}

- (void)setupWebViewByData:(id)data {
    
    if (data!= nil) {
        
        //解析的字典
        NSDictionary *dic = (NSMutableDictionary *)data;
        NSDictionary *bodyDic = [dic objectForKey:_detailID];
        NSMutableString *bodyStr = [[NSMutableString alloc] initWithString:[bodyDic objectForKey:@"body"]];
        
        //写一段接收主标题的html字符串,直接拼接到字符串
        NSMutableString *titleStr= [bodyDic objectForKey:@"title"];
        NSMutableString *sourceStr = [bodyDic objectForKey:@"source"];
        NSMutableString *ptimeStr = [bodyDic objectForKey:@"ptime"];
        
        NSMutableString *allTitleStr =[NSMutableString stringWithString:@"<style type='text/css'> p.thicker{font-weight: 900}p.light{font-weight: 0}p{font-size: 108%}h2 {font-size: 120%}h3 {font-size: 80%}</style> <h2 class = 'thicker'>xukun</h2><h3>hehe    lala</h3>"];
        
        [allTitleStr replaceOccurrencesOfString:@"xukun" withString:titleStr options:NSCaseInsensitiveSearch range:[allTitleStr rangeOfString:@"xukun"]];
        [allTitleStr replaceOccurrencesOfString:@"hehe" withString:sourceStr options:NSCaseInsensitiveSearch range:[allTitleStr rangeOfString:@"hehe"]];
        [allTitleStr replaceOccurrencesOfString:@"lala" withString:ptimeStr options:NSCaseInsensitiveSearch range:[allTitleStr rangeOfString:@"lala"]];
        
        NSArray *imageArray = [bodyDic objectForKey:@"img"];
        NSArray *videoArray = [bodyDic objectForKey:@"video"];
        if ([videoArray count]) {
            NSLog(@"这个新闻里面有视频或者音频---");
            NSMutableArray *videos = [NSMutableArray arrayWithCapacity:[videoArray count]];
            for (NSDictionary *videoDic in videoArray) {
                MCVideoInfo *videoin = [[MCVideoInfo alloc] initWithInfo:videoDic];
                [videos addObject:videoin];
                NSRange range = [bodyStr rangeOfString:videoin.ref];
                NSString *videoStr = [NSString stringWithFormat:@"<embed height='50' width='280' src='%@' />",videoin.url_mp4];
                [bodyStr replaceOccurrencesOfString:videoin.ref withString:videoStr options:NSCaseInsensitiveSearch range:range];
            }
            
        }
        if ([imageArray count]==0) {
            NSLog(@"新闻没图片");
            NSString * str5 = [allTitleStr stringByAppendingString:bodyStr];
            [_webView loadHTMLString:str5 baseURL:[[NSURL URLWithString:_requestUrlString] baseURL]];
            
        }else{
            
            NSLog(@"新闻内容里面有图片");
            
            NSMutableArray *images = [NSMutableArray arrayWithCapacity:[imageArray count]];
            
            for (NSDictionary *d in imageArray) {
                
                MCImageInfo *info = [[MCImageInfo alloc] initWithInfo:d];//kvc
                [images addObject:info];
                NSRange range = [bodyStr rangeOfString:info.ref];
                NSArray *wh = [info.pixel componentsSeparatedByString:@"*"];
                CGFloat width = [[wh objectAtIndex:0] floatValue];
                
                CGFloat rate = (self.view.bounds.size.width-15)/ width;
                CGFloat height = [[wh objectAtIndex:1] floatValue];
                CGFloat newWidth = width * rate;
                CGFloat newHeight = height *rate;
                
                NSString *imageStr = [NSString stringWithFormat:@"<img src = 'loading' id = '%@' width = '%.0f' height = '%.0f' hspace='0.0' vspace='5'>",[self replaceUrlSpecialString:info.src],newWidth,newHeight];
                [bodyStr replaceOccurrencesOfString:info.ref withString:imageStr options:NSCaseInsensitiveSearch range:range];
            }
            [self getImageFromDownloaderOrDiskByImageUrlArray:imageArray];
            
            [bodyStr replaceOccurrencesOfString:@"<p>　　" withString:@"<p>" options:NSCaseInsensitiveSearch range:[bodyStr rangeOfString:@"<p>　　"]];
            
            NSString * str5 = [allTitleStr stringByAppendingString:bodyStr];
            
            NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"webViewHtml" ofType:@"html"];
            NSMutableString* appHtml = [NSMutableString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
            
            NSRange range = [appHtml rangeOfString:@"<p>mainnews</p>"];
            
            [appHtml replaceOccurrencesOfString:@"<p>mainnews</p>" withString:str5 options:NSCaseInsensitiveSearch range:range];
            NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
            [_webView loadHTMLString:appHtml baseURL:baseURL];
            
        }
    }
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.webView.height = self.webView.scrollView.contentSize.height;
    [_tableView reloadData];
}

- (void)getImageFromDownloaderOrDiskByImageUrlArray:(NSArray *)imageArray {
    
    for (NSDictionary *d in imageArray) {
        
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:[imageArray count]];
        MCImageInfo *info = [[MCImageInfo alloc] initWithInfo:d];//kvc
        [images addObject:info];
        NSString *path = [UIImage diskCachePathWithURL:info.src];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if ([fileManager fileExistsAtPath:path]) {
            
            [_bridge send:[NSString stringWithFormat:@"replaceimage%@,%@",[self replaceUrlSpecialString:info.src],[UIImage diskCachePathWithURL:info.src]]];
            
        }else {
            [UIImage imageWithURL:info.src completed:^(UIImage *image) {
                if (image) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [_bridge send:[NSString stringWithFormat:@"replaceimage%@,%@",[self replaceUrlSpecialString:info.src],[UIImage diskCachePathWithURL:info.src]]];
                    });
                    
                }
            }];
        }
    }
}

- (NSString *)replaceUrlSpecialString:(NSString *)string {
    
    return [string stringByReplacingOccurrencesOfString:@"/"withString:@"_"];
}


@end
