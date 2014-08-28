//
//  GouWuCheVC.m
//  HaiLanZhiJia
//
//  Created by 蒋遂明 on 13-11-20.
//  Copyright (c) 2013年 donson. All rights reserved.
//
#define SHOP_INFO_TAG  0x500
#define YOUHUI_INFO_TAG 0x600
#define ZENGPIN_TAG    0x700

#import "GouWuCheVC.h"
#import "ShoppingCarEntity.h"
#import "GoodEntity.h"
#import "PXAlertView.h"

@interface GouWuCheVC (){
    int showingNumberIndex;
}

@property (nonatomic,retain)UIView *tableHeaderView;
@property (nonatomic,retain)UITableView *myTableView;
@property (nonatomic,retain)NSArray *youHuiArray;
@property (nonatomic)BOOL               isEditing;
@property (nonatomic,retain)ShoppingCarEntity *shopEntity;
@property (nonatomic,retain)UIView *myEmputyView;
@property (nonatomic,retain)UIView *myLoginView;
@property (nonatomic,retain)UIView *failView;

@end

@implementation GouWuCheVC

@synthesize tableHeaderView;
@synthesize myTableView;
@synthesize youHuiArray;

@synthesize isEditing;
@synthesize shopEntity;
@synthesize myEmputyView;
@synthesize aRequest;
@synthesize failView = _failView;

-(void)dealloc
{
    self.tableHeaderView = nil;
    self.myTableView = nil;
    self.youHuiArray = nil;
    self.shopEntity = nil;
    self.myEmputyView = nil;
    
    self.aRequest.delegate = nil;
    self.aRequest = nil;
    
    self.failView = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ReloadGouwuche object:nil];
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

#pragma mark —— 更改cell的代理 —— 
-(void)changeSelected:(BOOL)select ofIndex:(int)index
{
    [self.view addClickableActivityView:Loading];  //提示 加载中
    
    NSArray *goodsArray = [self.shopEntity.goodslist objectAtIndex:index];
    for (GoodEntity *entity in goodsArray) {
        entity.isselect = select;
    }
    // 发送更改是否选择
    self.aRequest.delegate = nil;
    self.aRequest = nil;
    DSRequest *requestObj = [[DSRequest alloc]init];
    self.aRequest = requestObj;
    [requestObj release];
    requestObj.delegate = self;
    
    [requestObj requestDataWithInterface:ShoppingCarGoodsSelection param:[self ShoppingCarGoodsSelectionParam:self.shopEntity.goodslist ofIndex:index] tag:1];
    // 返回数据后刷新
}
-(void)changeNumber:(NSString *)number ofIndex:(int)index
{
    [self.view addClickableActivityView:Loading];  //提示 加载中
    
    NSArray *goodsArray = [self.shopEntity.goodslist objectAtIndex:index];
    for (GoodEntity *entity in goodsArray) {
        entity.count = [number intValue];
    }
    
    // 发送更改数目
    self.aRequest.delegate = nil;
    self.aRequest = nil;
    DSRequest *requestObj = [[DSRequest alloc]init];
    self.aRequest = requestObj;
    [requestObj release];
    requestObj.delegate = self;
    
    [requestObj requestDataWithInterface:ShoppingCarModify param:[self ShoppingCarModifyParam:self.shopEntity.goodslist ofIndex:index] tag:2];
    // 返回数据后刷新
}

