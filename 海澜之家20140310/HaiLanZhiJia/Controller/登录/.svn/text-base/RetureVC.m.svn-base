//
//  RetureVC.m
//  HaiLanZhiJia
//
//  Created by creaver on 13-11-29.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "RetureVC.h"

@interface RetureVC ()
{
    UITextView *myView;
    UIWebView *showWebView;
}

@end

@implementation RetureVC

- (void)dealloc
{
    [showWebView release];
//    [myView release];
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
    
//    myView =  [[UITextView alloc]initWithFrame:CGRectMake(0, TITLEHEIGHT, MainViewWidth, MainViewHeight-TITLEHEIGHT-20)];
//    myView.font = SYSTEMFONT(14);
//    myView.backgroundColor = VIEW_BACKGROUND_COLOR;
//    myView.editable = NO;
//    myView.text = self.detailString;
//    [self.view addSubview:myView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
