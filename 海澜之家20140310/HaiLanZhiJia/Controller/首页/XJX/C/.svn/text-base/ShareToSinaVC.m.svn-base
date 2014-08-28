//
//  ShareToSinaVC.m
//  HaiLanZhiJia
//
//  Created by creaver on 13-11-29.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "ShareToSinaVC.h"
//#import "SinaWeibo.h"
#import "WeiboApi.h"
@interface ShareToSinaVC ()<WeiboAuthDelegate,WeiboRequestDelegate>
{
    UITextView *shareView;
    UIImageView *sharePic;
}

@end

@implementation ShareToSinaVC

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
    
    
    NSLog(@"FFFFFFFfffffff%@",self.urlString);
    
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    if(self.isSina)
    {
       [self setTitleString:@"分享到新浪微博"]; 
    }
    if(self.isTecent)
    {
      [self setTitleString:@"分享到腾讯微博"];   
    }
    [self createMyButtonWithTitleAndImage];
    [self setMyRightButtonTitle:@"发布"];
    [self setMyRightButtonBackGroundImageView:@"button1.png" hightImage:@"button1_press.png"];
    [self initView];
    
    // Do any additional setup after loading the view.
}


-(void)initView
{
    UIEdgeInsets insert = UIEdgeInsetsMake(10, 10, 10, 10);
    UIImage *bgImg = GETIMG(@"bg_list.png");
    bgImg = [bgImg resizableImageWithCapInsets:insert];
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, TITLEHEIGHT+10, MainViewWidth-20, 170)];
    bgView.image = bgImg;
    bgView.userInteractionEnabled = YES;
    [self.view addSubview:bgView];
    [bgView release];
    
    shareView = [[UITextView alloc]init];
//    NSString *shareStr = [NSString stringWithFormat:
//                          @"海澜之家购买的“%@“不错哦。http://mall.heilanhome.com（来自海澜之家客户端)",
//                          self.goodName];
    NSString *shareStr = [NSString stringWithFormat:
                          @"海澜之家购买的“%@“不错哦。%@（来自海澜之家客户端)",
                          self.goodName,self.fenxiangLianjie];

    shareView.frame = CGRectMake(0, 0, MainViewWidth-20, 170);
    shareView.backgroundColor = [UIColor clearColor];
    shareView.font = SYSTEMFONT(15);
    shareView.textColor = RGBCOLOR(60, 60, 60);
    [bgView addSubview:shareView];
    shareView.text = shareStr;
    
//    列表小图.png
    UIImage *image = GetImage(@"列表小图.png");
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(10, TITLEHEIGHT+10+175, 84, 88)];
    view.image = image;
    [self.view addSubview:view];
  
    
    sharePic = [[UIImageView alloc]initWithFrame:CGRectMake(2, 2, 80, 80)];
    
    [sharePic setImageWithURL:[NSURL URLWithString:self.urlString] placeholderImage:nil];
    [view addSubview:sharePic];
    [view release];
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *oneTouch =[touches anyObject];
    if(oneTouch.tapCount==1)
    {
        [shareView resignFirstResponder];
    }
}

-(void)myRightButtonAction:(UIButton *)button
{
    [button setEnabled:NO];     //点击一次就不能再点了
    [self addHud:@"正在发布"];
    [shareView resignFirstResponder];

//    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.urlString]]];
//    NSData *imageData = UIImagePNGRepresentation(image);
//    int lengthKb = [imageData length];
//    float kScaleNumber=0.0;
//    NSData *thumbImageData= UIImageJPEGRepresentation(image, kScaleNumber);
//    UIImage *image1 = [UIImage imageWithData:thumbImageData];
//    if(lengthKb>32)
//    {
//       kScaleNumber=30.0/lengthKb; 
//    }
//    else
//    {
//        kScaleNumber = 1;
//    }
    
    if(self.isSina)
    {
//         SinaWeibo *sinaWeibo=[self sinaweibo];
//        NSString *shareString = [NSString stringWithFormat:@"%@",shareView.text];
//        [sinaWeibo requestWithURL:@"statuses/upload.json"
//                           params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                   shareString, @"status",
//                                   sharePic.image, @"pic", nil]
//                       httpMethod:@"POST"
//                         delegate:self];
//        [shareView resignFirstResponder];
    }
    if(self.isTecent)
    {
        WeiboApi *weiboApi=[self tecentweibo];
        NSString *shareString = [NSString stringWithFormat:@"%@",shareView.text];
        NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"json",@"format",
                                       shareString, @"content",//内容
                                       sharePic.image, @"pic",//图片
                                       nil];
        [weiboApi requestWithParams:params apiName:@"t/add_pic" httpMethod:@"POST" delegate:self];
     //   [pic release];
        [params release];
  
    }
}

#pragma mark - 腾讯微博
- (WeiboApi *)tecentweibo
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.wbapi;
}



#pragma mark--- 腾讯 delegate
- (void)didReceiveRawData:(NSData *)data reqNo:(int)reqno
{
    [self.myRightButton setEnabled:YES];    //发布成功则发布按钮又可以点
    [self hideHud:nil];
    [WCAlertView showAlertWithTitle:nil message:@"微博分享成功" customizationBlock:^(WCAlertView *alertView) {
        alertView.style = WCAlertViewStyleWhite;
        alertView.labelTextColor=[UIColor blackColor];
        alertView.buttonTextColor=[UIColor blueColor];
    } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
        nil;
    } cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
    [self popViewController];
    
}
- (void)didFailWithError:(NSError *)error reqNo:(int)reqno
{
    [self.myRightButton setEnabled:YES];    //发布失败发布按钮又可以点
}
//#pragma mark - 新浪微博
//- (SinaWeibo *)sinaweibo
//{
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    return delegate.sinaweibo;
//}

//- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
//{
//    [self hideHud:nil];
//    if ([request.url hasSuffix:@"statuses/upload.json"])
//    {
//        [WCAlertView showAlertWithTitle:@"提示" message:@"转发到微博失败" customizationBlock:^(WCAlertView *alertView) {
//            alertView.style = WCAlertViewStyleWhite;
//            alertView.labelTextColor=[UIColor blackColor];
//            alertView.buttonTextColor=[UIColor blueColor];
//        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
//            nil;
//        } cancelButtonTitle:nil otherButtonTitles:@"确认", nil];    }
//    
//}

//- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
//{
//    [self hideHud:nil];
//    
//    if ([request.url hasSuffix:@"statuses/upload.json"])
//    {
//        
//        [WCAlertView showAlertWithTitle:@"提示" message:@"转发到微博成功" customizationBlock:^(WCAlertView *alertView) {
//            alertView.style = WCAlertViewStyleWhite;
//            alertView.labelTextColor=[UIColor blackColor];
//            alertView.buttonTextColor=[UIColor blueColor];
//        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
//            nil;
//        } cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
//        
//        
//    }else if ([request.url hasSuffix:@"statuses/update.json"])
//    {
//        [WCAlertView showAlertWithTitle:@"提示" message:@"转发到微博成功" customizationBlock:^(WCAlertView *alertView) {
//            alertView.style = WCAlertViewStyleWhite;
//            alertView.labelTextColor=[UIColor blackColor];
//            alertView.buttonTextColor=[UIColor blueColor];
//        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
//            nil;
//        } cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
//        
//    }
//    [self popViewController];
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
