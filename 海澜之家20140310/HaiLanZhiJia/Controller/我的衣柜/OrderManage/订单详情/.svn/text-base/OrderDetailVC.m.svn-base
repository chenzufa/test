//
//  OrderDetailVC.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-12-4.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "OrderDetailVC.h"
#import "OrderDetailCell.h"
#import "LogisticsInfoVC.h"
#import "OrderInfoVC.h"
#import "OrderAddressInfoVC.h"
#import "ShangPingDetailVC.h"

#import "UPPayPlugin.h"
#import "UPPayPluginDelegate.h"
#import "DSRequest.h"

@interface OrderDetailVC ()<UPPayPluginDelegate,DSRequestDelegate,ClickedImageDelegate>
{
    UIAlertView* mAlert;
    PayTypeEntity *entiPayType;
}

@end

@implementation OrderDetailVC
{
    UIView *headerView;
    UIView *footerView;
    UITableView *odTableView;
    
    UIButton *btnDiZhi;
    UILabel *labName;
    UILabel *labTel;
    UILabel *labAdd;
    
    UILabel *labTime;  //送货时间
    UILabel *labPay;  //支付方式
    
    BOOL open;  // 用于判断是否打开 商品清单
}

- (void)dealloc
{
    [headerView release];
    [footerView release];
    [odTableView release];
    
    [labName release];
    [labTel release];
    [labAdd release];
    
    [labTime release];
    if (labPay) {
        [labPay release];
    }
    
    entiPayType = nil;
    self.requestOjb.delegate = nil;
    self.requestOjb = nil;
    self.orderNum = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:TEXT_BACKGROUD_COLOR];
    [self setTitleString:@"订单详情"];
    
    [self createMyButtonWithTitleAndImage];
    [self setMyRightButtonTitle:@"支付"];
    [self setMyRightButtonBackGroundImageView:@"button1.png" hightImage:@"button1_press.png"];
    
    if (self.odType == OrderTypeGoing) {
        [self.myRightButton setHidden:NO];
    }else [self.myRightButton setHidden:YES];
    
    
    
    [self addHeaderView];                // 初始化 headerView
    [self addHeaderViewsMenues];         // 初始化 headerView中的按钮
    
    [self addFooterView];                // 初始化 footerView
    [self addFooterViewsMenues];         // 初始化 footerView 中的按钮
    
    [self addTableView];                 // 初始化 UITableView
    
    [self request];                      // 发送网络请求
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(zhifubaoSuccess) name:ZhifubaoSuccess object:nil]; //接受支付宝支付成功的通知
}

- (void)zhifubaoSuccess
{
    //支付回调
    [self popViewController];
//    [self request:RequestTypeGoing page:goCurrPage OrderNum:nil];
}

- (void)myRightButtonAction:(UIButton *)button
{
//    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝支付", nil];
//    RootVC *rootVC= [RootVC shareInstance];
//    [sheet showInView:rootVC.view];
//    [sheet release];
    
    [self payAction];
}

- (void)request     //   发送网络请求
{
    [self.view addHUDActivityView:Loading];  //提示 加载中
    
    if (!self.requestOjb) {
        DSRequest *request = [[DSRequest alloc]init];
        self.requestOjb = request;
        request.delegate = self;
        [request release];
    }
    
    [self.requestOjb requestDataWithInterface:MyOrderDetail param:[self MyOrderDetailParam:self.orderNum] tag:1];
}

#pragma mark DSRequestDelegate
- (void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    NSLog(@"请求成功!");
    if (tag == 10000) {
        [self hideAlert];
        
        StatusEntity *entity = (StatusEntity *)dataObj;
        //1表示成功，2表示失败
        if (entity.response == 1) {
            
            NSString* tn = entity.uppaytn;
            if (tn != nil && tn.length > 0)
            {
                NSLog(@"tn=%@",tn);
                //tn 交易流水号  mode 00正式环境 01测试环境
                [UPPayPlugin startPay:tn mode:kMode viewController:self delegate:self];
            }else
            {
                [self showAlertMessage:@"该订单已付款"];
            }
            
        }else
        {
            [self hideAlert];
            [self showAlertMessage:entity.failmsg];
        }
        
        return;
    }
    
    switch (tag) {
        case 1:
            self.entiOrderDetail = (OrderDetailEntity *)dataObj;
            [self setAddressDetailSource];  //获取到数据后刷新
            [self setFooterViewsSource];
            [odTableView reloadData];
            [self.view removeHUDActivityView];        //加载成功  停止转圈
            
            break;
        case 2:
        {
            StatusEntity *entiStatus = (StatusEntity *)dataObj;
            if (entiStatus.response == 1) {
                [labPay setText:entiPayType.name];
                self.entiOrderDetail.payby = entiPayType.name;
                self.entiOrderDetail.paycode = entiPayType.paycode;
            }
        }
            break;
        default:
            break;
    }
    
}

