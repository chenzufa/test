//
//  OrderFormVC.m
//  HaiLanZhiJia
//
//  Created by 蒋遂明 on 13-11-28.
//  Copyright (c) 2013年 donson. All rights reserved.
//
#define ADDRESS_TAG 0x1000
#define ORDER_INFO_TAG 0x500
#define FAPIAO_INFO_TAG  0x600
#define ZHIFU_TAG 0x700
#define DELIVER_TAG 0x800
#define BEIZHU_TAG 0x900
#define XIANJIN_TAG 0x1100
#define DIYONG_TAG 0x1200
#import "OrderFormVC.h"

@interface OrderFormVC ()

@property (nonatomic) BOOL showingList;

@end

@implementation OrderFormVC
@synthesize headerTableView;
@synthesize showingList;
@synthesize myTableView;
@synthesize footerTableView;
@synthesize mySetupEntity;
@synthesize payMentArray;
@synthesize specialBuyEntity;


-(void)dealloc
{
    _payTypeRequest.delegate = nil;
    SAFETY_RELEASE(_payTypeRequest);
    _addressRequest.delegate = nil;
    SAFETY_RELEASE(_addressRequest);
    SAFETY_RELEASE(_getDeliverFeeRequest);
    
    self.headerTableView = nil;
    self.myTableView = nil;
    self.footerTableView = nil;
    self.mySetupEntity = nil;
    self.payMentArray = nil;
    self.myOrderList = nil;
    self.specialBuyEntity = nil;
    self.deliverStates = nil;
    
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
    
    
    // 设置实体默认值
    // 获取商品列表
//    NSMutableArray *goodList = [NSMutableArray array];
    NSArray *myArray = self.mySetupEntity.goodslist;
//    for (int i =0; i< [myArray count]; i++) {
//        NSArray *goodsArray = [myArray objectAtIndex:i];
//        [goodList addObjectsFromArray:goodsArray];
//    }
    if (!self.mySetupEntity.deliverE) {
        self.mySetupEntity.deliverE = [[[DeliverEntity alloc]init]autorelease];
    }
    if (!self.mySetupEntity.billE) {
        self.mySetupEntity.billE = [[[InvoceEntity alloc]init]autorelease];
    }
    PayTypeEntity *payEntity = [[PayTypeEntity alloc]init];
    payEntity.name = @""; //支付的名字
    payEntity.typeId = -1;
    self.myOrderList = myArray;
    self.mySetupEntity.paytypeE =payEntity;
    [payEntity release];
    self.mySetupEntity.deliverE.deliverby = 1;
    self.mySetupEntity.deliverE.deliverTime = 3;        //设置默认送货方式  因为后台原因 此处为3
    self.mySetupEntity.billE.strContent = @"";
    self.mySetupEntity.billE.strTitle = @"";
    self.mySetupEntity.billE.isNeed = 0;
    self.mySetupEntity.note = @"";
    self.mySetupEntity.diYongFee = @"0.00";
    self.mySetupEntity.xianJinFee = @"0.00";
    
    [self setTitleString:@"填写订单"];
    
    [self addOrderInfo];
    [self createFooterView];
    
    [self addOtherMenues];
    
    self.showingList = NO;
    [self addTableView];
    
    [self createMyButtonWithTitleAndImage];
    [self setMyRightButtonTitle:@"提交订单"];
    [self setMyRightButtonBackGroundImageView:@"button2.png" hightImage:@"button2_press.png"];
	// Do any additional setup after loading the view.
    
    
    // 请求地址、位置
    [self requestToSerVer];
}

-(void)leftAction
{
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"您确定要取消填写订单吗？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==1) {
        [super leftAction];
    }
}

#pragma mark - 添加容器和订单概况
// 添加容器和订单概况
-(void)addOrderInfo
{
    UIView *myView  = [[UIView alloc]initWithFrame:CGRectMake(0, TITLEHEIGHT, MainViewWidth, 710)];
    self.headerTableView = myView;
    myView.backgroundColor = TEXT_BACKGROUD_COLOR;
//    [self.view addSubview:myView];
    [myView release];
    
    //订单概况
    UIView *aView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainViewWidth, 140)];
    aView.backgroundColor = [UIColor whiteColor];
    aView.tag = ORDER_INFO_TAG;
    
    for (int i =0; i<7; i++) {
        UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 8.0+17*i, 110, 17)];
        myLabel.backgroundColor = [UIColor clearColor];
        myLabel.textColor = RGBCOLOR(46, 46, 46);
        myLabel.textAlignment = NSTextAlignmentRight;
        myLabel.font = SYSTEMFONT(14);
        switch (i) {
            case 0:
                [myLabel setText:@"商品总计："];
                break;
            case 1:
                [myLabel setText:@"赠送积分总计："];
                break;
            case 2:
                [myLabel setText:@"商品金额总计："];
                break;
            case 3:
                [myLabel setText:@"+运费金额："];
                break;
            case 4:
                [myLabel setText:@"-抵用券："];
                break;
            case 5:
                [myLabel setText:@"-现金券："];
                break;
            case 6:
                [myLabel setText:@"=应付金额："];
                break;
            default:
                break;
        }
        [aView addSubview:myLabel];
        [myLabel release];
        
        
        UILabel *aLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 8.0+17*i, 310, 17)];
        aLabel.tag = ORDER_INFO_TAG +i+10;
        aLabel.textAlignment = NSTextAlignmentRight;
        aLabel.backgroundColor = [UIColor clearColor];
        aLabel.textColor = TEXT_RED_COLOR;
        aLabel.font = SYSTEMFONT(14);
        [aView addSubview:aLabel];
        [aLabel release];
        
    }
    UIImage *lineImg = GetImage(@"segmentation_line.png");
    UIImageView *lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,140, MainViewWidth, lineImg.size.height)];
    lineImgView.image = lineImg;
    [aView addSubview:lineImgView];
    
    [self.headerTableView addSubview:aView];
    [aView release];
    
    [self orderInfoRefresh];
}

