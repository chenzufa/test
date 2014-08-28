//
//  SeeBigPhoneVC.m
//  HaiLanZhiJia
//
//  Created by chenzufa on 13-12-11.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "SeeBigPhoneVC.h"
#import <QuartzCore/QuartzCore.h>
#import "ShangPingDetailVC.h"
@interface SeeBigPhoneVC (){
    NSMutableArray* _smallArray;
}

@property(nonatomic , retain)NSMutableArray* progressArray;
@property(nonatomic , retain)NSMutableDictionary* tagDic;
@end

@implementation SeeBigPhoneVC
@synthesize scrolview = _scrolview;
@synthesize imgs = _imgs;
@synthesize commentView = _commentView;
@synthesize isShow = _isShow;
@synthesize selectIndex = _selectIndex;
@synthesize progressArray = _progressArray;
@synthesize tagDic = _tagDic;

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

    if (_isCommentViewHide==YES)
    {
        _isShow = NO;
    }else
    {
        _isShow = NO;
    }
    //_selectIndex = 0;
    
    _progressArray = [[NSMutableArray alloc] init];
    _tagDic = [[NSMutableDictionary alloc] init];
    _smallArray = [[NSMutableArray alloc] init];
    
    [self setTitleString:(_isCommentViewHide)?@"":@"晒单"];
    [self initScrollView];
    [self initCommentView];
    [self initSaveBtn];
    if (_isCommentViewHide==YES)
    {
        
        self.titleBar.hidden = NO;
    }else
    {
        [self initRightButton];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [_scrolview release];_scrolview = nil;
    [_imgs release];_imgs = nil;
    [_commentView release];_commentView = nil;
    [_indexLabel release];_indexLabel = nil;
    [_tagDic release];_tagDic = nil;
    [_progressArray release];_progressArray = nil;
    [_smallArray release];_smallArray  = nil;
    [super dealloc];
}

#pragma mark - INIT UI
-(void)initSaveBtn
{
    UIImage *image = [UIImage imageNamed:@"mall_details_icon_download.png"];
    UIButton* saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setFrame:CGRectMake(0,MainViewHeight-45 - 15,image.size.width + 40,image.size.height + 30)];
    [saveBtn setImageEdgeInsets:UIEdgeInsetsMake(15, 20, 15, 20)];
    [saveBtn setImage:[UIImage imageNamed:@"mall_details_icon_download.png"] forState:UIControlStateNormal];
    [saveBtn setImage:[UIImage imageNamed:@"mall_details_icon_download.png"] forState:UIControlStateHighlighted];
    [saveBtn addTarget:self action:@selector(saveImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
}
- (void)initScrollView{
    
    
    _scrolview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, MainViewHeight)];
    _scrolview.delegate = self;
    _scrolview.pagingEnabled = YES;
    _scrolview.showsHorizontalScrollIndicator = YES;
    _scrolview.showsVerticalScrollIndicator = YES;
    _scrolview.backgroundColor = [UIColor blackColor];
    _scrolview.contentSize = CGSizeMake(320 * self.imgs.count, 0);
    for (int i = 0; i < self.imgs.count; i++) {
        
        UIProgressView* progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(50+320*i, 200, 200, 8)];
        progressView.progressViewStyle = UIProgressViewStyleDefault;
        progressView.progressTintColor = [UIColor whiteColor];
        progressView.trackTintColor = [UIColor blackColor];
        progressView.layer.borderWidth=1;
        progressView.layer.borderColor=[UIColor whiteColor].CGColor;
        progressView.layer.cornerRadius=5;
        progressView.hidden = YES;
        [_progressArray addObject:progressView];
        [_scrolview addSubview:progressView];
        [progressView release];
        
    }
    [self.view insertSubview:_scrolview belowSubview:self.titleBar];
    [_scrolview setContentOffset:CGPointMake(_selectIndex*_scrolview.frame.size.width, 0)];
    if (self.imgs && self.imgs.count>0) {
        [self setImgInImageView:_selectIndex];
    }
}