- (void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError *)error
{
    if (tag == 10000) {
        NSLog(@"失败");
        [self hideAlert];
        [self showAlertMessage:error.domain];
        return;
    }
    
    NSLog(@"请求失败");
    [self.view removeHUDActivityView];        //加载失败  停止转圈并弹出提示框
    [self.view addHUDLabelView:error.domain Image:nil afterDelay:2];
}

- (void)addHeaderView     // 初始化 headerView
{
    UIView *myView  = [[UIView alloc]initWithFrame:CGRectMake(0, TITLEHEIGHT, MainViewWidth - 20, 261)];
    [myView setBackgroundColor:[UIColor clearColor]];
    headerView = [myView retain];
    [myView release];
        
}

- (void)addFooterView     // 初始化 footerView
{
    UIView *myView  = [[UIView alloc]initWithFrame:CGRectMake(0, TITLEHEIGHT, MainViewWidth - 20, 162)];
    [myView setBackgroundColor:[UIColor clearColor]];
    footerView = [myView retain];
    [myView release];
    
}

- (void)addHeaderViewsMenues  // 初始化 headerView中的按钮
{
    //////////////物流追踪
//    UIButton *btnWuliu = [self buttonWithBackgroundImage:@"bg_list2_up.png" hightImage:@"bg_list2_up_press.png"x:0 y:10 hiddenArrow:NO title:@"物流追踪"];
//    btnWuliu.tag = 0;
    UIButton *btnWuliu = [UIButton buttonWithType:UIButtonTypeCustom];  //为了暂时先隐藏物流追踪按钮
    [btnWuliu setFrame:CGRectMake(0, 10, 0, 0)];
    
    //////////////订单信息
//    UIButton *btnXinXi = [self buttonWithBackgroundImage:@"bg_list2_down.png" hightImage:@"bg_list2_down_press.png" x:btnWuliu.frame.origin.x y:(btnWuliu.frame.origin.y + btnWuliu.frame.size.height) hiddenArrow:NO title:@"订单信息"];
    UIButton *btnXinXi = [self buttonWithBackgroundImage:@"bg_list.png" hightImage:@"bg_list_press.png" x:btnWuliu.frame.origin.x y:(btnWuliu.frame.origin.y + btnWuliu.frame.size.height) hiddenArrow:NO title:@"订单信息"];
    btnXinXi.tag = 1;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(btnWuliu.frame.origin.x, btnWuliu.frame.origin.y + btnWuliu.frame.size.height - 1, btnWuliu.frame.size.width, 0.5)];
    [lineView setBackgroundColor:[UIColor colorWithWhite:0.35 alpha:0.3]];
    [headerView addSubview:lineView];
    [lineView release];
    
    //////////////地址
    btnDiZhi = [self buttonWithBackgroundImage:@"bg_list.png" hightImage:@"bg_list_press.png"x:btnWuliu.frame.origin.x y:btnXinXi.frame.origin.y + btnXinXi.frame.size.height + 10 hiddenArrow:NO title:nil];
    btnDiZhi.tag = 2;
    
    [self createAddressDetail];
    
    UIButton *btnZhifu = nil;
//    if (self.myRightButton.hidden == NO) {
        //////////////支付方式
    btnZhifu = [self buttonWithBackgroundImage:@"bg_list.png" hightImage:@"bg_list_press.png"x:btnDiZhi.frame.origin.x y:btnDiZhi.frame.origin.y + btnDiZhi.frame.size.height + 10 hiddenArrow:NO title:@"支付方式"];
    btnZhifu.tag = 5;
    labPay = [[UILabel alloc]initWithFrame:CGRectMake(100, 18, 190, FontSize12 + 1)];
    [labPay setFont:SetFontSize(FontSize12)];
    [labPay setTextColor:RGBCOLOR(120, 120, 120)];
    [labPay setBackgroundColor:[UIColor clearColor]];
    [btnZhifu addSubview:labPay];