-(void)showNumberSelectorOfIndex:(int)index
{
    showingNumberIndex = index;
    if (isBigeriOS7version)
    {
        [PXAlertView showAlertWithTitle:@"请选择数量" message:nil cancelTitle:@"取消" otherTitle:@"确定" contentView:[self alertSubView:CGPointMake(0,0)] completion:^(BOOL cancelled)
         {
             if (cancelled==NO)
             {
                // 发送修改数量的请求
//                 int count = [self.countLabel.text intValue];
                 [self changeNumber:self.countLabel.text ofIndex:showingNumberIndex];
                 
             }
         }];
        
    }else
    {
        [WCAlertView showAlertWithTitle:@"请选择数量" message:@"\n\n" customizationBlock:^(WCAlertView *alertView)
         {
             alertView.style = WCAlertViewStyleDefault;
             alertView.labelTextColor=[UIColor blackColor];
             alertView.buttonTextColor=[UIColor blueColor];
             [alertView addSubview:[self alertSubView:CGPointMake(0, 50)]];
             
         } completionBlock:^(NSUInteger index,WCAlertView *alertview)
         {
             if (index==1)
             {
                 // 发送修改数量的请求
//                 int count = [self.countLabel.text intValue];
                 [self changeNumber:self.countLabel.text ofIndex:showingNumberIndex];
             }
         } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
    }
}

-(UIView*)alertSubView:(CGPoint)point
{
    
    UIImage *minusI = GETIMG(@"car_button_reduce_press@2x.png");
    
    UIView *contentV = [[[UIView alloc]initWithFrame:CGRectMake(point.x,point.y, 280, minusI.size.height/2)]autorelease];
    contentV.backgroundColor = [UIColor clearColor];
    
    CGFloat x=(280-(minusI.size.width/2)*3-4*2)/2;
    CGFloat y=0;
    CGFloat w=minusI.size.width/2;
    CGFloat h=minusI.size.height/2;
    UIButton *minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [minusButton setBackgroundImage:GETIMG(@"car_button_reduce_press@2x.png") forState:UIControlStateSelected];
    [minusButton setBackgroundImage:GETIMG(@"car_button_reduce@2x.png") forState:UIControlStateNormal];
    [minusButton addTarget:self action:@selector(alertBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    minusButton.frame = CGRectMake(x,y,w,h);
    minusButton.tag = 0x1111;
    [contentV addSubview:minusButton];
    
    x=minusButton.frame.origin.x+minusButton.frame.size.width+4;
    UILabel *countL = [[UILabel alloc]init];
    countL.backgroundColor = RGBCOLOR(235, 235, 235);//[UIColor clearColor];
    countL.textAlignment = NSTextAlignmentCenter;
    countL.textColor = TEXT_GRAY_COLOR;
    countL.font = SYSTEMFONT(15);
    countL.frame = CGRectMake(x, y,minusI.size.width/2,minusI.size.height/2);
    
    if ([self.shopEntity.goodslist count]>showingNumberIndex) {
        NSArray *goodsArray = [self.shopEntity.goodslist objectAtIndex:showingNumberIndex];
        if ([goodsArray count]>0) {
            GoodEntity *entity = [goodsArray objectAtIndex:0];
            [countL setText:[NSString stringWithFormat:@"%d",entity.count]];
        }
    }
    
    countL.layer.cornerRadius = 2;
    [contentV addSubview:countL];
    self.countLabel=countL;
    [countL release];
    
    x=countL.frame.origin.x+countL.frame.size.width+4;
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setBackgroundImage:GETIMG(@"car_button_add_press@2x.png") forState:UIControlStateSelected];
    [addButton setBackgroundImage:GETIMG(@"car_button_add@2x.png") forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(alertBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    addButton.frame = CGRectMake(x,y,minusI.size.width/2,minusI.size.height/2);
    addButton.tag = 0x2222;
    [contentV addSubview:addButton];
    
    return contentV;
}

-(void)alertBtnClicked:(UIButton*)btn
{
    switch (btn.tag)
    {
        case 0x1111://-
        {
            int count = [self.countLabel.text intValue];
            count--;
            if (count<1)
            {
                count=1;
            }
            self.countLabel.text = [NSString stringWithFormat:@"%d",count];
        }
            break;
        case 0x2222://+
        {
            int count = [self.countLabel.text intValue];
            count++;
            self.countLabel.text = [NSString stringWithFormat:@"%d",count];
        }
            break;
//        case 0x3333://cancel
//        {
//            [self alertHide];
//        }
//            break;
//        case 0x4444://jieSuan
//        {
//            [self alertHide];
//            
//            _requestType = qingQiuGouMai;
//            [self requestDatasource:jianJie];
//        }
//            break;
        default:
            break;
    }
}


-(void)deleteSelectedOfIndex:(int)index //改好了
{
    [self.view addClickableActivityView:Loading];  //提示 加载中
    
//    NSArray *goodsArray = [self.shopEntity.goodslist objectAtIndex:index];
//    for (GoodEntity *entity in goodsArray) {
//        entity.count = [number intValue];
//    }
    
    self.aRequest.delegate = nil;
    DSRequest *requestObj = [[DSRequest alloc]init];
    self.aRequest = requestObj;
    [requestObj release];
    requestObj.delegate = self;
    
    [requestObj requestDataWithInterface:ShoppingCarDel param:[self ShoppingCarDelParam:self.shopEntity.goodslist ofIndex:index] tag:3];
    
    // 返回数据后刷新
}

-(void)selectGood:(GoodEntity *)aGoodEntity
{
    // 点击事件，进入到商品的详情页面
    ShangPingDetailVC *detail = [[ShangPingDetailVC alloc]init];
    detail.spId = aGoodEntity.goodsid;  //商品信息
    detail.shopCarGoodEntity = aGoodEntity; //已购商品的信息
    [self pushViewController:detail];
    [detail release];
}

-(void)selectGoodId:(NSString *)goodID
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleString:@"购物车"];
    
    [self.view setFrame:CONTENTFRAME];
    if (self.isSubview)
    {
        [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, MainViewHeight)];
        
        
    }else{
        [self.leftButton setHidden:YES];
    }
    
    
    [self createDatas];
    
    
    [self createShopingInfo];
    [self createYouHuiInfo];
    [self createGiftInfo];
    [self createGoodsInCart];
    
    [self emputyShopingInfo];
    
    [self createMyButtonWithTitleAndImage];
    [self setMyRightButtonTitle:@"编辑"];
    [self setMyRightButtonBackGroundImageView:@"button1.png" hightImage:@"button1_press.png"];
    self.isEditing = NO;
	// Do any additional setup after loading the view.
    
    [self showAllYouHui:NO];
    
    [self requestToServer];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showVC) name:LoginSuccess object:nil];
    // 从下单成功界面返回发送通知  刷新购物车
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestToServer) name:ReloadGouwuche object:nil];
    [self autoFitTableViewHeight];
}

