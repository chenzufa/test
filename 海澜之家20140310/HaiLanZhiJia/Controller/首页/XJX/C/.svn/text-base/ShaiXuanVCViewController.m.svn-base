//
//  ShaiXuanVCViewController.m
//  HaiLanZhiJia
//
//  Created by xiaojiaxi on 13-11-28.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "ShaiXuanVCViewController.h"
#import "ShaiXuanDetailVC.h"
#import "ReXiaoShangPinVC.h"
#import <QuartzCore/QuartzCore.h>

#define kWidth         240
#define kCellLabelTag  0x9999
#define kCellLabelTag2 0x8888
#define kQingKongTag   0x1111
#define kQueDingTag    0x2222
#define kArrowImage    @"icon_next@2x.png"
@interface ShaiXuanVCViewController ()<UITableViewDataSource,UITableViewDelegate,ShaiXuanDetailVCDelegate>
@property(nonatomic,retain)NSMutableArray *shaiXuanArr;
@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,retain)NSIndexPath *currentIndex;
@property(nonatomic,retain)NSMutableDictionary *tiaoJianDic;//条件名称
@property(nonatomic,retain)NSMutableDictionary *tiaoJianIdDic;//条件ID
@property(nonatomic,retain)ShaiXuanDetailVC *shaiXuanDetailVC;
@end

