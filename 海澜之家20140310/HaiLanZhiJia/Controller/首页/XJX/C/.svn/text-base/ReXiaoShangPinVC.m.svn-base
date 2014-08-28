//
//  ReXiaoShangPinVC.m
//  HaiLanZhiJia
//
//  Created by xiaojiaxi on 13-11-27.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "ReXiaoShangPinVC.h"
#import "DSSegmentControl.h"
#import "SPLieBiaoCell.h"
#import "arrowView.h"
#import "PullTableView.h"
#import "SPGongGeCell.h"
#import "ShangPingDetailVC.h"
#import "SearchResultEntity.h"
typedef enum
{
    xinPin=0,
    xiaoLiang=1,
    jiaGe=2,
    haoPing=3
}DetailType;
typedef enum
{
    lieBiao=0,
    gongGe=1
}LookStyle;
typedef enum
{
    gaoToDi=0,
    diToGao=1
}JiaGePaiXuStyle;

#define kShaiXuanBtnTag 0x1111
#define tableViewTag 0x9999
#define biaoMianimage1 @"mall_icon_price_up@2x.png"
#define biaoMianimage2 @"mall_icon_price_down@2x.png"
#define biaoMianimage4 @"mall_icon_price_nor@2x.png"
#define biaoMianimage3 @"search_icon_search_tab@2x.png"
#define kTitleLength  10
#define kSearchTitleLength 4
@interface ReXiaoShangPinVC ()<UITableViewDataSource,UITableViewDelegate,DSSegmentControlDelegate,PullTableViewDelegate,SPGongGeCellDelegate>
@property(nonatomic,retain)NSMutableArray *spArr;
@property(nonatomic,assign)DetailType theType;
@property(nonatomic,assign)LookStyle  lookStyle;
@property(nonatomic,assign)JiaGePaiXuStyle  jiageStyle;
@property(nonatomic,retain)PullTableView *tableView;
@property(nonatomic,retain)UIImageView *souSuoV;
@property(nonatomic,assign)NSUInteger curPage;//当前请求页码
@property(nonatomic,assign)BOOL isFirstClickedJiaGeBtn;
@property(nonatomic,retain)SearchResultEntity *searchResultEntity;
@property(nonatomic,retain)UILabel *searchResultLabel;
@property(nonatomic,retain)UIScrollView  *hotKeyView;
@property(nonatomic,retain)UIView  *searchFailView;
@property(nonatomic,retain)UIView *failView;
@property(nonatomic,retain)NSArray *shaiXuanArr;
@property(nonatomic,assign)BOOL isNeedAddCurPage;
@property(nonatomic,retain)UILabel *tiShiLabel;
@property(nonatomic,assign)NSUInteger currentSegmentIndex;
@end