-(void)orderInfoRefresh
{
    UIView *aView = [self.headerTableView viewWithTag:ORDER_INFO_TAG];
    for (int i =0; i<7; i++) {
        UILabel *aLabel = (UILabel *)[aView viewWithTag:(ORDER_INFO_TAG+10+i)];
        switch (i) {
            case 0:
            {[aLabel setText:[NSString stringWithFormat:@"%d件",self.mySetupEntity.selectcount]];}
                break;
            case 1:
            {[aLabel setText:self.mySetupEntity.score];}
                break;

            case 2:
            {[aLabel setText:[NSString stringWithFormat:@"￥%@",self.mySetupEntity.goodsfee]];}
                break;

            case 3:
            {[aLabel setText:[NSString stringWithFormat:@"￥%@",self.mySetupEntity.deliverfee]];}
                break;

            case 4:
            {[aLabel setText:[NSString stringWithFormat:@"￥%@",self.mySetupEntity.diYongFee]];}
                break;

            case 5:
            {[aLabel setText:[NSString stringWithFormat:@"￥%@",self.mySetupEntity.deliverfee]];}
                break;
                
            case 6:
            {[aLabel setText:[NSString stringWithFormat:@"￥%@",self.mySetupEntity.total]];}
                break;

            default:
                break;
        }
        //[aLabel setText:@"多少"];
    }
}

#pragma mark - 添加其他按钮

-(void)addOtherMenues
{
    UIView *myView  = [[UIView alloc]initWithFrame:CGRectMake(0, TITLEHEIGHT +140, MainViewWidth, 750-140)];
    myView.backgroundColor = [UIColor clearColor];
    
    int currentY = 155;
    
    // 地址
    do {
        UIView *aView  = [[UIView alloc]initWithFrame:CGRectMake(0, currentY, MainViewWidth, 75)];
        aView.tag = ADDRESS_TAG;
        aView.backgroundColor = [UIColor clearColor];
        
        // 添加框框
        UIImage *aImg = GetImage(@"bg_list2_up.png");
        UIImageView *aImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,0, aImg.size.width, aImg.size.height)];
        aImageView.image = aImg;
        [aView addSubview:aImageView];
        [aImageView release];
        UIImage *bImg = GetImage(@"bg_list2_down.png");
        UIImageView *bImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,bImg.size.height-10, bImg.size.width, bImg.size.height)];
        bImageView.image = bImg;
        [aView addSubview:bImageView];
        [bImageView release];
        
        // 内容
        UILabel *aLable = [[UILabel alloc]initWithFrame:CGRectMake(20,12, 140, 21)];
        aLable.tag = ADDRESS_TAG +1;
        [aLable setTextColor:TEXT_GRAY_COLOR];
        [aLable setFont:SYSTEMFONT(15)];
        aLable.backgroundColor = [UIColor clearColor];
        [aLable setText:@"请选择送货地址"];
        [aView addSubview:aLable];
        [aLable release];
        
        UILabel *bLable = [[UILabel alloc]initWithFrame:CGRectMake(160,15, 160-40, 15)];
        bLable.tag = ADDRESS_TAG +2;
        [bLable setTextColor:TEXT_GRAY_COLOR];
        [bLable setTextAlignment:NSTextAlignmentRight];
        [bLable setFont:SYSTEMFONT(15)];
        bLable.backgroundColor = [UIColor clearColor];
        [aView addSubview:bLable];
        [bLable release];
        
        UILabel *cLable = [[UILabel alloc]initWithFrame:CGRectMake(20,32, 230, 40)];
        cLable.tag = ADDRESS_TAG +3;
        [cLable setTextColor:ColorFontgray];
        cLable.numberOfLines = 2;
        [cLable setFont:SYSTEMFONT(13)];
        cLable.backgroundColor = [UIColor clearColor];
        [aView addSubview:cLable];
        [cLable release];
        
        UIImage *cImg = GetImage(@"icon_next.png");
        UIImageView *cImageView = [[UIImageView alloc] initWithFrame:CGRectMake(290,30, cImg.size.width, cImg.size.height)];
        cImageView.image = cImg;
        [aView addSubview:cImageView];
        [cImageView release];
        
        [self.headerTableView addSubview:aView];
        [aView release];
        
        UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
        myButton.frame = CGRectMake(0, currentY, MainViewWidth, 75);
        //myIMG.size.width,myIMG.size.height
        myButton.backgroundColor = [UIColor clearColor];
        [myButton addTarget:self action:@selector(selectAddress:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerTableView addSubview:myButton];
        
    } while (0);
    currentY += (80+10);
    
    // 支付方式
    do {
        UIView *aView  = [[UIView alloc]initWithFrame:CGRectMake(0, currentY, MainViewWidth, 45)];
        aView.backgroundColor = [UIColor clearColor];
        aView.tag = ZHIFU_TAG;
        
        // 添加框框
        UIImage *aImg = GetImage(@"bg_list.png");
        UIImageView *aImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,0, aImg.size.width, aImg.size.height)];
        aImageView.image = aImg;
        [aView addSubview:aImageView];
        [aImageView release];
        
        // 内容
        UILabel *aLable = [[UILabel alloc]initWithFrame:CGRectMake(20,15, 70, 15)];
        [aLable setTextColor:TEXT_GRAY_COLOR];
        [aLable setFont:SYSTEMFONT(15)];
        aLable.backgroundColor = [UIColor clearColor];
        [aLable setText:@"支付方式"];
        [aView addSubview:aLable];
        [aLable release];
        
        UILabel *bLable = [[UILabel alloc]initWithFrame:CGRectMake(90,15, 160-15, 15)];
        bLable.tag = ZHIFU_TAG +1;
        [bLable setTextColor:SUBTITLE_GRAY_COLOR];
        [bLable setFont:SYSTEMFONT(15)];
        bLable.backgroundColor = [UIColor clearColor];
        [bLable setText:@""];
        [aView addSubview:bLable];
        [bLable release];
        
        UIImage *cImg = GetImage(@"icon_next.png");
        UIImageView *cImageView = [[UIImageView alloc] initWithFrame:CGRectMake(290,15, cImg.size.width, cImg.size.height)];
        cImageView.image = cImg;
        [aView addSubview:cImageView];
        [cImageView release];
        
        [self.headerTableView addSubview:aView];
        [aView release];
        
        UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
        myButton.frame = CGRectMake(0, currentY, MainViewWidth, 45);
        //myIMG.size.width,myIMG.size.height
        myButton.backgroundColor = [UIColor clearColor];
        [myButton addTarget:self action:@selector(selectPayment:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerTableView addSubview:myButton];
        
    } while (0);
    currentY += (45+10);
    
    // 配送方式
    do {
        UIView *aView  = [[UIView alloc]initWithFrame:CGRectMake(0, currentY, MainViewWidth, 90)];
        aView.backgroundColor = [UIColor clearColor];
        aView.tag = DELIVER_TAG;
        
        // 添加框框
        UIImage *aImg = GetImage(@"bg_list2_up.png");
        UIImageView *aImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,0, aImg.size.width, aImg.size.height)];
        aImageView.image = aImg;
        [aView addSubview:aImageView];
        [aImageView release];
        UIImage *bImg = GetImage(@"bg_list2_down.png");
        UIImageView *bImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,bImg.size.height-4, bImg.size.width, bImg.size.height)];
        bImageView.image = bImg;
        [aView addSubview:bImageView];
        [bImageView release];
        UIImage *lineImg = GetImage(@"segmentation_line.png");
        UIImageView *lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10,aImg.size.height, lineImg.size.width, lineImg.size.height)];
        lineImgView.image = lineImg;
        [aView addSubview:lineImgView];
        [lineImgView release];
        
        // 内容
        UILabel *aLable = [[UILabel alloc]initWithFrame:CGRectMake(20,15, 70, 15)];
        [aLable setTextColor:TEXT_GRAY_COLOR];
        [aLable setFont:SYSTEMFONT(15)];
        aLable.backgroundColor = [UIColor clearColor];
        [aLable setText:@"配送方式"];
        [aView addSubview:aLable];
        [aLable release];
        
        UILabel *bLable = [[UILabel alloc]initWithFrame:CGRectMake(90,15, 160-15, 15)];
        [bLable setTextColor:SUBTITLE_GRAY_COLOR];
        [bLable setFont:SYSTEMFONT(15)];
        bLable.backgroundColor = [UIColor clearColor];
        [bLable setText:@"第三方快递"];
        [aView addSubview:bLable];
        [bLable release];
        
        UILabel *cLable = [[UILabel alloc]initWithFrame:CGRectMake(20,15+44, 300, 15)];
        cLable.tag = DELIVER_TAG +1;
        [cLable setTextColor:ColorFontgray];
        [cLable setFont:SYSTEMFONT(12)];
        cLable.backgroundColor = [UIColor clearColor];
        [cLable setText:@"工作日、双休日与假日均送"];
        [aView addSubview:cLable];
        [cLable release];
        
        UIImage *cImg = GetImage(@"icon_next.png");
        UIImageView *cImageView = [[UIImageView alloc] initWithFrame:CGRectMake(290,15+44, cImg.size.width, cImg.size.height)];
        cImageView.image = cImg;
        [aView addSubview:cImageView];
        [cImageView release];
        
        [self.headerTableView addSubview:aView];
        [aView release];
        
        UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
        myButton.frame = CGRectMake(0, currentY, MainViewWidth, 90);
        //myIMG.size.width,myIMG.size.height
        myButton.backgroundColor = [UIColor clearColor];
        [myButton addTarget:self action:@selector(selectDeliver:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerTableView addSubview:myButton];
        
    } while (0);
    currentY += (90+10);
    // 发票
    do {
        UIView *aView  = [[UIView alloc]initWithFrame:CGRectMake(0, currentY, MainViewWidth, 90)];
        aView.backgroundColor = [UIColor clearColor];
        aView.tag = FAPIAO_INFO_TAG;
        
        // 添加框框
        UIImage *aImg = GetImage(@"bg_list2_up.png");
        UIImageView *aImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,0, aImg.size.width, aImg.size.height)];
        aImageView.image = aImg;
        [aView addSubview:aImageView];
        [aImageView release];
        UIImage *bImg = GetImage(@"bg_list2_down.png");
        UIImageView *bImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,bImg.size.height-4, bImg.size.width, bImg.size.height)];
        bImageView.image = bImg;
        [aView addSubview:bImageView];
        [bImageView release];
        UIImage *lineImg = GetImage(@"segmentation_line.png");
        UIImageView *lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10,aImg.size.height, lineImg.size.width, lineImg.size.height)];
        lineImgView.image = lineImg;
        [aView addSubview:lineImgView];
        [lineImgView release];
        
        // 内容
        UILabel *aLable = [[UILabel alloc]initWithFrame:CGRectMake(20,15, 70, 15)];
        [aLable setTextColor:TEXT_GRAY_COLOR];
        [aLable setFont:SYSTEMFONT(15)];
        aLable.backgroundColor = [UIColor clearColor];
        [aLable setText:@"发票信息"];
        [aView addSubview:aLable];
        [aLable release];
        
