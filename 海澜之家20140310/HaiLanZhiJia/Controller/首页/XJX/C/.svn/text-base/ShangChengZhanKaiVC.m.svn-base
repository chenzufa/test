//
//  ShangChengZhanKaiVC.h
//  HaiLanZhiJia
//
//  Created by xiaojiaxi on 13-11-26.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "ShangChengZhanKaiVC.h"
#import "ReXiaoShangPinVC.h"
#import "MMDrawerController.h"
#import "ShaiXuanVCViewController.h"
#import "NetImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "DSRequest.h"

#define MainScreenHeight  [UIScreen mainScreen].bounds.size.height
#define JianTouheight 12
#define kBottomLineTag 0x1111
#define ROWHEIHT 85
#define COLUMN    4   //列数

@interface  ShangChengZhanKaiVC()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain) UITableView    *expandTable;
@property (nonatomic,assign) NSInteger      currentSection;
@property (nonatomic,assign) NSInteger      lastSection;
@property (nonatomic,assign) BOOL           isCurrentOpen;
@property (nonatomic,retain) NSMutableArray *dataSource;
@property (nonatomic,retain) NSMutableDictionary *openCloseMarkDic;
@property (nonatomic,retain) UIView *failView;
@end

@implementation ShangChengZhanKaiVC
-(void)dealloc
{
    [_expandTable release];_expandTable=nil;
    [_dataSource release];_dataSource=nil;
    [_openCloseMarkDic release];_openCloseMarkDic=nil;
    [_failView release];_failView = nil;
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(245, 245, 245);
    [self setTitleString:@"商城"];
    self.leftButton.hidden = YES;
    self.rightButton.hidden = YES;
    [self performSelector:@selector(doAfterViewDidLoad) withObject:nil afterDelay:0.1];
}
-(void)doAfterViewDidLoad
{
    _expandTable = [[UITableView alloc]initWithFrame:CGRectMake(0,[self getTitleBarHeight]+50,MainViewWidth, MainScreenHeight-20-50-45-45) style:UITableViewStylePlain];
    _expandTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _expandTable.delegate = self;
    _expandTable.dataSource = self;
    _expandTable.backgroundColor = RGBCOLOR(245,245,245);
    [self.view addSubview:_expandTable];
    
    if (_dataSource == nil)
        _dataSource = [[NSMutableArray arrayWithCapacity:0]retain];
    if (_openCloseMarkDic==nil)
        _openCloseMarkDic = [[NSMutableDictionary dictionaryWithCapacity:0]retain];
    [self requestDatasource];
}
-(void)initRexiaoView
{
    UIButton *reXiaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [reXiaoBtn setBackgroundImage:[UIImage imageNamed:@"mall_bg_hot sale@2x.png"] forState:UIControlStateNormal];
    [reXiaoBtn setBackgroundImage:[UIImage imageNamed:@"mall_bg_hot sale_press@2x.png"] forState:UIControlStateHighlighted];
    reXiaoBtn.frame = CGRectMake(0, [self getTitleBarHeight], MainViewWidth, 50);
    [self.view addSubview:reXiaoBtn];
    [reXiaoBtn addTarget:self action:@selector(reXiaoBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *arrowView1 = [[UIImageView alloc]initWithFrame:CGRectMake(300,17.5, 9, 15)];
    [arrowView1 setImage:[UIImage imageNamed:@"icon_next@2x.png"]];
    [reXiaoBtn addSubview:arrowView1];
    [arrowView1 release];
    
    UIImage *rexiaoIconI = [UIImage imageNamed:@"mall_icon_list_hot@2x.png"];
    UIImageView *reXiaoIcon = [[UIImageView alloc]initWithFrame:CGRectMake(30,25-rexiaoIconI.size.height/4+2,rexiaoIconI.size.width/2,rexiaoIconI.size.height/2)];
    [reXiaoIcon setImage:[UIImage imageNamed:@"mall_icon_list_hot@2x.png"]];
    [reXiaoBtn addSubview:reXiaoIcon];
    [reXiaoIcon release];
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(100,10, 230, 30)];
    title.textColor  = RGBCOLOR(245, 245, 245);
    title.font = [UIFont systemFontOfSize:19.0f];
    title.backgroundColor = [UIColor clearColor];
    title.text = @"热卖排行";
    title.opaque = NO;
    [reXiaoBtn addSubview:title];
    [title release];
}

-(void)requestDatasource
{
    [self addHud:@""];
    DSRequest *request = [[DSRequest alloc]init];
    request.delegate = self;
    [request requestDataWithInterface:ShoppingMallCategory param:[self ShoppingMallCategoryParam] tag:1];
    [request release];
}
#pragma mark - DSRequestDelegate
-(void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    [self hideHud:nil];
    self.failView.hidden = YES;
    NSMutableArray *entityArr = (NSMutableArray*)dataObj;
    self.dataSource = entityArr;
    
    _lastSection = _dataSource.count;
    _currentSection = _dataSource.count;
    
    [self.expandTable reloadData];
    [self initRexiaoView];
    [self performSelector:@selector(hideFailView) withObject:nil afterDelay:1];
}
-(void)hideFailView
{
    self.failView.hidden=YES;
}
-(void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError*)error
{
    [self hideHud:nil];
    if (self.dataSource.count<=0)
    {
        [self initFailView];
        self.failView.hidden = NO;
    }
}
-(void)initFailView
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
#define juli 50
    UILabel *lbl = [[[UILabel alloc] initWithFrame:CGRectMake(0,140-juli,MainViewWidth, 20)] autorelease];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.textColor = RGBCOLOR(62, 62, 62);
    lbl.font = [UIFont systemFontOfSize:15.0f];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.text = @"咦，数据加载失败了";
    [_failView addSubview:lbl];
    
    UILabel *lbl2 = [[[UILabel alloc] initWithFrame:CGRectMake(0,170-juli,MainViewWidth, 20)] autorelease];
    lbl2.textAlignment = NSTextAlignmentCenter;
    lbl2.textColor = RGBCOLOR(82, 82, 82);
    lbl2.font = [UIFont systemFontOfSize:14.0f];
    lbl2.backgroundColor = [UIColor clearColor];
    lbl2.text = @"请检查下您的网络，重新加载吧";
    [_failView addSubview:lbl2];
    
    UIImage *bgI = [UIImage imageNamed:@"default_button@2x.png"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(MainViewWidth/2-bgI.size.width/4,210-juli,bgI.size.width/2, bgI.size.height/2-5);
    [btn setBackgroundImage:[UIImage imageNamed:@"default_button@2x.png"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"default_button_press@2x.png"] forState:UIControlStateHighlighted];
    [btn setTitle:@"重新加载" forState:UIControlStateNormal];
    [btn setTitleColor:RGBCOLOR(62, 62, 62) forState:UIControlStateNormal];
    [btn addTarget:self
            action:@selector(requestDatasource)
  forControlEvents:UIControlEventTouchUpInside];
    [_failView addSubview:btn];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == _currentSection && _isCurrentOpen)
        return 1;
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        /*展开显示的cell*/
        UITableViewCell *cell=nil;
        if(cell==nil)
        {
            cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"]autorelease];
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.detailTextLabel.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0,cell.bounds.size.width, [self cellHeight:indexPath])];
            view.backgroundColor =RGBCOLOR(15, 24, 45);
            [cell addSubview:view];
            [view release];
            
            MallCategoryEntity *object = [self.dataSource objectAtIndex:indexPath.section];
            int total = object.subcategory.count;

            for (int i=0; i<total; i++)
            {
                int row = i / COLUMN;
                int column = i % COLUMN;
                MallCategoryEntity *data = [object.subcategory objectAtIndex:i];
                
                UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(80*column, ROWHEIHT*row+JianTouheight, 80, ROWHEIHT)] autorelease];
                view.backgroundColor=[UIColor clearColor];
                UIImageView *netV = [[UIImageView alloc]initWithFrame:CGRectMake(7,3,66,63)];
                if ([data.categoryimg isKindOfClass:NSNull.class])
                    [netV setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"mall_expend_photo@2x.png"]];
                else
                    [netV setImageWithURL:[NSURL URLWithString:data.categoryimg] placeholderImage:[UIImage imageNamed:@"mall_expend_photo@2x.png"]];
                netV.contentMode = UIViewContentModeScaleAspectFit;
                [view addSubview:netV];
                netV.layer.cornerRadius = 6;
                netV.clipsToBounds = YES;
                [netV release];
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = netV.frame;
                btn.tag = i;
                [btn addTarget:self
                        action:@selector(subCateBtnAction:)
              forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:btn];
                
                UILabel *lbl = [[[UILabel alloc] initWithFrame:CGRectMake(0, 68, 80, 15)] autorelease];
                lbl.textAlignment = NSTextAlignmentCenter;
                lbl.textColor = [UIColor whiteColor];
                lbl.text = data.categoryname;
                lbl.font = [UIFont systemFontOfSize:15.0f];
                lbl.backgroundColor = [UIColor clearColor];
                [view addSubview:lbl];
                [cell addSubview:view];
            }
            if (total>0)
            {
                UIImage *expandI = [UIImage imageNamed:@"mall_expend_bg@2x.png"];
                UIImageView *expandV = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,cell.bounds.size.width,expandI.size.height/2)];
                expandV.image = expandI;
                [view addSubview:expandV];
                [expandV release];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count+(_dataSource.count>0?1:0);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == _currentSection)
        return [self cellHeight:indexPath];
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==_dataSource.count)
    {
        return 2;
    }
    CGFloat height = 80;
    
    MallCategoryEntity *object = [self.dataSource objectAtIndex:section];
    int total = object.subcategory.count;
    if (total>0)
    {
        if ([[_openCloseMarkDic objectForKey:[NSString stringWithFormat:@"%i",section]] intValue]==1)
            height = 75;
    }
    return height;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    if (section==_dataSource.count)
    {
        UIView *contentView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320,2)]autorelease];
        [contentView setBackgroundColor:RGBACOLOR(245,245,245,1)];
        contentView.backgroundColor = [UIColor clearColor];
        return contentView;
    }
        CGFloat height = 80;
        MallCategoryEntity *object = [self.dataSource objectAtIndex:section];
        int total = object.subcategory.count;
        if (total>0)
        {
            if ([[_openCloseMarkDic objectForKey:[NSString stringWithFormat:@"%i",section]] intValue]==1)
                height = 73;
        }
        UIView *contentView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320,height)]autorelease];
        contentView.tag =  0x2222;
        [contentView setBackgroundColor:RGBACOLOR(245,245,245,1)];
    
        if (height>=80)
        {
            UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(0,79,320,1)];
            [lineView setImage:[UIImage imageNamed:@"division line.png"]];
            [contentView addSubview:lineView];
            [lineView release];
        }
    
        
        UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(12, 5, 70, 70)];
        logo.backgroundColor = [UIColor clearColor];
        if ([object.categoryimg isKindOfClass:NSNull.class])
            [logo setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"列表小图.png"]];
        else
            [logo setImageWithURL:[NSURL URLWithString:object.categoryimg] placeholderImage:[UIImage imageNamed:@"列表小图.png"]];
        logo.contentMode = UIViewContentModeScaleAspectFit;
        logo.clipsToBounds = YES;
        [contentView addSubview:logo];
        [logo release];
    
        UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(100,15, 230, 30)];
        title.textColor  = RGBCOLOR(62, 62, 62);
        title.font = [UIFont systemFontOfSize:17.0f];
        title.backgroundColor = [UIColor clearColor];
        title.text = object.categoryname;
        title.opaque = NO;
        [contentView addSubview:title];
        [title release];
        
        UILabel * subTtile = [[UILabel alloc] initWithFrame:CGRectMake(100,51, 230,20)];
        subTtile.font = [UIFont systemFontOfSize:14.0f];
        subTtile.textColor = [UIColor colorWithRed:181/255.0
                                             green:175/255.0
                                              blue:175/255.0
                                             alpha:1.0];
        subTtile.backgroundColor = [UIColor clearColor];
        subTtile.opaque = NO;
        subTtile.text = object.description;
        [contentView addSubview:subTtile];
        [subTtile release];
        
        UIButton *expandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [expandBtn setFrame:CGRectMake(0,1, 320,height)];
        [expandBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [expandBtn setTitle:object.categoryname forState:UIControlStateNormal];
        [expandBtn setTag:section];
        [expandBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
        [expandBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [expandBtn addTarget:self action:@selector(expandCell:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:expandBtn];
    
        return contentView;
}

-(CGFloat)cellHeight:(NSIndexPath*)indexpath
{
    MallCategoryEntity *object = [self.dataSource objectAtIndex:indexpath.section];
    int total = object.subcategory.count;
    int rows = (total / COLUMN) + ((total % COLUMN) > 0 ? 1 : 0);
    CGFloat  height = ROWHEIHT * rows+((object.subcategory.count>0)?JianTouheight+5:0);
    return height;
}

- (void)whetherTheCurrentNoCellExpand:(BOOL)isCurrentHasCellExpand whetherExpandAnotherCell:(BOOL)isExpandAnotherCell
{
    [_expandTable beginUpdates];
    _isCurrentOpen = isCurrentHasCellExpand;
    NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
    for (int i = 0; i<1; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:(isExpandAnotherCell)?_lastSection:_currentSection];
        [rowToInsert addObject:indexPath];
    }
   
    if (!_isCurrentOpen)
    {
        NSIndexPath *indexpath = rowToInsert[0];
        [_openCloseMarkDic setObject:@"0" forKey:[NSString stringWithFormat:@"%i",indexpath.section]];
        [_expandTable deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationFade];
        [_expandTable reloadSections:[NSIndexSet indexSetWithIndex:indexpath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
        if (!isExpandAnotherCell)
        {
            _lastSection = _dataSource.count;
            _currentSection = _dataSource.count;
        }
    }else
    {
        NSIndexPath *indexpath = rowToInsert[0];
        [_openCloseMarkDic setObject:@"1" forKey:[NSString stringWithFormat:@"%i",indexpath.section]];
        [_expandTable insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationFade];
        [_expandTable reloadSections:[NSIndexSet indexSetWithIndex:indexpath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [rowToInsert release];
    [_expandTable endUpdates];
    if (isExpandAnotherCell)
    {
        _lastSection = _currentSection;
        [self whetherTheCurrentNoCellExpand:YES whetherExpandAnotherCell:NO];
    }
   
    if (_isCurrentOpen)
        [_expandTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_currentSection] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
#pragma mark-- 按钮点击事件
- (void)expandCell:(UIButton *)expandBtn
{
    MallCategoryEntity *object = [self.dataSource objectAtIndex:expandBtn.tag];
    int total = object.subcategory.count;
    if (total<=0)
    {
        MMDrawerController *mmvc = [MMDrawerController MMDrawerControllerWithName:object.categoryname withId:object.categoryid];
        [self pushViewController:mmvc];
        return;
    }
    _currentSection = expandBtn.tag;
    
    if (_lastSection==_dataSource.count) {
        _isCurrentOpen = NO;
        _lastSection = _currentSection;
        [self whetherTheCurrentNoCellExpand:YES whetherExpandAnotherCell:NO];
    }
    else
    {
        if (_lastSection==_currentSection)
            [self whetherTheCurrentNoCellExpand:NO whetherExpandAnotherCell:NO];
        else
            [self whetherTheCurrentNoCellExpand:NO whetherExpandAnotherCell:YES];
    }
}
-(void)subCateBtnAction:(UIButton *)btn
{
    int index = btn.tag;
    MallCategoryEntity *object = self.dataSource[_currentSection];
    NSArray *subArr = object.subcategory;
    MallCategoryEntity *subObject = subArr[index];

    MMDrawerController *mmvc = [MMDrawerController MMDrawerControllerWithName:subObject.categoryname withId:subObject.categoryid];
    [self pushViewController:mmvc];
}
-(void)reXiaoBtnClicked:(UIButton*)btn
{
    ReXiaoShangPinVC *mmvc = [[ReXiaoShangPinVC alloc]init];
    mmvc.comeFromType=PushComeFromReMai;
    mmvc.spId=@"-1";
    mmvc.title_ = @"热卖排行";
    [self pushViewController:mmvc];
    [mmvc release];
}
@end