//    [btnZhifu setHidden:self.myRightButton.hidden];
//    }
    
    int zhifuHeight = 0;
    if (btnZhifu.hidden == NO) {         // 如果有支付方式按钮 则
        zhifuHeight = 55;
    }
    //////////////送货时间
    UIButton *btnSongHuo = [self buttonWithBackgroundImage:@"bg_list.png" hightImage:@"bg_list_press.png"x:btnDiZhi.frame.origin.x y:btnDiZhi.frame.origin.y + btnDiZhi.frame.size.height + 10 + zhifuHeight hiddenArrow:YES title:@"送货时间"];
    btnSongHuo.tag = 3;
    labTime = [[UILabel alloc]initWithFrame:CGRectMake(100, 18, 190, FontSize12 + 1)];
    [labTime setFont:SetFontSize(FontSize12)];
    [labTime setTextColor:RGBCOLOR(120, 120, 120)];
    [labTime setBackgroundColor:[UIColor clearColor]];
    [btnSongHuo addSubview:labTime];
//    [labTime setText:@"只双休日、节假日送货（工作日不用送）"];
    
    //////////////商品清单
    UIButton *btnQingDan = [self buttonWithBackgroundImage:@"bg_list.png" hightImage:@"bg_list_press.png"x:btnSongHuo.frame.origin.x y:btnSongHuo.frame.origin.y + btnSongHuo.frame.size.height + 10 hiddenArrow:YES title:@"商品清单"];
    btnQingDan.tag = 4;
    UIImageView *imgViewArrow = [[UIImageView alloc]initWithImage:GetImage(@"car_icon_pack up.png")];
    [imgViewArrow setFrame:CGRectMake(278, 15, imgViewArrow.image.size.width, imgViewArrow.image.size.height)];
    imgViewArrow.tag = 1000;
    [btnQingDan addSubview:imgViewArrow];
    [imgViewArrow release];
    
}

- (void)createAddressDetail     // 初始化地址详情
{
    labName = [[UILabel alloc]initWithFrame:CGRectMake(10, 11, 100, FontSize15 + 4)];
    [labName setFont:SetFontSize(FontSize15)];
    [labName setTextColor:ColorFontBlack];
    [labName setBackgroundColor:[UIColor clearColor]];
    [btnDiZhi addSubview:labName];
    
    labTel = [[UILabel alloc]initWithFrame:CGRectMake(150, labName.frame.origin.y, 140, labName.frame.size.height)];
    [labTel setFont:SetFontSize(FontSize15)];
    [labTel setTextColor:ColorFontBlack];
    [labTel setBackgroundColor:[UIColor clearColor]];
    [btnDiZhi addSubview:labTel];
    
    labAdd = [[UILabel alloc]initWithFrame:CGRectMake(labName.frame.origin.x, labName.frame.origin.y + labName.frame.size.height + 10, 260, 30)];
    [labAdd setFont:SetFontSize(FontSize12)];
    [labAdd setTextColor:RGBCOLOR(120, 120, 120)];
    [labAdd setBackgroundColor:[UIColor clearColor]];
    [labAdd setNumberOfLines:2];
    [btnDiZhi addSubview:labAdd];
    
}