@implementation ReXiaoShangPinVC
-(void)dealloc
{
    [_title_ release];_title_=nil;
    [_spId release];_spId=nil;
    [_spArr release];_spArr=nil;
    [_tableView release];_tableView=nil;
    [_souSuoV release];_souSuoV=nil;
    [_searchResultEntity release];_searchResultEntity=nil;
    [_searchResultLabel release];_searchResultLabel=nil;
    [_hotKeyView release];_hotKeyView=nil;
    [_searchFailView release];_searchFailView=nil;
    [_failView release];_failView = nil;
    [_shaiXuanArr release];_shaiXuanArr = nil;
    [_tiShiLabel release];_tiShiLabel = nil;
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
    
    if (_comeFromType==PushComeFromSouSuo||_comeFromType==PushComeFromReMai)
    {
        [super leftAction];
    }
    if (_comeFromType==PushComeFromFenLei)
    {
        [self.mmdc leftAction];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_comeFromType==PushComeFromSouSuo)
    {
        _theType = haoPing;
    }else
    {
        _theType = xinPin;
    }
    _lookStyle = gongGe;
    _jiageStyle = diToGao;//默认低到高吧
    _curPage = 1;
    _currentSegmentIndex=0;
    _isFirstClickedJiaGeBtn = YES;
    
    [self initTitleBar];
    
    [self performSelector:@selector(doAfterViewDidLoad) withObject:nil afterDelay:0.1];

}
-(void)doAfterViewDidLoad
{
    [self initSubview];
    self.shaiXuanArr = [NSArray array];
    [self refreshData:self.shaiXuanArr isRefresh:YES];
}
-(void)requestDatasourceWithShaiXuanArr:(NSArray*)shaiXuanArr type:(int)theType tag:(int)theTag
{
    [self addHud:@""];
    DSRequest *request = [[DSRequest alloc]init];
    request.delegate = self;
    if (_comeFromType==PushComeFromSouSuo)
    {
        [request requestDataWithInterface:GetTextSearchResult param:[self  GetTextSearchResultParam:_title_ type:theType page:_curPage] tag:theTag];
    }else
    {
        [request requestDataWithInterface:GetGoodsList param:[self  GetGoodsListParam:_spId subspec:shaiXuanArr type:theType page:_curPage] tag:theTag];
    }
    [request release];
}
#pragma mark - DSRequestDelegate
-(void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    [self hideHud:nil];
    self.failView.hidden = YES;
    self.tableView.pullTableIsRefreshing = NO;
    self.tableView.pullTableIsLoadingMore = NO;
    
    switch (tag)
    {
        case 1://refresh
        {
            if (_spArr == nil)
            {
                _spArr = [[NSMutableArray arrayWithCapacity:0]retain];
            }else
            {
              [_spArr removeAllObjects];
            }
            
            if (_comeFromType==PushComeFromSouSuo)
            {
                
                
                self.searchResultEntity = (SearchResultEntity*)dataObj;
                if (self.searchResultEntity.goodslist.count<=0)
                {
                    self.searchFailView.hidden=NO;
                    [self refreshKeyWordViewBy:self.searchResultEntity.failkeywords];
                    
                    _isNeedAddCurPage=NO;
                }else
                {
                    [self reloadSearchResultLabel];
                    self.searchFailView.hidden=YES;
                    [self.spArr addObjectsFromArray:self.searchResultEntity.goodslist];
                    [self.tableView reloadData];
                    
                    _isNeedAddCurPage=YES;
                }
            }
            if (_comeFromType==PushComeFromFenLei||_comeFromType==PushComeFromReMai)
            {
                [self.spArr addObjectsFromArray:(NSMutableArray*)dataObj];
                _tiShiLabel.hidden = YES;
                if (self.spArr.count<=0)
                {
                    if (_tiShiLabel==nil)
                    {
                        UILabel *lbl = [[[UILabel alloc] initWithFrame:CGRectMake(0,30,MainViewWidth, 20)] autorelease];
                        lbl.textAlignment = NSTextAlignmentCenter;
                        lbl.textColor = RGBCOLOR(160,160,160);
                        lbl.font = [UIFont systemFontOfSize:14.0f];
                        lbl.backgroundColor = [UIColor clearColor];
                        self.tiShiLabel=lbl;
                        [self.tableView addSubview:lbl];
                    }
                    
                    if (_spArr.count<=0)
                    {
                        _tiShiLabel.hidden=NO;
                    }
                    
                    _tiShiLabel.text = (self.shaiXuanArr.count<=0)?@"暂无商品，请稍后再来":@"暂时没有符合条件的商品，换个条件试试吧。";
                    
                    [self.tableView reloadData];
                    _isNeedAddCurPage=NO;
                    return;
                }
                _isNeedAddCurPage = YES;
                [self.tableView reloadData];
            }
            
        }
            break;
        case 2://more
        {
            if (!self.spArr)
            {
                self.spArr = [NSMutableArray arrayWithCapacity:0];
            }
            if (_comeFromType==PushComeFromFenLei||_comeFromType==PushComeFromReMai)
            {
                if (((NSMutableArray*)dataObj).count==0)
                {
                    [self addFadeLabel:@"当前没有更多商品了"];
                    _isNeedAddCurPage=NO;
                    return;
                }else
                {
                    [self.spArr addObjectsFromArray:(NSMutableArray*)dataObj];
                    _isNeedAddCurPage=YES;
                }
            }
            if (_comeFromType==PushComeFromSouSuo)
            {
                if (((SearchResultEntity*)dataObj).goodslist.count==0)
                {
                    [self addFadeLabel:@"搜索不到更多商品了"];
                    _isNeedAddCurPage=NO;
                    return;
                }else
                {
                  self.searchResultEntity = (SearchResultEntity*)dataObj;
                  [self.spArr addObjectsFromArray:self.searchResultEntity.goodslist];
                    _isNeedAddCurPage=YES;
                }
            }
            [self.tableView reloadData];
        }
            break;
        default:
            break;
    }
}
-(void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError*)error
{
    [self hideHud:nil];
    _isNeedAddCurPage=NO;
    switch (tag)
    {
        case 1:
        {
            [self.spArr removeAllObjects];
            [self.tableView reloadData];
            [self initFailView:NO];
            self.failView.hidden = NO;
        }
            break;
        case 2:
        {
            if (_comeFromType==PushComeFromFenLei||_comeFromType==PushComeFromReMai) {
              [self addFadeLabel:@"当前没有更多商品了"];
            }
            if (_comeFromType==PushComeFromSouSuo) {
                [self addFadeLabel:@"搜索不到更多商品了"];
            }
        }
            break;
        default:
            break;
    }
}
-(void)initFailView:(BOOL)isTiShi
{
    if (_failView==nil)
    {
        CGRect myRect  = self.view.bounds;
        _failView = [[UIView alloc]initWithFrame:CGRectMake(myRect.origin.x, myRect.origin.y+TITLEHEIGHT, myRect.size.width, myRect.size.height-TITLEHEIGHT)];
        [self.view addSubview:_failView];
    }
    for (UIView *subView in _failView.subviews)
    {
        [subView removeFromSuperview];
    }
    if (isTiShi==NO)
    {
        UILabel *lbl = [[[UILabel alloc] initWithFrame:CGRectMake(0,140-45,MainViewWidth, 20)] autorelease];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.textColor = RGBCOLOR(62, 62, 62);
        lbl.font = [UIFont systemFontOfSize:15.0f];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.text = @"咦，数据加载失败了";
        [_failView addSubview:lbl];
        
        UILabel *lbl2 = [[[UILabel alloc] initWithFrame:CGRectMake(0,170-45,MainViewWidth, 20)] autorelease];
        lbl2.textAlignment = NSTextAlignmentCenter;
        lbl2.textColor = RGBCOLOR(82, 82, 82);
        lbl2.font = [UIFont systemFontOfSize:14.0f];
        lbl2.backgroundColor = [UIColor clearColor];
        lbl2.text = @"请检查下您的网络，重新加载吧";
        [_failView addSubview:lbl2];
        
        UIImage *bgI = [UIImage imageNamed:@"default_button@2x.png"];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(MainViewWidth/2-bgI.size.width/4,210-45,bgI.size.width/2, bgI.size.height/2-5);
        [btn setBackgroundImage:[UIImage imageNamed:@"default_button@2x.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"default_button_press@2x.png"] forState:UIControlStateHighlighted];
        [btn setTitle:@"重新加载" forState:UIControlStateNormal];
        [btn setTitleColor:RGBCOLOR(62, 62, 62) forState:UIControlStateNormal];
        [btn addTarget:self
                action:@selector(refreshDataWhenFailRequest)
      forControlEvents:UIControlEventTouchUpInside];
        [_failView addSubview:btn];
    }else
    {
        UILabel *lbl = [[[UILabel alloc] initWithFrame:CGRectMake(0,30,MainViewWidth, 20)] autorelease];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.textColor = RGBCOLOR(160,160,160);
        lbl.font = [UIFont systemFontOfSize:14.0f];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.text = (self.shaiXuanArr.count<=0)?@"暂无商品，请稍后再来":@"暂时没有符合条件的商品，换个条件试试吧。";
        [_failView addSubview:lbl];
        
    }
    
}
-(void)refreshDataWhenFailRequest
{
    [self refreshData:self.shaiXuanArr isRefresh:YES];
}
-(void)initTitleBar
{
    self.view.backgroundColor =RGBCOLOR(245, 245, 245);
    
    NSString *str = nil;
    if (_title_.length>kTitleLength) {
        str = [NSString stringWithFormat:@"%@...",[_title_ substringToIndex:kTitleLength]];
    }else
    {
        str = _title_;
    }
    
    [self setTitleString:str];
}
-(void)initSubview
{
    
    CGFloat x=0,y=0,w=0,h=0;
    if (_comeFromType==PushComeFromFenLei)
    {
        UIImage *rightImage=[UIImage imageNamed:@"button1@2x.png"];
         x = 250;
         y = [self getTitleBarHeight]/2.0-rightImage.size.height/3.6;
         w = rightImage.size.width/1.5;
         h = rightImage.size.height/1.8;
        UIButton *shaiXuanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        shaiXuanBtn.tag = kShaiXuanBtnTag;
        shaiXuanBtn.frame = CGRectMake(x,y,w,h);
        [shaiXuanBtn setBackgroundImage:GETIMG(@"button1_press@2x.png") forState:UIControlStateHighlighted];
        [shaiXuanBtn setBackgroundImage:GETIMG(@"button1@2x.png") forState:UIControlStateNormal];
        [shaiXuanBtn setTitle:@"" forState:UIControlStateNormal];
        [shaiXuanBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *btnI = [UIImage imageNamed:@"mall_icon_shaixuan@2x.png"];
        [shaiXuanBtn setImage:btnI forState:UIControlStateNormal];
        shaiXuanBtn.imageEdgeInsets = UIEdgeInsetsMake(5,15,5,15);
        [self.titleBar addSubview:shaiXuanBtn];
    }
   
    
    DSSegmentControl *segmentControl = [[DSSegmentControl alloc]initWithFrame:CGRectMake(0,[self getTitleBarHeight],320,45)];
    segmentControl.backgroundImage = @"tab_bg@2x.png";
    segmentControl.highlightImages = [NSArray arrayWithObjects:@"tab_sel4@2x.png",@"tab_sel4@2x.png",@"tab_sel4@2x.png", @"tab_sel4@2x.png",nil];
    if (_comeFromType==PushComeFromFenLei||_comeFromType==PushComeFromReMai)
    {
        segmentControl.biaoMianImages = [NSArray arrayWithObjects:@"0",@"0",@"1",@"0", nil];
        segmentControl.titles = [NSArray arrayWithObjects:@"新品",@"销量",@"价格",@"好评", nil];
    }
    if (_comeFromType==PushComeFromSouSuo)
    {
        segmentControl.biaoMianImages = [NSArray arrayWithObjects:@"0",@"0",@"1",@"1", nil];
        segmentControl.titles = [NSArray arrayWithObjects:@"好评",@"销量",@"价格",@"搜索", nil];
    }
    segmentControl.colorN = [UIColor colorWithRed:47/255.0 green:47/255.0 blue:47/255.0 alpha:1];
    segmentControl.colorH = [UIColor colorWithRed:29/255.0 green:20/255.0 blue:92/255.0 alpha:1];
    segmentControl.delegate = self;
    [segmentControl initSegmentControl];
    [self.view addSubview:segmentControl];
    [segmentControl release];
    
    
    y = segmentControl.frame.size.height+segmentControl.frame.origin.y+3;
    PullTableView *tableView = [[PullTableView alloc]initWithFrame:CGRectMake(0,y, 320, MainViewHeight-20-[self getTitleBarHeight]-45)];
    [tableView setBackgroundColor:[UIColor clearColor]];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.pullDelegate = self;
    tableView.pullLastRefreshDate = nil;
    tableView.pullArrowImage = [UIImage imageNamed:@""];
    tableView.pullBackgroundColor = RGBCOLOR(245, 245, 245);
    tableView.pullTextColor = RGBCOLOR(62, 62, 62);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView=tableView;
    tableView.tag = tableViewTag;
    [tableView release];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0, 320,10)];
    view.backgroundColor = [UIColor clearColor];
    tableView.tableFooterView  = view;
    [view release];
    
    UIImage *selectI = GetImage(@"mall_icon_list@2x.png");
    UIButton *switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [switchBtn setBackgroundImage:selectI forState:UIControlStateNormal];
    [switchBtn setFrame:CGRectMake(MainViewWidth-55,MainViewHeight-75,40,40)];
    [switchBtn setTitle:@"" forState:UIControlStateNormal];
    [switchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [switchBtn.titleLabel setFont:SetFontSize(18)];
    switchBtn.tag = 0;
    [switchBtn addTarget:self action:@selector(switchLookStyle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:switchBtn];
    
    if (_comeFromType==PushComeFromSouSuo)
    {
        UIView *failView = [[UIView alloc]initWithFrame:self.tableView.frame];
        failView.backgroundColor = self.view.backgroundColor;
        self.searchFailView = failView;
        failView.hidden = YES;
        [self.view addSubview:failView];
        [failView release];
        
        UIImage *souSuoI = [UIImage imageNamed:biaoMianimage3];
        UIImageView *souSuoV = [[UIImageView alloc]initWithFrame:CGRectMake(249.5,15, souSuoI.size.width/2, souSuoI.size.height/2)];
        souSuoV.image = souSuoI;
        [segmentControl addSubview:souSuoV];
        [segmentControl bringSubviewToFront:souSuoV];
        self.souSuoV = souSuoV;
        [souSuoV release];
        
        [self createKeyWordView];

    }

}
#pragma mark -- tableviewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_lookStyle==gongGe)
    {
        int rows = (self.spArr.count%2==0)?self.spArr.count/2:self.spArr.count/2+1;
        return rows;
    }else
    {
        return _spArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_lookStyle==gongGe)
    {
        static NSString *cell1 = @"gongGe";
        SPGongGeCell *cell =(SPGongGeCell*)[tableView dequeueReusableCellWithIdentifier:cell1];
        if (!cell)
        {
            cell = [[[SPGongGeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell1]autorelease];
        }
        if ((indexPath.row*2+1)==_spArr.count)
        {
            cell.objects = [NSArray arrayWithObjects:_spArr[indexPath.row*2], nil];
        }else
        {
            cell.objects = [NSArray arrayWithObjects:_spArr[indexPath.row*2],_spArr[indexPath.row*2+1], nil];
            
        }
        cell.delegate = self;
        [cell setNeedsLayout];
        return cell;

    }else
    {
        // liebiao
        static NSString *cell2 = @"lieBiao";
        SPLieBiaoCell *cell =(SPLieBiaoCell*)[tableView dequeueReusableCellWithIdentifier:cell2];
        if (!cell)
        {
            cell = [[[SPLieBiaoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell2]autorelease];
        }
        cell.object = _spArr[indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_lookStyle==lieBiao)
    {
        return [SPLieBiaoCell cellHeight:nil];

    }else
    {
        return [SPGongGeCell cellHeight:nil];
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_comeFromType==PushComeFromSouSuo)
    {
       CGFloat x=0;
       CGFloat y=0;
       CGFloat w=MainViewWidth;
       CGFloat h=15;
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(x,y,w,MAX(h,20))];
        view.backgroundColor =  self.view.backgroundColor;
        
        x=10;
        UILabel *resultL = [[UILabel alloc]initWithFrame:CGRectMake(x,y,w,MAX(h,20))];
        resultL.backgroundColor = self.view.backgroundColor;
        resultL.textAlignment = NSTextAlignmentLeft;
        resultL.font = [UIFont systemFontOfSize:13];
        resultL.textColor = RGBCOLOR(60,60,60);
        NSString *name = nil;
        if (_title_.length>kSearchTitleLength)
        {
            name = [NSString stringWithFormat:@"%@...",[_title_ substringToIndex:kSearchTitleLength]];
        }else
        {
            name = _title_;
        }
        resultL.text = [NSString stringWithFormat:@"搜到\" %@ \"相关的产品共\" ",name];
        resultL.numberOfLines = 1;
        self.searchResultLabel = resultL;
        [view addSubview:resultL];
        [resultL release];
        
        NSString *str = @"搜到\"";
        x=[str sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(MAXFLOAT, 20)].width;
        w=[name sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(MAXFLOAT, 20)].width;
        UILabel *nameL = [[UILabel alloc]initWithFrame:CGRectMake(x,y,w+5,20)];
        nameL.backgroundColor = self.view.backgroundColor;
        nameL.textAlignment = NSTextAlignmentLeft;
        nameL.font = [UIFont systemFontOfSize:13];
        nameL.textColor = RGBCOLOR(161,15,24);
        nameL.numberOfLines = 1;
        nameL.text = name;
        [resultL addSubview:nameL];
        [nameL release];
        
        NSString *str1 = [NSString stringWithFormat:@"搜到\" %@ \"相关的产品共\" ",name];
        x=[str1 sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(MAXFLOAT, 20)].width;
        w=[[NSString stringWithFormat:@"%i",self.searchResultEntity.totalsearchnumber] sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(MAXFLOAT, 20)].width;
        UILabel *countL = [[UILabel alloc]initWithFrame:CGRectMake(x,y,w+5,MAX(h,20))];
        countL.backgroundColor = [UIColor clearColor];
        countL.textAlignment = NSTextAlignmentLeft;
        countL.font = [UIFont systemFontOfSize:13];
        countL.textColor = RGBCOLOR(161,15,24);
        countL.text = [NSString stringWithFormat:@"%i",self.searchResultEntity.totalsearchnumber];
        countL.numberOfLines = 1;
        countL.tag = 0x6666;
        [resultL addSubview:countL];
        [countL release];
        
        NSString *str2=@"\"件";
        x=countL.frame.origin.x+countL.frame.size.width;
        w=30;
        UILabel *lastL=[[UILabel alloc]initWithFrame:CGRectMake(x,y,w+5,MAX(h,20))];
        lastL.backgroundColor=[UIColor clearColor];
        lastL.font=[UIFont systemFontOfSize:13];
        lastL.textAlignment=NSTextAlignmentLeft;
        lastL.textColor = RGBCOLOR(60,60,60);
        lastL.text=str2;
        [resultL addSubview:lastL];
        [lastL release];
        return [view autorelease];
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_comeFromType==PushComeFromSouSuo)
    {
        return 25;
    }
    return 0;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_lookStyle==lieBiao)
    {
        GoodEntity *object = _spArr[indexPath.row];
        ShangPingDetailVC *vc = [[ShangPingDetailVC alloc]init];
        vc.spId = object.goodsid;
        [self pushViewController:vc];
        [vc release];
    }
}
#pragma mark -- segmentControlDelegate
-(void)segmentControl:(DSSegmentControl*)segmentControl clickedAtIndex:(int)index button:(UIButton *)btn
{
    if (index==_currentSegmentIndex&&_theType!=jiaGe)
    {
        return;
    }
    [self.spArr removeAllObjects];
    [self.tableView reloadData];
    _curPage = 1;
    switch (index)
    {
        case 0://xinpin
        {
            NSLog(@"xinpin");
            if (_comeFromType==PushComeFromSouSuo)
            {
                _theType = haoPing;
            }else
            {
                _theType = xinPin;
            }
            [self performSelector:@selector(segmentControlClickedAfterDoIt) withObject:nil afterDelay:0.1];
            _isFirstClickedJiaGeBtn = YES;

        }
            break;
        case 1://xiaoLiang
        {
            NSLog(@"xiaoLiang");
            
            _theType = xiaoLiang;
            [self performSelector:@selector(segmentControlClickedAfterDoIt) withObject:nil afterDelay:0.1];
            _isFirstClickedJiaGeBtn = YES;

        }
            break;
        case 2://jiaGe
        {
            NSLog(@"jiaGe");
            _theType = jiaGe;
            if (_isFirstClickedJiaGeBtn==YES)
            {
                _jiageStyle = diToGao;
            }else
            {
                if (_jiageStyle==diToGao)
                {
                    _jiageStyle=gaoToDi;
                }else
                {
                    _jiageStyle=diToGao;
                }
            }
            if (_jiageStyle==gaoToDi)
            {
                [btn setImage:[UIImage imageNamed:biaoMianimage2] forState:UIControlStateSelected];
            }else
            {
                [btn setImage:[UIImage imageNamed:biaoMianimage1] forState:UIControlStateSelected];
            }
            [self performSelector:@selector(segmentControlClickedAfterDoIt) withObject:nil afterDelay:0.1];
            
            
            _isFirstClickedJiaGeBtn = NO;
            
        }
            break;
        case 3://haoPing
        {
            NSLog(@"haoPing");
            if (_comeFromType==PushComeFromSouSuo)
            {
                [self leftAction];
            }else
            {
                _theType = haoPing;
                [self performSelector:@selector(segmentControlClickedAfterDoIt) withObject:nil afterDelay:0.1];
                _isFirstClickedJiaGeBtn = YES;
            }
        }
            break;
        default:
            break;
    }
    
    _currentSegmentIndex=index;
}
-(void)segmentControlClickedAfterDoIt
{
    [self refreshData:self.shaiXuanArr isRefresh:YES];
}
#pragma mark -- 帅选 切换
- (void)buttonClicked:(UIButton*)btn
{
    switch (btn.tag)
    {
        case kShaiXuanBtnTag://shaiXuan
        {
            if (self.mmdc.openSide)
            {
                [self.mmdc closeDrawerAnimated:YES completion:^(BOOL completion){}];
            }else
            {
                [self.mmdc openDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL completion){}];
            }
        }
            break;
        default:
            break;
    }
}
-(void)switchLookStyle:(UIButton*)btn
{
    btn.selected=!btn.selected;
    
    if (_lookStyle==lieBiao)
    {
        _lookStyle = gongGe;
        [btn setBackgroundImage:GetImage(@"mall_icon_list@2x.png") forState:UIControlStateNormal];
    }else
    {
        _lookStyle = lieBiao;
        [btn setBackgroundImage:GetImage(@"mall_icon_photo@2x.png") forState:UIControlStateNormal];
    }
    [self.tableView reloadData];
}
#pragma mark -- spGongGeCellDelegate
-(void)cell:(SPGongGeCell *)cell imageBtnClicked:(UIButton *)btn
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSLog(@"SPGongGeCellIndexPath %@",indexPath);
    int row = indexPath.row;
    GoodEntity *object = nil;
    if (btn.tag==1)//点击左边的商品
    {
        object = _spArr[row*2];
    }
    if (btn.tag==2)//点击右边的商品
    {
        object = _spArr[row*2+1];
    }
    ShangPingDetailVC *vc = [[ShangPingDetailVC alloc]init];
    vc.spId = object.goodsid;
    [self pushViewController:vc];
    [vc release];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark -- pulltableview delegate
-(void)refreshTable
{
    self.tableView.pullLastRefreshDate = [NSDate date];
    self.tableView.pullTableIsRefreshing = NO;
}
//上啦更新数据再这里加载
-(void)loadMoreDataToTable
{
    self.tableView.pullTableIsLoadingMore = NO;
}
- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    _curPage = 1;
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:3.0f];
    [self refreshData:self.shaiXuanArr isRefresh:YES];
}
- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    if (_isNeedAddCurPage==YES)
    {
        _curPage++;
    }
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:3.0f];
    [self refreshData:self.shaiXuanArr isRefresh:NO];
}
-(void)refreshData:(NSArray*)shaiXuanArr isRefresh:(BOOL)isRefresh
{
    int theTag = (isRefresh)?1:2;
    
    switch (_theType)
    {
        case xinPin:
        {
            [self requestDatasourceWithShaiXuanArr:shaiXuanArr type:5  tag:theTag];
        }
            break;
        case xiaoLiang:
        {
            [self requestDatasourceWithShaiXuanArr:shaiXuanArr type:1 tag:theTag];
        }
            break;
        case jiaGe:
        {
            [self requestDatasourceWithShaiXuanArr:shaiXuanArr type:(_jiageStyle==diToGao)?3:4  tag:theTag];
        }
            break;
        case haoPing:
        {
            [self requestDatasourceWithShaiXuanArr:shaiXuanArr type:2  tag:theTag];
        }
            break;
        default:
            break;
    }

}
#pragma mark -- shaiXuanDelegate 筛选条件结果
-(void)object:(ShaiXuanVCViewController *)object shaiXuanArr:(NSArray *)shaiXuanArr
{
    if (shaiXuanArr==nil)
    {
        shaiXuanArr = [NSArray array];
    }
    self.shaiXuanArr = shaiXuanArr;
    [[NSUserDefaults standardUserDefaults] setObject:self.shaiXuanArr forKey:@"currentShaiXuanArr"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self refreshData:self.shaiXuanArr isRefresh:YES];
}

