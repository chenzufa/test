//
//  SecretVC.m
//  HaiLanZhiJia
//
//  Created by creaver on 13-12-3.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "SecretVC.h"

@interface SecretVC ()
{
    UITextView *fildView;
    UIWebView *showWebView;
}

@end

@implementation SecretVC

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
    [self setTitleString:self.thisTitle];
    [self initView];
	// Do any additional setup after loading the view.
}

-(void)initView
{
    
    showWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, TITLEHEIGHT, MainViewWidth, MainViewHeight-TITLEHEIGHT-20)];
    self.view.backgroundColor = [UIColor redColor];
    [showWebView loadHTMLString:self.detailString baseURL:nil];
    //  NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.detailString]];
    [self.view addSubview: showWebView];
    
//    fildView = [[UITextView alloc]initWithFrame:CGRectMake(0, TITLEHEIGHT, MainViewWidth, MainViewHeight-TITLEHEIGHT-20)];
//    fildView.font = SYSTEMFONT(14);
//    fildView.backgroundColor = VIEW_BACKGROUND_COLOR;
//
//    fildView.editable = NO;
//    fildView.text = self.detailString;
//    [self.view addSubview:fildView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
