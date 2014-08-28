//
//  CommonViewController.m
//  Donson
//
//  Created by donson on 12-7-21.
//  Copyright (c) 2012年 Donson. All rights reserved.
//

#import "CommonViewController.h"
//#import "NSObject+ToolClass.h"

NSString* LeftBtnImage=nil;
//
#define TitleBG             @"bg_nav bar@2x.jpg"
#define LogoImage           @"tongyong_wankelogo@2x.png"
#define RightBtnImage       @"360全景展示按钮.png"
#define LeftBtnImage        @"icon_back.png"

//
#define TITLELABELTAG   900
#define LEFTBUTTONTAG   901
#define RIGHTBUTTONTAG  902
#define LEFTBLANK       10
#define LEFTIMGTAG      9011
#define RIGHTIMGTAG      90111
@implementation CommonViewController

@synthesize titleBar, logoView,TopBackgroudImgV;
@synthesize seletedRootTitle, seletedSubTitle, isShow;

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    
    //
//    self.view.frame = self.view.bounds;
//    
//    
//    // 创建添加导航条视图
//    if (!titleBar)
//    {
//        titleBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainViewWidth, [self getTitleBarHeight])];
//        titleBar.backgroundColor = [UIColor clearColor];
//        [self.view addSubview:titleBar];
//        
//        // 创建导航条背景图片
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, titleBar.frame.size.width, titleBar.frame.size.height)];
//        imageView.userInteractionEnabled = YES;
//        imageView.image = GETIMG(TitleBG);
//        self.TopBackgroudImgV = imageView;
//        [titleBar addSubview:imageView];
//        [titleBar sendSubviewToBack:imageView];
//        [imageView release];
//    }
//    
//    //#if 0
//    //    // 品牌logo
//    //    if (!logoView)
//    //    {
//    //        logoView = [[UIImageView alloc] initWithFrame:CGRectMake(LEFTBLANK, 17, 135/2, 66/2)];
//    //        logoView.userInteractionEnabled = YES;
//    //        logoView.image = GETIMG(LogoImage);
//    //        [titleBar addSubview:logoView];
//    //    }
//    //#endif
//    
//    // 设置左右按钮事件
//    UIButton *backBtn = [self leftButton];
//    [backBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton *homeBtn = [self rightButton];
//    [homeBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setFrame:CGRectMake(0.0, 0.0, MainViewWidth, MainViewHeight)];
    
    
    // 创建当前VC背景图片
//    UIImage *bgImage = nil;
//    if (isIPhone5)
//    {
//        bgImage = GETIMG(@"tongyong_bg@2x.png");
//    }
//    else
//    {
//        bgImage = GETIMG(@"tongyong_bg_i4@2x.png");
//    }
//    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    
    // 创建添加导航条视图
    if (!titleBar)
    {
        titleBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainViewWidth, [self getTitleBarHeight])];
        titleBar.backgroundColor = [UIColor clearColor];
        [self.view addSubview:titleBar];
        
        
        // 创建导航条背景图片
        UIImage *image = GETIMG(TitleBG);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, titleBar.frame.size.width, titleBar.frame.size.height)];
        imageView.userInteractionEnabled = YES;
        imageView.tag = 789;
        imageView.image = image;
        self.TopBackgroudImgV = imageView;
        [titleBar addSubview:imageView];
        [titleBar sendSubviewToBack:imageView];
        [imageView release];
    }
    
    
    // 品牌logo
    if (!logoView)
    {
        logoView = [[UIImageView alloc] initWithFrame:CGRectMake(MainViewWidth/2-135/4, 11/2, 135/2, 66/2)];
        logoView.userInteractionEnabled = YES;
        logoView.image = GETIMG(LogoImage);
        [titleBar addSubview:logoView];
    }
    
    // 设置左右按钮事件
    UIButton *backBtn = [self leftButton];
    [backBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *homeBtn = [self rightButton];
    [homeBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    
}

// 返回导航条高度
- (int) getTitleBarHeight
{
    return 45;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    SAFETY_RELEASE(titleBar);
    SAFETY_RELEASE(logoView);
}

// 重新设置左右按钮的图片
- (void)setLeftButtonImageNormal:(NSString *)strNormal
{
    UIImage *bgImage = GETIMG(strNormal);
    [self.leftButton setBackgroundImage:bgImage forState:UIControlStateNormal];
    
    [self.rightButton setFrame:CGRectMake(titleBar.frame.size.width-bgImage.size.width-LEFTBLANK,
                                          (int)((titleBar.frame.size.height - bgImage.size.height) / 2.0),
                                          bgImage.size.width,
                                          bgImage.size.height)];
}
- (void)setRightButtonImageNormal:(NSString *)strNormal
{
    UIImage *bgImage = GETIMG(strNormal);
    [self.rightButton setBackgroundImage:bgImage forState:UIControlStateNormal];
    
    [self.rightButton setFrame:CGRectMake(titleBar.frame.size.width-bgImage.size.width-LEFTBLANK,
                                          (int)((titleBar.frame.size.height - bgImage.size.height) / 2.0),
                                          bgImage.size.width,
                                          bgImage.size.height)];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
     
    return interfaceOrientation==UIInterfaceOrientationPortrait;
}

- (void)resetVC
{
    // ...
}

- (void)showVC
{
    // ...
}

- (void)changeBG:(BOOL)isDefault
{
    // ...
}

/**
 @function:根据title显示对应的视图
 @param:title 是否显示动画 是否调用委托方法
 @return:无
 */
- (void)showInfomationWithTitle:(NSString*)title animation:(BOOL)isAnimation runDelegate:(BOOL)isRun
{
    // ...
}

/**
 @function:刷新自己的菜单
 @param:无
 @return:无
 */
- (void)refrushOwnMenu
{
    // ...
}

- (void)setTitleBarHidden:(BOOL)hidden
{
    self.titleBar.hidden = hidden;
}

- (void)setLogoHidden:(BOOL)hidden
{
    logoView.hidden = hidden;
}

- (void)setTitleString:(NSString*)string
{
    UILabel *_titlelabel = self.titleLabel;
    _titlelabel.text = string;
 
}

- (void)setTitleBarImageStr:(NSString *)imgStr
{
    UIImageView *imgBg = (UIImageView *)[self.titleBar viewWithTag:789];
    [imgBg setImage:GetImage(imgStr)];
}

- (void)setButtonsHidden:(BOOL)leftBtnHidden rightBtnHidden:(BOOL)rightBtnHidden
{
    [[self leftButton] setHidden:leftBtnHidden];
    [[self rightButton] setHidden:rightBtnHidden];
}

- (UILabel*) titleLabel
{
    UILabel *_titlelabel = (UILabel*)[titleBar viewWithTag:TITLELABELTAG];
    if (nil == _titlelabel)
    {
        CGRect frame = titleBar.bounds;
        _titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2-300/2+35, 0,210 , TITLEHEIGHT)];
        _titlelabel.backgroundColor = [UIColor clearColor];
        _titlelabel.tag = TITLELABELTAG;
        _titlelabel.userInteractionEnabled = NO;
        _titlelabel.textColor = [UIColor whiteColor];
//        _titlelabel.alpha = 0.6;
        _titlelabel.textAlignment = NSTextAlignmentCenter;
        [titleBar addSubview:_titlelabel];
        // [UIFont fontWithName:@"Helvetica-Bold" size:20]
        [_titlelabel setFont:SYSTEMFONT(20)];
//        [_titlelabel setFont:SYSTEMBOLDFONT(20)];
        [_titlelabel autorelease];
    }
    
    return _titlelabel;
}

