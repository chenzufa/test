//
//  ShakeVC.m
//  HaiLanZhiJia
//
//  Created by chenzufa on 13-12-3.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "ShakeVC.h"
#import "ShakeRestrictEntity.h"
#import "SpecEntity.h"
#import "ShangPingDetailVC.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#define degreesToRadians(x) (M_PI*(x)/180.0)

//左右摇摆的角度
#define RADIUS 3.0f
#define SOUNDID  1109  //CalendarAlert
#define ShakeTime 0.3

@interface ShakeVC ()<UIPickerViewDataSource,UIPickerViewDelegate,UIScrollViewDelegate>{
    BOOL _isStop;
    BOOL _willBack;
//    NSTimer *shakTimer;
}

@property(nonatomic , retain)DSRequest* shakeRequest;
@property(nonatomic , retain)DSRequest* factorRequest;
@property(nonatomic , retain)UIView* productView;
@property(nonatomic , retain)UIView* priceView;
@property(nonatomic , retain)NSArray* pickDataForType;  //全部种类
@property(nonatomic , retain)NSArray* pickDataForPrice; //全部价格
@property(nonatomic , retain)UIView* popView;
@property(nonatomic , retain)UIPickerView* pickView;
@property(nonatomic , retain)UIImageView* bgImg;
@property(nonatomic , retain)NSTimer* myTimer;
@property(nonatomic , retain)UIScrollView* contentScrollView;
@property(nonatomic , retain)GoodEntity* goodEntity;
@property (nonatomic, retain)AVAudioPlayer *audioPlayer;

@property(nonatomic , assign)BOOL isProduct;
@property(nonatomic , assign)NSInteger selectIndex;
@property(nonatomic , assign)BOOL isFirst; //摇一摇第一次

@end

@implementation ShakeVC
@synthesize productView = _productView;
@synthesize priceView = _priceView;
@synthesize isProduct = _isProduct;
@synthesize pickDataForType = _pickDataForType;
@synthesize pickDataForPrice = _pickDataForPrice;
@synthesize popView = _popView;
@synthesize pickView = _pickView;
@synthesize selectIndex = _selectIndex;
@synthesize contentScrollView = _contentScrollView;
@synthesize shakeRequest = _shakeRequest;
@synthesize factorRequest = _factorRequest;
@synthesize isFirst = _isFirst;
@synthesize bgImg = _bgImg;
@synthesize myTimer = _myTimer;
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
    
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    [self becomeFirstResponder];
    
    _isFirst = YES;
    
    [self setTitleString:@"摇一摇"];
    
    [self initBackGroundImg];
    [self initShakeButton];
    
    [self initFacrorRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:NO];
    [_priceView release];_priceView = nil;
    [_productView release];_productView =  nil;
    [_pickDataForPrice release];_pickDataForPrice = nil;
    [_pickDataForType release];_pickDataForType = nil;
    [_popView release]; _popView = nil;
    [_pickView release];[_pickView release];
    [_contentScrollView release];_contentScrollView = nil;
    _shakeRequest.delegate = nil;
    [_shakeRequest release];_shakeRequest = nil;
    _factorRequest.delegate = nil;
    [_factorRequest release];_factorRequest = nil;
    [_bgImg release];_bgImg = nil;
    self.goodEntity = nil;
    
    self.audioPlayer = nil;
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)leftAction{
    [super leftAction];
    [self popViewController];
    _willBack = YES;
    [self stopShakeAll];
}

#pragma mark ---------------
- (void) senderMotion
{
    AudioServicesPlaySystemSound(SOUNDID);
    
    //震动
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self player:@"摇一摇.mp3"];
    // 发送请求
    
    
}

/*！
 * @abstract  播放本地音频
 *
 * @param filename  文件路径
 */
- (void) player:(NSString*) filename
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    NSString *strPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:filename];
    NSURL *url = [NSURL fileURLWithPath:strPath];
    
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    player.numberOfLoops = 0;
    player.currentTime = 0.0;
    [player prepareToPlay];
    //    player.delegate = self;
    self.audioPlayer = player;
    [player play];
    [player release];
}