//        UILabel *bLable = [[UILabel alloc]initWithFrame:CGRectMake(90,15, 160-15, 15)];
//        bLable.tag = FAPIAO_INFO_TAG +1;
//        [bLable setTextColor:SUBTITLE_GRAY_COLOR];
//        [bLable setFont:SYSTEMFONT(15)];
//        bLable.backgroundColor = [UIColor clearColor];
//        [bLable setText:@"普通发票"];
//        [aView addSubview:bLable];
//        [bLable release];
        
        UILabel *cLable = [[UILabel alloc]initWithFrame:CGRectMake(20,15+44, 270, 15)];  // 发票抬头
        cLable.tag = FAPIAO_INFO_TAG +2;
        [cLable setTextColor:ColorFontgray];
        [cLable setFont:SYSTEMFONT(12)];
        cLable.backgroundColor = [UIColor clearColor];
        [cLable setText:@"您没有索要发票"];
        [aView addSubview:cLable];
        [cLable release];
        
        UILabel *dLable = [[UILabel alloc]initWithFrame:CGRectMake(20,23+44, 270, 15)]; // 发票内容
        dLable.tag = FAPIAO_INFO_TAG +3;
        [dLable setTextColor:ColorFontgray];
        [dLable setFont:SYSTEMFONT(12)];
        dLable.backgroundColor = [UIColor clearColor];