- (UIButton*)leftButton
{
    UIButton *backBtn = (UIButton*)[titleBar viewWithTag:LEFTBUTTONTAG];
    if (nil == backBtn)
    {
        backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setTag:LEFTBUTTONTAG];
//        [backBtn setBackgroundColor:[UIColor redColor]];
//<<<<<<< .mine
        [backBtn setFrame:CGRectMake(0, 0, 50, TITLEHEIGHT)];
//        UIImageView *img = [[UIImageView alloc] initWithImage:GETIMG(LeftBtnImage)];
//        img.userInteractionEnabled = NO;
//        img.tag = LEFTIMGTAG;
//        img.backgroundColor = [UIColor clearColor];
//        img.frame = CGRectMake(LEFTBLANK, TITLEHEIGHT/2-46/4, GetImageWidth(img.image), GetImageHeight(img.image));
//        [backBtn addSubview:img];
//        [img release];
        [backBtn setImage:GETIMG(LeftBtnImage) forState:UIControlStateNormal];
        backBtn.imageView.contentMode = UIViewContentModeCenter;
//=======
//        [backBtn setFrame:CGRectMake(0, 0, 100, TITLEHEIGHT)];
//        /*(UIImageView *img = [[UIImageView alloc] initWithImage:GETIMG(LeftBtnImage)];
//        img.userInteractionEnabled = NO;
//        img.tag = LEFTIMGTAG;
//        img.backgroundColor = [UIColor clearColor];
//        img.frame = CGRectMake(LEFTBLANK, TITLEHEIGHT/2-46/4, GetImageWidth(img.image), GetImageHeight(img.image));
//        [backBtn addSubview:img];
//        [img release];*/
//        [backBtn setImage:GETIMG(LeftBtnImage) forState:UIControlStateNormal];
//        [backBtn setImage:GETIMG(@"icon_back_press.png") forState:UIControlStateHighlighted];
//        backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0,62);
//>>>>>>> .r39660
        [titleBar addSubview:backBtn];
    }
    
    return backBtn;
}

-(void)setLeftButtonImage:(NSString *)str
{
    UIImageView *img =(UIImageView *)[self.leftButton viewWithTag:LEFTIMGTAG];
    [img setImage:GETIMG(str)];
}

-(void)setRightButtonImage:(NSString *)str
{
//    UIImageView *img =(UIImageView *)[self.rightButton viewWithTag:RIGHTIMGTAG];
//    [img setImage:GETIMG(str)];
//    sel
    [self.rightButton setImage:GETIMG(str) forState:UIControlStateNormal];
}

