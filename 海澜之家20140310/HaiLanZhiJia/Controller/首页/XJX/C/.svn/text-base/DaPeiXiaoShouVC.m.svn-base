//
//  DaPeiXiaoShouVC.m
//  HaiLanZhiJia
//
//  Created by xiaojiaxi on 13-11-26.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "DaPeiXiaoShouVC.h"
#import "DaPeiXiaoShouCell.h"
#import <QuartzCore/QuartzCore.h>
#import "SuitDetailEntity.h"
#import "NetImageView.h"
#import "GouWuCheVC.h"
#import "DSImageView.h"
#import "UIViewController+Hud.h"
#import "SKBounceAnimation.h"
#import "RootVC.h"
#import "ShangPingDetailVC.h"

#define kTableviewTag 0x9999
#define yansebtnBaseTag  0x2222
#define chiMaBtnBaseTag  0x3333
#define kCellHeight  120
#define kMaxPickerHeight ((MainViewHeight)-([self getTitleBarHeight]))

@interface DaPeiXiaoShouVC ()<DaPeiXiaoShouCellDelegate>
@property(nonatomic,retain)UIView *chiCunSelectedView;
@property(nonatomic,retain)NSMutableArray *colorArr;
@property(nonatomic,retain)NSMutableArray *chiCunArr;
@property(nonatomic,retain)UIView *pickerBgV;//zhe zhao
@property(nonatomic,assign)CGFloat bounceOutHeight;
@property(nonatomic,retain)SuitDetailEntity *object;
@property(nonatomic,retain)UIButton *curSelectedColorSizeBtn;
@property(nonatomic,retain)UIScrollView *scrollView;
@property(nonatomic,retain)UIView *contentView;//tao zhuang rong qi shi tu
@property(nonatomic,retain)NSMutableArray *yanseLabArr;
@property(nonatomic,assign)NSUInteger currentYanSeBtnIndex;//当前点击的颜色尺码index
@property(nonatomic,copy)NSString *curSelectColor;//当前点击的颜色
@property(nonatomic,copy)NSString *curSelectSize;//当前点击的尺码
@property(nonatomic,retain)UIButton *curYanSeBtn;//当前点击的颜色尺码按钮
@property(nonatomic,retain)NSMutableDictionary *suitColorAndSize;//已经选择好的颜色尺寸
@property(nonatomic,retain)DSImageView *shangPinView;
@property(nonatomic,retain)UIView *hongDianView;//购物车红点
@property(nonatomic,assign)NSInteger gouWuCheSpCount;
@property(nonatomic,retain)UIButton *gouWuCheBtn;
@property(nonatomic,retain)UIImageView *mainImageView;
@property(nonatomic,retain)NSMutableDictionary *cacheColorSize;
@property(nonatomic,assign)BOOL isReload;
@end