//        [dLable setText:@"您没有索要发票"];
        [aView addSubview:dLable];
        [dLable release];
        
        UIImage *cImg = GetImage(@"icon_next.png");
        UIImageView *cImageView = [[UIImageView alloc] initWithFrame:CGRectMake(290,15+44, cImg.size.width, cImg.size.height)];
        cImageView.image = cImg;
        [aView addSubview:cImageView];
        [cImageView release];
        
        [self.headerTableView addSubview:aView];
        [aView release];
        
        UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
        myButton.frame = CGRectMake(0, currentY, MainViewWidth, 90);
        //myIMG.size.width,myIMG.size.height
        myButton.backgroundColor = [UIColor clearColor];
        [myButton addTarget:self action:@selector(selectBill:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerTableView addSubview:myButton];
        
    } while (0);
    currentY += (90+10);
    // 现金券
    do {
        UIView *aView  = [[UIView alloc]initWithFrame:CGRectMake(0, currentY, MainViewWidth, 45)];
        aView.tag = XIANJIN_TAG;
        aView.backgroundColor = [UIColor clearColor];
        
        // 添加框框
        UIImage *aImg = GetImage(@"bg_list.png");
        UIImageView *aImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,0, aImg.size.width, aImg.size.height)];
        aImageView.image = aImg;
        [aView addSubview:aImageView];
        [aImageView release];
        
        // 内容
        UILabel *aLable = [[UILabel alloc]initWithFrame:CGRectMake(20,15, 200, 15)];
        [aLable setTextColor:TEXT_GRAY_COLOR];
        [aLable setFont:SYSTEMFONT(15)];
        aLable.backgroundColor = [UIColor clearColor];
        [aLable setText:@"使用现金券抵消部分金额"];
        [aView addSubview:aLable];
        [aLable release];
        
        UILabel *bLable = [[UILabel alloc]initWithFrame:CGRectMake(160,15, 160-50, 15)];
        bLable.tag = XIANJIN_TAG+1;
        [bLable setTextColor:TEXT_RED_COLOR];
        [bLable setTextAlignment:NSTextAlignmentRight];
        [bLable setFont:SYSTEMFONT(15)];
        bLable.backgroundColor = [UIColor clearColor];
        [bLable setText:@"0.00元"];
        [aView addSubview:bLable];
        [bLable release];
        
        UIImage *cImg = GetImage(@"icon_next.png");
        UIImageView *cImageView = [[UIImageView alloc] initWithFrame:CGRectMake(290,15, cImg.size.width, cImg.size.height)];
        cImageView.image = cImg;
        [aView addSubview:cImageView];
        [cImageView release];
        
        [self.headerTableView addSubview:aView];
        [aView release];
        
        UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
        myButton.frame = CGRectMake(0, currentY, MainViewWidth, 45);
        //myIMG.size.width,myIMG.size.height
        myButton.backgroundColor = [UIColor clearColor];
        [myButton addTarget:self action:@selector(selectXianJin:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerTableView addSubview:myButton];
    } while (0);
    currentY += (45+10);
    // 抵用券
    do {
        UIView *aView  = [[UIView alloc]initWithFrame:CGRectMake(0, currentY, MainViewWidth, 45)];
        aView.tag = DIYONG_TAG;
        aView.backgroundColor = [UIColor clearColor];
        
        // 添加框框
        UIImage *aImg = GetImage(@"bg_list.png");
        UIImageView *aImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,0, aImg.size.width, aImg.size.height)];
        aImageView.image = aImg;
        [aView addSubview:aImageView];
        [aImageView release];
        
        // 内容
        UILabel *aLable = [[UILabel alloc]initWithFrame:CGRectMake(20,15, 200, 15)];
        [aLable setTextColor:TEXT_GRAY_COLOR];
        [aLable setFont:SYSTEMFONT(15)];
        aLable.backgroundColor = [UIColor clearColor];
        [aLable setText:@"使用抵用券抵消部分金额"];
        [aView addSubview:aLable];
        [aLable release];
        
        UILabel *bLable = [[UILabel alloc]initWithFrame:CGRectMake(160,15, 160-50, 15)];
        bLable.tag = DIYONG_TAG +1;
        [bLable setTextColor:TEXT_RED_COLOR];
        [bLable setTextAlignment:NSTextAlignmentRight];
        [bLable setFont:SYSTEMFONT(15)];
        bLable.backgroundColor = [UIColor clearColor];
        [bLable setText:@"0.00元"];
        [aView addSubview:bLable];
        [bLable release];
        
        UIImage *cImg = GetImage(@"icon_next.png");
        UIImageView *cImageView = [[UIImageView alloc] initWithFrame:CGRectMake(290,15, cImg.size.width, cImg.size.height)];
        cImageView.image = cImg;
        [aView addSubview:cImageView];
        [cImageView release];
        
        [self.headerTableView addSubview:aView];
        [aView release];
        
        UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
        myButton.frame = CGRectMake(0, currentY, MainViewWidth, 45);
        //myIMG.size.width,myIMG.size.height
        myButton.backgroundColor = [UIColor clearColor];
        [myButton addTarget:self action:@selector(selectDiYong:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerTableView addSubview:myButton];
    } while (0);
    currentY += (45+10);
    // 备注
    do {
        UIView *aView  = [[UIView alloc]initWithFrame:CGRectMake(0, currentY, MainViewWidth, 45)];
        aView.tag = BEIZHU_TAG;
        aView.backgroundColor = [UIColor clearColor];
        
        // 添加框框
        UIImage *aImg = GetImage(@"bg_list.png");
        UIImageView *aImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,0, aImg.size.width, aImg.size.height)];
        aImageView.image = aImg;
        [aView addSubview:aImageView];
        [aImageView release];
        
        // 内容
        UILabel *aLable = [[UILabel alloc]initWithFrame:CGRectMake(20,15, 70, 15)];
        [aLable setTextColor:TEXT_GRAY_COLOR];
        [aLable setFont:SYSTEMFONT(15)];
        aLable.backgroundColor = [UIColor clearColor];
        [aLable setText:@"备注："];
        [aView addSubview:aLable];
        [aLable release];
        
        UILabel *bLable = [[UILabel alloc]initWithFrame:CGRectMake(80.0,3, 200, 45)];
        bLable.tag = BEIZHU_TAG +1;
        [bLable setTextColor:ColorFontgray];
        [bLable setFont:SYSTEMFONT(FontSize12)];
        bLable.backgroundColor = [UIColor clearColor];
