//
//  BarCodeScanVC.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-27.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "BarCodeScanVC.h"
#import "ScanFrameView.h"
#import "HandInputVC.h"

@interface BarCodeScanVC ()<ShangPingDetailVCDelegate>

@end

@implementation BarCodeScanVC
{
    ZBarReaderView *zbarView;
    
    UIButton *button;
    
    
}

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
    [zbarView stop];
    zbarView.readerDelegate = nil;
    [zbarView release];
    zbarView = nil;
//    [labRemindUp release];
    
    self.requestOjb = nil;
    self.requestOjb.delegate = nil;
    self.arrScanHistory = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setTitleString:@"扫描购物"];
    
    [self createMyButtonWithTitleAndImage];
    [self setMyRightButtonImage:@"search_scan_icon_histury.png" hightImage:@"search_scan_icon_histury.png"];
    [self setMyRightButtonBackGroundImageView:@"button1.png" hightImage:@"button1_press.png"];
    
    [self initUI];
}

- (void)myRightButtonAction:(UIButton *)button
{
    ScanHistoryVC *historyVC = [[ScanHistoryVC alloc]init];
    historyVC.backDelegate = self;
    [self pushViewController:historyVC];
    [historyVC release];
}

- (void)leftAction
{
    [super leftAction];
    [zbarView stop];
}

#pragma mark - 从扫描历史返回是调用此协议方法
- (void)scanHistroyVCDisMissed:(ScanHistoryVC *)scanHistroyvc
{
    [zbarView start];
}

- (void)initUI
{
//    MySegMentControl *segment = [[MySegMentControl alloc]initWithFrame:CGRectMake(0, TITLEHEIGHT, 50, 50)];
//    segment.segments = [NSArray arrayWithObjects:@"条码扫描",@"二维码扫描", nil];
//    [segment createSegments];
//    segment.delegate = self;
    
    
    zbarView = [[ZBarReaderView alloc]init];
//    zbarView.frame = CGRectMake(0, segment.frame.origin.y + segment.frame.size.height, MainViewWidth, MainViewHeight - TITLEHEIGHT - segment.frame.size.height);
    zbarView.frame = CGRectMake(0, TITLEHEIGHT, MainViewWidth, MainViewHeight - TITLEHEIGHT);
    zbarView.readerDelegate = self;
    
    
    // 黑边及方框
    ScanFrameView *scanView = [[ScanFrameView alloc]initWithFrame:zbarView.frame];
    
//    labRemindUp = [[UILabel alloc]initWithFrame:CGRectMake(69, segment.frame.origin.y + segment.frame.size.height + 22, 182, 27)];
    UILabel *labRemindUp = [[UILabel alloc]initWithFrame:CGRectMake(69, 22 + TITLEHEIGHT, 182, 29)];
    [labRemindUp setFont:SetFontSize(FontSize12)];
    [labRemindUp setText:@"请调整条码直至与中央红线垂直距离为10cm，尽量避免逆光和阴影"];
    [labRemindUp setTextColor:[UIColor whiteColor]];
    [labRemindUp setTextAlignment:NSTextAlignmentCenter];
    [labRemindUp setBackgroundColor:[UIColor clearColor]];
    [labRemindUp setNumberOfLines:2];
    
    UILabel *labRemindDown = [[UILabel alloc]initWithFrame:CGRectMake(100, 280 + labRemindUp.frame.origin.y, 150, FontSize12)];
    [labRemindDown setFont:SetFontSize(FontSize12)];
    [labRemindDown setText:@"扫描成功后将自动识别"];
    [labRemindDown setTextColor:[UIColor whiteColor]];
    [labRemindDown setBackgroundColor:[UIColor clearColor]];
    
    UIImage *imgBtn = GetImage(@"search_scan_button.png");
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:imgBtn forState:UIControlStateNormal];
    [button setBackgroundImage:GetImage(@"search_scan_button_press.png") forState:UIControlStateHighlighted];
    [button setFrame:CGRectMake(18, 410 - 20, imgBtn.size.width, imgBtn.size.height)];
    [button addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:zbarView];
    [self.view addSubview:scanView];
//    [self.view addSubview:segment];
    [self.view addSubview:labRemindUp];
    [self.view addSubview:labRemindDown];
    [self.view addSubview:button];
    
    [zbarView start];
    
    [scanView release];    
    [labRemindDown release];
    [labRemindUp release];
//    [segment release];
}

- (void)request:(NSString *)strCode
{
    [zbarView addHUDActivityView:Loading];  //提示 加载中
    
    DSRequest *request = [[DSRequest alloc]init];
    self.requestOjb = request;
    request.delegate = self;
    [request requestDataWithInterface:GetBarcodeSearchResult param:[self GetBarcodeSearchResultParam:strCode] tag:1];
    [request release];
}