@implementation DaPeiXiaoShouVC
-(void)dealloc
{
    [_chiCunSelectedView release];_chiCunSelectedView=nil;
    [_object release];_object=nil;
    [_colorArr release];_colorArr=nil;
    [_chiCunArr release];_chiCunArr=nil;
    [_pickerBgV release];_pickerBgV=nil;
    [_spId release];_spId = nil;
    [_mainSpColor release];_mainSpColor=nil;
    [_mainSpSize release];_mainSpSize=nil;
    [_curSelectedColorSizeBtn release];_curSelectedColorSizeBtn=nil;
    [_scrollView release];_scrollView=nil;
    [_contentView release];_contentView=nil;
    [_yanseLabArr release];_yanseLabArr=nil;
    [_curSelectColor release];_curSelectColor = nil;
    [_curSelectSize release];_curSelectSize = nil;
    [_curYanSeBtn release];_curYanSeBtn=nil;
    [_suitColorAndSize release];_suitColorAndSize=nil;
    [_shangPinView release];_shangPinView = nil;
    [_hongDianView release];_hongDianView = nil;
    [_gouWuCheBtn release];_gouWuCheBtn = nil;
    [_mainImageView release];_mainImageView = nil;
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
-(void)leftAction
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super leftAction];
}
- (void)controllerviewDidAppear
{
    //购物车商品数量显示
    int count = [[[NSUserDefaults standardUserDefaults]objectForKey:kGouWuCheGoodsCount] intValue];
    if (count>=0)
    {
        [self setGouWuCheCount:count];
        [self addBounceAnimation:self.hongDianView];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor =RGBCOLOR(245, 245, 245);
    [self setTitleString:@"搭配销售"];
    
    self.curSelectColor = @"";
    self.curSelectSize = @"";
    self.suitColorAndSize = [NSMutableDictionary dictionaryWithCapacity:0];
    self.cacheColorSize = [NSMutableDictionary dictionary];
    [_suitColorAndSize setObject:[NSArray arrayWithObjects:self.mainSpColor,self.mainSpSize, nil] forKey:@"0"];
    
    [self performSelector:@selector(doAfterViewDidLoad) withObject:nil afterDelay:0.1];
}
-(void)doAfterViewDidLoad
{
    [self initSubview];
    [self requestDatasource];
}
-(void)requestDatasource
{
    [self addHud:@""];
    DSRequest *request = [[DSRequest alloc]init];
    request.delegate = self;
    [request requestDataWithInterface:SuitDetail param:[self SuitDetailParam:_spId] tag:1];
    [request release];
}
-(void)initSubview
{
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(10,[self getTitleBarHeight],300, MainViewHeight-20-[self getTitleBarHeight])];
    scroll.backgroundColor = RGBCOLOR(245,245,245);
    scroll.contentSize = CGSizeMake(300,MainViewHeight-20-[self getTitleBarHeight]-15);
    scroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scroll];
    self.scrollView = scroll;
    [scroll release];
    
    CGFloat x = 260;
    CGFloat y = MainViewHeight-50-20-10;
    CGFloat w = 40;
    CGFloat h = 40;
    UIButton *gouWuCheBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    gouWuCheBtn.frame = CGRectMake(x,y,w,h);
    [gouWuCheBtn setBackgroundImage:[UIImage imageNamed:@"mall_details_icon_car@2x.png"] forState:UIControlStateNormal];
    [gouWuCheBtn addTarget:self action:@selector(gouWuCheBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.gouWuCheBtn = gouWuCheBtn;
    [self.view addSubview:gouWuCheBtn];
    
    NSNumber *count = [[NSUserDefaults standardUserDefaults]objectForKey:kGouWuCheGoodsCount];
    self.hongDianView = [self hongDianPoint:CGPointMake(18,2) number:count.intValue];
    [self.gouWuCheBtn addSubview:self.hongDianView];
    if (count.intValue==0)
    {
        self.hongDianView.hidden = YES;
    }

}

#pragma mark - DSRequestDelegate
-(void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    [self hideHud:nil];
    
    if (tag==1)
    {
        SuitDetailEntity *object = (SuitDetailEntity*)dataObj;
        NSMutableArray *suits = [NSMutableArray arrayWithArray:object.suits];
        for (int i=0; i<suits.count; i++)
        {
            SuitEntity *objectE = suits[i];
            
            NSMutableArray *colors = [NSMutableArray array];
            for (NSDictionary *colorSizeDic in objectE.colorandsizes)
            {
                [colors addObject:[colorSizeDic objectForKey:@"color"]];
            }
            objectE.color = colors;
        }
        object.suits = [suits copy];
        self.object = object;
        //购物车商品数量显示
        [self setGouWuCheCount:[[[NSUserDefaults standardUserDefaults]objectForKey:kGouWuCheGoodsCount] intValue]];
        [self addBounceAnimation:self.hongDianView];
        _currentYanSeBtnIndex = object.suits.count;
        
        if (object.suits.count>0)
        {
            UIView *contentV = [[UIView alloc]init];
            contentV.backgroundColor = RGBCOLOR(245, 245, 245);
            contentV.frame = CGRectMake(0,10, 300, _scrollView.contentSize.height);
            self.contentView = contentV;
            [self.scrollView addSubview:contentV];
            [contentV release];
            
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,300, 44)];
            view.backgroundColor = [UIColor clearColor];
            CGFloat y=10;
            CGFloat x=10;
            CGFloat w=150;
            CGFloat h=44;
            UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake(x,y,w,h)];
            titleL.backgroundColor = [UIColor clearColor];
            titleL.textAlignment = NSTextAlignmentLeft;
            titleL.font = [UIFont systemFontOfSize:16];
            titleL.textColor = RGBCOLOR(62,62,62);
            titleL.numberOfLines = 0;
            titleL.text = @"优惠搭配套装";
            [view addSubview:titleL];
            [titleL release];
            [contentV addSubview:view];
            [view release];
            
            x=0;
            y=titleL.frame.origin.y+titleL.frame.size.height;
            w=300;
            h=kCellHeight;
            for (int i=0; i<object.suits.count; i++)
            {
                SuitEntity *suit = object.suits[i];
                UIView *view = [self cellViewFrame:CGRectMake(x, y, w, h) object:suit tag:i isMainSp:([suit.goodsid isEqualToString:_spId]?YES:NO)];
                [contentV addSubview:view];
                y=y+kCellHeight;
            }
            
            UIImage *lineImage2=[UIImage imageNamed:@"division line.png"];
            x = 0;
            w = 320;
            h = lineImage2.size.height;
            UIImageView *lingImageView2=[[UIImageView alloc]initWithFrame:CGRectMake(x,y,w,h)];
            lingImageView2.image=lineImage2;
            [contentV addSubview:lingImageView2];
            [lingImageView2 release];
            
            UIImage *yI = GetImage(@"mall_button_buy2@2x.png");
            x=218;
            w=yI.size.width/2.0;
            h=yI.size.height/2.0;
            DSImageView *imageview = [[DSImageView alloc]initWithFrame:CGRectMake(x+2, y+15,29,29)];
            self.shangPinView = imageview;
            imageview.image = [UIImage imageNamed:@"列表小图.png"];
            imageview.hidden = YES;
            [contentV addSubview:self.shangPinView];
            [imageview release];
            UIButton *gouMaiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [gouMaiBtn setBackgroundImage:yI forState:UIControlStateNormal];
            [gouMaiBtn setBackgroundImage:GetImage(@"mall_button_buy2_press@2x.png") forState:UIControlStateHighlighted];
            [gouMaiBtn setFrame:CGRectMake(x,y+15,w,h)];
            [gouMaiBtn addTarget:self action:@selector(gouMaiTaoZhuang:) forControlEvents:UIControlEventTouchUpInside];
            [contentV addSubview:gouMaiBtn];
           

            x=10;
            w=70;
            h=20;
            UILabel *jiaGeTitleL = [[UILabel alloc]initWithFrame:CGRectMake(x,y+5,w,MAX(h, 20))];
            jiaGeTitleL.backgroundColor = [UIColor clearColor];
            jiaGeTitleL.textAlignment = NSTextAlignmentLeft;
            jiaGeTitleL.font = [UIFont systemFontOfSize:14];
            jiaGeTitleL.textColor = RGBCOLOR(150,150,150);
            jiaGeTitleL.numberOfLines = 0;
            jiaGeTitleL.text = @"套装价格：";
            [contentV addSubview:jiaGeTitleL];
            [jiaGeTitleL release];
            
            x=jiaGeTitleL.frame.origin.x+jiaGeTitleL.frame.size.width+5;
            w=100;
            h=20;
            UILabel *jiaGeL = [[UILabel alloc]initWithFrame:CGRectMake(x,y+5,w,MAX(h, 20))];
            jiaGeL.backgroundColor = [UIColor clearColor];
            jiaGeL.textAlignment = NSTextAlignmentLeft;
            jiaGeL.font = [UIFont systemFontOfSize:14];
            jiaGeL.textColor = RGBCOLOR(216,0,21);
            jiaGeL.numberOfLines = 0;
            jiaGeL.text = ([_object.suitprice isKindOfClass:[NSNull class]])?@"":_object.suitprice;
            [contentV addSubview:jiaGeL];
            [jiaGeL release];
            
            x=10;
            y=jiaGeTitleL.frame.origin.y+jiaGeTitleL.frame.size.height+7;
            w=70;
            h=20;
            UILabel *yuanJiaTitle = [[UILabel alloc]initWithFrame:CGRectMake(x,y,w,MAX(h, 20))];
            yuanJiaTitle.backgroundColor = [UIColor clearColor];
            yuanJiaTitle.textAlignment = NSTextAlignmentLeft;
            yuanJiaTitle.font = [UIFont systemFontOfSize:14];
            yuanJiaTitle.textColor = RGBCOLOR(150,150,150);
            yuanJiaTitle.numberOfLines = 0;
            yuanJiaTitle.text = @"商品原价：";
            [contentV addSubview:yuanJiaTitle];
            [yuanJiaTitle release];
            
            x=yuanJiaTitle.frame.origin.x+yuanJiaTitle.frame.size.width+5;
            w=100;
            h=20;
            UILabel *yuanjiaL = [[UILabel alloc]initWithFrame:CGRectMake(x,y,w,MAX(h, 20))];
            yuanjiaL.backgroundColor = [UIColor clearColor];
            yuanjiaL.textAlignment = NSTextAlignmentLeft;
            yuanjiaL.font = [UIFont systemFontOfSize:14];
            yuanjiaL.textColor = RGBCOLOR(150,150,150);
            yuanjiaL.numberOfLines = 0;
            yuanjiaL.text = ([_object.originalprice isKindOfClass:[NSNull class]])?@"":_object.originalprice;
            [contentV addSubview:yuanjiaL];
            [yuanjiaL release];
            
            x=10;
            y=yuanJiaTitle.frame.origin.y+yuanJiaTitle.frame.size.height+7;
            w=70;
            h=20;
            UILabel *jieShengTitleL = [[UILabel alloc]initWithFrame:CGRectMake(x,y,w,MAX(h, 20))];
            jieShengTitleL.backgroundColor = [UIColor clearColor];
            jieShengTitleL.textAlignment = NSTextAlignmentLeft;
            jieShengTitleL.font = [UIFont systemFontOfSize:14];
            jieShengTitleL.textColor = RGBCOLOR(150,150,150);
            jieShengTitleL.numberOfLines = 0;
            jieShengTitleL.text = @"立即节省：";
            [contentV addSubview:jieShengTitleL];
            [jieShengTitleL release];
            
            x=jieShengTitleL.frame.origin.x+jieShengTitleL.frame.size.width+5;
            w=100;
            h=20;
            UILabel *jieShengL = [[UILabel alloc]initWithFrame:CGRectMake(x,y,w,MAX(h, 20))];
            jieShengL.backgroundColor = [UIColor clearColor];
            jieShengL.textAlignment = NSTextAlignmentLeft;
            jieShengL.font = [UIFont systemFontOfSize:14];
            jieShengL.textColor = RGBCOLOR(30,162,16);
            jieShengL.numberOfLines = 0;
            jieShengL.text = ([_object.discount isKindOfClass:[NSNull class]])?@"":_object.discount;
            [contentV addSubview:jieShengL];
            [jieShengL release];
            
            
            y=jieShengL.frame.origin.y+jieShengL.frame.size.height;
            self.scrollView.contentSize = CGSizeMake(300,y+60);
            contentV.frame = CGRectMake(0,10, 300, _scrollView.contentSize.height-50);
            contentV.layer.cornerRadius = 3;
            contentV.layer.borderColor = RGBCOLOR(200, 200, 200).CGColor;
            contentV.layer.borderWidth = 1;
        }else
        {
            [self addFadeLabel:@"暂无商品套装"];
        }
    }
    
    if (tag==2)
    {
        StatusEntity *object = (StatusEntity*)dataObj;
        if (object.response==1)//成功
        {
            [self addToShoppingCarAnimation];
            self.gouWuCheSpCount = object.totalcount;
            [RootVC setNumber:object.totalcount ofIndex:3];
            [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:object.totalcount] forKey:kGouWuCheGoodsCount];
        }
        if (object.response==2)//失败
        {
            [self addFadeLabel:@"加入购物车失败，请重试"];
        }
    }
    
}
-(void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError*)error
{
    [self hideHud:nil];
    switch (tag)
    {
        case 1:
        {
          [self addFadeLabel:@"暂无商品套装"];
        }
            break;
        case 2:
        {
           [self addFadeLabel:@"加入购物车失败，请重试"];
        }
            break;
        default:
            break;
    }
}
-(void)bgButtonClicked:(UIButton*)btn
{
    if (btn.tag==0)
    {
        [super leftAction];
    }
    if (btn.tag<self.object.suits.count&&btn.tag!=0)
    {
        SuitEntity *suit =self.object.suits[btn.tag];
        
        NSArray *colorSizeArr = [_suitColorAndSize objectForKey:[NSString stringWithFormat:@"%i",btn.tag]];
        GoodEntity *good = nil;
        if (colorSizeArr!=nil)
        {
            good = [[GoodEntity alloc]init];
            good.goodsid = suit.goodsid;
            good.color = colorSizeArr[0];
            good.size = colorSizeArr[1];
        }
        
        ShangPingDetailVC *vc = [[ShangPingDetailVC alloc]init];
        vc.spId = suit.goodsid;
        vc.shopCarGoodEntity=good;
        [self pushViewController:vc];
        [vc release];
        if (good) {
            [good release];
        }
    }
    
}
-(UIView*)cellViewFrame:(CGRect)frame  object:(SuitEntity*)object tag:(int)btnTag isMainSp:(BOOL)isMainSp
{
    CGFloat x = 10;
    CGFloat y = 10;
    CGFloat w = 100;
    CGFloat h = 100;
    
    
    UIButton *contentView = [UIButton buttonWithType:UIButtonTypeCustom];
    contentView.frame = frame;
    contentView.backgroundColor = [UIColor clearColor];
    [contentView addTarget:self action:@selector(bgButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    contentView.tag = btnTag;
    
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, w, h)];
    view.image = [UIImage imageNamed:@"列表小图.png"];
    view.userInteractionEnabled = NO;
    [contentView addSubview:view];
    [view release];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(x+3, y+3,w-6,h-10)];
    [imageV setImageWithURL:[NSURL URLWithString:object.img] placeholderImage:[UIImage imageNamed:@""]];
    [contentView addSubview:imageV];
    imageV.userInteractionEnabled = NO;
    imageV.clipsToBounds = YES;
    if (isMainSp==YES)
    {
        self.mainImageView = imageV;
    }
    [imageV release];
    
    x=imageV.frame.origin.x+imageV.frame.size.width+9;
    y=15;
    w=180;
    h=40;
    UILabel *nameL = [[UILabel alloc]initWithFrame:CGRectMake(x,y,w,h)];
    nameL.backgroundColor = [UIColor clearColor];
    nameL.textAlignment = NSTextAlignmentLeft;
    nameL.font = [UIFont systemFontOfSize:14];
    nameL.textColor = RGBCOLOR(62,62,62);
    nameL.numberOfLines = 2;
    nameL.text = object.name;
    [contentView addSubview:nameL];
    [nameL release];
    
    y=nameL.frame.origin.y+nameL.frame.size.height+5;
    w=180;
    h=20;
    UILabel *jiaGeL = [[UILabel alloc]initWithFrame:CGRectMake(x,y,w,MAX(h, 20))];
    jiaGeL.backgroundColor = [UIColor clearColor];
    jiaGeL.textAlignment = NSTextAlignmentLeft;
    jiaGeL.font = [UIFont systemFontOfSize:14];
    jiaGeL.textColor = RGBCOLOR(220,40,49);
    jiaGeL.numberOfLines = 0;
    jiaGeL.text = object.price;
    [contentView addSubview:jiaGeL];
    [jiaGeL release];
    
    y=jiaGeL.frame.origin.y+jiaGeL.frame.size.height;
    w=(isMainSp==YES)?180:150;
    h=38;
    UILabel *yanSeL = [[UILabel alloc]initWithFrame:CGRectMake(x,y,w,MAX(h, 20))];
    yanSeL.backgroundColor = [UIColor clearColor];
    yanSeL.textAlignment = NSTextAlignmentLeft;
    yanSeL.font = [UIFont systemFontOfSize:13];
    yanSeL.textColor = ColorAndSize;//RGBCOLOR(130,130,130);
    yanSeL.numberOfLines = 2;
    yanSeL.adjustsFontSizeToFitWidth=YES;
    [contentView addSubview:yanSeL];
    [yanSeL release];
    if (isMainSp==YES)
    {
        yanSeL.text = [NSString stringWithFormat:@"颜色: %@\n尺码: %@",_mainSpColor,_mainSpSize];
    }
    if (_yanseLabArr==nil)
    {
        self.yanseLabArr = [NSMutableArray arrayWithCapacity:0];
    }
    [_yanseLabArr addObject:yanSeL];

    if (isMainSp==NO)
    {
       
        UIImage *yI = GetImage(@"mall_button_choose@2x.png");
        x=218;
        y=72;
        w=yI.size.width/2.0;
        h=yI.size.height/2.0;
        UIButton *yanSeChiMaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [yanSeChiMaBtn setBackgroundImage:yI forState:UIControlStateNormal];
        [yanSeChiMaBtn setBackgroundImage:GetImage(@"mall_button_choose_press@2x.png") forState:UIControlStateHighlighted];
        [yanSeChiMaBtn setFrame:CGRectMake(x,y,w,h)];
        [yanSeChiMaBtn addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
        yanSeChiMaBtn.tag = btnTag;
        [contentView addSubview:yanSeChiMaBtn];
    }
    
    
    UIImage *lineImage=[UIImage imageNamed:@"division line.png"];
    x = 0;
    y = 0;
    w = 320;
    h = lineImage.size.height/2;
    UIImageView *lingImageView=[[UIImageView alloc]initWithFrame:CGRectMake(x,y,w,h)];
    lingImageView.image=lineImage;
    [contentView addSubview:lingImageView];
    [lingImageView release];
    
    return contentView;
}
#pragma mark-- *******************0310
-(void)reloadPickerView:(SuitEntity*)object
{
    self.contentView.userInteractionEnabled=YES;
    self.pickerBgV.userInteractionEnabled=NO;
    self.pickerBgV.hidden=YES;
    self.chiCunSelectedView.hidden=YES;
    [self.chiCunSelectedView removeFromSuperview];
    [self initPickerView:object];
    
    self.chiCunSelectedView.hidden=NO;
    self.pickerBgV.hidden=NO;
    self.pickerBgV.userInteractionEnabled=NO;
    self.contentView.userInteractionEnabled=NO;
    CGFloat height = ([self isBigPickerMaxHeight:object])?kMaxPickerHeight:[self heightForHeader:object];
    CGRect frame = self.chiCunSelectedView.frame;
    frame.origin.y-=height;
    self.chiCunSelectedView.frame=frame;
    self.pickerBgV.userInteractionEnabled=YES;
    
}
-(void)initPickerView:(SuitEntity*)object
{
    if (_pickerBgV==nil)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,MainViewWidth, MainViewHeight)];
        view.backgroundColor = [UIColor colorWithRed:10/255.0 green:10/255.0 blue:10/255.0 alpha:0.5];
        [self.view addSubview:view];
        self.pickerBgV = view;
        [view release];
    }
   self.pickerBgV.hidden = YES;
    
    CGFloat x=0;
    CGFloat y=MainViewHeight;
    CGFloat w=MainViewWidth;
    CGFloat h=([self isBigPickerMaxHeight:object])?kMaxPickerHeight:[self heightForHeader:object];
    _bounceOutHeight = y-h;
    UIImage *seletedImage = [UIImage imageNamed:@"bg_picker@2x.png"];
    UIImageView *chiCunSelectedBgV = [[UIImageView alloc]initWithFrame:CGRectMake(x,y,w,h)];
    chiCunSelectedBgV.image = seletedImage;
    chiCunSelectedBgV.userInteractionEnabled = YES;
    self.chiCunSelectedView = chiCunSelectedBgV;
    [self.view addSubview:chiCunSelectedBgV];
    [chiCunSelectedBgV release];
    
    y=10;
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(x,y,w,h-10)];
    scroll.backgroundColor = [UIColor clearColor];
    scroll.contentSize = CGSizeMake(MainViewWidth,[self heightForHeader:object]);
    scroll.showsVerticalScrollIndicator = NO;
    scroll.scrollEnabled=[self isBigPickerMaxHeight:object]?YES:NO;
    [self.chiCunSelectedView addSubview:scroll];
    [scroll release];
    
    
     x=10;
     y=5;
     w=300;
     h= 30;
    UIView *yanSeView = [[UIView alloc]initWithFrame:CGRectMake(x,y,w,MAX(h, 30))];
    yanSeView.backgroundColor = [UIColor clearColor];
    [scroll addSubview:yanSeView];
    [yanSeView release];
    
    UILabel *yanSeL = [[UILabel alloc]initWithFrame:CGRectMake(0,0,45,30)];
    yanSeL.backgroundColor = [UIColor clearColor];
    yanSeL.text = @"颜色:";
    yanSeL.textAlignment = NSTextAlignmentLeft;
    yanSeL.font = [UIFont systemFontOfSize:15];
    yanSeL.textColor = RGBCOLOR(60,60,60);
    yanSeL.numberOfLines = 0;
    if (object.color.count>0)
    {
        [yanSeView addSubview:yanSeL];
        [yanSeL release];
        x=yanSeL.frame.origin.x+yanSeL.frame.size.width;
    }
    
    y=0;
    w=82;
    h=32;
    _colorArr = [[NSMutableArray arrayWithCapacity:0]retain];
    for (int i=0; i<object.color.count; i++)
    {
        UIButton *yansebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        yansebtn.tag = i+yansebtnBaseTag;
        yansebtn.frame = CGRectMake(x,y,w,h);
        [yansebtn setTitle:object.color[i] forState:UIControlStateNormal];
        [yansebtn setTitleColor:RGBCOLOR(60,60,60) forState:UIControlStateNormal];
        [yansebtn setBackgroundImage:GETIMG(@"mall_button_colour@2x.png") forState:UIControlStateNormal];
        [yansebtn setBackgroundImage:GETIMG(@"mall_button_colour_sel@2x.png") forState:UIControlStateHighlighted];
        [yansebtn setBackgroundImage:GETIMG(@"mall_button_colour_sel@2x.png") forState:UIControlStateSelected];
        yansebtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [yansebtn addTarget:self action:@selector(colorSelected:) forControlEvents:UIControlEventTouchUpInside];
        [yanSeView addSubview:yansebtn];
        [_colorArr addObject:yansebtn];
        if ((i+1)%3==0)
        {
            if (i!=0)
            {
                x=yanSeL.frame.origin.x+yanSeL.frame.size.width;
                y = y+35;
            }else
            {
                x=yansebtn.frame.origin.x+yansebtn.frame.size.width+5;
            }
        }else
        {
            x=yansebtn.frame.origin.x+yansebtn.frame.size.width+5;
        }
    }
    if (_colorArr.count>0)
    {
        UIButton *colorBtn = (UIButton*)_colorArr[_colorArr.count-1];
        y = colorBtn.frame.origin.y+colorBtn.frame.size.height;
        CGRect yanSeFrame = yanSeView.frame;
        yanSeFrame.size.height = y;
        yanSeView.frame = yanSeFrame;
    }
    
    y = yanSeView.frame.origin.y+yanSeView.frame.size.height+10;
    if (object.color.count==0)
    {
        y=5;
    }
    x=10;
    w=300;
    h= 35;
    UIView *chiMaView = [[UIView alloc]initWithFrame:CGRectMake(x,y,w,MAX(h, 30))];
    chiMaView.backgroundColor = [UIColor clearColor];
    [scroll addSubview:chiMaView];
    [chiMaView release];
    
    UILabel *chiMaL = [[UILabel alloc]initWithFrame:CGRectMake(0,0,45,30)];
    chiMaL.backgroundColor = [UIColor clearColor];
    chiMaL.text = @"尺码:";
    chiMaL.textAlignment = NSTextAlignmentLeft;
    chiMaL.font = [UIFont systemFontOfSize:15];
    chiMaL.textColor = RGBCOLOR(62,62,62);
    chiMaL.numberOfLines = 0;
