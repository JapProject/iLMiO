//
//  tabWebViewController.m
//  ilmio
//
//  Created by mac on 15/8/17.
//  Copyright (c) 2015年 com.mitsui-designtec. All rights reserved.
//

#import "tabWebViewController.h"

@interface tabWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation tabWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www1099gk.sakura.ne.jp/odm/qa.html"]]];
}


@end