-(void)autoFitTableViewHeight
{
    int bottomHeight = 0;
    int loginViewHeight = 0;
    if (self.isSubview) {
        bottomHeight = 0;
    }else{
        bottomHeight = BOTTOMHEIGHT;
    }
    if (isNotLogin) {
        loginViewHeight = 50;
    }else{
        loginViewHeight = 0;
    }
    [self.myTableView setFrame:CGRectMake(0, loginViewHeight+TITLEHEIGHT, self.view.frame.size.width, MainViewHeight - [self getTitleBarHeight] - 20 - bottomHeight)];
    self.myLoginView.hidden = !isNotLogin;
    if (![[WatchDog luckDog]haveNetWork]) {
        self.myLoginView.hidden = YES;
        self.myRightButton.hidden = YES;
    }
}

-(void)showVC
{
    UIImageView *imageV = (UIImageView *)[self.view viewWithTag:0x800];
    if (isNotLogin) {
        imageV.hidden = NO;
    }else{
        imageV.hidden = YES;
    }
//    [self setMyRightButtonTitle:@"编辑"];
    [self requestToServer];
    [self autoFitTableViewHeight];
}

- (void)myRightButtonAction:(UIButton *)button
{
    self.isEditing = !self.isEditing;
    if (self.isEditing) {
        [self setMyRightButtonTitle:@"完成"];
        
    }else{
         [self setMyRightButtonTitle:@"编辑"];
    }
    [self.myTableView reloadData];
}

-(void)requestToServer
{
    [self.view addClickableActivityView:Loading];  //提示 加载中
//    if (!self.aRequest) {//
        DSRequest *requestObj = [[DSRequest alloc]init];
        requestObj.delegate = self;
        self.aRequest = requestObj;
        [requestObj release];
//    }

    [self.aRequest requestDataWithInterface:GetShoppingCarInfo param:[self GetShoppingCarInfoParam] tag:0];
}

-(void)createDatas
{
    ShoppingCarEntity *entity = [[ShoppingCarEntity alloc]init];
    entity.selectcount = 0;
    entity.goodsfee = @"0.00";
    entity.discount = @"0.00";
    entity.total = @"0.00";
    entity.discountinfo = [NSArray array];
    
    entity.goodslist = [NSMutableArray array];
    self.shopEntity = entity;
    [entity release];

}


#pragma mark ---空购物车---
- (void)emputyShopingInfo
{
//    UIView *bView = [[UIView alloc]initWithFrame:CONTENTFRAME];
//    bView.backgroundColor = [UIColor clearColor];
//    bView.hidden = YES;
//    self.myLoginView = bView;
//    [self.view addSubview:bView];
//    [self.view sendSubviewToBack:bView];
//    [bView release];
//    self.myLoginView.hidden = !isNotLogin;
    
    
    
    UIView *aView = [[UIView alloc]initWithFrame:CONTENTFRAME];
    aView.backgroundColor = [UIColor clearColor];
    aView.hidden = YES;
    self.myEmputyView = aView;
    [self.view addSubview:aView];
    [self.view sendSubviewToBack:aView];
    [aView release];
    
    // 登录
    do {
        UIImage *bImg = GetImage(@"car_bg_log in.png");
        UIImageView *bImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,TITLEHEIGHT, bImg.size.width, bImg.size.height)];
        bImageView.userInteractionEnabled = YES;
        bImageView.image = bImg;
        bImageView.tag = 0x800;
        self.myLoginView = bImageView;
        bImageView.hidden = YES;
        //
        UILabel *aLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.0, 0, 210, 50)];
        aLabel.backgroundColor = [UIColor clearColor];
        aLabel.numberOfLines = 2;
        aLabel.textColor = TEXT_GRAY_COLOR;
        aLabel.font = SYSTEMFONT(14);
        [aLabel setText:@"温馨提示：登录后，你可以同步\n电脑和手机购物车中的商品"];
        [bImageView addSubview:aLabel];
        [aLabel release];
        
        UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *myIMG = GETIMG(@"car_button_log in.png");
        [myButton setBackgroundImage:myIMG forState:UIControlStateNormal];
        [myButton setBackgroundImage:GETIMG(@"car_button_log in_press.png") forState:UIControlStateHighlighted];
        myButton.frame = CGRectMake(250,10,myIMG.size.width,myIMG.size.height);
        [myButton addTarget:self action:@selector(Login:) forControlEvents:UIControlEventTouchUpInside];
        [bImageView addSubview:myButton];
        
        [self.view addSubview:bImageView];
        [bImageView release];
        
    } while (0);
    
    
    // 图标、描述、按钮
    UIImage *aImg = GetImage(@"car_icon_car.png");
    UIImageView *aImageView = [[UIImageView alloc] initWithFrame:CGRectMake(130,200, aImg.size.width, aImg.size.height)];
    aImageView.image = aImg;
    [self.myEmputyView addSubview:aImageView];
    [aImageView release];
    
    UILabel *aLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 256, MainViewWidth, 15)];
    aLabel.backgroundColor = [UIColor clearColor];
    aLabel.textColor = TEXT_GRAY_COLOR;
    aLabel.font = SYSTEMFONT(12);
    aLabel.textAlignment = NSTextAlignmentCenter;
    [aLabel setText:@"购物车还是空的，快去逛逛吧！"];
    [self.myEmputyView addSubview:aLabel];
    [aLabel release];
    
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *myIMG = GETIMG(@"car_button_go.png");
    [myButton setBackgroundImage:myIMG forState:UIControlStateNormal];
    [myButton setBackgroundImage:GETIMG(@"car_button_go_press.png") forState:UIControlStateHighlighted];
    myButton.frame = CGRectMake(105,280,myIMG.size.width,myIMG.size.height);
    [myButton addTarget:self action:@selector(goShoping:) forControlEvents:UIControlEventTouchUpInside];
    [self.myEmputyView addSubview:myButton];
}

