//
//  TuiHuoLiuVC.m
//  HaiLanZhiJia
//
//  Created by creaver on 13-12-2.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "TuiHuoLiuVC.h"

@interface TuiHuoLiuVC ()
{
    UITextView *fildView;
    UIWebView *showWebView;
}

@end

@implementation TuiHuoLiuVC

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

//去除html标签
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}

-(void)initView
{
    showWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, TITLEHEIGHT, MainViewWidth, MainViewHeight-TITLEHEIGHT-20)];
    self.view.backgroundColor = [UIColor redColor];
     [showWebView loadHTMLString:self.detailString baseURL:nil];
  //  NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.detailString]];
    [self.view addSubview: showWebView];
   
//    
//    fildView = [[UITextView alloc]initWithFrame:CGRectMake(0, TITLEHEIGHT, MainViewWidth, MainViewHeight-TITLEHEIGHT)];
//    fildView.font = SYSTEMFONT(14);
//    fildView.backgroundColor = VIEW_BACKGROUND_COLOR;
//
//    fildView.editable = NO;
//    fildView.text =  [self filterHTML:self.detailString];
//    [self.view addSubview:fildView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
