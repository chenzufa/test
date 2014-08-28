//
//  MyClothListVC.m
//  HaiLanZhiJia
//
//  Created by chenzufa on 13-12-2.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "MyClothListVC.h"
#import "NotShowClothCell.h"
#import "ShowClothCell.h"
#import "FabuShaiDanVC.h"
#import "MyShowOrderEntity.h"
#import "UITableView+RemindNoData.h"
#import "ShangPingDetailVC.h"
#import "SeeBigPhoneVC.h"
@interface MyClothListVC ()<ViewWithImagesDelegate,FabuShaiDanVCDelegate>{
    NSInteger _page1;
    NSInteger _page2;
}

@property(nonatomic ,assign)NSInteger pageNumber1;  //未晒单页码
@property(nonatomic ,assign)NSInteger pageNumber2;  //已晒单页码

@end

@implementation MyClothListVC
@synthesize data1 = _data1;
@synthesize tableView1 = _tableView1;
@synthesize data2 = _data2;
@synthesize tableView2 = _tableView2;
@synthesize request = _request;

@synthesize pageNumber1 = _pageNumber1,pageNumber2 = _pageNumber2;

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
    
    _pageNumber1 = 1;
    _pageNumber2 = 1;
    _data1 = [[NSMutableArray alloc] init];
    _data2 = [[NSMutableArray alloc] init];
    
    [self setTitleString:@"我的晒单"];
    [self initTwoButton];
    [self initTableView1];
    [self initTableView2];
//    _tableView1.pullTableIsRefreshing = YES;
//    if (_tableView1.pullTableIsRefreshing) {
        [self initNRequest:YES];
//        [self performSelector:@selector(initNRequest) withObject:nil afterDelay:2.0];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    _request.delegate = nil;
    [_request release]; _request = nil;
    [_tableView1 release];_tableView1 = nil;
    [_tableView2 release];_tableView2 = nil;
    [_data1 release];_data1 = nil;
    [_data2 release];_data2 = nil;
    [super dealloc];
}

#pragma mark - init tableView
- (void)initTableView1{
    if (_tableView1 == nil) {
        _tableView1 = [[PullTableView alloc] initWithFrame:CGRectMake(0, 80, 320, self.view.frame.size.height - 80 - 20)];
        _tableView1.autoresizesSubviews = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tableView1.delegate = self;
        _tableView1.dataSource = self;
        if ([_tableView1 respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView1 setSeparatorInset:UIEdgeInsetsZero];
        }
        _tableView1.pullDelegate = self;
//        [_tableView1 setPullBackgroundColor:[UIColor clearColor]];
        
        _tableView1.tableFooterView = [[[UIView alloc] init] autorelease];
        [self.view addSubview:_tableView1];
    }
}

- (void)initTableView2{
    if (_tableView2 == nil) {
        _tableView2 = [[PullTableView alloc] initWithFrame:CGRectMake(0, 80, 320, self.view.frame.size.height - 80 - 20) style:UITableViewStylePlain];
        _tableView2.pullDelegate = self;
        _tableView2.hidden = YES;
        _tableView2.autoresizesSubviews = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tableView2.delegate = self;
        _tableView2.dataSource = self;
        if ([_tableView2 respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView2 setSeparatorInset:UIEdgeInsetsZero];
        }
        [_tableView2 setPullBackgroundColor:[UIColor clearColor]];
        _tableView2.tableFooterView = [[[UIView alloc] init] autorelease];
        [self.view addSubview:_tableView2];
    }
    
    [self initRequest:YES];
//    [self performSelector:@selector(initRequest) withObject:nil afterDelay:2.0];
}