-(BOOL)firstGoinAtIndex:(NSInteger)index{
    if ([_tagDic objectForKey:[NSNumber numberWithInt:index]]) {
        return YES;
    }else{
        return NO;
    }
}

- (void)setImgInImageView:(NSInteger)index{
    if (![self firstGoinAtIndex:index]) {
        [_tagDic setObject:@"1" forKey:[NSNumber numberWithInt:index]];
        UIScrollView* sll = [[UIScrollView alloc] initWithFrame:CGRectMake(320*index, 60, _scrolview.frame.size.width, _scrolview.frame.size.height-160)];
        sll.delegate = self;
        sll.userInteractionEnabled = YES;
        sll.showsHorizontalScrollIndicator = NO;
        sll.showsVerticalScrollIndicator = NO;
        sll.maximumZoomScale = 2;
        sll.minimumZoomScale = 1;
        sll.backgroundColor = [UIColor clearColor];
        sll.bounces = YES;
        sll.clipsToBounds = YES;
        [_scrolview insertSubview:sll atIndex:index];
        [sll release];
        
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.tag = 200;
        imageView.userInteractionEnabled = YES;
        if ( [self.imgs count]>0 &&[[self.imgs objectAtIndex:index] isKindOfClass:[NSString class]]) {
            [imageView setImageWithURL:[NSURL URLWithString:[self.imgs objectAtIndex:index]] placeholderImage:[UIImage imageNamed:@"商品大图.png"]];
        }
        if (imageView.image) {
            //float h = 320 /imageView.image.size.width  * imageView.image.size.height;
            imageView.frame = CGRectMake(0, 0, 320, 320);
        }
        if (imageView.frame.size.height > sll.frame.size.height) {
            float offsetY = (sll.frame.size.height - imageView.frame.size.height) / 2.0;
            imageView.center = CGPointMake(160, sll.frame.size.height / 2.0 + offsetY);
        }else{
            imageView.center = CGPointMake(160, sll.frame.size.height / 2.0);
        }
        imageView.hidden = YES;
        UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [imageView addGestureRecognizer:gesture];
        [gesture release];
        
        [sll addSubview:imageView];
        [imageView release];
        
        [_smallArray addObject:sll];
        
        UIProgressView* p = [_progressArray objectAtIndex:index];
        p.hidden = NO;
        NSString* str = nil;
        if ([[self.imgs objectAtIndex:index] isKindOfClass:[NSString class]]) {
            str = [self.imgs objectAtIndex:index];
        }else{
            str = @"";
        }
        NSURL* url = [NSURL URLWithString:str];
        [[SDWebImageManager sharedManager]  downloadWithURL:url options:SDWebImageProgressiveDownload progress:^(NSUInteger receivedSize, long long expectedSize) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [p setProgress:receivedSize*1.0/expectedSize animated:NO];
            });
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [p setHidden:YES];
                imageView.hidden = NO;
            });
        }];
    }
}

//评论视图
-(void) initCommentView
{
    if (_isCommentViewHide==NO)
    {
        _commentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 120, 320, 100)];
        _commentView.backgroundColor = [UIColor blackColor];
        _commentView.userInteractionEnabled = YES;
        [self.view addSubview:_commentView];
        
        
        NSString* str = [NSString stringWithFormat:@"晒单评价：\n%@",self.comment];
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 310, 80)];
        label.userInteractionEnabled = YES;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor whiteColor];
        label.numberOfLines = 0;
        label.text = str;
        [label sizeToFit];
        label.frame = CGRectMake(10, 0, 310, 80);
        [_commentView addSubview:label];
        [label release];
    }
    
    _indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, 320, 20)];
    _indexLabel.userInteractionEnabled = YES;
    _indexLabel.backgroundColor = [UIColor clearColor];
    _indexLabel.textColor = [UIColor whiteColor];
    _indexLabel.textAlignment = NSTextAlignmentCenter;
    if (self.imgs.count > 0) {
        _indexLabel.text = [NSString stringWithFormat:@"%d/%d",_selectIndex+1,self.imgs.count];
    }
    [self.view addSubview:_indexLabel];
}

