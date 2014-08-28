//
//  ShowClothVC.m
//  HaiLanZhiJia
//
//  Created by chenzufa on 13-12-2.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "ShowClothVC.h"
#import "MyClothListVC.h"
#import "PKShowClothCell.h"
#import "ShowOrderEntity.h"
#import "UIImageView+WebCache.h"
#import "SeeBigPhoneVC.h"
#import "ShangPingDetailVC.h"

@interface PKButton : UIButton
@end

@implementation PKButton
@end

@interface ShowClothVC ()<FaCelldelegate>
{
    NSInteger _page;
    BOOL _isBack;
}

@property(nonatomic , retain)NSMutableArray* items;
@property(nonatomic , assign)NSInteger pageNumber;
@property(nonatomic , retain)UILabel* labRemindNoData;
@property(nonatomic , retain)NSMutableDictionary* dicImg;
@property(nonatomic , retain)NSTimer* timer;
@end

@implementation ShowClothVC
@synthesize collectionView = _collectionView;
@synthesize items = _items;
@synthesize request =_request;
@synthesize pageNumber = _pageNumber;
@synthesize labRemindNoData = _labRemindNoData;
@synthesize dicImg = _dicImg;
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
    _items = [[NSMutableArray alloc] init];
    _pageNumber = 1; //默认页码为1
    _page = _pageNumber;
    _dicImg = [[NSMutableDictionary alloc] init];
    
    [self setTitleString:@"晒单"];
    [self initRightButton];
    [self initpcCollectionView];
    
    _labRemindNoData= [[UILabel alloc]initWithFrame:CGRectMake(20, 100, self.view.frame.size.width - 85, 30)];
    [_labRemindNoData setNumberOfLines:2];
    [_labRemindNoData setFont:SetFontSize(FontSize12)];
    [_labRemindNoData setTextColor:ColorFontgray];
    [_labRemindNoData setTextAlignment:NSTextAlignmentCenter];
    [_labRemindNoData setBackgroundColor:[UIColor clearColor]];
    _labRemindNoData.hidden = YES;
    [self.view addSubview:_labRemindNoData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fabuSuccessed:) name:@"FabuShaiDanSuccessed" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _request.delegate = nil;
    [_request release];_request = nil;
    [_items release];_items = nil;
    [_collectionView release];_collectionView = nil;
    [_labRemindNoData release];_labRemindNoData = nil;
    [_dicImg release];_dicImg = nil;
    [self.timer invalidate];
    self.timer  = nil;
    [super dealloc];
}