#pragma mark-- ************************0310
    NSArray *sizes = nil;
    sizes = [self sizesWithObject:object];
    if (sizes.count>0)
    {
        [chiMaView addSubview:chiMaL];
        [chiMaL release];
        x=chiMaL.frame.origin.x+chiMaL.frame.size.width;
    }
    
    y=0;
    w=117;
    h=32;
    _chiCunArr = [[NSMutableArray arrayWithCapacity:0]retain];
    for (int i=0; i<sizes.count; i++)
    {
        UIButton *chiMaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        chiMaBtn.tag = i+chiMaBtnBaseTag;
        chiMaBtn.frame = CGRectMake(x,y,w,h);
        [chiMaBtn setTitle:[sizes[i] objectForKey:@"size"] forState:UIControlStateNormal];
        [chiMaBtn setTitleColor:RGBCOLOR(60,60,60) forState:UIControlStateNormal];
        [chiMaBtn setBackgroundImage:GETIMG(@"mall_button_size@2x.png") forState:UIControlStateNormal];
        [chiMaBtn setBackgroundImage:GETIMG(@"mall_button_size_sel@2x.png") forState:UIControlStateHighlighted];
        [chiMaBtn setBackgroundImage:GETIMG(@"mall_button_size_sel@2x.png") forState:UIControlStateSelected];
         [chiMaBtn setBackgroundImage:GetImage(@"mall_button_size_dis@2x.png") forState:UIControlStateDisabled];
        chiMaBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [chiMaBtn addTarget:self action:@selector(chiCunSelected:) forControlEvents:UIControlEventTouchUpInside];
        [chiMaView addSubview:chiMaBtn];
        [_chiCunArr addObject:chiMaBtn];
        if ((i+1)%2==0)
        {
            if (i!=0)
            {
                x=chiMaL.frame.origin.x+chiMaL.frame.size.width;
                y = y+35;
            }else
            {
                x=chiMaBtn.frame.origin.x+chiMaBtn.frame.size.width+8;
            }
        }else
        {
            x=chiMaBtn.frame.origin.x+chiMaBtn.frame.size.width+8;
        }
        //如果一种尺码没有库存就把按钮置灰
        if ([[sizes[i] objectForKey:@"store"] integerValue]==0)
        {
            chiMaBtn.enabled=NO;
        }else
        {
            chiMaBtn.enabled=YES;
        }
    }
    
      if (_chiCunArr.count>0)
      {
        UIButton *chiMaBtn = (UIButton*)_chiCunArr[_chiCunArr.count-1];
        y = chiMaBtn.frame.origin.y+chiMaBtn.frame.size.height;
        CGRect chiMaFrame = chiMaView.frame;
        chiMaFrame.size.height = y;
        chiMaView.frame = chiMaFrame;
      }
    
    if (_isReload==NO)
    {
        //已选择颜色显示
        NSArray *colorSizeArr = [_suitColorAndSize objectForKey:[NSString stringWithFormat:@"%i",_currentYanSeBtnIndex]];
        NSString *color = nil;
        NSString *size = nil;
        if (colorSizeArr.count==2)
        {
            color = colorSizeArr[0];
            size = colorSizeArr[1];
        }
        
        for (UIButton *btn in _colorArr)
        {
            if ([[btn titleForState:UIControlStateNormal] isEqualToString:color])
            {
                btn.selected = YES;
                self.curSelectColor = [btn titleForState:UIControlStateNormal];
                [self.cacheColorSize setObject:self.curSelectColor forKey:@"color"];
                break;
            }
        }
        for (UIButton *btn in _chiCunArr)
        {
            if ([[btn titleForState:UIControlStateNormal] isEqualToString:size])
            {
                [self chiCunSelected:btn];
                break;
            }
        }
 
    }else
    {
        for (UIButton *btn in _colorArr)
        {
            btn.selected = NO;
        }
        for (UIButton *btn in _colorArr)
        {
            if ([self.curSelectColor isEqualToString:[btn titleForState:UIControlStateNormal]])
            {
                btn.selected = YES;
            }
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark -- 按钮
-(void)gouMaiTaoZhuang:(UIButton*)btn
{
    if (!(_mainSpColor.length>0&&_mainSpSize.length>0))
    {
        [self addFadeLabel:@"抱歉，主商品库存不足"];
        return;
    }
    if (_suitColorAndSize.count<self.object.suits.count)
    {
        [self addFadeLabel:@"请先选择好颜色和尺码"];
        return;
    }
    NSMutableArray *goodsList = [NSMutableArray arrayWithCapacity:0];
    for (int i=0; i<self.object.suits.count; i++)
    {
        SuitEntity *suit =self.object.suits[i];
        NSMutableDictionary *good = [NSMutableDictionary dictionaryWithCapacity:0];
        [good setObject:suit.goodsid forKey:@"goodsid"];
        NSArray *colorSize = [_suitColorAndSize objectForKey:[NSString stringWithFormat:@"%i",i]];
        [good setObject:colorSize[0] forKey:@"color"];
        [good setObject:colorSize[1] forKey:@"size"];
        [goodsList addObject:good];
    }
    
    [self addHud:@"请稍后..."];
    DSRequest *request = [[DSRequest alloc]init];
    request.delegate = self;
    [request requestDataWithInterface:AddToShoppingCar param:[self AddToShoppingCarParam:goodsList issuit:1] tag:2];
    [request release];
}
-(void)gouWuCheBtnClicked:(UIButton*)btn
{
    [self popToRoot];
    [[NSNotificationCenter defaultCenter]postNotificationName:kSPDetailShopCarClickedNotification object:self];
}
#pragma mark--颜色尺码按钮选择
-(void)clickedButton:(UIButton*)btn
{
    int index = btn.tag;
    _currentYanSeBtnIndex = btn.tag;
    _isReload = NO;
    [self initPickerView:self.object.suits[index]];
    [self viewInAnimation:self.chiCunSelectedView object:self.object.suits[index]];
    self.curYanSeBtn = btn;
    btn.enabled = NO;
}

-(void)chiCunSelected:(UIButton*)btn
{
    for (UIButton *btn in _chiCunArr)
    {
        btn.selected = NO;
    }
    btn.selected = YES;
    self.curSelectSize = [btn titleForState:UIControlStateNormal];
}

-(void)colorSelected:(UIButton*)btn
{
    if ([_curSelectColor isEqualToString:[btn titleForState:UIControlStateNormal]])
    {
        return;
    }
    _isReload = YES;
    self.curSelectColor = [btn titleForState:UIControlStateNormal];
    [self.cacheColorSize setObject:self.curSelectColor forKey:@"color"];
    [self reloadPickerView:self.object.suits[_currentYanSeBtnIndex]];
}
-(void)sel:(UIButton*)btn
{
    for (UIButton *btn in _colorArr)
    {
        btn.selected = NO;
    }
    btn.selected = YES;
}
#pragma mark-- *********************0310
-(NSArray*)sizesWithObject:(SuitEntity*)object
{
    NSArray *sizes = nil;
    if (_isReload==NO)
    {
        NSArray *ColorSizeArr = [_suitColorAndSize objectForKey:[NSString stringWithFormat:@"%i",_currentYanSeBtnIndex]];
        if (ColorSizeArr)
        {
            NSDictionary *colorObject=nil;
            for (NSDictionary *colorDic in object.colorandsizes)
            {
                NSString *color = [colorDic objectForKey:@"color"];
                if ([color isEqualToString:ColorSizeArr[0]])
                {
                    colorObject = colorDic;
                    break;
                }
            }
            sizes = [colorObject objectForKey:@"sizeandstore"];
        }else
        {
            sizes = [object.colorandsizes[0] objectForKey:@"sizeandstore"];
        }
        
    }else
    {
        if (self.curSelectColor.length>0)
        {
            NSDictionary *colorObject=nil;
            for (NSDictionary *colorDic in object.colorandsizes)
            {
                NSString *color = [colorDic objectForKey:@"color"];
                if ([color isEqualToString:self.curSelectColor])
                {
                    colorObject = colorDic;
                    break;
                }
            }
            sizes = [colorObject objectForKey:@"sizeandstore"];
        }
    }

    return sizes;
}
-(CGFloat)heightForHeader:(SuitEntity*)object
{
    CGFloat height = 0;
    int colorCount = ((object.color.count%3)==0)?object.color.count/3:(object.color.count/3)+1;
    CGFloat h2 = colorCount*32+(colorCount-1)*3;
    
    NSArray *sizes = [self sizesWithObject:object];
    int chiCunCount = ((sizes.count%2)==0)?sizes.count/2:(sizes.count/2)+1;
    CGFloat h3 = chiCunCount*32+(chiCunCount-1)*3;
    height = 15+h2+10+h3+40;
    
    return height;
}
-(BOOL)isBigPickerMaxHeight:(SuitEntity*)object
{
    if ([self heightForHeader:object]>=kMaxPickerHeight)
    {
        return YES;
    }else
    {
        return NO;
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
     UITouch *touch = [touches anyObject];
     CGPoint location = [touch  locationInView:self.view];
    if (location.y<_bounceOutHeight)
    {
        [self viewOutAnimation:self.chiCunSelectedView];
       
        if (_curSelectColor.length>0&&_curSelectSize.length>0)
        {
            UILabel *label = [_yanseLabArr objectAtIndex:_currentYanSeBtnIndex];
            label.text = [NSString stringWithFormat:@"颜色: %@\n尺码: %@",_curSelectColor,_curSelectSize];
            [_suitColorAndSize setObject:[NSArray arrayWithObjects:self.curSelectColor,self.curSelectSize, nil] forKey:[NSString stringWithFormat:@"%i",_currentYanSeBtnIndex]];
        }
        self.curSelectColor = @"";
        self.curSelectSize = @"";
        self.curYanSeBtn.enabled = YES;
    }
}
#pragma mark -- animation
#pragma mark --animation
- (void)zoomIn: (UIView *)view andAnimationDuration: (float) duration andWait:(BOOL) wait sx:(CGFloat)sx sy:(CGFloat)sy ex:(CGFloat)ex ey:(CGFloat)ey
{
    __block BOOL done = wait;
    view.transform = CGAffineTransformMakeScale(sx, sy);
    [UIView animateWithDuration:duration animations:^{
        view.transform = CGAffineTransformMakeScale(ex, ey);
        
    } completion:^(BOOL finished) {
        done = NO;
    }];
    while (done == YES)
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
}
- (void)zoomOut: (UIView *)view andAnimationDuration: (float) duration andWait:(BOOL) wait sx:(CGFloat)sx sy:(CGFloat)sy ex:(CGFloat)ex ey:(CGFloat)ey
{
    __block BOOL done = wait;
    view.transform = CGAffineTransformMakeScale(sx,sy);
    [UIView animateWithDuration:duration animations:^{
        view.transform = CGAffineTransformIdentity;
        view.transform = CGAffineTransformMakeScale(ex,ey);
        
    } completion:^(BOOL finished) {
        done = NO;
    }];
    while (done == YES)
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
}
#pragma mark--出现隐藏动画
-(void)viewInAnimation:(UIView*)view object:(SuitEntity*)object
{
    view.hidden=NO;
    self.pickerBgV.hidden=NO;
    self.pickerBgV.userInteractionEnabled=NO;
    self.contentView.userInteractionEnabled=NO;
    [UIView beginAnimations:@"In" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView setAnimationDuration:0.3];
    CGFloat height = ([self isBigPickerMaxHeight:object])?kMaxPickerHeight:[self heightForHeader:object];
    CGRect frame = self.chiCunSelectedView.frame;
    frame.origin.y-=height;
    self.chiCunSelectedView.frame=frame;
    [UIView commitAnimations];
}
-(void)viewOutAnimation:(UIView*)view
{
    [UIView beginAnimations:@"Out" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView setAnimationDuration:0.2];
    CGRect frame = self.chiCunSelectedView.frame;
    frame.origin.y = MainViewHeight;
    self.chiCunSelectedView.frame=frame;
    [UIView commitAnimations];
}
-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID isEqualToString:@"In"])
    {
        self.pickerBgV.userInteractionEnabled=YES;
    }
    if ([animationID isEqualToString:@"Out"])
    {
        self.contentView.userInteractionEnabled=YES;
        self.pickerBgV.userInteractionEnabled=NO;
        self.pickerBgV.hidden=YES;
        self.chiCunSelectedView.hidden=YES;
        [self.chiCunSelectedView removeFromSuperview];
    }
}
-(void)hiddenPickerView:(UIView*)view
{
    view.hidden = YES;
}
#pragma mark -- 数量红点
-(UIView*)hongDianPoint:(CGPoint)point number:(int)count
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(point.x, point.y,20,14);
    btn.userInteractionEnabled = NO;
    btn.backgroundColor = RGBCOLOR(251, 66, 55);
    btn.layer.cornerRadius = 6;
    CGFloat fontSize = 0;
    if (count<10)
    {
        fontSize = 13;
    }else if(count>=10&&count<=99)
    {
        fontSize = 11;
    }else
    {
        fontSize = 10;
    }
    NSString *countStr = @"";
    if (count<=99)
    {
        countStr = [NSString stringWithFormat:@"%i",count];
    }else{
        countStr = @"99+";
    }
    [btn setTitle:countStr forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:fontSize];
    btn.tag = 0x1234;
    return btn ;
}
//购物车商品数量显示
-(void)setGouWuCheCount:(int)count
{
    if (count<=0)
    {
        self.hongDianView.hidden=YES;
    }else
    {
        self.hongDianView.hidden=NO;
    }
    CGFloat fontSize = 0;
    if (count<10)
    {
        fontSize = 13;
    }else if(count>=10&&count<=99)
    {
        fontSize = 11;
    }else
    {
        fontSize = 10;
    }
    NSString *countStr = @"";
    if (count<=99)
    {
        countStr = [NSString stringWithFormat:@"%i",count];
    }else{
        countStr = @"99+";
    }
    
    [((UIButton*)self.hongDianView) setTitle:countStr forState:UIControlStateNormal];
    [((UIButton*)self.hongDianView) setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ((UIButton*)self.hongDianView).titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:fontSize];
}