//导航栏右边按钮
- (void)initRightButton
{
    UIButton* myRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [myRightButton setFrame:CGRectMake(235, 7, 75, 30)];
    [myRightButton.titleLabel setFont:SetFontSize(FontSize15)];
    [myRightButton setTitle:@"查看详情" forState:UIControlStateNormal];
    [myRightButton setTitleColor:RGBCOLOR(236, 224, 224) forState:UIControlStateNormal];
    [myRightButton setBackgroundImage:[UIImage imageNamed:@"button2@2x.png"] forState:UIControlStateNormal];
    [myRightButton setBackgroundImage:[UIImage imageNamed:@"button2_press@2x.png"] forState:UIControlStateHighlighted];
    [myRightButton addTarget:self action:@selector(myRightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleBar addSubview:myRightButton];
}

- (void)myRightButtonAction:(UIButton*)sender{
    
    
    ShangPingDetailVC * detail = [[ShangPingDetailVC alloc] init];
    detail.spId = self.goodsid;
    [self pushViewController:detail];
    [detail release];
}
-(void)saveImage:(UIButton*)btn
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存至相册", nil];
    RootVC *rootVC= [RootVC shareInstance];
    [sheet showInView:rootVC.view];
    [sheet release];
    
    

}

#pragma mark SheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if (self.imgs.count <= 0) {
            return;
        }
        
        UIImage* image = nil;
        if ([[self.imgs objectAtIndex:_selectIndex] isKindOfClass:[NSString class]])
        {
            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.imgs objectAtIndex:_selectIndex]]]];
        }
        if (image==nil)
        {
            image = [UIImage imageNamed:@"商品大图.png"];
        }
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//        });
//        [MBProgressHUD showSuccess:@"成功保存到相册" toView:self.scrolview];

    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [MBProgressHUD showSuccess:@"保存失败" toView:self.scrolview];
    } else {
        [MBProgressHUD showSuccess:@"成功保存到相册" toView:self.scrolview];
    }
}

#pragma mark - UIScrollViewDelegate Method
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _scrolview) {
        int inx = _scrolview.contentOffset.x / 320;
        NSLog(@"   inx = %i",inx);
        _selectIndex = inx;
        _indexLabel.text = [NSString stringWithFormat:@"%d/%d",inx+1,self.imgs.count];
        if (![self firstGoinAtIndex:inx]) {
            [self setImgInImageView:inx];
            for (UIScrollView * scrollview in _smallArray) {
                if (_isShow) {
                    scrollview.clipsToBounds = NO;
                }
            }
        }
    }
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    int inx = _scrolview.contentOffset.x / 320;
    
    NSLog(@"%@",[[_scrolview.subviews objectAtIndex:inx] viewWithTag:200]);
    
    UIImageView* v = (UIImageView*)[[_scrolview.subviews objectAtIndex:inx] viewWithTag:200];
    _selectIndex = inx;
    return v;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    int inx = _scrolview.contentOffset.x / 320;
    UIScrollView* s = [_scrolview.subviews objectAtIndex:inx];
    UIImageView* v = (UIImageView*)[[_scrolview.subviews objectAtIndex:inx] viewWithTag:200];
    CGFloat offsetX = (s.bounds.size.width > s.contentSize.width)?(s.bounds.size.width - s.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (s.bounds.size.height > s.contentSize.height)?(s.bounds.size.height - s.contentSize.height) * 0.5 : 0.0;
    [s viewWithTag:200].center = CGPointMake(s.contentSize.width * 0.5 + offsetX,s.contentSize.height * 0.5 + offsetY  );
    NSLog(@"%f,%f---------%f,%f",v.frame.origin.x,v.frame.origin.y,v.frame.size.width,v.frame.size.height);
}

- (void)tap:(UITapGestureRecognizer*)gesture{
    _isShow = !_isShow;
    _commentView.hidden = _isShow;
    self.titleBar.hidden = _isShow;
    for (UIScrollView * scrollview in _smallArray) {
        if (_isShow) {
            scrollview.clipsToBounds = NO;
        }else{
            scrollview.clipsToBounds = YES;
        }
    }
}

@end