#pragma mark - Init UI
//导航栏右边按钮
- (void)initRightButton
{
    UIButton* myRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [myRightButton setFrame:CGRectMake(238, 7, 75, 30)];
    [myRightButton.titleLabel setFont:SetFontSize(FontSize15)];
    [myRightButton setTitle:@"我的晒单" forState:UIControlStateNormal];
    [myRightButton setTitleColor:RGBCOLOR(236, 224, 224) forState:UIControlStateNormal];
    [myRightButton setBackgroundImage:[UIImage imageNamed:@"button2.png"] forState:UIControlStateNormal];
    [myRightButton setBackgroundImage:[UIImage imageNamed:@"button2_press.png"] forState:UIControlStateHighlighted];
    [myRightButton addTarget:self action:@selector(myRightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleBar addSubview:myRightButton];
}

- (void)myRightButtonAction:(UIButton*)sender{
    if (isNotLogin) {
        LoginViewCtrol *loginView = [[LoginViewCtrol alloc]init];
        [self pushViewController:loginView];
        [loginView release];
    }else {
        MyClothListVC* myClothList = [[MyClothListVC alloc] init];
        [self pushViewController:myClothList];
        [myClothList release];
    }
}

//初始化瀑布流列表
-(void)initpcCollectionView
{
    _collectionView = [[PullPsCollectionView alloc] initWithFrame:CGRectMake(0, 45, self.view.frame.size.width, self.view.frame.size.height - 45 )];
    if (isBigeriOS7version) {
        _collectionView.frame = CGRectMake(0, 45, self.view.frame.size.width, self.view.frame.size.height - 45-20 );
    }
    [self.view insertSubview:_collectionView atIndex:0];
    _collectionView.collectionViewDelegate = self;
    _collectionView.collectionViewDataSource = self;
    _collectionView.pullDelegate=self;
    _collectionView.backgroundColor = RGBCOLOR(247, 247, 247);
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    
    _collectionView.numColsPortrait = 2;
    _collectionView.numColsLandscape = 3;
    _collectionView.pullArrowImage = [UIImage imageNamed:@"blackArrow"];
    _collectionView.pullBackgroundColor = [UIColor clearColor];
    _collectionView.pullTextColor = ColorFontBlack;
    //    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
    //    [headerView setBackgroundColor:[UIColor redColor]];
    //    self.collectionView.headerView=headerView;
    //    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:self.collectionView.bounds];
    //    loadingLabel.text = @"Loading...";
    //    loadingLabel.textAlignment = UITextAlignmentCenter;
    //    _collectionView.loadingView = loadingLabel;
    
    //    [self loadDataSource];
    if(!_collectionView.pullTableIsRefreshing) {
        _collectionView.pullTableIsRefreshing = YES;
        [self refreshTable];
//        [self performSelector:@selector(refreshTable) withObject:nil afterDelay:2.0];
    }
}

- (void)initRequest{
    if (_request == nil) {
        _request = [[DSRequest alloc] init];
        _request.delegate = self;
    }
    if ([_request checkNetWork]) {
        [_request requestDataWithInterface:ShowOrderList param:[self ShowOrderListParam:_pageNumber] tag:0];
    }else{
        NSLog(@"网络连接不好");
        [self.view addHUDLabelView:@"网络连接失败" Image:nil afterDelay:2.0];
    }
}

- (void) refreshTable
{
    self.collectionView.pullLastRefreshDate = [NSDate date];
    self.collectionView.pullTableIsRefreshing = YES;
    [self initRequest];
}

- (void) loadMoreDataToTable
{
    self.collectionView.pullTableIsLoadingMore = YES;
    [self initRequest];
}

- (BOOL)hasNext{
    return _pageNumber* 20 == _items.count;
}

- (void)selectTitle:(UIButton*)sender{
    NSLog(@"%d",sender.tag-500);
    ShowOrderEntity* entity = [_items objectAtIndex:sender.tag - 500];
    
    ShangPingDetailVC * detail = [[ShangPingDetailVC alloc] init];
    detail.spId = entity.goodsid;
    [self pushViewController:detail];
    [detail release];
}

#pragma mark - PullTableViewDelegate
//刷新
- (void)pullPsCollectionViewDidTriggerRefresh:(PullPsCollectionView *)pullTableView
{
    _pageNumber = 1;
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:2.0f];
}

//下拉加载
- (void)pullPsCollectionViewDidTriggerLoadMore:(PullPsCollectionView *)pullTableView
{
    [self loadMoreDataToTable];
//    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:2.0f];
}