//        [bLable setText:@"备注内容"];
        [aView addSubview:bLable];
        [bLable release];
        
        UIImage *cImg = GetImage(@"icon_next.png");
        UIImageView *cImageView = [[UIImageView alloc] initWithFrame:CGRectMake(290,15, cImg.size.width, cImg.size.height)];
        cImageView.image = cImg;
        [aView addSubview:cImageView];
        [cImageView release];
        
        [self.headerTableView addSubview:aView];
        [aView release];
        
        UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
        myButton.frame = CGRectMake(0, currentY, MainViewWidth, 45);
        //myIMG.size.width,myIMG.size.height
        myButton.backgroundColor = [UIColor clearColor];
        [myButton addTarget:self action:@selector(selectBeizhu:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerTableView addSubview:myButton];
        
    } while (0);
    currentY += (45+10);
    // 商品清单
    do {
        UIView *aView  = [[UIView alloc]initWithFrame:CGRectMake(0, currentY, MainViewWidth, 45)];
        aView.backgroundColor = [UIColor clearColor];
        
        // 添加框框
        UIImage *aImg = GetImage(@"bg_list.png");
        UIImageView *aImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,0, aImg.size.width, aImg.size.height)];
        aImageView.image = aImg;
        [aView addSubview:aImageView];
        [aImageView release];
        
        // 内容
        UILabel *labShangpinList = [[UILabel alloc]initWithFrame:CGRectMake(20,15, 100, 15)];
        [labShangpinList setTextColor:TEXT_GRAY_COLOR];
        [labShangpinList setFont:SYSTEMFONT(15)];
        labShangpinList.backgroundColor = [UIColor clearColor];
        int shangpinlistCount = 0;
        for (GoodEntity *oneGoods in self.myOrderList) {
            shangpinlistCount = oneGoods.count + shangpinlistCount;
        }
        [labShangpinList setText:[NSString stringWithFormat:@"商品清单(%i)",shangpinlistCount]];
        [aView addSubview:labShangpinList];
        [labShangpinList release];
        
//        UILabel *bLable = [[UILabel alloc]initWithFrame:CGRectMake(160,15, 160-15, 15)];
//        [bLable setTextColor:TEXT_GRAY_COLOR];
//        [bLable setFont:SYSTEMFONT(15)];
//        bLable.backgroundColor = [UIColor clearColor];
////        [bLable setText:@"10.00元"];
//        [bLable setText:self.mySetupEntity.total];
//        [aView addSubview:bLable];
//        [bLable release];
        
//        UIImage *cImg = GetImage(@"icon_next.png");
//        UIImageView *cImageView = [[UIImageView alloc] initWithFrame:CGRectMake(290,15, cImg.size.width, cImg.size.height)];
//        cImageView.image = cImg;
//        [aView addSubview:cImageView];
//        [cImageView release];
        
        [self.headerTableView addSubview:aView];
        [aView release];
        
        UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
        myButton.frame = CGRectMake(0, currentY, MainViewWidth, 45);
        //myIMG.size.width,myIMG.size.height
        myButton.backgroundColor = [UIColor clearColor];
        myButton.selected = NO;
        [myButton addTarget:self action:@selector(selectList:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerTableView addSubview:myButton];
        UIImage *cImg = GetImage(@"car_icon_pack up.png");
        UIImageView *cImageView = [[UIImageView alloc] initWithFrame:CGRectMake(290 - 5,15, cImg.size.width, cImg.size.height)];
        cImageView.image = cImg;
        cImageView.tag =1000;
        [myButton addSubview:cImageView];
        [cImageView release];

    } while (0);
    currentY += (45+10);
    NSLog(@"%d",currentY);
    
    [self.view addSubview:myView];
    [myView release];
}

#pragma mark - 计算应付金额
-(void)setTotalCount{
    float moneyTicketCount = 0.00;
    for (ShoppingTicketEntity *aEntity in self.mySetupEntity.moneyTicketList){
        if (aEntity.amount && ![aEntity.amount isKindOfClass:[NSNull class]] && ![aEntity.amount isEqualToString:@""]) {
            moneyTicketCount += [aEntity.amount floatValue];
        }
    }
    NSString *strMoney = [NSString stringWithFormat:@"￥%.2f",moneyTicketCount];
    UIView *aView = [self.headerTableView viewWithTag:ORDER_INFO_TAG];
    UILabel *aLabel = (UILabel *)[aView viewWithTag:(ORDER_INFO_TAG+10+5)];
    [aLabel setText:strMoney];
    //
    float tradeTicketCount = 0.00;
    for (ShoppingTicketEntity *aEntity in self.mySetupEntity.tradeTicketList){
        if (aEntity.amount && ![aEntity.amount isKindOfClass:[NSNull class]] && ![aEntity.amount isEqualToString:@""]) {
            tradeTicketCount += [aEntity.amount floatValue];
        }
    }
    NSString *strTrade = [NSString stringWithFormat:@"￥%.2f",tradeTicketCount];
    UILabel *bLabel = (UILabel *)[aView viewWithTag:(ORDER_INFO_TAG+10+4)];
    [bLabel setText:strTrade];
    //
    float deliverFee = 0.0;
    if (self.mySetupEntity.deliverfee && ![self.mySetupEntity.deliverfee isKindOfClass:[NSNull class]] && ![self.mySetupEntity.deliverfee isEqualToString:@""]) {
        deliverFee += [self.mySetupEntity.deliverfee floatValue];
    }
    NSString *strDeliverFee = [NSString stringWithFormat:@"￥%.2f",deliverFee];
    UILabel *deliverLabel = (UILabel *)[aView viewWithTag:(ORDER_INFO_TAG+10+3)];
    [deliverLabel setText:strDeliverFee];
    
    float totalCount = [self.mySetupEntity.total floatValue] - moneyTicketCount - tradeTicketCount + deliverFee;
    if (totalCount<0) {
        totalCount = 0;
    }
    NSString *strTotal = [NSString stringWithFormat:@"￥%.2f",totalCount];
    UILabel *cLabel = (UILabel *)[aView viewWithTag:(ORDER_INFO_TAG+10+6)];
    [cLabel setText:strTotal];
}

#pragma mark - 点击按钮进入其他页面

