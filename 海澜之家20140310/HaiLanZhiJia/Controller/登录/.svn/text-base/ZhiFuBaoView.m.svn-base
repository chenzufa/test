//
//  ZhiFuBaoView.m
//  HaiLanZhiJia
//
//  Created by creaver on 14-2-12.
//  Copyright (c) 2014年 donson. All rights reserved.
//

#import "ZhiFuBaoView.h"
#import "UIViewController+Hud.h"
#import "DSRequest.h"
#import "RootVC.h"
#define BASE_URL @"https://mapi.alipay.com/gateway.do?_input_charset=utf-8&partner=2088001972246472&return_url=http://mall.heilanhome.com/interface/fastlogin/&service=alipay.auth.authorize&target_service=user.auth.quick.login&sign=a9415f8f245d26982d4f1acf7837128b&sign_type=MD5"
@interface ZhiFuBaoView ()<UIWebViewDelegate>
{
    UIWebView *webView;
}
@property(nonatomic,retain)NSString *someId;//匿名id
@property(nonatomic,retain)NSString *deceiveToken;//推送token
@property(nonatomic,retain)DSRequest *aRequest;
@end

@implementation ZhiFuBaoView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [webView release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.someId = [[NSUserDefaults standardUserDefaults] objectForKey:AnonymityId];//匿名id
    self.deceiveToken = [[NSUserDefaults standardUserDefaults] objectForKey:kkkDeviceToken];//推送token
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, TITLEHEIGHT, MainViewWidth, MainViewHeight-TITLEHEIGHT)];
    webView.delegate=self;
    webView.scalesPageToFit=YES;
    [webView.scrollView setBounces:NO];
    [self.view addSubview:webView];
    NSURL *url =[NSURL URLWithString:BASE_URL];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
     [self addHud:Loading];
    
//    NSLog(@"stringByReplacingPercentEscapesUsingEncoding %@",[@"%E8%83%A1%E9%B9%8F" stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);

	// Do any additional setup after loading the view.
}
#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //成功后返回
    //数据：http://mall.heilanhome.com/interface/fastlogin/?is_success=T&notify_id=RqPnCoPT3K9%252Fvwbh3I74nHh3NFI%252FVB%252BrkJIXUPsA2%252F%252BWrMxOF9k%252BynXCm12JuTLJHUTU&real_name=%E8%83%A1%E9%B9%8F&token=201402127c22f116dfdf42dfbb9a215eb294e18e&user_id=2088102820317358&sign=cae72d77a31e70732b67f1d196a5f01e&sign_type=MD5
    NSString *loginString = [[request URL] absoluteString];
    NSString *bringString = @"is_success=T";
    NSString *token = @"";
    NSString *userName = @"";
    if([loginString rangeOfString:bringString].location !=NSNotFound)
    {
        
        NSArray *stringArray = [loginString componentsSeparatedByString:@"&"];
        for (NSString *string in stringArray)
        {
           if([string rangeOfString:@"user_id"].location !=NSNotFound)
           {
               NSArray *tokenAry = [string componentsSeparatedByString:@"="];
               token = [tokenAry objectAtIndex:1];
           }
            if([string rangeOfString:@"real_name"].location !=NSNotFound)
            {
                NSArray *tokenAry = [string componentsSeparatedByString:@"="];
                userName = [tokenAry objectAtIndex:1];
            }
        }
        NSLog(@"支付宝token:%@,支付宝userName:%@",token,userName);
        DSRequest *requestObj = [[DSRequest alloc]init];
        requestObj.delegate = self;
        self.aRequest = requestObj;
        NSString *nameString = [userName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //密码普通登陆有效
//        [requestObj requestDataWithInterface:Login param:[self LoginParam:@"13163763245" password:@"111111" type:@"1" thirdtoken:token anonymityid:self.someId token:self.deceiveToken] tag:0];
         [requestObj requestDataWithInterface:Login param:[self LoginParam:nameString password:@"" type:@"4" thirdtoken:token anonymityid:self.someId token:self.deceiveToken] tag:0];
        [self addHud:@"正在登录"];
        [requestObj release];
    }
    NSLog(@"数据：%@",loginString);
    return YES;
}




-(void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    webView.hidden = YES;
    NSLog(@"%@",dataObj);
     [self popViewController];
    if(self.loginDelegate&&[self.loginDelegate respondsToSelector:@selector(zhifubaoLogin:andTag:)])
    {
        [self.loginDelegate zhifubaoLogin:dataObj andTag:tag];
    }
    
}

-(void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError *)error
{
    webView.hidden = YES;
    [self hideHud:nil];
    if(self.loginDelegate&&[self.loginDelegate respondsToSelector:@selector(zhifubaoLoginFail:andTag:andEnum:)])
    {
        [self.loginDelegate zhifubaoLoginFail:tag andError:error andEnum:type];
    }
    [self popViewController];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideHud:nil];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideHud:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