//BounceAnimation
- (void) addBounceAnimation:(UIView*)view
{
	SKBounceAnimation *bounceAnimation = [SKBounceAnimation animationWithKeyPath:@"bounds"];
	bounceAnimation.fromValue = [NSValue valueWithCGRect:view.frame];
	bounceAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0,0,14,20)];
	bounceAnimation.duration = 0.8f;
	bounceAnimation.numberOfBounces = 5;
    
	bounceAnimation.removedOnCompletion = NO;
	bounceAnimation.fillMode = kCAFillModeForwards;
    
	[view.layer addAnimation:bounceAnimation forKey:@"someKey"];
}
//加入购物车动画效果 步骤1
-(void)addToShoppingCarAnimation
{
    if (self.mainImageView.image)
    {
        self.shangPinView.image = self.mainImageView.image;
    }else
    {
        self.shangPinView.image = [UIImage imageNamed:@"列表小图.png"];
    }
    
    //购物图像
    CALayer *transitionLayer = [[CALayer alloc] init];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    transitionLayer.opacity = 1.0;
    transitionLayer.contents = (id)(self.shangPinView.layer.contents);
    transitionLayer.frame = [[UIApplication sharedApplication].keyWindow convertRect:self.shangPinView.bounds fromView:self.shangPinView];
    [[UIApplication sharedApplication].keyWindow.layer addSublayer:transitionLayer];
    [CATransaction commit];
    
    //路径曲线
    UIBezierPath *movePath = [UIBezierPath bezierPath];
    [movePath moveToPoint:transitionLayer.position];
    CGPoint toPoint = CGPointMake(self.gouWuCheBtn.center.x, self.gouWuCheBtn.center.y+20);
    [movePath addCurveToPoint:toPoint controlPoint1:CGPointMake(transitionLayer.frame.origin.x+80,transitionLayer.frame.origin.y-180) controlPoint2:CGPointMake(self.gouWuCheBtn.center.x,transitionLayer.position.y)];
     //关键帧
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.path = movePath.CGPath;
    positionAnimation.removedOnCompletion = YES;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.beginTime = CACurrentMediaTime();
    group.duration = 0.5f;
    group.animations = [NSArray arrayWithObjects:positionAnimation,nil];
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    group.autoreverses = NO;
    
    [transitionLayer addAnimation:group forKey:@"opacity"];
    [self performSelector:@selector(addGouWuCheFinished:) withObject:transitionLayer afterDelay:0.5f];
}
//加入购物车 步骤2
- (void)addGouWuCheFinished:(CALayer*)transitionLayer
{
    transitionLayer.hidden = YES;
    [transitionLayer removeAllAnimations];
    
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:self.gouWuCheSpCount] forKey:kGouWuCheGoodsCount];
    //购物车商品数量显示
    self.hongDianView.hidden = NO;
    [self setGouWuCheCount:self.gouWuCheSpCount];
    [self addBounceAnimation:self.hongDianView];
}

@end