- (void)setAddressDetailSource  //  设置地址块数据
{
    odTableView.tableHeaderView = nil;
    if (self.paystatus != 0) {
        [self.myRightButton setHidden:YES];
    }else [self.myRightButton setHidden:NO];
    
    [labName setText:self.entiOrderDetail.name];
    [labTel setText:self.entiOrderDetail.tel];
    [labAdd setText:self.entiOrderDetail.address];
    [labTime setText:self.entiOrderDetail.availabledate];
    [labPay setText:self.entiOrderDetail.payby];
    CGSize labelSize = [labAdd.text sizeWithFont:labAdd.font constrainedToSize:CGSizeMake(labAdd.frame.size.width, 35) lineBreakMode:NSLineBreakByWordWrapping];
    int tempHeight = (int)labelSize.height;         // 当高度小数点后面有数时，使用的高度 取整并加1  如：28.31  取高度为29
    int labHeight = labelSize.height > tempHeight?tempHeight + 1:tempHeight;
    [labAdd setFrame:CGRectMake(labAdd.frame.origin.x, labAdd.frame.origin.y, labAdd.frame.size.width, labHeight)];
    
    [btnDiZhi setFrame:CGRectMake(btnDiZhi.frame.origin.x, btnDiZhi.frame.origin.y, btnDiZhi.frame.size.width, labAdd.frame.origin.y + labAdd.frame.size.height + 15)];
    [btnDiZhi setImageEdgeInsets:UIEdgeInsetsMake((btnDiZhi.frame.size.height - 15) / 2, 283, (btnDiZhi.frame.size.height - 15) / 2, 8)];
    
    UIButton *zhifuButton = (UIButton *)[headerView viewWithTag:5];       //支付订单 按钮
//    [zhifuButton setHidden:self.myRightButton.hidden];
    int zhifuHeight = 55;       //  支付方式按钮修改为一直显示，此处高度查保持55
    [zhifuButton setFrame:CGRectMake(zhifuButton.frame.origin.x, btnDiZhi.frame.origin.y + btnDiZhi.frame.size.height + 10, zhifuButton.frame.size.width, zhifuButton.frame.size.height)];
//    zhifuHeight = 55;
//    if (self.myRightButton.hidden == NO) {  // 如果有支付方式按钮 支付方式按钮可以点击
    [zhifuButton.imageView setHidden:self.myRightButton.hidden];    // 不可支付时，支付方式按钮不可点击，上面的箭头隐藏
    [zhifuButton setUserInteractionEnabled:!self.myRightButton.hidden];
//    }
    
    UIButton *songhuoButton = (UIButton *)[headerView viewWithTag:3];       //送货时间 按钮
    [songhuoButton setFrame:CGRectMake(songhuoButton.frame.origin.x, btnDiZhi.frame.origin.y + btnDiZhi.frame.size.height + 10 + zhifuHeight, songhuoButton.frame.size.width, songhuoButton.frame.size.height)];
    
    UIButton *shangpinqingdanButton = (UIButton *)[headerView viewWithTag:4];       //商品清单 按钮
    [shangpinqingdanButton setFrame:CGRectMake(shangpinqingdanButton.frame.origin.x, songhuoButton.frame.origin.y + songhuoButton.frame.size.height + 10, shangpinqingdanButton.frame.size.width, shangpinqingdanButton.frame.size.height)];
    UILabel *labInButton = (UILabel *)[shangpinqingdanButton viewWithTag:99];
    
    int shangpinlistCount = 0;
    for (GoodEntity *oneGoods in self.entiOrderDetail.goodslist) {
        shangpinlistCount = oneGoods.count + shangpinlistCount;
    }
    [labInButton setText:[NSString stringWithFormat:@"商品清单(%i)",shangpinlistCount]];
    
    [headerView setFrame:CGRectMake(headerView.frame.origin.x, headerView.frame.origin.y, headerView.frame.size.width, shangpinqingdanButton.frame.origin.y + shangpinqingdanButton.frame.size.height)];
    
    
    odTableView.tableHeaderView = headerView;       //此处重新赋值，不然odTableView.tableHeaderView仍然是之前headerview的高度
    
    
}

- (void)addFooterViewsMenues
{
    
    UIImageView *imgViewBackGround = [[UIImageView alloc]initWithImage:GetImage(@"user_bg_list.png")];
    [imgViewBackGround setFrame:CGRectMake(0, 10, imgViewBackGround.image.size.width, imgViewBackGround.image.size.height)];
    [footerView addSubview:imgViewBackGround];
    NSArray *arrleft = [[NSArray alloc]initWithObjects:@"商品总计：",@"赠送积分总计：",@"商品金额总计：",@"+运费金额：",@"-抵用券：",@"-现金券：",@"=应付总额：", nil];
    for (int i = 0; i < 7; i ++) {
        UILabel *labLeft = [[UILabel alloc]initWithFrame:CGRectMake(5, 20 + 18 * i, 110, FontSize15)];
        [labLeft setFont:SetFontSize(FontSize15)];
        [labLeft setBackgroundColor:[UIColor clearColor]];
        [labLeft setTextColor:ColorFontBlack];
        [labLeft setTextAlignment:NSTextAlignmentRight];
        [footerView addSubview:labLeft];
        [labLeft setText:[arrleft objectAtIndex:i]];

        
        UILabel *labRight = [[UILabel alloc]initWithFrame:CGRectMake(180, labLeft.frame.origin.y, 115, labLeft.frame.size.height)];
        [labRight setFont:labLeft.font];
        [labRight setBackgroundColor:labLeft.backgroundColor];
        [labRight setTextColor:ColorFontRed];
        [labRight setTextAlignment:labLeft.textAlignment];
        labRight.tag = 100 + i;
        [footerView addSubview:labRight];

        [labLeft release];
        [labRight release];
        
    }
    [arrleft release];
    
}