#pragma mark -- reloadSearchResultLabel
-(void)reloadSearchResultLabel
{
    NSString *name = nil;
    if (_title_.length>kSearchTitleLength)
    {
        name = [NSString stringWithFormat:@"%@...",[_title_ substringToIndex:kSearchTitleLength]];
    }else
    {
        name = _title_;
    }
    self.searchResultLabel.text = [NSString stringWithFormat:@"搜到\" %@ \"相关的产品共\" ",name];
    
    UILabel *countL = (UILabel*)[self.searchResultLabel viewWithTag:0x6666];
    CGRect frame = countL.frame;
    frame.size.width = [[NSString stringWithFormat:@"%i",self.searchResultEntity.totalsearchnumber] sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(MAXFLOAT, 20)].width+3;
    countL.frame = frame;
    countL.text = [NSString stringWithFormat:@"%i",self.searchResultEntity.totalsearchnumber];

}
#pragma mark - 添加热门关键词视图
-(void)createKeyWordView
{
    if (self.hotKeyView==nil)
    {
        CGFloat x=10;
        CGFloat y=10;
        CGFloat w=MainViewWidth;
        CGFloat h=20;
        
        UILabel *tiShiL = [[UILabel alloc]initWithFrame:CGRectMake(x,y,w,MAX(h,20))];
        tiShiL.backgroundColor = [UIColor clearColor];
        tiShiL.textAlignment = NSTextAlignmentCenter;
        tiShiL.font = [UIFont systemFontOfSize:15];
        tiShiL.textColor = RGBCOLOR(150,150,150);
        //jiangsuiming  2014-01-26
        NSString *input1 = @"搜到\" ";
        tiShiL.text = input1;
        CGSize size1 = [input1 sizeWithFont:tiShiL.font forWidth:MAXFLOAT lineBreakMode:NSLineBreakByCharWrapping];
        tiShiL.frame = CGRectMake(tiShiL.frame.origin.x, tiShiL.frame.origin.y, size1.width, size1.height);
        tiShiL.numberOfLines = 1;
        [self.searchFailView addSubview:tiShiL];
        [tiShiL release];
        do {
            UILabel *titleLabe = [[UILabel alloc]initWithFrame:CGRectMake(tiShiL.frame.origin.x + tiShiL.frame.size.width,y,w,MAX(h,20))];
            titleLabe.backgroundColor = [UIColor clearColor];
            titleLabe.textAlignment = NSTextAlignmentCenter;
            titleLabe.font = [UIFont systemFontOfSize:15];
            titleLabe.textColor = RGBCOLOR(161,15,24);
            NSString *name = nil;
            if (_title_.length>kSearchTitleLength)
            {
                name = [NSString stringWithFormat:@"%@...",[_title_ substringToIndex:kSearchTitleLength]];
            }else
            {
                name = _title_;
            }
            titleLabe.text = name;
            CGSize size2 = [titleLabe.text sizeWithFont:titleLabe.font forWidth:MAXFLOAT lineBreakMode:NSLineBreakByCharWrapping];
            titleLabe.frame = CGRectMake(tiShiL.frame.origin.x + tiShiL.frame.size.width, tiShiL.frame.origin.y, size2.width, size2.height);
            titleLabe.numberOfLines = 1;
            titleLabe.tag = 0x3838;
            [self.searchFailView addSubview:titleLabe];
            [titleLabe release];
            
            UILabel *tiShiLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(titleLabe.frame.origin.x + titleLabe.frame.size.width,y,w,MAX(h,20))];
            tiShiLabel2.backgroundColor = [UIColor clearColor];
            tiShiLabel2.textAlignment = NSTextAlignmentCenter;
            tiShiLabel2.font = [UIFont systemFontOfSize:15];
            tiShiLabel2.textColor = RGBCOLOR(150,150,150);
            tiShiLabel2.text = @" \"相关的产品共\"  \" 件";
            CGSize size3 = [@" \"相关的产品共\"  \" 件" sizeWithFont:titleLabe.font forWidth:MAXFLOAT lineBreakMode:NSLineBreakByCharWrapping];
            tiShiLabel2.frame = CGRectMake(titleLabe.frame.origin.x + titleLabe.frame.size.width, tiShiL.frame.origin.y, size3.width, size3.height);
            tiShiLabel2.numberOfLines = 1;
            tiShiLabel2.tag = 0x3839;
            [self.searchFailView addSubview:tiShiLabel2];
            [tiShiLabel2 release];
            
            UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(101,0,20,MAX(h,20))];
            numberLabel.backgroundColor = [UIColor clearColor];
            numberLabel.textAlignment = NSTextAlignmentCenter;
            numberLabel.font = [UIFont systemFontOfSize:15];
            numberLabel.textColor = RGBCOLOR(161,15,24);
            numberLabel.text = @"0";
            numberLabel.numberOfLines = 1;
            [tiShiLabel2 addSubview:numberLabel];
            [numberLabel release];
        } while (0);
        
        
        x=10;
        w=MainViewWidth-20;
        y=tiShiL.frame.origin.y+tiShiL.frame.size.height+25;
        UILabel *xiangZhaoL = [[UILabel alloc]initWithFrame:CGRectMake(x,y,w,MAX(h,20))];
        xiangZhaoL.backgroundColor = [UIColor clearColor];
        xiangZhaoL.textAlignment = NSTextAlignmentLeft;
        xiangZhaoL.font = [UIFont systemFontOfSize:15];
        xiangZhaoL.textColor = RGBCOLOR(60,60,60);
        xiangZhaoL.text = @"您是不是想找:";
        xiangZhaoL.numberOfLines = 1;
        [self.searchFailView addSubview:xiangZhaoL];
        [xiangZhaoL release];
        
        x=20;
        y=xiangZhaoL.frame.origin.y+xiangZhaoL.frame.size.height+15;
        w=280;
        h=self.searchFailView.frame.size.height-y;
        UIScrollView *keyWordsContent = [[UIScrollView alloc]initWithFrame:CGRectMake(x,y,w,h)];
        keyWordsContent.contentSize = CGSizeMake(w,h);
        keyWordsContent.showsVerticalScrollIndicator = NO;
        keyWordsContent.backgroundColor = [UIColor clearColor];
        self.hotKeyView = keyWordsContent;
        [self.searchFailView addSubview:keyWordsContent];
        [keyWordsContent release];
    }
}

