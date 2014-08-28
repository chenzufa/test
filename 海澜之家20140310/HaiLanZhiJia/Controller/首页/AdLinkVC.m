//
//  AdLinkVC.m
//  HaiLanZhiJia
//
//  Created by creaver on 13-11-25.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "AdLinkVC.h"

@interface AdLinkVC ()
{
    UIWebView *webView;
}

@end

@implementation AdLinkVC

- (void)dealloc
{
    [webView release];
    self.urlString = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
}

-(void)initUI
{
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, MainViewHeight-TITLEHEIGHT-20)];
    self.view.backgroundColor = [UIColor redColor];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    [self.view addSubview: webView];
    [webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