-(void)goShoping:(UIButton *)button
{
//    [self popToRoot];
    if (self.isSubview) {
        [self popToRoot];
    }
    [[RootVC shareInstance] showTableIndex:0];
}

-(void)Login:(UIButton *)button
{
    LoginViewCtrol *loginView = [[LoginViewCtrol alloc]init];
    [self pushViewController:loginView];
    [loginView release];

}

#pragma mark LoginViewCtrolDisMissDelegate
- (void)loginViewCtrolDisMissed
{
    UIImageView *imageV = (UIImageView *)[self.myEmputyView viewWithTag:0x800];
    if (isNotLogin) {
        imageV.hidden = NO;
    }else{
        imageV.hidden = YES;
    }
    
    [self requestToServer];              // 登录成功后刷新界面
    [self autoFitTableViewHeight];
}

#pragma mark ---购物车信息---
-(void)createShopingInfo
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, TITLEHEIGHT, MainViewWidth, 185)];
    self.tableHeaderView = headView;
//    [self.view addSubview:headView];
    [headView release];
    
    UIView *shopingInfo = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainViewWidth, 90)];
    shopingInfo.backgroundColor = [UIColor clearColor];
    shopingInfo.tag = SHOP_INFO_TAG;
    
    for (int i =0; i<4; i++) {
        UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(7.0, 10.0+19*i, 80, 19)];
        myLabel.backgroundColor = [UIColor clearColor];
        myLabel.textColor = RGBCOLOR(46, 46, 46);
        myLabel.font = SYSTEMFONT(14);
        switch (i) {
            case 0:
                [myLabel setText:@"商品总数："];
                break;
            case 1:
                [myLabel setText:@"商品总额："];
                break;
            case 2:
                [myLabel setText:@"优惠金额："];
                break;
            case 3:
                [myLabel setText:@"应付总额："];
                break;
            default:
                break;
        }
        [shopingInfo addSubview:myLabel];
        [myLabel release];
        
        
        UILabel *aLabel = [[UILabel alloc]initWithFrame:CGRectMake(82.0, 10.0+19*i, 100, 19)];
        aLabel.tag = SHOP_INFO_TAG +i+10;
        aLabel.backgroundColor = [UIColor clearColor];
        aLabel.textColor = ColorFontBlack;
        if (i ==3) {
            [aLabel setTextColor:TEXT_RED_COLOR];
        }
        aLabel.font = SYSTEMFONT(14);
        [shopingInfo addSubview:aLabel];
        [aLabel release];
        
    }
    
    
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *myIMG = GETIMG(@"car_button_finish.png");
    [myButton setBackgroundImage:myIMG forState:UIControlStateNormal];
    [myButton setBackgroundImage:GETIMG(@"car_button_finish_press@2x.png") forState:UIControlStateHighlighted];
    myButton.frame = CGRectMake(229,25,myIMG.size.width,myIMG.size.height);
    [myButton addTarget:self action:@selector(jieShuan) forControlEvents:UIControlEventTouchUpInside];
    [shopingInfo addSubview:myButton];
    
    
    [self.tableHeaderView addSubview:shopingInfo];
    [shopingInfo release];
    
    [self shopingInfoRefresh];
}