-(void)refreshKeyWordViewBy:(NSArray *)keyArr
{
    
    for (UIView *view in [self.hotKeyView subviews] ) {
        [view removeFromSuperview];
    }
    int currentX    = 0.0;
    int currentY    = 0.0;
    
    //通过array 添加关键字
    NSMutableArray *buttonsArray = [[[NSMutableArray alloc]init]autorelease];
    for (int i=0; i<[keyArr count]; i++) {
        
        NSString *myStr = [keyArr objectAtIndex:i];
        CGSize mySize = [myStr sizeWithFont:SYSTEMFONT(14) forWidth:280.0 lineBreakMode:NSLineBreakByCharWrapping];
        CGSize btnSize = CGSizeMake(mySize.width, mySize.height);
        // 需要换行
        if (currentX>=320-40-(mySize.width+20)) {
            currentX    = 0.0;
            currentY    += 40.0;
        }
        
        // 添加关键字按钮
        UIButton *keyWordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        keyWordBtn.frame = CGRectMake(currentX, currentY,MIN(btnSize.width+15, 280), 35);
        [keyWordBtn setTitle:myStr forState:UIControlStateNormal];
        
        UIImage *myImg = GetImage(@"search_bg_key word.png");
        UIImage *resizeImg = [myImg resizableImageWithCapInsets:UIEdgeInsetsMake(4, 10, 4, 10)];
        [keyWordBtn setBackgroundImage:resizeImg forState:UIControlStateNormal];
        
        [keyWordBtn setTitleColor:TEXT_GRAY_COLOR forState:UIControlStateNormal];
        [keyWordBtn addTarget:self action:@selector(goSearchBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        keyWordBtn.titleLabel.font = SYSTEMFONT(14);
        
        [self.hotKeyView addSubview:keyWordBtn];
        
        currentX += (btnSize.width +30);
        
        [buttonsArray addObject:keyWordBtn];
    }
    
    NSMutableArray *leftArray = [NSMutableArray array];
    NSMutableArray *rightArray = [NSMutableArray array];
    NSMutableArray *leftX = [NSMutableArray array];
    NSMutableArray *rightX = [NSMutableArray array];
    for (int i =0; i<[buttonsArray count]; i++) {
        UIButton *aButton = [buttonsArray objectAtIndex:i];
        CGRect btnRect = aButton.frame;
        aButton.alpha = 0.0;
        if (aButton.center.x <160) {
            
            [leftX addObject:[NSString stringWithFormat:@"%f",btnRect.origin.x]];
            aButton.frame = CGRectMake(320, btnRect.origin.y, btnRect.size.width, btnRect.size.height) ;
            [leftArray addObject:aButton];
        }else{
            [rightX addObject:[NSString stringWithFormat:@"%f",aButton.frame.origin.x]];
            aButton.frame = CGRectMake(0, btnRect.origin.y, btnRect.size.width, btnRect.size.height);
            [rightArray addObject:aButton];
        }
    }
    
    
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        for (int i = 0; i< [leftArray count];i++) {
            UIButton *button = [leftArray objectAtIndex:i];
            CGRect btnRect = button.frame;
            button.alpha = 1;
            button.frame = CGRectMake([[leftX objectAtIndex:i]floatValue], btnRect.origin.y, btnRect.size.width, btnRect.size.height);
        }
        
        
    }completion:^ (BOOL finished){
        [UIView animateWithDuration:0.5 animations:^{
            for (int i = 0; i< [rightArray count];i++) {
                UIButton *button = [rightArray objectAtIndex:i];
                CGRect btnRect = button.frame;
                button.alpha = 1;
                button.frame = CGRectMake([[rightX objectAtIndex:i]floatValue], btnRect.origin.y, btnRect.size.width, btnRect.size.height);
            }
        }];
        
    }];
    
    
    currentX    = 0.0;
    currentY    += 45.0;
    
    UIImage *myImg = GetImage(@"search_button_go on@2x.png");
    UIButton *goOnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    goOnBtn.backgroundColor = [UIColor clearColor];
    goOnBtn.frame = CGRectMake(self.hotKeyView.frame.size.width/2-myImg.size.width/4, currentY, myImg.size.width/2.0, myImg.size.height/2.0);
    
    [goOnBtn setBackgroundImage:GetImage(@"search_button_go on@2x.png") forState:UIControlStateNormal];
    [goOnBtn setBackgroundImage:GetImage(@"search_button_go on_press@2x.png") forState:UIControlStateHighlighted];

    [goOnBtn addTarget:self action:@selector(goOnBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.hotKeyView addSubview:goOnBtn];
    self.hotKeyView.contentSize = CGSizeMake(280, currentY+myImg.size.height/2.0+10);
}
//继续逛逛
-(void)goOnBtnClicked:(UIButton*)btn
{
    [[NSNotificationCenter defaultCenter]postNotificationName:kJiXuGuangGuangNotification object:self];
    [self leftAction];
}
//热词按钮被点击
-(void)goSearchBtnClicked:(UIButton*)btn
{
    _title_ = [btn.titleLabel.text copy];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshHistoryTable" object:btn.titleLabel.text];
    NSString *str = nil;
    if (_title_.length>kTitleLength) {
        str = [NSString stringWithFormat:@"%@...",[_title_ substringToIndex:kTitleLength]];
    }else
    {
        str = _title_ ;
    }
    [self setTitleString:str];
    NSString *name = nil;
    if (_title_.length>kSearchTitleLength)
    {
        name = [NSString stringWithFormat:@"%@...",[_title_ substringToIndex:kSearchTitleLength]];
    }else
    {
        name = _title_;
    }
    UILabel *classL = (UILabel*)[self.searchFailView viewWithTag:0x3838];
    classL.text = name;
    CGSize size2 = [classL.text sizeWithFont:classL.font constrainedToSize:CGSizeMake(CGFLOAT_MAX, 20)];
    CGRect frame1 = classL.frame;
    frame1.size.width = size2.width;
    classL.frame = frame1;
    
    UILabel *tishiL = (UILabel*)[self.searchFailView viewWithTag:0x3839];
    CGRect frame2 = tishiL.frame;
    frame2.origin.x=classL.frame.origin.x+classL.frame.size.width;
    tishiL.frame = frame2;
    
    [self refreshData:[NSArray array] isRefresh:YES];
}
@end