@implementation ShaiXuanVCViewController
-(void)dealloc
{
    [_shaiXuanArr release];
    _shaiXuanArr = nil;
    [_tableView release];
    _tableView=nil;
    [_currentIndex release];
    _currentIndex = nil;
    [_tiaoJianDic release];
    _tiaoJianDic = nil;
    [_tiaoJianIdDic release];
    _tiaoJianIdDic = nil;
    [_shaiXuanDetailVC release];
    _shaiXuanDetailVC=nil;
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleBar.hidden = YES;
    self.TopBackgroudImgV.hidden = YES;
    [self setTitleBarHidden:YES];
    self.view.backgroundColor = RGBACOLOR(45,44,44, 1);
    
    [self performSelector:@selector(doAfterViewDidLoad) withObject:nil afterDelay:0.1];

}
-(void)doAfterViewDidLoad
{
    [self requestDatasource];
    [self initSubview];
}
-(void)requestDatasource
{
    if (_tiaoJianDic==nil) {
        _tiaoJianDic = [[NSMutableDictionary dictionaryWithCapacity:0]retain];
    }else
    {
        [_tiaoJianDic removeAllObjects];
    }
    if (_tiaoJianIdDic==nil) {
        _tiaoJianIdDic = [[NSMutableDictionary dictionaryWithCapacity:0]retain];
    }else
    {
        [_tiaoJianIdDic removeAllObjects];
    }
    if (_shaiXuanArr==nil)
    {
        _shaiXuanArr = [[NSMutableArray arrayWithCapacity:0]retain];
    }else
    {
        [_shaiXuanArr removeAllObjects];
    }
    
    [self addHud:@""];
    DSRequest *request = [[DSRequest alloc]init];
    request.delegate = self;
    [request requestDataWithInterface:GetGoodsListSpec param:[self GetGoodsListSpecParam:_spId] tag:1];
    [request release];
}
#pragma mark - DSRequestDelegate
-(void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    [self hideHud:nil];
    NSMutableArray *objectArr = (NSMutableArray*)dataObj;
    self.shaiXuanArr = objectArr;
    UIView *view = [self.view viewWithTag:0x7474];
    if (self.shaiXuanArr.count<=0)
    {
        UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0,44,self.tableView.bounds.size.width,1)];
        [contentView setBackgroundColor:RGBCOLOR(0,0,0)];
        [self.view addSubview:contentView];
        [contentView release];
        view.hidden = NO;
        return;
    }
    view.hidden=YES;
    [self.tableView reloadData];
}
-(void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError*)error
{
    [self hideHud:nil];
}
-(void)initSubview
{
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = 0;
    CGFloat h = 44;
    
    UIView *viewBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 44)];
    viewBar.backgroundColor = RGBCOLOR(45, 45, 44);
    [self.view addSubview:viewBar];
    [viewBar release];
    x=20;
    w=viewBar.bounds.size.width-x;
    
    UILabel *titleBar_ = [[UILabel alloc]initWithFrame:CGRectMake(x,y,w,h)];
    titleBar_.backgroundColor = [UIColor clearColor];
    titleBar_.text = @"筛选";
    titleBar_.textColor = RGBCOLOR(208,205,205);
    titleBar_.font = [UIFont systemFontOfSize:15];
    [viewBar addSubview:titleBar_];
    [titleBar_ release];
    
    UILabel *tiShiL = [[UILabel alloc]initWithFrame:CGRectMake(0,self.view.center.y-20,kWidth,20)];
    tiShiL.textAlignment = NSTextAlignmentCenter;
    tiShiL.backgroundColor = [UIColor clearColor];
    tiShiL.text = @"无筛选条件";
    tiShiL.textColor = RGBCOLOR(150,150,150);
    tiShiL.font = [UIFont systemFontOfSize:15];
    tiShiL.tag = 0x7474;
    [viewBar addSubview:tiShiL];
    tiShiL.hidden = YES;
    [tiShiL release];
    
    UIImage *queDingI = [UIImage imageNamed:@"mall_button_confirm@2x.png"];
    y = MainViewHeight-queDingI.size.height/2.0-30;
    w=queDingI.size.width/2.0;
    h=queDingI.size.height/2.0;
    x=kWidth-w-20;
    UIButton *queDingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    queDingBtn.frame = CGRectMake(x,y,w,h);
    [queDingBtn setBackgroundImage:queDingI forState:UIControlStateNormal];
    [queDingBtn setBackgroundImage:[UIImage imageNamed:@"mall_button_confirm_press@2x.png"] forState:UIControlStateHighlighted];
    [queDingBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    queDingBtn.layer.borderColor=[UIColor blackColor].CGColor;
    queDingBtn.layer.borderWidth=1;
    queDingBtn.layer.cornerRadius=3;
    [self.view addSubview:queDingBtn];
    queDingBtn.tag = kQueDingTag;
    
    UIImage *shaiXuanI = [UIImage imageNamed:@"mall_button_delete@2x.png"];
    y = MainViewHeight-queDingI.size.height/2.0-30;
    x=20;
    w=shaiXuanI.size.width/2.0;
    h=shaiXuanI.size.height/2.0;
    UIButton *shaiXuanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shaiXuanBtn.frame = CGRectMake(x,y,w,h);
    [shaiXuanBtn setBackgroundImage:shaiXuanI forState:UIControlStateNormal];
    [shaiXuanBtn setBackgroundImage:[UIImage imageNamed:@"mall_button_delete_press@2x.png"] forState:UIControlStateHighlighted];
    [shaiXuanBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shaiXuanBtn];
    shaiXuanBtn.layer.borderColor=[UIColor blackColor].CGColor;
    shaiXuanBtn.layer.borderWidth=1;
    shaiXuanBtn.layer.cornerRadius=3;
    shaiXuanBtn.tag = kQingKongTag;
    
    x=0;
    h=y-viewBar.frame.origin.y-viewBar.frame.size.height-10;
    y=viewBar.frame.origin.y+viewBar.frame.size.height;
    w=kWidth;
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(x,y+3,w,h)];
    [tableView setBackgroundColor:[UIColor clearColor]];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [tableView release];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0, 320, 10)];
    view.backgroundColor = [UIColor clearColor];
    tableView.tableFooterView  = view;
    [view release];

    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentIndex = indexPath;
    
    SpecEntity *object = _shaiXuanArr[indexPath.section];
    if (object.subspec.count>0)
    {
        ShaiXuanDetailVC *vc = [[ShaiXuanDetailVC alloc]init];
        self.shaiXuanDetailVC = vc;
        [vc release];
        SpecEntity *spE = [[SpecEntity alloc]init];
        spE.specid=@"全部";
        spE.specname=@"全部";
        NSMutableArray *shaixuanarr = [NSMutableArray arrayWithArray:object.subspec];
        [shaixuanarr insertObject:spE atIndex:0];
        _shaiXuanDetailVC.shaiXuanArr = shaixuanarr;
        _shaiXuanDetailVC.sxTitle = object.specname;
        _shaiXuanDetailVC.delegate = self;
        CGRect frame = _shaiXuanDetailVC.view.frame;
        frame.origin.x=self.view.bounds.size.width;
        _shaiXuanDetailVC.view.frame=frame;
        [self.view addSubview:_shaiXuanDetailVC.view];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDuration:0.35];
        frame =  _shaiXuanDetailVC.view.frame;
        frame.origin.x=0;
        _shaiXuanDetailVC.view.frame=frame;
        [UIView commitAnimations];
        [spE release];
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*展开显示的cell*/
    static NSString *cellId = @"cellId";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell==nil)
    {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"]autorelease];
        cell.textLabel.backgroundColor = RGBCOLOR(35, 34, 34);
        cell.detailTextLabel.backgroundColor = RGBCOLOR(35, 34, 34);
        cell.contentView.backgroundColor = RGBCOLOR(35, 34, 34);
        
        UIView *contentV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 240, 45)];
        contentV.backgroundColor = RGBCOLOR(35, 34, 34);
        [cell.contentView addSubview:contentV];
        [contentV release];
        
        CGFloat w = 100;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20,0,w, 44)];
        label.backgroundColor = RGBCOLOR(35, 34, 34);
        label.textColor = RGBCOLOR(208,205,205);
        label.font = [UIFont systemFontOfSize:15];
        label.tag = kCellLabelTag;
        [cell.contentView addSubview:label];
        [label release];
        
        CGFloat x = label.frame.origin.x+label.frame.size.width;
        UILabel *HuiChuangLabel = [[UILabel alloc]initWithFrame:CGRectMake(x,0,w,44)];
        HuiChuangLabel.backgroundColor = RGBCOLOR(35, 34, 34);
        HuiChuangLabel.textColor = RGBCOLOR(208,205,205);
        HuiChuangLabel.font = [UIFont systemFontOfSize:15];
        HuiChuangLabel.tag = kCellLabelTag2;
        HuiChuangLabel.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:HuiChuangLabel];
        [HuiChuangLabel release];
        
        UIImage *arrowI = [UIImage imageNamed:kArrowImage];
        CGFloat y = (44-arrowI.size.height/2.0)/2.0;
        UIImageView *arrowV = [[UIImageView alloc]initWithFrame:CGRectMake(225, y, arrowI.size.width/2.0, arrowI.size.height/2.0)];
        arrowV.image = arrowI;
        [cell.contentView addSubview:arrowV];
        [arrowV release];
    }
    UILabel *label = (UILabel*)[cell.contentView viewWithTag:kCellLabelTag];
    SpecEntity *object = _shaiXuanArr[indexPath.section];
    label.text = object.specname;
    
    UILabel *label2 = (UILabel*)[cell.contentView viewWithTag:kCellLabelTag2];
    NSString *tiaoJian = [_tiaoJianDic objectForKey:[NSString stringWithFormat:@"%i",indexPath.section]];
    label2.text = tiaoJian;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _shaiXuanArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *contentView = [[[UIView alloc]initWithFrame:CGRectMake(0,0,tableView.bounds.size.width,1)]autorelease];
    [contentView setBackgroundColor:RGBCOLOR(0,0,0)];
    return contentView;
}
-(void)btnClicked:(UIButton*)btn
{
    if (btn.tag == kQingKongTag)
    {
        if (_tiaoJianIdDic.count>0)
        {
            if (self.delegate)
            {
                 NSArray *arr2 = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentShaiXuanArr"];
                if (arr2.count>0)
                {
                    if ([self.delegate respondsToSelector:@selector(object:shaiXuanArr:)])
                    {
                        [self.delegate object:self shaiXuanArr:[NSArray array]];
                    }
                }
            }
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"currentShaiXuanArr"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [_tiaoJianDic removeAllObjects];
            [_tiaoJianIdDic removeAllObjects];
            [self.tableView reloadData];
        }
    }
    
    if (btn.tag == kQueDingTag)
    {
        if (self.delegate)
        {
            ReXiaoShangPinVC *vc =(ReXiaoShangPinVC*) self.delegate;
            if (vc.mmdc.openSide)
            {
                [vc.mmdc closeDrawerAnimated:YES completion:^(BOOL completion){}];
            }
            if (_tiaoJianIdDic.count<=0)
            {
                return;
            }
            if ([self.delegate respondsToSelector:@selector(object:shaiXuanArr:)])
            {
                NSArray *arr = [_tiaoJianIdDic allValues];
                NSSet *set = [NSSet setWithArray:arr];
               
                if (set.allObjects.count==1&&[set.allObjects[0] isEqualToString:@"全部"])
                {
                    arr = [NSArray array];
                }
                [self.delegate object:self shaiXuanArr:arr];
            }
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark -- shaiXuanDetailVCDelegate
-(void)object:(ShaiXuanDetailVC *)object value:(SpecEntity *)value
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_currentIndex];
    UILabel *label = (UILabel*)[cell.contentView viewWithTag:kCellLabelTag2];
    label.text = value.specname;
    [_tiaoJianDic setObject:value.specname forKey:[NSString stringWithFormat:@"%i",_currentIndex.section]];
    [_tiaoJianIdDic setObject:value.specid forKey:[NSString stringWithFormat:@"%i",_currentIndex.section]];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.45];
    CGRect frame =  _shaiXuanDetailVC.view.frame;
    frame.origin.x=self.view.bounds.size.width;
    _shaiXuanDetailVC.view.frame=frame;
    [UIView commitAnimations];
}
@end