#pragma mark - Init UI
//摇一摇按钮
- (void)initShakeButton{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(277, 9, 27, 27);
    button.tag = 120;
    [button setBackgroundImage:[UIImage imageNamed:@"search_shake_icon_shake@2x.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(shakeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleBar addSubview:button];
}

//摇一摇数据请求
- (void)initShakeRequest{
    if (_shakeRequest == nil) {
        _shakeRequest = [[DSRequest alloc] init];
        _shakeRequest.delegate = self;
    }
    if (!self.items) {
        self.items = @"0";
    }
    
    if (!self.price) {
        self.price = @"0";
    }
    
    if ([_shakeRequest checkNetWork]) {
        NSLog(@"******************%@,%@",self.items,self.price);
        [_shakeRequest requestDataWithInterface:GetShakeSearchResult param:[self GetShakeSearchResultParam:[NSArray arrayWithObjects:self.items, nil] subastrict:[NSArray arrayWithObjects:self.price, nil]] tag:0];
    }else{
        [self stopShakeAll];
        [self.view addHUDLabelView:@"网络连接失败" Image:nil afterDelay:1.0];
        [(UIButton*)[self.titleBar viewWithTag:120] setEnabled:YES];
        _isStop = NO;
    }
}

//摇一摇条件筛选数据请求
- (void)initFacrorRequest{
    if (_factorRequest == nil) {
        _factorRequest = [[DSRequest alloc] init];
        _factorRequest.delegate = self;
    }
    if ([_factorRequest checkNetWork]) {
        [_factorRequest requestDataWithInterface:GetShakeRestrict param:[self GetShakeRestrictParam] tag:1];
    }else{
        NSLog(@"网络中断");
    }
}

- (void)initTwoButtons{
    UIImageView* bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab_bg@2x.png"]];
    bgView.userInteractionEnabled = YES;
    bgView.frame = CGRectMake(0, 45, 320, 35);
    [self.view addSubview:bgView];
    [bgView release];
    
    UIImageView*  centerLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_shake_line@2x.png"]];
    centerLine.frame = CGRectMake(160, 0, 1, 35);
    [bgView addSubview:centerLine];
    [centerLine release];
    
    //商品种类
    _productView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 35)];
    _productView.backgroundColor = [UIColor clearColor];
    _productView.tag = 100;
    [bgView addSubview:_productView];
    
    UILabel* title1 = [[UILabel alloc] init];
    title1.backgroundColor = [UIColor clearColor];
    title1.font = [UIFont systemFontOfSize:15];
    title1.textColor = RGBCOLOR(46, 46, 46);
    [_productView addSubview:title1];
    [title1 release];
    
    UIImageView* img1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_shake_icon_down@2x.png"]];
    [_productView addSubview:img1];
    [img1 release];
    NSLog(@"%@            %@",[[_pickDataForType objectAtIndex:0] categoryname],[[_pickDataForType objectAtIndex:0] categoryid]);
    if ([[[_pickDataForType objectAtIndex:0] categoryname] isKindOfClass:[NSString class]]) {
        [self setViewTitleInView:_productView andTitle:[[_pickDataForType objectAtIndex:0] categoryname]];
    }
    if (![[[_pickDataForType objectAtIndex:0] categoryid] isKindOfClass:[NSNull class]]) {
        self.items = [[_pickDataForType objectAtIndex:0] categoryid];
    }
    UITapGestureRecognizer* tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showZhonglei:)];
    [_productView addGestureRecognizer:tap1];
    [tap1 release];
    
    //商品价格
    _priceView = [[UIView alloc] initWithFrame:CGRectMake(160, 0, 160, 35)];
    _priceView.backgroundColor = [UIColor clearColor];
    _priceView.tag = 101;
    [bgView addSubview:_priceView];
    
    UILabel* title2 = [[UILabel alloc] init];
    title2.backgroundColor = [UIColor clearColor];
    title2.font = [UIFont systemFontOfSize:15];
    title2.textColor = RGBCOLOR(46, 46, 46);
    [_priceView addSubview:title2];
    [title2 release];
    
    UIImageView* img2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_shake_icon_down@2x.png"]];
    [_priceView addSubview:img2];
    [img2 release];
    if ([[[_pickDataForPrice objectAtIndex:0] specname] isKindOfClass:[NSString class]]) {
        [self setViewTitleInView:_priceView andTitle:[[_pickDataForPrice objectAtIndex:0] specname]];
    }
    if ([[_pickDataForPrice objectAtIndex:0] specid]) {
        self.price = [[_pickDataForPrice objectAtIndex:0] specid];
    }
    
    UITapGestureRecognizer* tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showZhonglei:)];
    [_priceView addGestureRecognizer:tap2];
    [tap2 release];
}

