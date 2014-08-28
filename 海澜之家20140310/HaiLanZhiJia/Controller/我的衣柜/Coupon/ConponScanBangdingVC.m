//
//  ConponScanBangdingVC.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-12-3.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "ConponScanBangdingVC.h"
#import "ScanFrameView.h"
@interface ConponScanBangdingVC ()

@end

@implementation ConponScanBangdingVC
{
    ZBarReaderView *zbarView;
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
    [zbarView release];
    self.requestObj.delegate = nil;
    self.requestObj = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setTitleString:@"扫描绑定"];
    [self initUI];
    NSLog(@"++++++++++++++++++type = %i",self.conponType);
}

- (void)request:(NSString *)strNum
{
    [self.view addHUDActivityView:@"正在绑定"];  //提示 正在绑定
    
    if (!self.requestObj) {
        DSRequest *request = [[DSRequest alloc]init];
        self.requestObj = request;
        request.delegate = self;
        [request release];
    }
    
    [self.requestObj requestDataWithInterface:BindShoppingTicket param:[self BindShoppingTicketParam:strNum password:nil type:self.conponType haspassword:0 isscan:1] tag:1];    //type	int	绑定购物券类型 1：现金券 2：抵用券
    
}

#pragma mark DSRequestDelegate
- (void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    [self.view removeHUDActivityView];        //绑定成功  停止转圈
    
    StatusEntity *entiSta = (StatusEntity *)dataObj;
    NSLog(@"++++++++++++++++%@",entiSta.failmsg);
    if (entiSta.response == 1) {
        [self.view.window addHUDLabelView:@"绑定成功" Image:nil afterDelay:2];
    }else {
        [self.view.window addHUDLabelView:entiSta.failmsg Image:nil afterDelay:2];
    }
    [zbarView start];
}

- (void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError *)error
{
    [self.view removeHUDActivityView];        //绑定成功  停止转圈
    [self.view addHUDLabelView:@"无法连接网络" Image:nil afterDelay:2];
    [zbarView start];
}

- (void)initUI
{
    zbarView = [[ZBarReaderView alloc]init];
    zbarView.frame = CGRectMake(0, TITLEHEIGHT, MainViewWidth, MainViewHeight - TITLEHEIGHT);
    zbarView.readerDelegate = self;
    
//    [zbarView setScanCrop:[self getScanCrop:CGRectMake(imgViewScan.frame.origin.x, imgViewScan.frame.origin.y - segment.frame.origin.y - segment.frame.size.height, imgViewScan.frame.size.width, imgViewScan.frame.size.height) readerViewBounds:zbarView.bounds]];
    
    // 黑边及方框
    ScanFrameView *scanView = [[ScanFrameView alloc]initWithFrame:zbarView.frame];
    
    UILabel *labRemindUp = [[UILabel alloc]initWithFrame:CGRectMake(69, 25 + TITLEHEIGHT, 182, 30)];
    [labRemindUp setFont:SetFontSize(FontSize12)];
    [labRemindUp setText:@"将二维码图像置于扫描框内，离手机10cm左右，扫描进行绑定"];
    [labRemindUp setTextColor:[UIColor whiteColor]];
    [labRemindUp setTextAlignment:NSTextAlignmentCenter];
    [labRemindUp setBackgroundColor:[UIColor clearColor]];
    [labRemindUp setNumberOfLines:2];
    
    UILabel *labRemindDown = [[UILabel alloc]initWithFrame:CGRectMake(100, 300 + TITLEHEIGHT, 150, FontSize12)];
    [labRemindDown setFont:SetFontSize(FontSize12)];
    [labRemindDown setText:@"扫描成功后将自动识别"];
    [labRemindDown setTextColor:[UIColor whiteColor]];
    [labRemindDown setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:zbarView];
    [self.view addSubview:scanView];
    [self.view addSubview:labRemindUp];
    [self.view addSubview:labRemindDown];
    
    [zbarView start];
    
    [scanView release];
    [labRemindDown release];
    [labRemindUp release];
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
//        NSString* codeStr = sym.data;
        [zbarView stop];
        
        NSLog(@"扫描内容：%@",sym.data);
        if (sym.data.length) {
            [self request:sym.data];
        }
        
        
        
        break;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