#pragma mark - PKCollectionViewTableViewDataSource or PKCollectionDelegate
- (PKCollectionViewCell *)collectionView:(PKCollectionView *)collectionView viewAtIndex:(NSInteger)index {
//    NSInteger i = index%5;
    
    ShowOrderEntity* entity = [_items objectAtIndex:index];
    
    PKShowClothCell *cell = (PKShowClothCell *)[self.collectionView dequeueReusableView];
    if (!cell) {
        cell = [[[PKShowClothCell alloc] initWithFrame:CGRectZero] autorelease] ;
    }else{
        for ( int i = 0; i < cell.subviews.count; i++) {  //避免重用
            UIView* view = [cell.subviews objectAtIndex:i];
            if ([view isKindOfClass:[PKButton class]]) {
                [view removeFromSuperview];
            }
        }
    }
    /*
     胡鹏加
     */
    cell.tag = index;
    [cell initViews];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.imageView.image = [_dicImg objectForKey:[NSNumber numberWithInt:index]];
    cell.imageView.frame = CGRectMake(0, 0, 148, cell.imageView.image.size.height / cell.imageView.image.size.width*148);
    
    NSMutableString* str = [NSMutableString string];
    if ([entity.username isKindOfClass:[NSString class]] && entity.username.length > 0) {
        [str appendFormat:@"%@：",entity.username];
    }else{
        [str appendString:@""];
    }
    
    if ([entity.title isKindOfClass:[NSString class]]) {
        [str appendString:entity.title];
    }
    
    cell.name.text = str;
    
    cell.name.numberOfLines = 0;
    [cell.name sizeToFit];
    cell.name.frame = CGRectMake(5, cell.imageView.frame.size.height+5, 140,cell.name.frame.size.height);
        
    PKButton* button = [PKButton buttonWithType:UIButtonTypeCustom];
    button.frame = cell.name.frame;
    button.tag = 500+index;
    cell.delgate = self;
    [button addTarget:self action:@selector(selectTitle:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:button];
    
    return cell;
}

- (CGFloat)heightForViewAtIndex:(NSInteger)index {
    ShowOrderEntity* entity = [_items objectAtIndex:index];
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    if ([entity.thumbnailimg isKindOfClass:[NSArray class]]) {
        if (entity.thumbnailimg.count > 0) {
            [dic setObject:[entity.thumbnailimg objectAtIndex:0] forKey:@"url"];
        }
    }
    
    NSMutableString* str = [NSMutableString string];
    if ([entity.username isKindOfClass:[NSString class]] && entity.username.length > 0) {
        [str appendFormat:@"%@：",entity.username];
    }else{
        [str appendString:@""];
    }
    
    if ([entity.title isKindOfClass:[NSString class]]) {
        [str appendString:entity.title];
    }
    [dic setObject:str forKey:@"title"];
    
    UIImage* oldImg = [UIImage imageNamed:@"商品大图.png"];
    if ([_dicImg objectForKey:[NSNumber numberWithInt:index]] && oldImg != [_dicImg objectForKey:[NSNumber numberWithInt:index]]) {
        UIImage* image = [_dicImg objectForKey:[NSNumber numberWithInt:index]];
        
        // Label
        NSString *caption = [dic objectForKey:@"title"];
        CGSize labelSize = CGSizeZero;
        UIFont *labelFont = [UIFont boldSystemFontOfSize:14.0];
        labelSize = [caption sizeWithFont:labelFont constrainedToSize:CGSizeMake(148, INT_MAX) lineBreakMode:UILineBreakModeWordWrap];

        return floorf(image.size.height / (image.size.width / 148)) + labelSize.height+5;
        
    }else{
        CGFloat height = 0.0;
        CGFloat width = 148 ;
        
        height += 4;
        
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 148, 148)];
        NSLog(@"%@",[dic objectForKey:@"url"]);
        [imageView setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"url"]] placeholderImage:[UIImage imageNamed:@"商品大图.png"]];
        
        
        [_dicImg setObject:imageView.image forKey:[NSNumber numberWithInt:index]];
        height += floorf(imageView.image.size.height / (imageView.image.size.width / width));
        
        [imageView release];
        // Label
        NSString *caption = [dic objectForKey:@"title"];
        CGSize labelSize = CGSizeZero;
        UIFont *labelFont = [UIFont boldSystemFontOfSize:14.0];
        labelSize = [caption sizeWithFont:labelFont constrainedToSize:CGSizeMake(width, INT_MAX) lineBreakMode:UILineBreakModeWordWrap];
        
        height += labelSize.height;
        height += 5;
        
        return height;
    }
}