//默认图片
- (void)initBackGroundImg{
    NSArray* imageArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"search_shake_icon_shake2@2x.png"],
                                                           [UIImage imageNamed:@"search_shake_icon_shake3@2x.png"],
                                                           nil];
    
    _bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 82.5, 79)];
    _bgImg.image = [UIImage imageNamed:@"search_shake_icon_shake2@2x.png"];
    _bgImg.center = CGPointMake(MainViewWidth/2.0, MainViewHeight / 2.0);
    _bgImg.animationImages = imageArray;
    _bgImg.animationDuration = 0.5f;
    _bgImg.animationRepeatCount = 0;
    [self.view addSubview:_bgImg];
}

//初始化摇一摇数据显示视图
- (void)initContentScrollView{
    [self stopShakeAll]; //停止动画
    
    if (_willBack) {
        return;
    }
    
    if (_isFirst) {
        [_bgImg stopAnimating];
        [_bgImg removeFromSuperview];_bgImg = nil;
        _isFirst = NO;
    }
    
    if (_contentScrollView != nil) {
        [UIView animateWithDuration:0.3 animations:^{
            _contentScrollView.frame = CGRectMake(0, - (MainViewHeight - 100), 320,MainViewHeight - 100);
        } completion:^(BOOL finished) {
                    }];
        [_contentScrollView release];
        _contentScrollView = nil;
    }

    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, 320,MainViewHeight - 80 - 20)];
    _contentScrollView.delegate = self;
    _contentScrollView.pagingEnabled = NO;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.showsVerticalScrollIndicator = NO;
    _contentScrollView.contentSize = CGSizeMake(0, 428);
    if (_popView) {
        [self.view insertSubview:_contentScrollView belowSubview:_popView];
    }else{
        [self.view addSubview:_contentScrollView];
    }
    
    
    //商品图片
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(92.5, 72, 135, 135)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.tag = 500;
    imageView.clipsToBounds = YES;
    
    [imageView setImageWithURL:[NSURL URLWithString:self.goodEntity.goodsimg] placeholderImage:[UIImage imageNamed:@"商品大图"]];
    [_contentScrollView addSubview:imageView];
    [imageView release];
    
    //商品价格
    UILabel*  price = [[UILabel alloc] initWithFrame:CGRectMake(0, 225, 320, 14)];
    price.backgroundColor = [UIColor clearColor];
    price.textAlignment = NSTextAlignmentCenter;
    price.font = [UIFont systemFontOfSize:14];
    price.textColor = RGBCOLOR(240, 103, 103);
    if ([self.goodEntity.price isKindOfClass:[NSString class]]) {
        price.text =[NSString stringWithFormat:@"￥%@",self.goodEntity.price];
    }
    
    [_contentScrollView addSubview:price];
    [price release];
    
    //商品简介
    UILabel* infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 250, 190, 38)];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.font = [UIFont systemFontOfSize:15];
    infoLabel.textColor = RGBCOLOR(63, 63, 63);
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.numberOfLines = 2;
    if ([self.goodEntity.goodsname isKindOfClass:[NSString class]]) {
        infoLabel.text = self.goodEntity.goodsname;
    }
    [_contentScrollView addSubview:infoLabel];
    [infoLabel release];
    
    //查看详情
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(101, 305, 118, 29);
    [button setBackgroundImage:[UIImage imageNamed:@"search_shake_button_details@2x.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"search_shake_button_details_press@2x.png"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(showInfo:) forControlEvents:UIControlEventTouchUpInside];
    [_contentScrollView addSubview:button];
    
    [UIView animateWithDuration:1.0f animations:^{
        _contentScrollView.frame = CGRectMake(0, 80, 320,MainViewHeight - 80 - 20);
    }];
}

#pragma mark - 按钮 Methods
//摇一摇
- (void)shakeClick:(UIButton*)sender{
    [self shaking];
}

- (void)shaking
{
    if (self.isFirst) {
        _myTimer = [NSTimer scheduledTimerWithTimeInterval:0.14 target:self selector:@selector(ShakeAnimationWithView:) userInfo:nil repeats:YES];
        [_myTimer fire];
    }else{
        _myTimer = [NSTimer scheduledTimerWithTimeInterval:0.14 target:self selector:@selector(ShakeAnimationWithUIImageview:) userInfo:nil repeats:YES];
        [_myTimer fire];
    }
    _isStop = YES;
    [(UIButton*)[self.titleBar viewWithTag:120] setEnabled:NO];
    
    [self senderMotion];
    
    
    [self performSelector:@selector(initShakeRequest) withObject:nil afterDelay:2.0];
}

//设置名字与图片居中显示
- (void)setViewTitleInView:(UIView*)view andTitle:(NSString*)title{
    BOOL isYueJie;
    UIFont *font = [UIFont systemFontOfSize:15];
    CGSize size = CGSizeMake(160,35);
    CGSize labelsize = [title sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    
    if (160-labelsize.width < 22.5) {
        isYueJie = YES;
    }else{
        isYueJie = NO;
    }
    
    for (id v in view.subviews) {
        if ([v isKindOfClass:[UILabel class]]) {
            if (isYueJie) {
                ((UILabel*)v).frame = CGRectMake(0, 0, 137.5, 35);
            }else{
                ((UILabel*)v).frame = CGRectMake((160 - labelsize.width - 22.5) / 2.0, 0, labelsize.width, 35);
            }
            ((UILabel*)v).text = title;
        }
        if ([v isKindOfClass:[UIImageView class]]) {
            if (isYueJie) {
                ((UIImageView*)v).frame = CGRectMake(137.5, 12.25, 12.5, 9.5);
            }else{
                float width = (160 - labelsize.width - 22.5) / 2.0 + labelsize.width+10;
                ((UIImageView*)v).frame = CGRectMake(width, 12.5, 12.5, 9.5);
            }
        }
    }
}

//查看详情
- (void)showInfo:(UIButton*)sender{
    ShangPingDetailVC* detail = [[ShangPingDetailVC alloc] init];
    detail.spId = self.goodEntity.goodsid;
    [self pushViewController:detail];
    [detail release];
}

//第一次动画实现
-(void)ShakeAnimationWithView:(id)sender
{
    [_bgImg startAnimating];
}

//图片动画实现
-(void)ShakeAnimationWithUIImageview:(id)sender
{
    CGFloat t =2.0;
    CGAffineTransform translateRight  = CGAffineTransformTranslate(CGAffineTransformIdentity, t,0.0);
    CGAffineTransform translateLeft =CGAffineTransformTranslate(CGAffineTransformIdentity,-t,0.0);
    UIImageView* v = (UIImageView*)[_contentScrollView viewWithTag:500];
    
    v.transform = translateLeft;
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:2.0];
        v.transform = translateRight;
    } completion:^(BOOL finished){
        if(finished){
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                v.transform =CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
    
}

//结束所有动画
-(void)stopShakeAll
{
    if (_bgImg != nil) {
        [_bgImg stopAnimating];
    }
    [_myTimer invalidate];
    _myTimer = nil;
}

//去除UIImageView的锯齿
-(UIImageView *)clearSawtoothOfView:(UIImageView *)imgView
{
    UIGraphicsBeginImageContextWithOptions(imgView.frame.size, NO, 1);
    [imgView.image drawInRect:CGRectMake(0, 0, imgView.frame.size.width, imgView.frame.size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    [imgView setImage:image];
    return imgView;
}

#pragma mark - Gesture Methods
- (void)showZhonglei:(UITapGestureRecognizer*)gesture{
    _selectIndex = 0;
    NSLog(@"商品");
    if ([gesture view].tag == 100) {
        _isProduct = YES;
    }else{
        _isProduct = NO;
    }
    _popView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_popView];
    
    UIView* bgView = [[UIView alloc] initWithFrame:_popView.bounds];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.7;
    [_popView addSubview:bgView];
    [bgView release];
        
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 261, 320, 45)];
    [toolBar setBarStyle:UIBarStyleBlackTranslucent];
    [_popView addSubview:toolBar];
    [toolBar release];
        
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(clicked:)];
    cancelItem.tag = 100;
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(clicked:)];
    doneItem.tag = 101;
    UIBarButtonItem *spacItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    spacItem.width = 208;
        
    [toolBar setItems:[NSArray arrayWithObjects:cancelItem,spacItem,doneItem, nil]];
        
    UIPickerView* pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 216, 320, 216)];
    pickView.delegate = self;
    pickView.backgroundColor = [UIColor whiteColor];
    pickView.dataSource = self;
    pickView.showsSelectionIndicator = YES;
    [_popView addSubview:pickView];
    [pickView release];
    
    [cancelItem release];
    [doneItem release];
    [spacItem release];
}

