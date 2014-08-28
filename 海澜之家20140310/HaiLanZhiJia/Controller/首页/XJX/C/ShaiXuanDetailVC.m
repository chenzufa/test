//
//  ShaiXuanDetailVC.m
//  HaiLanZhiJia
//
//  Created by xiaojiaxi on 13-12-2.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "ShaiXuanDetailVC.h"

#define kWidth         240
#define kCellLabelTag  0x2222
#define kSelectedImage @"icon_select@2x.png"
@interface ShaiXuanDetailVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,retain)NSMutableArray *gouArr;
@end

@implementation ShaiXuanDetailVC
-(void)dealloc
{
    [_shaiXuanArr release];
    _shaiXuanArr = nil;
    [_tableView release];
    _tableView = nil;
    [_gouArr release];
    _gouArr = nil;
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
    
    CGRect frame = self.view.frame;
    frame.origin.x = 0;
    frame.size.width = 240;
    self.view.frame = frame;
    
    self.titleBar.hidden = YES;
    self.TopBackgroudImgV.hidden = YES;
    [self setTitleBarHidden:YES];
    
     self.view.backgroundColor = RGBACOLOR(45,44,44, 1);
    [self initDatasource];
    [self initSubview];
}
-(void)initDatasource
{
    if (_gouArr==nil)
    {
        _gouArr = [[NSMutableArray arrayWithCapacity:0]retain];
    }else
    {
        [_gouArr removeAllObjects];
    }
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
    titleBar_.text = _sxTitle;
    titleBar_.textColor = RGBCOLOR(208,205,205);
    titleBar_.font = [UIFont systemFontOfSize:15];
    [viewBar addSubview:titleBar_];
    [titleBar_ release];
       
    x=0;
    h=MainViewHeight-20-50;
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
    for (UIImageView *gou in _gouArr)
    {
        gou.hidden = YES;
    }
    UIImageView *gou = (UIImageView*)_gouArr[indexPath.section];
    gou.hidden = NO;
    
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(object:value:)])
        {
            SpecEntity *value = _shaiXuanArr[indexPath.section];
            [self.delegate object:self value:value];
        }
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell==nil)
    {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"]autorelease];
        cell.textLabel.backgroundColor = RGBCOLOR(35, 34, 34);
        cell.detailTextLabel.backgroundColor = RGBCOLOR(35, 34, 34);
        cell.contentView.backgroundColor = RGBCOLOR(35, 34, 34);
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20,0,cell.bounds.size.width-40, 44)];
        label.backgroundColor = RGBCOLOR(35, 34, 34);
        label.textColor = RGBCOLOR(208,205,205);
        label.font = [UIFont systemFontOfSize:15];
        label.tag = kCellLabelTag;
        [cell.contentView addSubview:label];
        [label release];
    }
    UIImage *gouI = [UIImage imageNamed:kSelectedImage];
    CGFloat y = (44-gouI.size.height/2.0)/2.0;
    UIImageView *gouV = [[UIImageView alloc]initWithFrame:CGRectMake(170, y, gouI.size.width/2.0, gouI.size.height/2.0)];
    gouV.image = gouI;
    [cell.contentView addSubview:gouV];
    [_gouArr addObject:gouV];
    gouV.hidden = YES;
    [gouV release];
    
    UILabel *label = (UILabel*)[cell.contentView viewWithTag:kCellLabelTag];
    SpecEntity *object = _shaiXuanArr[indexPath.section];
    label.text = object.specname;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