- (void)setFooterViewsSource  // 设置 footerView 数据
{
    for (int i = 0; i< 7; i ++) {
        UILabel *label = (UILabel *)[footerView viewWithTag:100 + i];
        switch (i) {
            case 0:
                if ([self.entiOrderDetail.count isKindOfClass:[NSString class]]) {
                    [label setText:[NSString stringWithFormat:@"%@件",self.entiOrderDetail.count]];
                }
                break;
            case 1:
                if ([self.entiOrderDetail.score isKindOfClass:[NSString class]]) {
                    [label setText:self.entiOrderDetail.score];
                }
                
                break;
            case 2:
                if ([self.entiOrderDetail.goodsfee isKindOfClass:[NSString class]]) {
                    [label setText:[NSString stringWithFormat:@"￥%@",self.entiOrderDetail.goodsfee]];
                }
                break;
            case 3:
                if ([self.entiOrderDetail.deliverfee isKindOfClass:[NSString class]]) {
                    [label setText:[NSString stringWithFormat:@"￥%@",self.entiOrderDetail.deliverfee]];
                }
                break;
            case 4:
                if ([self.entiOrderDetail.tradeticket isKindOfClass:[NSString class]]) {
                    [label setText:[NSString stringWithFormat:@"￥%@",self.entiOrderDetail.tradeticket]];
                }
                break;
            case 5:
                if ([self.entiOrderDetail.moneyticket isKindOfClass:[NSString class]]) {
                    [label setText:[NSString stringWithFormat:@"￥%@",self.entiOrderDetail.moneyticket]];
                }
                break;
            case 6:
                if ([self.entiOrderDetail.total isKindOfClass:[NSString class]]) {
                    [label setText:[NSString stringWithFormat:@"￥%@",self.entiOrderDetail.total]];
                }
                break;
                
            default:
                break;
        }
    }
}

//用于生产button
- (UIButton *)buttonWithBackgroundImage:(NSString *)strImg hightImage:(NSString *)strHightImg x:(float)x y:(float)y hiddenArrow:(BOOL)hidden title:(NSString *)title
{
    UIImage *imgbtn = [GetImage(strImg) resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    UIImage *imgHightbtn = [GetImage(strHightImg) resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:imgbtn forState:UIControlStateNormal];
    [button setBackgroundImage:imgHightbtn forState:UIControlStateHighlighted];
    [button setFrame:CGRectMake(x, y, imgbtn.size.width, imgbtn.size.height)];
    [button addTarget:self action:@selector(clickedHeaderViewButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor clearColor]];
    if (!hidden) {
        [button setImage:GetImage(@"icon_next.png") forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake((button.frame.size.height - 15) / 2, 283, (button.frame.size.height - 15) / 2, 8)];
    }
    
    [headerView addSubview:button];
    
    if (title) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 100, FontSize15)];
        [label setFont:SetFontSize(FontSize15)];
        [label setTextColor:ColorFontBlack];
        label.tag = 99;
        [label setText:title];
        [label setBackgroundColor:[UIColor clearColor]];
        [button addSubview:label];
        [label release];
    }
    
        
    return button;
}