#pragma mark ### 去结算 ###
-(void)jieShuan
{
    if (isNotLogin)
    {
        //[self addFadeLabel:@"您还没有登陆，请先登陆"];
        LoginViewCtrol *vc = [[LoginViewCtrol alloc]init];
        [self pushViewController:vc];
        [vc release];
    }else{
        if (self.shopEntity.goodslist.count == 0) {
            [self.view addClickableActivityView:@"请选中商品"];  //提示
            return;
        }
        DSRequest *requestObj = [[DSRequest alloc]init];
        self.aRequest = requestObj;
        [requestObj release];
        requestObj.delegate = self;
        [requestObj requestDataWithInterface:GoodsSettleUp param:[self GoodsSettleUpParam] tag:4];
        
        [self.view addClickableActivityView:Loading];  //提示 加载中
    }
    
}

-(void)shopingInfoRefresh
{
    UIView *aView = [self.tableHeaderView viewWithTag:SHOP_INFO_TAG];
    for (int i =0; i<4; i++) {
        UILabel *aLabel = (UILabel *)[aView viewWithTag:(SHOP_INFO_TAG+10+i)];
        switch (i) {
            case 0:
            {
                [aLabel setText:[NSString stringWithFormat:@"%d件",self.shopEntity.selectcount]];
                break; 
            }
            case 1:
            {
                [aLabel setText:[NSString stringWithFormat:@"¥%@",self.shopEntity.goodsfee]];
                break;
            }
            case 2:
            {
                [aLabel setText:[NSString stringWithFormat:@"¥%@",self.shopEntity.discount]];
                break;
            }
            case 3:
            {
                [aLabel setText:[NSString stringWithFormat:@"¥%@",self.shopEntity.total]];
                break;
            }
                
            default:
                break;
        }
        
    }
}


#pragma mark ---优惠信息---
-(void)createYouHuiInfo
{
    UIView *youHuiInfo = [[UIView alloc]initWithFrame:CGRectMake(0, 90, MainViewWidth, 60)];
    youHuiInfo.clipsToBounds = YES;
    youHuiInfo.backgroundColor = RGBCOLOR(239, 239, 198);
    youHuiInfo.tag = YOUHUI_INFO_TAG;

    int currentY = 10.0;
    for (int i =0; i<[self.youHuiArray count]; i++)
    {
        currentY += 15;
        if (i==1) {
            currentY += 15;
            break;
        }
    }
    currentY +=10;
    if ([self.youHuiArray count]==0) {
        currentY =0;
    }
    
    // 添加按钮
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *myIMG = GETIMG(@"car_icon_more.png");
    myButton.tag = YOUHUI_INFO_TAG +1;
    [myButton setBackgroundImage:myIMG forState:UIControlStateNormal];
    [myButton setBackgroundImage:GetImage(@"car_button_reduce.png") forState:UIControlStateSelected];
    
    myButton.frame = CGRectMake(295,currentY/2-myIMG.size.height/2,myIMG.size.width,myIMG.size.height);
    [myButton addTarget:self action:@selector(expendYouhui:) forControlEvents:UIControlEventTouchUpInside];
    [youHuiInfo addSubview:myButton];
    
    CGRect youhuiRect = youHuiInfo.frame;
    [youHuiInfo setFrame:CGRectMake(youhuiRect.origin.x, youhuiRect.origin.y, youhuiRect.size.width, currentY)];
    [self.tableHeaderView addSubview:youHuiInfo];
    [youHuiInfo release];
    
}



- (void)expendYouhui:(UIButton *)button
{
    if (!button.selected) {
        if ([self.youHuiArray count]>2) {
            button.selected = YES;
        }
    }else{
        button.selected = NO;
    }
    [self showAllYouHui:button.selected];
}