//初始化 已晒单 和 未晒单两个按钮
- (void)initTwoButton{
    // 两个按钮
    MySegMentControl *segment = [[MySegMentControl alloc]initWithFrame:CGRectMake(0, [self getTitleBarHeight], 50, 50)];
    segment.segments = [NSArray arrayWithObjects:@"未晒单",@"已晒单", nil];
    [segment createSegments];
    segment.delegate = self;
    [self.view addSubview:segment];
    [segment release];
    
//    UIButton *hotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    hotBtn.tag = 200;
//    hotBtn.backgroundColor = [UIColor clearColor];
//    UIImage *myImg = GetImage(@"tab_sel2.png");
//    hotBtn.frame = CGRectMake(0, 45, 160, 35);
//    [hotBtn setTitle:@"未晒单" forState:UIControlStateNormal];
//    [hotBtn setBackgroundImage:myImg forState:UIControlStateSelected];
//    [hotBtn setTitleColor:TEXT_GRAY_COLOR forState:UIControlStateNormal];
//    [hotBtn setTitleColor:TEXT_BLUE_COLOR forState:UIControlStateSelected];
//    [hotBtn addTarget:self action:@selector(clickMenuButton:) forControlEvents:UIControlEventTouchUpInside];
//    hotBtn.selected = YES;
//    hotBtn.titleLabel.font = SYSTEMFONT(14);
//    [self.view addSubview:hotBtn];
//    
//    UIButton *history = [UIButton buttonWithType:UIButtonTypeCustom];
//    history.tag = 201;
//    history.backgroundColor = [UIColor clearColor];
//    history.frame = CGRectMake(160, 45, 160, 35);
//    [history setTitle:@"已晒单" forState:UIControlStateNormal];
//    [history setBackgroundImage:GetImage(@"tab_sel2.png") forState:UIControlStateSelected];
//    [history setTitleColor:TEXT_GRAY_COLOR forState:UIControlStateNormal];
//    [history setTitleColor:TEXT_BLUE_COLOR forState:UIControlStateSelected];
//    [history addTarget:self action:@selector(clickMenuButton:) forControlEvents:UIControlEventTouchUpInside];
//    history.titleLabel.font = SYSTEMFONT(14);
//    [self.view addSubview:history];
}

#pragma mark MySegmengControllerDelegate
- (void)segmentControl:(MySegMentControl *)setMentControl touchedAtIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            [_tableView1 setHidden:NO];
            [_tableView2 setHidden:YES];
            break;
        case 1:
            [_tableView1 setHidden:YES];
            [_tableView2 setHidden:NO];
            break;
            
        default:
            break;
    }
}

//- (void)clickMenuButton:(UIButton*)sender{
//    int another =0;
//    if (sender.tag == 200) {
//        another = 201;
//        [self showTableView:NO];
//    }else{
//        another = 200;
//        [self showTableView:YES];
//    }
//    sender.selected = YES;
//    UIButton *btn =(UIButton *)[self.view viewWithTag:another];
//    btn.selected = NO;
//}
//
//- (void)showTableView:(BOOL)hide{
//    _tableView1.hidden = hide;
//    _tableView2.hidden = !hide;
//}

//未晒单请求
- (void) initNRequest:(BOOL )isRefreshing{      // 为yes是  是刷新 no 是加载更多
    if (isRefreshing) {
        _tableView1.pullTableIsRefreshing = YES;
    }else _tableView1.pullTableIsLoadingMore = YES;
    
    if (_request == nil) {
        _request = [[DSRequest alloc] init];
        _request.delegate = self;
    }
    if ([_request checkNetWork]) {
        [_request requestDataWithInterface:MyShowOrder param:[self MyShowOrderParam:1 page:_pageNumber1] tag:0];
    }else{
        NSLog(@"网络连接不好");
        [self.view addHUDLabelView:@"网络连接失败" Image:nil afterDelay:1.0];
        _tableView1.pullTableIsRefreshing = NO;
        _tableView1.pullTableIsLoadingMore = NO;
    }
}

//已晒单请求
- (void) initRequest:(BOOL )isRefreshing{
    if (isRefreshing) {
        _tableView2.pullTableIsRefreshing = YES;
    }else _tableView2.pullTableIsLoadingMore = YES;
    
    if (_request == nil) {
        _request = [[DSRequest alloc] init];
        _request.delegate = self;
    }
    if ([_request checkNetWork]) {
        [_request requestDataWithInterface:MyShowOrder param:[self MyShowOrderParam:2 page:_pageNumber2] tag:1];
    }else{
        NSLog(@"网络连接不好");
        [self.view addHUDLabelView:@"网络连接失败" Image:nil afterDelay:1.0];
        _tableView2.pullTableIsLoadingMore = NO;
        _tableView2.pullTableIsRefreshing = NO;
    }
}

//未晒单
- (BOOL)nhadNext{
    return _pageNumber1*20 == _data1.count;
}

//已晒单
- (BOOL)hadNext{
    return _pageNumber2*20 == _data2.count;
}

#pragma mark - PullTableViewDelegate Methods
//刷新
- (void)pullTableViewDidTriggerRefresh:(PullTableView*)pullTableView{
    if (pullTableView == _tableView1) {
        _pageNumber1 = 1;
        [self initNRequest:YES];
//        [self performSelector:@selector(initNRequest) withObject:nil afterDelay:2.0];
    }else{
        _pageNumber2 = 1;
        [self initRequest:YES];
//        [self performSelector:@selector(initRequest) withObject:nil afterDelay:2.0];
    }
}