#pragma mark - HeaderView中的按钮点击事件
- (void)clickedHeaderViewButton:(UIButton *)btn
{
    NSLog(@"btn.tag = %i",btn.tag);
    switch (btn.tag) {
        case 0:
        {
            LogisticsInfoVC *logisVC = [[LogisticsInfoVC alloc]init];
            logisVC.orderNum = self.entiOrderDetail.ordernumber;
            [self pushViewController:logisVC];
            [logisVC release];
        }
            break;
        case 1:
        {
            OrderInfoVC *orderInfoVC = [[OrderInfoVC alloc]init];
            orderInfoVC.entiOrderDetail = self.entiOrderDetail;
            [self pushViewController:orderInfoVC];
            [orderInfoVC release];
        }
            break;
        case 2:
        {
            OrderAddressInfoVC *addressVC = [[OrderAddressInfoVC alloc]init];
            addressVC.arrInfo = [NSArray arrayWithObjects:self.entiOrderDetail.name,self.entiOrderDetail.tel,self.entiOrderDetail.address,self.entiOrderDetail.availabledate, nil];
            [self pushViewController:addressVC];
            [addressVC release];
        }
            break;
        case 3:
            
            break;
        case 4:
            open = !open;
            
            UIImageView *imageview = (UIImageView*)[btn viewWithTag:1000];
            if (open) {
                [UIView animateWithDuration:0.35 animations:^(void){
                    [odTableView reloadData];
                    [imageview setTransform:CGAffineTransformMakeRotation(M_PI)];
                }];
//                imageview.image = GetImage(@"car_icon_pack up.png");
//                [btn setImage:GetImage(@"car_icon_pack up.png") forState:UIControlStateNormal];
//                [imageview setFrame:CGRectMake(283-5, 15, imageview.image.size.width, imageview.image.size.height)];
            }else
            {
                [UIView animateWithDuration:0.35 animations:^(void){
                    [odTableView reloadData];
                    [imageview setTransform:CGAffineTransformMakeRotation(0)];
                }];
//                imageview.image = GetImage(@"icon_next.png");
//                [btn setImage:GetImage(@"icon_next.png") forState:UIControlStateNormal];
//                [imageview setFrame:CGRectMake(283, 15, imageview.image.size.width, imageview.image.size.height)];
            }
            
            break;
        case 5:     // 选择支付方式
        {
            PayMentVC *payVC = [[PayMentVC alloc]init];
            PayTypeEntity *one = [[[PayTypeEntity alloc]init]autorelease];
            one.name = self.entiOrderDetail.payby;
            one.paycode = self.entiOrderDetail.paycode;
            
            payVC.myEntity = one;
            payVC.isOrderDetail = YES;
            payVC.delegate = self;
            [self pushViewController:payVC];
            [payVC release];
        }
            break;
            
        default:
            break;
    }
}

- (void)sendFormMessage:(enum InfoType)type Object:(id)object
{
    entiPayType = (PayTypeEntity *)object;
    
    if (!self.requestOjb) {
        DSRequest *request = [[DSRequest alloc]init];
        self.requestOjb = request;
        request.delegate = self;
        [request release];
    }
    
    [self.requestOjb requestDataWithInterface:ChangeOrderPaytype param:[self ChangeOrderPaytypeParam:self.entiOrderDetail.ordernumber paytypeid:[NSString stringWithFormat:@"%i",entiPayType.typeId]] tag:2];
    
    
//    [labPay setText:oneEnti.name];
//    self.entiOrderDetail.payby = oneEnti.name;
//    self.entiOrderDetail.paycode = oneEnti.paycode;
    
}

- (void)addTableView  // 初始化 UITableView
{
    odTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, TITLEHEIGHT, MainViewWidth - 20, MainViewHeight - TITLEHEIGHT - 20)];
    odTableView.delegate = self;
    odTableView.dataSource = self;
    [self.view addSubview:odTableView];
    odTableView.tableHeaderView = headerView;
    odTableView.tableFooterView = footerView;
    [odTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [odTableView setBackgroundColor:[UIColor clearColor]];
    [odTableView setShowsVerticalScrollIndicator:NO];
}

#pragma mark UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (open) {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (open) {
        return self.entiOrderDetail.goodslist.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"tableviewcell";
    OrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[OrderDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
        cell.clickedDelegate = self;
    }
//    if (indexPath.row < self.entiOrderDetail.goodslist.count - 1) {
//        [cell setOtherRowBackGroundImageView];
//    }else [cell setlastRowBackGroundImageView];
    cell.imgViewHead.tag = indexPath.row;
    GoodEntity *one = [self.entiOrderDetail.goodslist objectAtIndex:indexPath.row];
    [cell setImgViewHead:one.goodsimg labTitle:one.goodsname labMoney:one.price labSize:one.sizeandcolor goodsCount:one.count ispresentation:one.ispresentation];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark - cell的图片点击响应
- (void)clickedImageViewAtIndexPath:(NSIndexPath*)indexPath
{
    NSLog(@"index = %i",indexPath.row);
    GoodEntity *one = [self.entiOrderDetail.goodslist objectAtIndex:indexPath.row];
    ShangPingDetailVC *vc = [[ShangPingDetailVC alloc]init];
    vc.spId = one.goodsid;
    [self pushViewController:vc];
    [vc release];
}