-(void)selectAddress:(UIButton *)button
{
    AddressManagerVC *add = [[AddressManagerVC alloc]init];
    add.delegate = self;
    [self pushViewController:add];
    [add release];
}
-(void)selectPayment:(UIButton *)button
{
    PayMentVC *payVC = [[PayMentVC alloc]init];
    payVC.myEntity = self.mySetupEntity.paytypeE;
    payVC.delegate = self;
    [self pushViewController:payVC];
    [payVC release];
}

-(void)selectDeliver:(UIButton *)button
{
    DeliverVC *deliverVC = [[DeliverVC alloc]init];
    deliverVC.myEntity = self.mySetupEntity.deliverE;
    deliverVC.delegate = self;
    [self pushViewController:deliverVC];
    [deliverVC release];
}

- (void)selectBill:(UIButton *)button
{
    BillVC *billVC = [[BillVC alloc]init];
    billVC.myEntity = self.mySetupEntity.billE;
    billVC.delegate = self;
    [self pushViewController:billVC];
    [billVC release];
}

-(void)selectXianJin:(UIButton *)button
{
    XianJinQuanVC *xianjinVC = [[XianJinQuanVC alloc]init];
    xianjinVC.orderType = self.orderType;//@property (nonatomic)int orderType; //1.购物车普通商品2.团购 3.秒杀
    xianjinVC.selectedArray = self.mySetupEntity.moneyTicketList;
    xianjinVC.delegate = self;
    [self pushViewController:xianjinVC];
    [xianjinVC release];
}

-(void)selectDiYong:(UIButton *)button
{
    DiYongQuanVC *diyongVC = [[DiYongQuanVC alloc]init];
    diyongVC.orderType = self.orderType;//@property (nonatomic)int orderType; //1.购物车普通商品2.团购 3.秒杀
    diyongVC.selectedArray = self.mySetupEntity.tradeTicketList;
    diyongVC.delegate = self;
    [self pushViewController:diyongVC];
    [diyongVC release];
}

-(void)selectBeizhu:(UIButton *)button
{
    BeizhuVC *beizhuVC = [[BeizhuVC alloc]init];
    beizhuVC.strNote = self.mySetupEntity.note;
    beizhuVC.delegate = self;
    [self pushViewController:beizhuVC];
    [beizhuVC release];
}