//加载更多
- (void)pullTableViewDidTriggerLoadMore:(PullTableView*)pullTableView{
    if (pullTableView == _tableView1) {
        [self initNRequest:NO];
//        [self performSelector:@selector(initNRequest) withObject:nil afterDelay:2.0];
    }else{
        [self initRequest:NO];
//        [self performSelector:@selector(initRequest) withObject:nil afterDelay:2.0];
    }
}

#pragma mark - UITableViewDataSource and UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tableView1) {
        return _data1.count;
    }else{
        return _data2.count;
    }
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView1) {
        return 113;
    }else{
        
        MyShowOrderEntity* entity = [_data2 objectAtIndex:indexPath.row];
        
        float height = 100;
        CGFloat contentWidth = 300;
        // 用何種字體進行顯示
        UIFont *font = [UIFont systemFontOfSize:14];
        // 該行要顯示的內容
        NSString *content = [entity.comment isKindOfClass:[NSString class]] ? [NSString stringWithFormat:@"晒单评价：%@",entity.comment] : @"";
        // 計算出顯示完內容需要的最小尺寸
        CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
        // 這裏返回需要的高度
        
        if (size.height > 0) {
            height += size.height+20;
        }
        // 还未判断小图是否有数据显示
        if (entity.imgarray.count > 0) {
            height += 65;
            return height;
        }else{
            return height;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView1) {
        static NSString* identifield = @"cell";
        NotShowClothCell* cell = [tableView dequeueReusableCellWithIdentifier:identifield];
        if (cell == nil) {
            cell = [[[NotShowClothCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifield] autorelease];
        }
        
        MyShowOrderEntity* entity = [_data1 objectAtIndex:indexPath.row];
        
        if ([entity.goodsimg isKindOfClass:[NSString class]]) {
            [cell.imgView setImageWithURL:[NSURL URLWithString:entity.goodsimg] placeholderImage:[UIImage imageNamed:@"列表小图.png"]];
        }else{
            cell.imgView.image = [UIImage imageNamed:@"列表小图.png"];
        }
        
        if ([entity.goodsname isKindOfClass:[NSString class]]) {
            cell.name.text = entity.goodsname;
        }
        
        if ([entity.sizeandcolor isKindOfClass:[NSString class]]) {
            cell.color.text = entity.sizeandcolor;
        }
        if ([entity.buydate isKindOfClass:[NSString class]]) {
            cell.date.text = entity.buydate;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString* identifield = @"cell1";
        ShowClothCell* cell = [tableView dequeueReusableCellWithIdentifier:identifield];
        if (cell == nil) {
            cell = [[[ShowClothCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifield] autorelease];
        }
        
         MyShowOrderEntity* entity = [_data2 objectAtIndex:indexPath.row];
        
        if ([entity.goodsimg isKindOfClass:[NSString class]]) {
            [cell.imgView setImageWithURL:[NSURL URLWithString:entity.goodsimg] placeholderImage:[UIImage imageNamed:@"列表小图.png"]];
        }else{
            cell.imgView.image = [UIImage imageNamed:@"列表小图.png"];
        }
        
        if ([entity.goodsname isKindOfClass:[NSString class]]) {
            cell.name.text = entity.goodsname;
        }
        
        if ([entity.sizeandcolor isKindOfClass:[NSString class]]) {
            cell.color.text = entity.sizeandcolor;
        }
        if ([entity.comment isKindOfClass:[NSString class]]) {
            cell.content.numberOfLines = 0;
            cell.content.text = [NSString stringWithFormat:@"晒单评价：%@",entity.comment];
            [cell.content sizeToFit];
        }
        cell.content.frame = CGRectMake(cell.content.frame.origin.x, cell.content.frame.origin.y, 300, cell.content.frame.size.height + 10);
        
        cell.smallImgs.viewWithImagesDelegate = self;
        float ox = cell.content.frame.origin.y+cell.content.frame.size.height;
        cell.smallImgs.frame = CGRectMake(0, ox, 0, 0);
        [cell setSmallimgsWithArray:entity.imgarray];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _tableView1) {         //  未晒单
        MyShowOrderEntity* entity = [_data1 objectAtIndex:indexPath.row];
        
        FabuShaiDanVC* fabuShaidan = [[FabuShaiDanVC alloc] init];
        fabuShaidan.delegate = self;
        fabuShaidan.goodID = entity.goodsid;
        fabuShaidan.sizeAndColor = entity.sizeandcolor;
        fabuShaidan.orderID = entity.ordergoodsid;
        [self pushViewController:fabuShaidan];
        [fabuShaidan release];
    }else{                                  //  已晒单
        MyShowOrderEntity *one = [_data2 objectAtIndex:indexPath.row];
        ShangPingDetailVC *vc = [[ShangPingDetailVC alloc]init];
        vc.spId = one.goodsid;
        [self pushViewController:vc];
        [vc release];
    }
}

#pragma mark - FabuShaiDanVCDelegate Methods
//发布晒单成功
- (void)fabuSuccessed{
    _pageNumber1 = 1;
    _pageNumber2 = 1;
//    _tableView1.pullTableIsRefreshing = YES;
//    if (_tableView1.pullTableIsRefreshing) {
        [self initNRequest:YES];
        [self initRequest:YES];
//        [self performSelector:@selector(initNRequest) withObject:nil afterDelay:2.0];
//        [self performSelector:@selector(initRequest) withObject:nil afterDelay:2.0];
//    }
}

#pragma mark - viewWithImgs Delegate
-(void)selectedImg:(ViewWithImages*)view atIndex:(NSInteger)index{
    ShowClothCell* cell = nil;
    if (isBigeriOS7version) {
        cell = (ShowClothCell*)[[[view superview] superview] superview];
    }else{
        cell = (ShowClothCell*)[[view superview] superview];
    }
    NSIndexPath* indexPath = [_tableView2 indexPathForCell:cell];
    
    MyShowOrderEntity* entity = [_data2 objectAtIndex:indexPath.row];
    
    SeeBigPhoneVC* bigPhone = [[SeeBigPhoneVC alloc] init];
    if ([entity.imgarray isKindOfClass:[NSArray class]]) {
        bigPhone.imgs = entity.imgarray;
    }
    bigPhone.selectIndex = index;
    bigPhone.goodsid = entity.goodsid;
    bigPhone.comment = entity.comment;
    [self pushViewController:bigPhone];
    [bigPhone release];
}

#pragma mark - DSRequestDelegate Methods
-(void)requestDataSuccess:(id)dataObj tag:(int)tag{
    _tableView1.pullTableIsRefreshing = NO;
    _tableView1.pullTableIsLoadingMore = NO;
    _tableView2.pullTableIsLoadingMore = NO;
    _tableView2.pullTableIsRefreshing = NO;    
//    if (dataObj == nil) {
//        [self.view addHUDLabelView:@"数据已完全加载！" Image:nil afterDelay:2.0];
//    }
    
    NSLog(@"请求成功");
    if (tag == 0) {      //未晒单数据
         NSLog(@"1111******%@",dataObj);
        if (_pageNumber1 == 1) {
            [_data1 removeAllObjects];
        }
        if (_pageNumber1!= 1 && _page1 == _pageNumber1) {
            int index = _data1.count / 20 * 20;
            int j = _data1.count - _data1.count / 20 * 20;
            for (int i = 0; i < j; i++) {
                [_data1 removeObjectAtIndex:index];
            }
            [_data1 addObjectsFromArray:(NSArray*)dataObj];
        }else{
            [_data1 addObjectsFromArray:(NSArray*)dataObj];
        }
        _page1 = _pageNumber1;
        
        if ([self nhadNext]) {
            _pageNumber1++;
        }
        
        if (_data1.count == 0) {
            [_tableView1 addRemindWhenNoData:@"您还没有可晒单的商品"];
            
        }else {
            [_tableView1 hiddenReminndWhenNoDatainSupView];
            
        }
        NSLog(@"--------------%d",_pageNumber1);
        [_tableView1 reloadData];
    }else{               //已晒单数据
        NSLog(@"2222******%@",dataObj);
        if (_pageNumber2 == 1) {
            [_data2 removeAllObjects];
        }
        if (_pageNumber2!= 1 && _page2 == _pageNumber2) {
            int index = _data2.count / 20 * 20;
            int j = _data2.count - _data2.count / 20 * 20;
            for (int i = 0; i < j; i++) {
                [_data2 removeObjectAtIndex:index];
            }
            [_data2 addObjectsFromArray:(NSArray*)dataObj];
        }else{
            [_data2 addObjectsFromArray:(NSArray*)dataObj];
        }
        _page2 = _pageNumber2;
        
        if ([self hadNext]) {
            _pageNumber2++;
        }

        if (_data2.count == 0) {
            [_tableView2 addRemindWhenNoData:@"您还没有给商品晒单，赶快晒一晒"];
            
        }else {
            [_tableView2 hiddenReminndWhenNoDatainSupView];

        }
        NSLog(@"+++++++++++++++%d",_pageNumber2);
        [_tableView2 reloadData];
    }
}

-(void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError*)error{
    NSLog(@"请求失败");
    _tableView1.pullTableIsRefreshing = NO;
    _tableView1.pullTableIsLoadingMore = NO;
    _tableView2.pullTableIsLoadingMore = NO;
    _tableView2.pullTableIsRefreshing = NO;
    
    [self.view addHUDLabelView:error.domain Image:nil afterDelay:2.0];
}

@end