//#pragma mark UITableViewDelegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    GoodEntity *one = [self.entiOrderDetail.goodslist objectAtIndex:indexPath.row];
//    ShangPingDetailVC *vc = [[ShangPingDetailVC alloc]init];
//    vc.spId = one.goodsid;
//    [self pushViewController:vc];
//    [vc release];
//}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if (buttonIndex == 0) {
//        [self pay];
//    }
}


-(void)payAction
{
    /*paycode	string	付款方式标识，例如：
     unionpay 银联在线支付
     alipay 支付宝
     bank 银行汇款/转帐
     tenpay 财付通
     onlinepay 在线支付
     */
    //默认支付宝
    if (self.entiOrderDetail !=nil && [self.entiOrderDetail.paycode compare:@"unionpay" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        //银联在线支付
        [self upPay];
        return;
    }
    
    [self alixPay];
}

////////
//-------6226440123456785 111101
- (void)upPay
{
    [self showAlertWait];
    
    //
    DSRequest *dsrequest=[[DSRequest alloc]init];
    dsrequest.delegate = self;
    [dsrequest requestDataWithInterface:GetUPPayTN param:[self GetUPPayTNParam:self.entiOrderDetail.ordernumber] tag:10000];
    [dsrequest release];
}
//------
- (void)showAlertWait
{
    mAlert = [[UIAlertView alloc] initWithTitle:kWaiting message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [mAlert show];
    UIActivityIndicatorView* aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    aiv.center = CGPointMake(mAlert.frame.size.width / 2.0f - 15, mAlert.frame.size.height / 2.0f + 10 );
    [aiv startAnimating];
    [mAlert addSubview:aiv];
    [aiv release];
    [mAlert release];
}

- (void)showAlertMessage:(NSString*)msg
{
    mAlert = [[UIAlertView alloc] initWithTitle:kNote message:msg delegate:nil cancelButtonTitle:kConfirm otherButtonTitles:nil, nil];
    [mAlert show];
    [mAlert release];
}
- (void)hideAlert
{
    if (mAlert != nil)
    {
        [mAlert dismissWithClickedButtonIndex:0 animated:YES];
        mAlert = nil;
    }
}
//-----------
- (void)UPPayPluginResult:(NSString *)result
{
    //银联手机支付控件有三个支付状态返回值:success、fail、cancel,分别代表:支付成功、支付失败、用户取消支付。这三个返回状态值以字符串的形式作为回调函
    NSString* msg = [NSString stringWithFormat:kResult, result];
    if ([result isEqualToString:@"success"])
    {
        msg = [NSString stringWithFormat:kResult,@"支付成功"];
        
        if ([self.payDelegate respondsToSelector:@selector(payDidSuccess)]) {       //支付成功后回调
            [self.payDelegate payDidSuccess];
        }
        
    }else if ([result isEqualToString:@"fail"])
    {
        msg = [NSString stringWithFormat:kResult,@"支付失败"];
    }else if ([result isEqualToString:@"cancel"])
    {
        msg = [NSString stringWithFormat:kResult,@"用户取消支付"];
    }
    [self showAlertMessage:msg];
    
    if (isBigeriOS7version) {
        RootVC *aRoot = [RootVC shareInstance];
        self.view.frame = CGRectMake(0, 0, aRoot.view.frame.size.width, aRoot.view.frame.size.height);
    }
}
//////////

#pragma mark - 支付
-(void)alixPay
{
    //将商品信息拼接成字符串
    NSString *partner = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Partner"];
    NSString *seller = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Seller"];
    
    AlixPayOrder *order = [[[AlixPayOrder alloc] init] autorelease];
    
    // partner seller   关键字段
    order.partner = partner;
    order.seller = seller;
    
//    // --------
//    order.tradeNO = self.entiOrderDetail.ordernumber;//one.ordernumber;//订单id
//    order.productName = @"测试支付"; //商品标题
//	order.productDescription = @"123657"; //商品描述
//    order.amount = @"0.01";//支付金额
//    // --------
    // --------
    order.tradeNO = self.entiOrderDetail.ordernumber;//订单id
    order.productName = self.entiOrderDetail.ordernumber;//@"测试支付"; //商品标题
	order.productDescription = @"海澜之家";// @"123657"; //商品描述
    order.amount = self.entiOrderDetail.total;// @"0.01";//支付金额
    // --------
    
    // order.notifyURL =  @"http://www.xxx.com"; //回调URL
    
    //modified by caijunbo on 2014-02-25
    //动态使用绑定的ip地址
//    order.notifyURL = @"http://113.106.90.141:2046/Api/PayCallBack";
    order.notifyURL=[NSString stringWithFormat:@"%@PayCallBack",ZHIFUBAO_ADDRESS];
    //end modifying
    
    NSString *appScheme = @"HaiLanZhiJia";
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    // 客户的私钥    关键字段
    id<DataSigner> signer = CreateRSADataSigner([[NSBundle mainBundle]
                                                 objectForInfoDictionaryKey:@"RSA private key"]);
    //    NSString *privateKey =  @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAOWJZHgOI+KbXugA1h4T0XV0DnVhhbGY8/aeqD1IXDqkBewYVop2ycyINsC11apu12nX2ESb65gWJwS4n+IeB1c+aW3kzvsMPqP+snEbKuVIWnPq40EFf3/Ii8nJHNqM8iRaoNv+t4biZ88ojtGYMDYhSFgn6NVT5zjb232pw3YlAgMBAAECgYEAyfAS9NAz3/QjDedWeMWkvDlrUveGQFW5JFo21xtnEKwnDavnzw9swEWCLg6LONMlLtgXS10FaxrqHuwytSMH/p1fMijOBrDKuwo2yd0rnJNMMQaXge/z7Sic3ql/Jw/RtRCvyu/H31BIN7dljXFwp1i1NGy1Dp8FA9i2CSUU600CQQD868ipCH83N1v3VyGFd0Ay3q0g1gTzOujdhdeVHdz7B2N6BZgJGlUaqkgq1NmJKpASS4dm9lWX6RKbEO3kPF8zAkEA6FS7glzIG8vqCHnxQ9RcO2KC3cfqCze9UVJl6wdyQlNf9m82hFBNHe/ndRZOE2iNPvW5XkvLubiYvJAIk3K1RwJBAPtD8zGas2fTo5XyBedmNW1UM4Mvm/NYTwfkc+w8otDw4i7TZ9uDQZEgIloK46KVmlPSnU3448frUQSkqPHZ2GkCQAO50CQADul7NK6cHgVjc3M0WjrqSNOTOkMCmkXRocB0i9Zs5CftDb+MKF8VU302MQWwdR+RAZxh3HkxqiGLNmMCQDdnxkMAfvLuxahvNimUFV4VoKtCcayIC+IJrefCUW3BVptCZxulk88aocw7LW56xHwcm0ChdKMlkGmTYamQAoU=";
    //    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    
    //    NSString *payPublicStr = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQChhJyjxYniah/98EZPwOhcV6u9LdngWGYFN7tK CMCKTgqu0EP0Ir7wuz3AxJWrOixGaV4i6qD3bnKCy7ifGQtDqUSf+Uxy6uQA7dcrmroonE6lRmJY ndwD2WhlXefkbbTXAPcMHYdWbGQbihg6KpsXBVS6wbTzL+WinxWyxz1bIwIDAQAB";
    
    
    NSString *signedString = [signer signString:orderSpec];
    NSString *orderString = nil;
    if (signedString != nil)
    {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        //获取快捷支付单例并调用快捷支付接口
        AlixPay * alixpay = [AlixPay shared];
        int ret = [alixpay pay:orderString applicationScheme:appScheme];
        NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%@",orderString);
        
        if (ret == kSPErrorAlipayClientNotInstalled)
        {
            [WCAlertView showAlertWithTitle:@"提示" message:@"您还没有安装支付宝快捷支付，请先安装。" customizationBlock:^(WCAlertView *alertView) {
                alertView.style = WCAlertViewStyleWhite;
                alertView.labelTextColor=[UIColor blackColor];
                alertView.buttonTextColor=[UIColor blueColor];
            } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                if(buttonIndex == 1)
                {
                    //进入下载支付宝
                    NSString * URLString = @"http://itunes.apple.com/cn/app/id535715926?mt=8";
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
                }
                
                
            } cancelButtonTitle:@"取消" otherButtonTitles:@"前往下载", nil];
            
        }
        else if (ret == kSPErrorSignError)
        {
            NSLog(@"签名错误！");
        }
        
        
    }
    
    // OrderDetailEntity
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