-(void)selectPuBuCell:(int)index
{
    NSLog(@"!!!!!!!!!!!!%d",index);
    ShowOrderEntity* entity = [_items objectAtIndex:index];
    NSMutableArray* array = [[NSMutableArray alloc] init];
    if ([entity.imgarray isKindOfClass:[NSArray class]]) {
        [array addObjectsFromArray:entity.imgarray];
    }
    
    SeeBigPhoneVC* bigPhone = [[SeeBigPhoneVC alloc] init];
    bigPhone.selectIndex = 0;
    bigPhone.imgs = array;
    bigPhone.goodsid = entity.goodsid;
    bigPhone.comment = entity.content;
    [self pushViewController:bigPhone];
    [bigPhone release];
    
    [array release];

    
}


//- (void)collectionView:(PKCollectionView *)collectionView didSelectView:(PKCollectionViewCell *)view atIndex:(NSInteger)index {
//    ShowOrderEntity* entity = [_items objectAtIndex:index];
//    NSMutableArray* array = [[NSMutableArray alloc] init];
//    if ([entity.imgarray isKindOfClass:[NSArray class]]) {
//        [array addObjectsFromArray:entity.imgarray];
//    }
//    
//    SeeBigPhoneVC* bigPhone = [[SeeBigPhoneVC alloc] init];
//    bigPhone.selectIndex = 0;
//    bigPhone.imgs = array;
//    bigPhone.goodsid = entity.goodsid;
//    bigPhone.comment = entity.content;
//    [self pushViewController:bigPhone];
//    [bigPhone release];
//    
//    [array release];
//}

- (NSInteger)numberOfViewsInCollectionView:(PKCollectionView *)collectionView {
    return [_items count];
}

#pragma mark - DSRequestDelegate Methods
-(void)requestDataSuccess:(id)dataObj tag:(int)tag{
    NSLog(@"%d,%d",[(NSArray*)dataObj count],_pageNumber);
    self.collectionView.pullTableIsRefreshing = NO;
    self.collectionView.pullTableIsLoadingMore = NO;
    if (dataObj == nil) {
        [self.view addHUDLabelView:@"数据已完全加载！" Image:nil afterDelay:2.0];
        return;
    }
    if (_pageNumber == 1) {
        [_items removeAllObjects];
    }
    if (_pageNumber!= 1 && _page == _pageNumber) {
        int index = _items.count / 20 * 20;
        int j = _items.count - _items.count / 20 * 20;
        for (int i = 0; i < j; i++) {
            [_items removeObjectAtIndex:index];
            [_dicImg removeObjectForKey:[NSNumber numberWithInt:index+i]];
        }
        [_items addObjectsFromArray:(NSArray*)dataObj];
    }else{
        [_items addObjectsFromArray:(NSArray*)dataObj];
    }
    _page = _pageNumber;
    if ([self hasNext]) {
        _pageNumber++; // 加载成功后页码加1
    }

    [_collectionView reloadData];
    
    if (_items.count == 0) {
        _collectionView.hidden = YES;
        _labRemindNoData.hidden = NO;
    }else{
        _collectionView.hidden = NO;
        _labRemindNoData.hidden = YES;
    }
    
    if (_isBack) {
        [self.timer invalidate];
        self.timer = nil;
    }else{
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(refreshData:) userInfo:nil repeats:YES];
    }
}

-(void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError*)error{
    [self.view addHUDLabelView:error.domain Image:nil afterDelay:2.0];
    self.collectionView.pullTableIsRefreshing = NO;
    self.collectionView.pullTableIsLoadingMore = NO;
}

- (void)refreshData:(NSTimer*)timer{
    UIImage* image = [UIImage imageNamed:@"商品大图.png"];
    for (int i = 0; i < _items.count; i++) {
        UIImage* im =[_dicImg objectForKey:[NSNumber numberWithInt:i]];
        if (im == image) {
            if (!_isBack) {
                [_collectionView reloadData];
            }
            return;
        }
    }
    [self.timer invalidate];
    self.timer = nil;
}   

- (void)fabuSuccessed:(NSNotification*)fication{
    _pageNumber = 1;
    _collectionView.pullTableIsRefreshing = YES;
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:2.0];
}

- (void)leftAction{
    [self popViewController];
    _isBack = YES;
}

@end