- (void)clicked:(UIBarButtonItem*)sender{
    if (sender.tag == 100) {
        [_popView removeFromSuperview];
    }else{
        [_popView removeFromSuperview];
        if (_isProduct) {
            if ([[[_pickDataForType objectAtIndex:_selectIndex] categoryname] isKindOfClass:[NSString class]]) {
                [self setViewTitleInView:_productView andTitle:[[_pickDataForType objectAtIndex:_selectIndex] categoryname]];
            }
            if (![[[_pickDataForType objectAtIndex:_selectIndex] categoryid] isKindOfClass:[NSNull class]]) {
                self.items = [[_pickDataForType objectAtIndex:_selectIndex] categoryid];
            }
            
        }else{
            if ([[[_pickDataForPrice objectAtIndex:_selectIndex] specname] isKindOfClass:[NSString class]]) {
                [self setViewTitleInView:_priceView andTitle:[[_pickDataForPrice objectAtIndex:_selectIndex] specname]];
            }
            if (![[[_pickDataForPrice objectAtIndex:_selectIndex] specid] isKindOfClass:[NSNull class]]) {
                self.price = [[_pickDataForPrice objectAtIndex:_selectIndex] specid];
            }
        }
    }
}

#pragma mark - UIPickerViewDataSource and UIPickerViewDelegate
- (float)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (_isProduct) {
        return _pickDataForType.count;
    }else{
        return _pickDataForPrice.count;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"%d",row);
    _selectIndex = row;
}