- (UIButton*)rightButton
{
    UIButton* rightBtn = (UIButton*)[titleBar viewWithTag:RIGHTBUTTONTAG];
    if (nil == rightBtn)
    {
        rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setTag:RIGHTBUTTONTAG];
        [rightBtn setFrame:CGRectMake(titleBar.frame.size.width-50-LEFTBLANK, (int)(titleBar.frame.size.height-46)/2, 50, TITLEHEIGHT)];
//        UIImageView *img = [[UIImageView alloc] initWithImage:GETIMG(RightBtnImage)];
//        img.userInteractionEnabled = NO;
//        img.backgroundColor = [UIColor clearColor];
//        img.tag = RIGHTIMGTAG;
//        img.frame = CGRectMake(0, (int)(rightBtn.frame.size.height-28)/2+5, 54/2, 46/2);
//        [rightBtn addSubview:img];
//        [img release];
        [rightBtn setImage:GETIMG(RightBtnImage) forState:UIControlStateNormal];
        rightBtn.imageView.contentMode = UIViewContentModeCenter;
        [titleBar addSubview:rightBtn];
    }
    
    return rightBtn;
}

- (void)leftAction
{
    [self popViewController];
}

-(void)rightAction
{
    
}

- (void)pushViewController:(UIViewController*)controller
{
    [[ModelManager shareManager] pushController:controller WithDelegate:self supportTransition:YES];
}

- (void)pushViewController:(UIViewController*)controller WithAnimation:(BOOL)animal
{
    [[ModelManager shareManager] pushController:controller WithDelegate:self supportTransition:animal];
}

- (void)popViewController
{
    [[ModelManager shareManager] popController:self WithDelegate:self supportTransition:YES];
}

- (void)popToRoot
{
    [[ModelManager shareManager] popToRootControllerWithDelegate:self supportTransition:YES];
}

#pragma mask -
#pragma ModelManagerDelegate
- (void)viewWillShow
{
}

- (void)viewWillRemove
{
}

- (void)dealloc
{
    self.seletedRootTitle = nil;
    self.seletedSubTitle = nil;
    SAFETY_RELEASE(logoView);
    SAFETY_RELEASE(titleBar);
    SAFETY_RELEASE(TopBackgroudImgV);
//    SAFETY_RELEASE(_myRightButton);
    [super dealloc];
}


////////////////////////////////////////////////////////创建右边的按钮
- (void)createMyButtonWithTitleAndImage
{
    _myRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_myRightButton setFrame:CGRectMake(0, 0, 0, 45)];
    [_myRightButton.titleLabel setFont:SetFontSize(FontSize15)];
    [_myRightButton setTitleColor:RGBCOLOR(236, 224, 224) forState:UIControlStateNormal];
    [_myRightButton addTarget:self action:@selector(myRightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleBar addSubview:_myRightButton];
}

- (void)myRightButtonAction:(UIButton *)button
{
    
}

- (void)setMyRightButtonTitle:(NSString *)title
{
    if (title) {
        [_myRightButton setTitle:title forState:UIControlStateNormal];
//        CGSize labelSize = [title sizeWithFont:_myRightButton.titleLabel.font constrainedToSize:CGSizeMake(80, FontSize15) lineBreakMode:NSLineBreakByCharWrapping];
//        
//        [_myRightButton setFrame:CGRectMake(MainViewWidth - 12  - labelSize.width, _myRightButton.frame.origin.y, labelSize.width, _myRightButton.frame.size.height)];
//        [_myRightButton setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
        
        
    }
    
    
}

- (void)setMyRightButtonImage:(NSString *)imageName hightImage:(NSString *)hightImageName
{
    if (imageName) {
        [_myRightButton setImage:GetImage(imageName) forState:UIControlStateNormal];
        
        [_myRightButton setFrame:CGRectMake(MainViewWidth - 12 - _myRightButton.imageView.image.size.width, _myRightButton.frame.origin.y, _myRightButton.imageView.image.size.width, _myRightButton.imageView.image.size.height)];
        [_myRightButton setCenter:CGPointMake(_myRightButton.center.x, [self getTitleBarHeight] / 2)];
    }
    
    if (hightImageName) {
        [_myRightButton setImage:GetImage(hightImageName) forState:UIControlStateHighlighted];
    }
    
    
}

- (void)setMyRightButtonBackGroundImageView:(NSString *)imageName hightImage:(NSString *)hightImageName
{
    if (imageName) {
        UIImage *image = GetImage(imageName);
        [_myRightButton setBackgroundImage:image forState:UIControlStateNormal];
        
        [_myRightButton setFrame:CGRectMake(MainViewWidth - 12 - image.size.width, _myRightButton.frame.origin.y, image.size.width, image.size.height)];
        [_myRightButton setCenter:CGPointMake(_myRightButton.center.x, [self getTitleBarHeight] / 2)];
    }
    
    if (hightImageName) {
        [_myRightButton setBackgroundImage:GetImage(hightImageName) forState:UIControlStateHighlighted];
    }
    
    if (_myRightButton.titleLabel.text) {
        [_myRightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}

@end