-(void)showAllYouHui:(BOOL )showAll
{
    self.youHuiArray = self.shopEntity.discountinfo;
    
    UIView *youHuiInfo = [self.tableHeaderView viewWithTag:YOUHUI_INFO_TAG];
    if (youHuiInfo) {
        for (UIView *view in [youHuiInfo subviews]) {
            if (![view isKindOfClass:[UIButton class]]) {
                [view removeFromSuperview];
            }
            
        }
    }
    
    // 取前两条数据
    int currentY = 10.0;
    int number = [self.youHuiArray count];
    
    for (int i =0; i<[self.youHuiArray count]; i++)
    {
        
        UILabel *aLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.0, currentY, 240, 15)];
        aLabel.tag = YOUHUI_INFO_TAG +i+10;
        aLabel.backgroundColor = [UIColor clearColor];
        aLabel.textColor = RGBCOLOR(46, 46, 46);
        aLabel.font = SYSTEMFONT(14);
        [aLabel setText:[self.youHuiArray objectAtIndex:i]];
        [youHuiInfo addSubview:aLabel];
        [aLabel release];
        
        currentY += 15;
        if (!showAll) {
            if (i==1 && number>2) {
                UILabel *aLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.0, currentY, 240, 15)];
                aLabel.backgroundColor = [UIColor clearColor];
                aLabel.textColor = RGBCOLOR(46, 46, 46);
                aLabel.font = SYSTEMFONT(14);
                [aLabel setText:@"..."];
                [youHuiInfo addSubview:aLabel];
                [aLabel release];
                currentY += 15;
                
                break;
            }
        }
    }

    currentY+=10;
    if (number ==0) {
        currentY = 0;
    }
    
    
    [UIView animateWithDuration:0.35 animations:^{
        CGRect youhuiRect = youHuiInfo.frame;
        [youHuiInfo setFrame:CGRectMake(youhuiRect.origin.x, youhuiRect.origin.y, youhuiRect.size.width, currentY)];
        UIButton *view = (UIButton *)[youHuiInfo viewWithTag:(YOUHUI_INFO_TAG+1)];
        view.center = CGPointMake(view.center.x, currentY/2);
        if (number<3) {
            view.hidden = YES;
        }else{
            view.hidden = NO;
        }
        if (showAll) {
            view.selected = YES;
        }else{
            view.selected = NO;
        }
        
        UIView *zengpinView = [self.tableHeaderView viewWithTag:ZENGPIN_TAG];
        CGRect zengpinRect = zengpinView.frame;
        
        CGRect rect = self.tableHeaderView.frame;
        if (self.shopEntity.presentationcount >0){
            zengpinView.frame = CGRectMake(zengpinRect.origin.x, youhuiRect.origin.y+currentY, zengpinRect.size.width, 35);
            self.tableHeaderView.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, youhuiRect.origin.y+currentY+35);
        }else{
            zengpinView.frame = CGRectMake(zengpinRect.origin.x, youhuiRect.origin.y+currentY, zengpinRect.size.width, 0);
            self.tableHeaderView.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, youhuiRect.origin.y+currentY);
        }
        
        self.myTableView.tableHeaderView = self.tableHeaderView;
    }];
}

#pragma mark ---选择赠品---
-(void)createGiftInfo
{
    UIView *youHuiInfo = [self.tableHeaderView viewWithTag:YOUHUI_INFO_TAG];
    //    car_bg_gift@2x.png
    UIImage *myImg = GetImage(@"car_bg_gift.png");
    UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,youHuiInfo.frame.origin.y+youHuiInfo.frame.size.height, myImg.size.width, myImg.size.height)];
//    UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,youHuiInfo.frame.origin.y+youHuiInfo.frame.size.height, myImg.size.width, 0)];
    myImageView.tag = ZENGPIN_TAG;
    myImageView.clipsToBounds = YES;
    myImageView.image = myImg;
    myImageView.userInteractionEnabled = YES;
    [self.tableHeaderView addSubview:myImageView];
    [myImageView release];
    
    do {
        UILabel *bLable = [[UILabel alloc]initWithFrame:CGRectMake(10,0, 25, myImg.size.height)];
        bLable.tag = ZENGPIN_TAG +2;
        [bLable setTextColor:TEXT_RED_COLOR];
        [bLable setFont:SYSTEMFONT(12)];
        bLable.backgroundColor = [UIColor clearColor];
        [bLable setText:[NSString stringWithFormat:@"%d个",self.shopEntity.presentationcount]];
        [myImageView addSubview:bLable];
        [bLable release];
        
        UILabel *aLable = [[UILabel alloc]initWithFrame:CGRectMake(35,0, 200, myImg.size.height)];
        aLable.tag = ZENGPIN_TAG +3;
        aLable.backgroundColor = [UIColor clearColor];
        [aLable setFont:SYSTEMFONT(12)];
        [aLable setText:@"赠品可选择"];
        [myImageView addSubview:aLable];
        [aLable release];
    } while (0);
    