#pragma mark DSRequestDelegate
- (void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    NSLog(@"请求成功!");
//    dataObj = nil;
    if (dataObj == nil) {
        WCAlertView *alert = [[WCAlertView alloc]initWithTitle:@"扫描结果" message:@"没有找到该商品，需要重新尝试吗？" delegate:self cancelButtonTitle:@"不扫了" otherButtonTitles:@"重新扫", nil];
        [alert setStyle:WCAlertViewStyleWhite];
        [alert show];
        [alert release];
    }else {
        NSDate *currTime = [NSDate date];                               //获取当前时间
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *strTime = [formatter stringFromDate:currTime];
        [formatter release];
        
        GoodDetailEntity *entiGoodDetail = (GoodDetailEntity *)dataObj;
        NSMutableDictionary *dicOne = [[NSMutableDictionary alloc]init];
        [dicOne setObject:entiGoodDetail.goodsid forKey:@"goodsid"];
        [dicOne setObject:entiGoodDetail.imgdetail forKey:@"imgdetail"];
        [dicOne setObject:entiGoodDetail.goodsname forKey:@"goodsname"];
        [dicOne setObject:strTime forKey:@"strTime"];
        
        NSArray *arrs = [[NSUserDefaults standardUserDefaults]objectForKey:ScanHistory];        //将扫描结果保存至本地作为历史记录
        self.arrScanHistory = [NSMutableArray array];
        if (arrs) {
            [self.arrScanHistory addObjectsFromArray:arrs];
        }
        [self.arrScanHistory addObject:dicOne];
        [dicOne release];
        
        [[NSUserDefaults standardUserDefaults] setObject:self.arrScanHistory forKey:ScanHistory];
        
        ShangPingDetailVC *goodsDetailVC = [[ShangPingDetailVC alloc]init];
        goodsDetailVC.spDetailObject = entiGoodDetail;
        goodsDetailVC.delegate = self;
        [goodsDetailVC setComeFromType:ComeFromTiaoMa];
        [self pushViewController:goodsDetailVC];
        [goodsDetailVC release];
        
        NSLog(@"entiGoodDetail = %@",entiGoodDetail.goodsname);
    }
    
    [zbarView removeHUDActivityView];        //加载成功  停止转圈
}

#pragma mark - 商品详情返回时调用的协议方法
- (void)comeBackFromSpDetailVC
{
    [zbarView start];
}

- (void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError *)error
{
    NSLog(@"请求失败");
    [zbarView removeHUDActivityView];        //加载失败  停止转圈并弹出提示框
    [zbarView addHUDLabelView:error.domain Image:nil afterDelay:2];
}

#pragma mark WCAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex = %i",buttonIndex);
    if (buttonIndex == 0) {     //不扫了
        [self popViewController];
    }else {
        [zbarView start];
    }
}

- (void)clicked:(UIButton *)btn   //手动输入按钮点击事件
{
    HandInputVC *inputVC = [[HandInputVC alloc]init];
    [self pushViewController:inputVC];
    [inputVC release];
}

//#pragma mark MySegmentControlDelegate
//- (void)segmentControl:(MySegMentControl *)setMentControl touchedAtIndex:(NSInteger)index
//{
////    CATransition *transition = [CATransition animation];
////    [transition setDuration:1];
////    [transition setType:kCATransitionReveal];
////    [zbarView start];
//    
//    if (index == 0) {
////        [transition setSubtype:kCATransitionFromLeft];
//        [labRemindUp setText:@"请调整条码直至与中央红线垂直距离为10cm，尽量避免逆光和阴影"];
//        [button setHidden:NO];
//    }else {
////        [transition setSubtype:kCATransitionFromRight];
//        [labRemindUp setText:@"将二维码图像置于扫描框内，离手机10cm左右，扫描进行购物"];
//        [button setHidden:YES];
//    }
////    [self.view.layer addAnimation:transition forKey:@"ss"];
//}

-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    CGFloat x,y,width,height;
    
    x = rect.origin.x / readerViewBounds.size.width;
    y = rect.origin.y / readerViewBounds.size.height;
    width = rect.size.width / readerViewBounds.size.width;
    height = rect.size.height / readerViewBounds.size.height;
    NSLog(@"x = %f y = %f w = %f h = %f",x,y,width,height);
    return CGRectMake(x, y, width, height);
}

#pragma mark ZbarReaderViewDelegate
- (void) readerView: (ZBarReaderView*) view didReadSymbols: (ZBarSymbolSet*) syms fromImage: (UIImage*) img
{
    for(ZBarSymbol *sym in syms) {
        
        if (sym.data ==nil || sym.data == [NSNull class])
        {
            return;
        }
        
        //中文乱码解决
        NSString* codeStr = [NSString stringWithFormat:@"BAR_%@",sym.data];
        [zbarView stop];
        NSLog(@"扫描内容：%@",codeStr);
        if (codeStr.length) {
            [self request:codeStr];
        }
//        NSString *dic = nil;
//        if (codeStr.length > 0) {
//            
//            SBJsonParser *parser = [[SBJsonParser alloc]init];
//            dic = [parser objectWithString:codeStr];
//            [parser release];
//            
//        }
//        NSLog(@" 扫描内容： 解析前：%@  解析后：%@",codeStr,dic);
        
        
        
        
        
        break;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