-(void)selectList:(UIButton *)button
{
    button.selected = !button.selected;
    self.showingList = button.selected;
    UIImageView *imageview = (UIImageView*)[button viewWithTag:1000];
    if (self.showingList) {
        [UIView animateWithDuration:0.35 animations:^(void){
            [imageview setTransform:CGAffineTransformMakeRotation(M_PI)];
        }];
        
    }else
    {
        [UIView animateWithDuration:0.35 animations:^(void){
            [imageview setTransform:CGAffineTransformMakeRotation(0)];
        }];
        

    }
    [UIView animateWithDuration:0.35 animations:^{
        [self.myTableView reloadData];
        [self.myTableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }];
    
}
#pragma mark ############ 视图回调 ############

-(void)sendFormMessage:(enum InfoType)type Object:(id)object
{
    switch (type) {
        case InfoTypeAddress:
        {
            AddressEntity* entity = object;
            UIView *aView = [self.headerTableView viewWithTag:ADDRESS_TAG];
            UILabel *aLabel = (UILabel *)[aView viewWithTag:(ADDRESS_TAG +1)];
            [aLabel setText:entity.name];
            UILabel *bLabel = (UILabel *)[aView viewWithTag:(ADDRESS_TAG +2)];
            [bLabel setText:entity.tel];
            UILabel *cLabel = (UILabel *)[aView viewWithTag:(ADDRESS_TAG +3)];
            
            [cLabel setText:[NSString stringWithFormat:@"%@ %@",entity.area,entity.address]];
            
            self.mySetupEntity.addressE = entity;
            
            [self getDeliverFee];   // 地址和支付方式决定运费，这里请求运费
        }
            break;
        case InfoTypeZhiFu:
        {
            PayTypeEntity* entity = object;
            UIView *aView = [self.headerTableView viewWithTag:ZHIFU_TAG];
            UILabel *aLabel = (UILabel *)[aView viewWithTag:(ZHIFU_TAG +1)];
            [aLabel setText:entity.name];
            
            self.mySetupEntity.paytypeE = entity;
            
            [self getDeliverFee];   // 地址和支付方式决定运费，这里请求运费
        }
            break;
        case InfoTypeDeliver:
        {
            DeliverEntity *entity = object;
            
            int i = entity.deliverTime;
            NSArray *myArray = [NSArray arrayWithObjects:@"工作日、双休日与假日均送", @"只工作日送货（双休日、假日不用送）",@"只双休日、假日送货（工作日不用送）",nil];
            UIView *aView = [self.headerTableView viewWithTag:DELIVER_TAG];
            UILabel *aLabel = (UILabel *)[aView viewWithTag:(DELIVER_TAG +1)];
            [aLabel setText:[myArray objectAtIndex:i]];
            entity.deliverTime = (i + 2)%3 + 1;     // 后台送货时间的顺序跟上面不统一  用这个方法进行转换
            self.mySetupEntity.deliverE = entity;
        }
            break;
        case InfoTypeFaPiao:
        {
            InvoceEntity *entity = object;
            
            UIView *aView = [self.headerTableView viewWithTag:FAPIAO_INFO_TAG];
//            UILabel *typeLabel = (UILabel *)[aView viewWithTag:(FAPIAO_INFO_TAG +1)];
            UILabel *taitouLabel = (UILabel *)[aView viewWithTag:(FAPIAO_INFO_TAG +2)];
            UILabel *infoLabel = (UILabel *)[aView viewWithTag:(FAPIAO_INFO_TAG +3)];
            if (entity.isNeed) {
                [taitouLabel setText:[NSString stringWithFormat:@"发票抬头：%@",entity.strContent]];
                [taitouLabel setFrame:CGRectMake(20,5+44, 270, 15)];
                [infoLabel setText:@"发票内容：服装"];
            }else{
                [taitouLabel setText:@"您没有索要发票"];
                [taitouLabel setFrame:CGRectMake(20,15+44, 270, 15)];
                [infoLabel setText:@""];
            }
        
            self.mySetupEntity.billE = entity;
        }
            break;
        case InfoTypeXianjin:
        {
            NSMutableArray *myArray = object;
            float money = 0.0;
            for (ShoppingTicketEntity *entity in myArray) {
                money +=[entity.amount floatValue];
            }
            UIView *aView = [self.headerTableView viewWithTag:XIANJIN_TAG];
            UILabel *infoLabel = (UILabel *)[aView viewWithTag:(XIANJIN_TAG +1)];
            [infoLabel setText:[NSString stringWithFormat:@"%.2f元",money]];
            
            self.mySetupEntity.moneyTicketList = myArray;
            self.mySetupEntity.xianJinFee = [NSString stringWithFormat:@"%.2f",money];
            
            [self setTotalCount];
        }
            break;
        case InfoTypeDiyong:
        {
            NSMutableArray *myArray = object;
            float money = 0.0;
            for (ShoppingTicketEntity *entity in myArray) {
                money +=[entity.amount floatValue];
            }
            UIView *aView = [self.headerTableView viewWithTag:DIYONG_TAG];
            UILabel *infoLabel = (UILabel *)[aView viewWithTag:(DIYONG_TAG +1)];
            [infoLabel setText:[NSString stringWithFormat:@"%.2f元",money]];
            
            self.mySetupEntity.tradeTicketList = myArray;
            self.mySetupEntity.diYongFee = [NSString stringWithFormat:@"%.2f",money];
            
            [self setTotalCount];
        }
            break;
        case InfoTypeBeizhu:
        {
            NSString *str = object;
            UIView *aView = [self.headerTableView viewWithTag:BEIZHU_TAG];
            //            UILabel *typeLabel = (UILabel *)[aView viewWithTag:(FAPIAO_INFO_TAG +1)];
            UILabel *infoLabel = (UILabel *)[aView viewWithTag:(BEIZHU_TAG +1)];
            [infoLabel setText:str];
            
            self.mySetupEntity.note = str;
            
        }
            break;
        default:
            break;
    }
}


#pragma mark ### 提交订单请求 ###
// 添加订单
- (void)myRightButtonAction:(UIButton *)button
{
    // 数值为空检测
    GoodsSettleUpEntity *entity = self.mySetupEntity;
    if (entity.paytypeE.typeId ==-1 || [entity.paytypeE.name isKindOfClass:[NSNull class]] || [entity.paytypeE.name isEqualToString:@""]) {
        [self addFadeLabel:@"请选择支付方式"];
        return;
    }
    
    if (entity.addressE.addressid == nil || [entity.addressE.addressid isKindOfClass:[NSNull class]] || [entity.addressE.addressid isEqualToString:@""]) {
        [self addFadeLabel:@"请添加收货地址"];
        return;
    }
    
    //提交订单先检测能否运送到相应地区 1表示成功，2表示失败
    if (self.deliverStates.response != 1) {
        //如果有错误，则提示用户错误信息
        if (!isStringEmputy(self.deliverStates.failmsg)) {
            [self.view addHUDLabelView:self.deliverStates.failmsg Image:nil afterDelay:2];
        }
        return;
    }

    if (_commitFormRequest) {
        _commitFormRequest.delegate = nil;
        [_commitFormRequest release];
        _commitFormRequest = nil;
    }
    
    
    
    _commitFormRequest = [[DSRequest alloc]init];
    _commitFormRequest.delegate = self;
    
    int isNeed = 0;
    if (entity.billE.isNeed) {
        isNeed = 1;
    }
   
    [_commitFormRequest requestDataWithInterface:CommitOrder param:
     [self CommitOrderParam:entity.addressE.addressid
                      payas:entity.paytypeE.typeId
                  deliverby:entity.deliverE.deliverby delivertime:entity.deliverE.deliverTime
                       note:entity.note
                 invoceisneed:isNeed invocetitle:entity.billE.strTitle invocecontent:entity.billE.strContent
                moneyticket:entity.moneyTicketList
                tradeticket:entity.tradeTicketList type:self.orderType] tag:2];
    //1.购物车普通商品2.团购 3.秒杀
    
    [self.view addHUDActivityView:Loading];  //提示 加载中
}


-(void)createFooterView
{
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainViewWidth, 140)];
    
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [myButton setTitle:@"提交订单" forState:UIControlStateNormal];
    [myButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [myButton setBackgroundImage:GETIMG(@"button3_press.png") forState:UIControlStateSelected];
    [myButton setBackgroundImage:GETIMG(@"button3.png") forState:UIControlStateNormal];
    [myButton setFrame:CGRectMake(10, 20, 300, 44)];
    [myButton addTarget:self action:@selector(myRightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:myButton];
    
    self.footerTableView = myView;
    [self.view addSubview:myView];
    [myView release];
}

- (void)addTableView
{
    UITableView  *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, TITLEHEIGHT, self.view.frame.size.width, MainViewHeight - [self getTitleBarHeight] - 20) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorColor = RGBACOLOR(199, 199, 199, 1);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = YES;
    tableView.backgroundView = [[[UIView alloc]initWithFrame:tableView.frame]autorelease];
    tableView.backgroundView.backgroundColor = [UIColor clearColor];
    tableView.hidden = NO;
    tableView.tableHeaderView = self.headerTableView;
    tableView.tableFooterView = self.footerTableView;
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.myTableView = tableView;
    [self.view addSubview:tableView];
    [tableView release];

}
#pragma mark - Table view
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (self.showingList) {
        return 1;
    }else{
        return 0;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.myOrderList count];
    //    return [self.historyArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    GoodsListCell *cell = (GoodsListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[[GoodsListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.clickedDelegate = self;
    }
    GoodEntity *entity = [self.myOrderList objectAtIndex:indexPath.row];
    [cell resetSubViewsByEntity:entity row:indexPath.row];
    
//    OrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (!cell) {
//        cell = [[[OrderDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
//        cell.clickedDelegate = self;
//    }
//    //    if (indexPath.row < self.entiOrderDetail.goodslist.count - 1) {
//    //        [cell setOtherRowBackGroundImageView];
//    //    }else [cell setlastRowBackGroundImageView];
//    cell.imgViewHead.tag = indexPath.row;
//    GoodEntity *one = [self.myOrderList objectAtIndex:indexPath.row];
//    [cell setImgViewHead:one.goodsimg labTitle:one.goodsname labMoney:one.price labSize:one.sizeandcolor goodsCount:one.count ispresentation:one.ispresentation];
    
    
    return cell;
}