//    UILabel *numberLabel =(UILabel *)[myImageView viewWithTag:ZENGPIN_TAG +2];
//    UILabel *numberInfoLabel =(UILabel *)[myImageView viewWithTag:ZENGPIN_TAG +3];
//    if (self.shopEntity.presentationinfo && ![self.shopEntity.presentationinfo isKindOfClass:[NSNull class]]) {
//        numberLabel.hidden = NO;
//        numberInfoLabel.hidden = NO;
//    }else{
//        numberLabel.hidden = YES;
//        numberInfoLabel.hidden = YES;
//    }
    
    UIImage *aImg = GetImage(@"icon_next.png");
    UIImageView *aImageView = [[UIImageView alloc] initWithFrame:CGRectMake(300,8, aImg.size.width, aImg.size.height)];
    aImageView.image = aImg;
    [myImageView addSubview:aImageView];
    [aImageView release];
    
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    myButton.backgroundColor = [UIColor clearColor];
    myButton.frame = CGRectMake(0,0,myImg.size.width,myImg.size.height);
    [myButton addTarget:self action:@selector(zengPing) forControlEvents:UIControlEventTouchUpInside];
    [myImageView addSubview:myButton];
    
    
    
}
-(void)refreshZengPinInfo
{
    UIView *aView = [self.tableHeaderView viewWithTag:ZENGPIN_TAG];
    if (self.shopEntity.presentationcount >0) {
        [aView setFrame:CGRectMake(0,aView.frame.origin.y, aView.frame.size.width, 35)];
    }else{
        [aView setFrame:CGRectMake(0,aView.frame.origin.y, aView.frame.size.width, 0)];
    }
    
    UILabel *numberLabel =(UILabel *)[aView viewWithTag:ZENGPIN_TAG +2];
    UILabel *numberInfoLabel =(UILabel *)[aView viewWithTag:ZENGPIN_TAG +3];
    NSString *showInfo = nil;
    
    NSString *myStr = [NSString stringWithFormat:@"%d个",self.shopEntity.presentationcount];
    CGSize mySize = [myStr sizeWithFont:numberInfoLabel.font forWidth:CGFLOAT_MAX lineBreakMode:NSLineBreakByCharWrapping];
    [numberLabel setText:myStr];
    [numberLabel setFrame:CGRectMake(numberLabel.frame.origin.x, numberLabel.frame.origin.y, mySize.width, numberLabel.frame.size.height)];
    
    if (isStringEmputy(self.shopEntity.presentationinfo)) {
        showInfo = @"赠品可选择（任选一个）";
    }else{
        showInfo = [NSString stringWithFormat:@"赠品可选择(%@)",self.shopEntity.presentationinfo];
    }
    
    [numberInfoLabel setText:showInfo];
    [numberInfoLabel setFrame:CGRectMake(numberLabel.frame.origin.x + mySize.width, numberLabel.frame.origin.y, numberInfoLabel.frame.size.width, numberInfoLabel.frame.size.height)];

}

-(void)zengPing
{
    SelectGiftVC *gift = [[SelectGiftVC alloc]init];
    gift.delegate = self;
    [self pushViewController:gift];
    [gift release];
}

#pragma mark ### 赠品返回数据回调 ###
-(void)PresentCommittedReturnInfo:(CommitPresentationEntity *)aEntity
{
    self.shopEntity.selectcount = aEntity.selectcount;
    self.shopEntity.goodsfee = aEntity.goodsfee;
    self.shopEntity.discount = aEntity.discount;
    self.shopEntity.total = aEntity.total;
    self.shopEntity.discountinfo = aEntity.discountinfo;
    self.shopEntity.presentationinfo = aEntity.presentationinfo;
    
    // 列表信息
    [self.myTableView reloadData];
    // 概况
    [self shopingInfoRefresh];
    // 赠品信息
    [self refreshZengPinInfo];
    // 优惠信息
    [self showAllYouHui:NO];
}

#pragma mark ---购物车商品信息---
-(void)createGoodsInCart
{
    int bottomHeight = BOTTOMHEIGHT;
    if (self.isSubview) {
        bottomHeight = 0;
    }
    UITableView  *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, TITLEHEIGHT, self.view.frame.size.width, MainViewHeight - [self getTitleBarHeight] - 20 - bottomHeight) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorColor = RGBACOLOR(199, 199, 199, 1);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = YES;
    tableView.backgroundView = [[[UIView alloc]initWithFrame:tableView.frame]autorelease];
    tableView.backgroundView.backgroundColor = [UIColor clearColor];
    tableView.hidden = NO;
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    self.myTableView = tableView;
    [self.view addSubview:tableView];
    [tableView release];
    
    // 添加 tableview footer
    self.myTableView.tableHeaderView = self.tableHeaderView;
    self.myTableView.tableFooterView = [[[UIView alloc]initWithFrame:CGRectZero]autorelease];
}


