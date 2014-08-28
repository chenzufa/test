//
//  HuoDongRuleView.m
//  HaiLanZhiJia
//
//  Created by creaver on 13-11-25.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "HuoDongRuleView.h"

@interface HuoDongRuleView ()
{
    UIWebView *showWebView;
}

@end

@implementation HuoDongRuleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
    }
    return self;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    [self setFrame:CGRectMake(0, 0, MainViewWidth, MainViewHeight)];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainViewWidth, MainViewHeight)];
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:0.5];
    [view setUserInteractionEnabled:YES];
    [self addSubview:view];
    [view release];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    [view addGestureRecognizer:tap];
    [tap release];
    
    UIImageView *imgViewBackGround =[[UIImageView alloc]initWithImage:GetImage(@"bg_pop.png")];
    [imgViewBackGround setFrame:CGRectMake(0, 0, imgViewBackGround.image.size.width, imgViewBackGround.image.size.height)];
    [imgViewBackGround setCenter:CGPointMake(MainViewWidth / 2, (MainViewHeight) / 2)];
    [self addSubview:imgViewBackGround];
    showWebView =[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, imgViewBackGround.image.size.width, imgViewBackGround.image.size.height)];
    showWebView.delegate = self;
    [imgViewBackGround addSubview:showWebView];
    [imgViewBackGround release];
    [showWebView release];
}

- (void)tapView:(id)sender
{
    [self removeFromSuperview];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '75%'";
    
    [webView stringByEvaluatingJavaScriptFromString:str];

}

- (void)setContentsText:(NSString *)strtext
{
     [showWebView loadHTMLString:self.rule baseURL:nil];
}

//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    [self setTitleString:@"活动规则说明"];
//    
//    showWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, TITLEHEIGHT, MainViewWidth, MainViewHeight-TITLEHEIGHT-20)];
//    self.view.backgroundColor = [UIColor redColor];
//    [showWebView loadHTMLString:self.rule baseURL:nil];
//    //  NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.detailString]];
//    [self.view addSubview: showWebView];

//}


@end