#pragma mark - cell的图片点击响应
- (void)clickedImageViewAtIndexPath:(NSIndexPath*)indexPath
{
    NSLog(@"index = %i",indexPath.row);
    GoodEntity *entity = [self.myOrderList objectAtIndex:indexPath.row];
    ShangPingDetailVC *detailVC = [[ShangPingDetailVC alloc]init];
    detailVC.spId = entity.goodsid;
    [self pushViewController:detailVC];
    [detailVC release];
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    GoodEntity *entity = [self.myOrderList objectAtIndex:indexPath.row];
//    ShangPingDetailVC *detailVC = [[ShangPingDetailVC alloc]init];
//    detailVC.spId = entity.goodsid;
//    [self pushViewController:detailVC];
//    [detailVC release];
//    
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 发起请求和请求回调

-(void)requestToSerVer
{
    if (_addressRequest) {
        _addressRequest.delegate = nil;
        [_addressRequest release];
        _addressRequest = nil;
    }
    _addressRequest = [[DSRequest alloc]init];
    _addressRequest.delegate = self;
    [_addressRequest requestDataWithInterface:GetAddressList param:[self GetAddressListParam] tag:0];
    
    
    if (_payTypeRequest) {
        _payTypeRequest.delegate = nil;
        [_payTypeRequest release];
        _payTypeRequest = nil;
    }
    _payTypeRequest = [[DSRequest alloc]init];
    _payTypeRequest.delegate = self;
    [_payTypeRequest requestDataWithInterface:GetPayType param:[self GetPayTypeParam] tag:1];
    
}

- (void)getDeliverFee
{
    if (self.mySetupEntity.paytypeE.typeId ==-1 || isStringEmputy(self.mySetupEntity.addressE.addressid)) {
        return;
    }
    [self.view addHUDActivityView:Loading];  //提示 加载中
    
    if (_getDeliverFeeRequest) {
        _getDeliverFeeRequest.delegate = nil;
        [_getDeliverFeeRequest release];
        _getDeliverFeeRequest = nil;
    }
    _getDeliverFeeRequest = [[DSRequest alloc]init];
    _getDeliverFeeRequest.delegate = self;
    [_getDeliverFeeRequest requestDataWithInterface:GetDeliverFee param:[self GetDeliverFeeParam:self.mySetupEntity.addressE.addressid paytypeid:self.mySetupEntity.paytypeE.typeId type:self.orderType] tag:3];
}

-(void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError *)error
{
    [self.view removeHUDActivityView];        //加载失败  停止转圈
    NSLog(@"失败");
}

-(void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    [self.view removeHUDActivityView];        //加载成功  停止转圈
    
    if(tag == 0)
    {
        NSArray *myArray = dataObj;
        for (AddressEntity* entity in myArray) {
            if (entity.isdefault ==1) {
                
                UIView *aView = [self.headerTableView viewWithTag:ADDRESS_TAG];
                UILabel *aLabel = (UILabel *)[aView viewWithTag:(ADDRESS_TAG +1)];
                [aLabel setText:entity.name];
                UILabel *bLabel = (UILabel *)[aView viewWithTag:(ADDRESS_TAG +2)];
                [bLabel setText:entity.tel];
                UILabel *cLabel = (UILabel *)[aView viewWithTag:(ADDRESS_TAG +3)];
                [cLabel setText:[NSString stringWithFormat:@"%@ %@",entity.area,entity.address]];
                self.mySetupEntity.addressE = entity;
                
                [self getDeliverFee];   // 地址和支付方式决定运费，这里请求运费
            }
        }
        

        
    }
    if(tag == 1)
    {
        self.payMentArray = dataObj;
        if ([self.payMentArray count]>0) {
            PayTypeEntity* entity=[self.payMentArray objectAtIndex:0];
            if (![entity.name isKindOfClass:[NSNull class]]) {
                UIView *aView = [self.headerTableView viewWithTag:ZHIFU_TAG];
                UILabel *aLabel = (UILabel *)[aView viewWithTag:(ZHIFU_TAG +1)];
                [aLabel setText:entity.name];
                self.mySetupEntity.paytypeE = entity;
                
                [self getDeliverFee];   // 地址和支付方式决定运费，这里请求运费
            }
        }
        
    }
    if(tag == 2)
    {
        StatusEntity* entity = dataObj;
        if (entity.response ==1) {
            //提交订单成功，发送订单提示通知
            [[NSNotificationCenter defaultCenter]postNotificationName:@"OrderRedRemind" object:nil];
            
            OrderSuccessVC *orderSuccessVC = [[OrderSuccessVC alloc]init];
            orderSuccessVC.statusEntity = entity;
            orderSuccessVC.specialBuyEntity = self.specialBuyEntity;
            orderSuccessVC.orderType = self.orderType; //1.购物车普通商品2.团购 3.秒杀
            orderSuccessVC.payTypeEntity = self.mySetupEntity.paytypeE;//支付方式
            [self pushViewController:orderSuccessVC];
            [orderSuccessVC release];
        }
        else if (entity.response ==2)
        {
            // 失败添加提示
            NSLog(@"%@",entity.failreason);
            [self.view addHUDLabelView:entity.failreason Image:nil afterDelay:2];
        }
        
        
    }
    
    //运费信息
    if (tag ==3) {
        StatusEntity* entity = dataObj;
        self.deliverStates = entity;
        
        //1表示成功，2表示失败
        if (entity.response == 2) {
            //如果有错误，则提示用户错误信息
            if (!isStringEmputy(entity.failmsg)) {
                [self.view addHUDLabelView:entity.failmsg Image:nil afterDelay:2];
            }
            
        }else if (entity.response == 1){
            NSString *deliverFee = [NSString stringWithFormat:@"%d",[entity.deliverfee intValue]];
            if (!isStringEmputy(deliverFee)) {
                self.mySetupEntity.deliverfee = deliverFee;
                //刷新付款,下面统一刷新[self setTotalCount]
            }
        }
        
    }
    
    [self setTotalCount];
}


@end