#pragma mark - Table view
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *entityArr = [self.shopEntity.goodslist objectAtIndex:indexPath.row];
    int numberInIndex = [entityArr count];
    if (numberInIndex==1) {
        return 110;
    }else{
        return 110*numberInIndex+40;
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.shopEntity.goodslist count];
    //    return [self.historyArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    GouWucheCell *cell = (GouWucheCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[GouWucheCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.cellIndex = indexPath.row;
    cell.isEditing = self.isEditing;
    [cell createCellByEntityArray:[self.shopEntity.goodslist objectAtIndex:indexPath.row]];
    cell.delegate = self;
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initFailView
{
    if (_failView==nil)
    {
        CGRect myRect  = self.view.bounds;
        _failView = [[UIView alloc]initWithFrame:CGRectMake(myRect.origin.x, myRect.origin.y+TITLEHEIGHT, myRect.size.width, myRect.size.height-TITLEHEIGHT)];
        [self.view addSubview:_failView];

        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0,140,MainViewWidth, 20)];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.textColor = ColorFontBlack;
        lbl.font = [UIFont systemFontOfSize:15.0f];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.text = @"咦，数据加载失败了";
        [_failView addSubview:lbl];
        [lbl release];////////////
        
        UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(0,170,MainViewWidth, 20)];
        lbl2.textAlignment = NSTextAlignmentCenter;
        lbl2.textColor = ColorFontBlack;
        lbl2.font = [UIFont systemFontOfSize:14.0f];
        lbl2.backgroundColor = [UIColor clearColor];
        lbl2.text = @"请检查下您的网络，重新加载吧";
        [_failView addSubview:lbl2];
        [lbl2 release];
        
        UIImage *bgI = [UIImage imageNamed:@"default_button@2x.png"];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(MainViewWidth/2-bgI.size.width/4,210,bgI.size.width/2, bgI.size.height/2-5);
        [btn setBackgroundImage:[UIImage imageNamed:@"default_button@2x.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"default_button_press@2x.png"] forState:UIControlStateHighlighted];
        [btn setTitle:@"重新加载" forState:UIControlStateNormal];
        [btn setTitleColor:RGBCOLOR(62, 62, 62) forState:UIControlStateNormal];
        //btn.backgroundColor = RGBCOLOR(237, 237, 237);
        [btn addTarget:self
                action:@selector(requestToServer)
      forControlEvents:UIControlEventTouchUpInside];
        //btn.layer.borderWidth=1;
        //btn.layer.borderColor=RGBCOLOR(162, 162, 162).CGColor;
        //btn.layer.cornerRadius=5;
        [_failView addSubview:btn];
    }
//    for (UIView *subView in _failView.subviews)
//    {
//        [subView removeFromSuperview];
//    }
    
}


-(void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError *)error
{
    NSLog(@"失败");
    if(tag == 0)
    {
        // 获取
    }
    if(tag == 1)
    {
        // 是否选择
    }
    if(tag == 2)
    {
        // 更改个数
    }
    if (tag ==3)
    {
        // 删除
    }
    if (tag ==4)
    {
        // 结算
    }
    
    [self hideHud:nil];
    
    [self initFailView];
    self.failView.hidden = NO;
    self.myRightButton.hidden = YES;
    self.myLoginView.hidden = YES;
    self.myTableView.hidden = YES;
    self.myEmputyView.hidden = YES;
    [self.view removeHUDActivityView];        //加载成功  停止转圈
    
    //  断网之后购物车数字隐藏
    [RootVC setNumber:0 ofIndex:3];
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:0] forKey:kGouWuCheGoodsCount];
}



-(void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    if(tag == 0 || tag == 1 || tag == 2 || tag == 3)
    {
        self.shopEntity = dataObj;
        
        //设置已经选中商品的个数
        int count = 0;
        for (NSArray *myArray in self.shopEntity.goodslist) {
            for (GoodEntity *aEntity in myArray) {
                count += aEntity.count;
            }
        }
        if (![self.shopEntity.goodslist isKindOfClass:[NSNull class]]) {
            [RootVC setNumber:count ofIndex:3];
            [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:count] forKey:kGouWuCheGoodsCount];
        }
        
        // 列表信息
        [self.myTableView reloadData];
        // 概况
        [self shopingInfoRefresh];
        // 赠品信息
        [self refreshZengPinInfo];
        // 优惠信息
        [self showAllYouHui:NO];
        // 赠品信息
        [self refreshZengPinInfo];
        
        
        // 获取
        if ([self.shopEntity.goodslist count]==0) {
            self.myEmputyView.hidden = NO;
            self.myTableView.hidden = YES;
            self.myRightButton.hidden = YES;
            
            self.isEditing = NO;    // 购物车为空是  默认取消编辑状态
            [self setMyRightButtonTitle:@"编辑"];
        }else{
            self.myEmputyView.hidden = YES;
            self.myTableView.hidden = NO;
            self.myRightButton.hidden = NO;
        }
    }
    
    if(tag == 0)
    {
        
    }
    if(tag == 1)
    {
        // 是否选择
    }
    if(tag == 2)
    {
        // 更改个数
    }
    if (tag ==3)
    {
        // 删除
    }
    if (tag ==4)
    {
        // 结算
        GoodsSettleUpEntity* entity=dataObj;
        if (entity.response == 1) {
//            entity.goodslist = self.shopEntity.goodslist;
            
            OrderFormVC *order = [[OrderFormVC alloc]init];
            order.orderType = 1;        //1.购物车普通商品2.团购 3.秒杀
            order.mySetupEntity = entity;
            [self pushViewController:order];
            [order release];
        }else if (entity.response == 2){
            // 失败添加提示
            NSLog(@"%@",entity.failmsg);
            [self.view addHUDLabelView:entity.failmsg Image:nil afterDelay:2];
        }
        
    }
    

    self.failView.hidden = YES;
    [self.view removeHUDActivityView];        //加载成功  停止转圈

    
}

@end