- (UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UIView* aview = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)]autorelease];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 270, 40)];
    label.font = [UIFont systemFontOfSize:18];
    label.backgroundColor = [UIColor clearColor];
    //label.textColor = RGBCOLOR(50,78, 132);
    if (_isProduct) {
        if ([[[_pickDataForType objectAtIndex:row] categoryname] isKindOfClass:[NSString class]]) {
            label.text = [[_pickDataForType objectAtIndex:row] categoryname];
        }
    }else{
        if ([[[_pickDataForPrice objectAtIndex:row] specname] isKindOfClass:[NSString class]]) {
            label.text = [[_pickDataForPrice objectAtIndex:row] specname];
        }
    }
    
    [aview addSubview:label];
    [label release];
    return aview;
}

#pragma mark - DSRequestDelegate Methods
-(void)requestDataSuccess:(id)dataObj tag:(int)tag{
    if (_willBack) {
        return;
    }
    if (tag == 0) {
        
        if(!dataObj){
            [self stopShakeAll]; //停止动画
            [self.view addHUDLabelView:@"抱歉、没有搜索到你所需要的商品" Image:nil afterDelay:2.0];
            [(UIButton*)[self.titleBar viewWithTag:120] setEnabled:YES];
            _isStop = NO;
            return;
        }
        if ([dataObj isKindOfClass:[NSArray class]]) {
            self.goodEntity = [dataObj objectAtIndex:0];
        }
        
        [self initContentScrollView];

        [(UIButton*)[self.titleBar viewWithTag:120] setEnabled:YES];
        _isStop = NO;
    }else{
        if(!dataObj){
            return;
        }
        
        NSLog(@"%@",[[((ShakeRestrictEntity*)dataObj).category objectAtIndex:0] categoryname]);
        
        if ([((ShakeRestrictEntity*)dataObj).category isKindOfClass:[NSArray class]]) {
            _pickDataForType = [[NSArray alloc] initWithArray:((ShakeRestrictEntity*)dataObj).category];
        }
        if ([((ShakeRestrictEntity*)dataObj).price isKindOfClass:[NSArray class]]) {
            _pickDataForPrice = [[NSArray alloc] initWithArray:((ShakeRestrictEntity*)dataObj).price];
        }
        
        [self initTwoButtons];
    }
}

-(void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError*)error{
    if (tag == 0) {
        [self stopShakeAll];
        [self.view addHUDLabelView:error.domain Image:nil afterDelay:1.0];
        [(UIButton*)[self.titleBar viewWithTag:120] setEnabled:YES];
        _isStop = NO;
    }else{
        [(UIButton*)[self.titleBar viewWithTag:120] setEnabled:YES];
        _isStop = NO;
        NSLog(@"%@",error);
    }
}

#pragma mark -- 摇一摇
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
//    if (self.isFirst) {
//        if (!_isStop) {
//            _myTimer = [NSTimer scheduledTimerWithTimeInterval:0.14 target:self selector:@selector(ShakeAnimationWithView:) userInfo:nil repeats:YES];
//            [_myTimer fire];
//        }
//        
//    }else{
//        if (!_isStop) {
//            _myTimer = [NSTimer scheduledTimerWithTimeInterval:0.14 target:self selector:@selector(ShakeAnimationWithUIImageview:) userInfo:nil repeats:YES];
//            [_myTimer fire];
//        }
//    }
//    _isStop = YES;
//    [(UIButton*)[self.titleBar viewWithTag:120] setEnabled:NO];
//    
//    [self senderMotion];
//    
//    [self performSelector:@selector(initShakeRequest) withObject:nil afterDelay:2.0];
//    

    [self shaking];
}


@end
