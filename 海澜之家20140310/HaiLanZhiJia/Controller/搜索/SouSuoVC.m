//
//  SouSuoVC.m
//  HaiLanZhiJia
//
//  Created by 蒋遂明 on 13-11-20.
//  Copyright (c) 2013年 donson. All rights reserved.
//
#define MENUTAGADD      0x500
#define KEYVIEWTAG      0x600
#define SEARCHTAG       0x700
#define OTHERSTAG       0x800

#define SEARCH_HISTORY   @"searchHistory"

#import "SouSuoVC.h"
#import "ShakeVC.h"
#import "BuyByColorVC.h"
#import "AppDelegate.h"
#import "RootVC.h"
#define APPID @"5258a87c"
#define TIMEOUT         @"20000"            // timeout      连接超时的时间，以ms为单位

#import <QuartzCore/QuartzCore.h>

@interface SouSuoVC ()<UIAlertViewDelegate>

@property (nonatomic,retain)NSMutableArray *historyArray;
@property (nonatomic,retain)UIView  *footView;

@end

@implementation SouSuoVC

@synthesize aRequest;
@synthesize hotKeyView;
@synthesize textInputView;
@synthesize historyTabView;
@synthesize inputTextField;
@synthesize historyArray;
@synthesize footView;
@synthesize iflySpeechRecognizer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    self.hotKeyView = nil;
    self.textInputView = nil;
    self.historyTabView = nil;
    self.inputTextField = nil;
    self.historyArray = nil;
    self.footView = nil;
    self.strSpeak = nil;
    
    self.iflySpeechRecognizer = nil;
    [alertView release];
    
    self.aRequest.delegate = nil;
    self.aRequest = nil;
    
    [super dealloc];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setFrame:CONTENTFRAME];
    self.view.backgroundColor = RGBACOLOR(242, 242, 242, 1);
    [self.leftButton setHidden:YES];
    [self setTitleString:@"搜索"];
    
    // 添加点击背景事件
    [self addTapButton];
    
    [self createSubViews];
    [self createHistoryView];
    [self createKeyWordView];
    [self createSearchView];
    
    // 添加右上角搜索按钮
    [self createOtherSearch];
    
    [self.historyTabView reloadData];
    
    [[NSNotificationCenter defaultCenter]addObserver:self  selector:@selector(jiXuGuangGuang:) name:kJiXuGuangGuangNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self  selector:@selector(refreshHistoryTable:) name:@"refreshHistoryTable" object:nil];
    // Do any additional setup after loading the view.
    [self requestToGetNewHot];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化语音输入
- (void)initIflyRecognizer
{
    IFlySpeechRecognizer *tempSpeedRecogn = nil;
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@,timeout=%@",APPID,TIMEOUT];
    tempSpeedRecogn = [IFlySpeechRecognizer createRecognizer: initString delegate:self];
    tempSpeedRecogn.delegate = self;//请不要删除这句,createRecognizer是单例方法，需要重新设置代理
    [tempSpeedRecogn setParameter:@"domain" value:@"sms"];
    [tempSpeedRecogn setParameter:@"sample_rate" value:@"16000"];
    [tempSpeedRecogn setParameter:@"plain_result" value:@"0"];
    
    [initString release];
    self.iflySpeechRecognizer = tempSpeedRecogn;
    [tempSpeedRecogn release];
}

#pragma mark IFlySpeechRecognizerDelegate
- (void)onBeginOfSpeech
{
    NSLog(@"onBeginOfSpeech");
    self.strSpeak = nil;
}

- (void)onCancel
{
    NSLog(@"onCancel");
}

- (void)onVolumeChanged:(int)volume
{
    NSLog(@"onVolumeChanged________%i",volume);
    alertView.iVolume = volume;
    [alertView beginTalking];
//    [alertView wasIdentificaing];

}

- (void)onEndOfSpeech
{
    NSLog(@"onEndOfSpeech");
    [alertView wasIdentificaing];   //  识别中
    
    [self.iflySpeechRecognizer stopListening];
}

- (void)onResults:(NSArray *)results
{
//    NSLog(@"onResults");
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [results objectAtIndex:0];
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    NSLog(@"转写结果：%@",result);
    
    if (!self.strSpeak) {
        
        self.strSpeak = result;
    }
    
    if (self.strSpeak.length == 0) {
        [alertView identificaFailed]; // 没有听清
    }else {
        [alertView identificaSuccessed:self.strSpeak];   //  识别成功
    }
    
    
    [result release];
}

- (void)onError:(IFlySpeechError *)errorCode
{
    NSLog(@"onError");
//    [alertView identificaFailed]; // 没有听清
}



#pragma mark - 添加热门关键词和搜索历史按钮
-(void)createSubViews
{
    // 背景
//    UIImage *bgImg = GetImage(@"tab_bg.png");
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, TITLEHEIGHT, bgImg.size.width, bgImg.size.height)];
//    imageView.userInteractionEnabled = NO;
//    imageView.image = bgImg;
//    [self.view addSubview:imageView];
//    [imageView release];
    UIImageView *backGroundImgView = [[UIImageView alloc]init];//WithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [backGroundImgView setImage:GetImage(@"tab_bg.png")];
    [backGroundImgView setFrame:CGRectMake(0, TITLEHEIGHT, backGroundImgView.image.size.width, backGroundImgView.image.size.height)];
    
    [self.view addSubview:backGroundImgView];
    [backGroundImgView release];
    
    // 两个按钮
    UIButton *hotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    hotBtn.tag = MENUTAGADD;
    hotBtn.backgroundColor = [UIColor clearColor];
    UIImage *myImg = GetImage(@"tab_sel2.png");
    hotBtn.frame = CGRectMake(0, TITLEHEIGHT, myImg.size.width, myImg.size.height);
    [hotBtn setTitle:@"热门关键词" forState:UIControlStateNormal];
    [hotBtn setBackgroundImage:myImg forState:UIControlStateSelected];
    [hotBtn setTitleColor:TEXT_GRAY_COLOR forState:UIControlStateNormal];
    [hotBtn setTitleColor:TEXT_BLUE_COLOR forState:UIControlStateSelected];
    [hotBtn addTarget:self action:@selector(clickMenuButton:) forControlEvents:UIControlEventTouchUpInside];
    hotBtn.selected = YES;
    hotBtn.titleLabel.font = SYSTEMFONT(14);
    [self.view addSubview:hotBtn];
    
    UIButton *history = [UIButton buttonWithType:UIButtonTypeCustom];
    history.tag = MENUTAGADD+1;
    history.backgroundColor = [UIColor clearColor];
    history.frame = CGRectMake(160, TITLEHEIGHT, myImg.size.width, myImg.size.height);
    [history setTitle:@"搜索历史" forState:UIControlStateNormal];
    [history setBackgroundImage:GetImage(@"tab_sel2.png") forState:UIControlStateSelected];
    [history setTitleColor:TEXT_GRAY_COLOR forState:UIControlStateNormal];
    [history setTitleColor:TEXT_BLUE_COLOR forState:UIControlStateSelected];
    [history addTarget:self action:@selector(clickMenuButton:) forControlEvents:UIControlEventTouchUpInside];
    history.titleLabel.font = SYSTEMFONT(14);
    [self.view addSubview:history];
}

// 切换视图
-(void)clickMenuButton:(UIButton *)button
{
    int another =0;
    if (button.tag == MENUTAGADD) {
        another = MENUTAGADD+1;
        [self showHotkeyView:YES];
    }else{
        another = MENUTAGADD;
        [self showHotkeyView:NO];
    }
    button.selected = YES;
    UIButton *btn =(UIButton *)[self.view viewWithTag:another];
    btn.selected = NO;
}

-(void)showHotkeyView:(BOOL)show
{
    self.hotKeyView.hidden = !show;
    self.historyTabView.hidden =show;
    if (!show) {
        // 更新搜索历史 刷新数据
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSMutableArray *historyArr = [userDefaultes valueForKey:SEARCH_HISTORY];
        if (!historyArr) {
            historyArr = [NSMutableArray array];
        }
        self.historyArray = historyArr;
        
        [self.historyTabView reloadData];
    }
}

// 添加热门关键词视图
#pragma mark - 添加热门关键词视图
-(void)createKeyWordView
{
    UIScrollView *keyWordsContent = [[UIScrollView alloc]initWithFrame:CGRectMake(20, TITLEHEIGHT+85, 280, 300)];
    keyWordsContent.showsHorizontalScrollIndicator = NO;
    keyWordsContent.backgroundColor = [UIColor clearColor];
    keyWordsContent.alpha=1;
    self.hotKeyView = keyWordsContent;
    [self.view addSubview:keyWordsContent];
    [keyWordsContent release];
    
    // 单击的 Recognizer
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [self.hotKeyView addGestureRecognizer:singleRecognizer];
    [singleRecognizer release];

    
    NSMutableArray *myArray = [[NSMutableArray alloc]init];
    [self refreshKeyWordViewBy:myArray];
    [myArray release];
}
#pragma mark-- --
-(void)handleSingleTap:(UITapGestureRecognizer*)tapGesture
{
    [self hideOthersView];
    
    CGPoint location=[tapGesture locationInView:tapGesture.view];
    UIView *hitView=[tapGesture.view hitTest:location withEvent:nil];
    if ([hitView isKindOfClass:[UIButton class]])
    {
        if (hitView.tag==0x3838)
        {
            [self  requestToGetNewHot];
        }else
        {
         [self goSearch:(UIButton*)hitView];
        }
    }

}
-(void)refreshKeyWordViewBy:(NSArray *)keyArr
{
    
    for (UIView *view in [self.hotKeyView subviews] ) {
        [view removeFromSuperview];
    }
    int currentX    = 0.0;
    int currentY    = 0.0;
    
    NSMutableArray *newArray = [NSMutableArray array];
    for (NSString *str in keyArr) {
        if ([str length]<10) {
            [newArray insertObject:str atIndex:0];
        }else{
            [newArray addObject:str];
        }
    }
    
     //通过array 添加关键字
    NSMutableArray *buttonsArray = [[[NSMutableArray alloc]init]autorelease];
    for (int i=0; i<[newArray count]; i++) {
        
        NSString *myStr = [newArray objectAtIndex:i];
        CGSize mySize = [myStr sizeWithFont:SYSTEMFONT(14) forWidth:500 lineBreakMode:NSLineBreakByCharWrapping];
        CGSize btnSize = CGSizeMake(mySize.width, mySize.height);
        // 需要换行
        BOOL aLine = NO;
        if (currentX !=0.0 && currentX>=320-40-(mySize.width+20)) {
            currentX    = 0.0;
            currentY    += 45.0;
            
            if (mySize.width > 320 - 40) {
                aLine = YES;
            }
        }
        
        // 添加关键字按钮
        UIButton *keyWordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [keyWordBtn.titleLabel setLineBreakMode:NSLineBreakByCharWrapping];
//        keyWordBtn.backgroundColor = [UIColor redColor];
        if (aLine) {
            keyWordBtn.frame = CGRectMake(currentX, currentY, 320 - 40, 35);
        }else{
            keyWordBtn.frame = CGRectMake(currentX, currentY, btnSize.width+20, 35);
        }
        
        [keyWordBtn setTitle:myStr forState:UIControlStateNormal];
        [keyWordBtn.titleLabel setNumberOfLines:1];
        
        UIImage *myImg = GetImage(@"search_bg_key word.png");
        UIImage *resizeImg = [myImg resizableImageWithCapInsets:UIEdgeInsetsMake(4, 10, 4, 10)];
        [keyWordBtn setBackgroundImage:resizeImg forState:UIControlStateNormal];

        [keyWordBtn setTitleColor:TEXT_GRAY_COLOR forState:UIControlStateNormal];
        [keyWordBtn addTarget:self action:@selector(goSearch:) forControlEvents:UIControlEventTouchUpInside];
        keyWordBtn.titleLabel.font = SYSTEMFONT(14);
        keyWordBtn.tag = 0x500+i;
        
        [self.hotKeyView addSubview:keyWordBtn];
        
        currentX += (btnSize.width +30);
        
        [buttonsArray addObject:keyWordBtn];
    }
   
    CATransition *animation = [CATransition animation];
    //动画时间
    animation.duration = 0.5f;
    //先慢后快
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    //animation.removedOnCompletion = NO;
    
    //各种动画效果
    /*
     kCATransitionFade;
     kCATransitionMoveIn;
     kCATransitionPush;z
     kCATransitionReveal;
     */
    /*
     kCATransitionFromRight;
     kCATransitionFromLeft;
     kCATransitionFromTop;
     kCATransitionFromBottom;
     */
    //各种组合
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    
    
    for (int i =0; i<[buttonsArray count]; i++) {
        UIButton *aButton = [buttonsArray objectAtIndex:i];
        [aButton.layer addAnimation:animation forKey:@"animation"];
    }
    
    currentX    = 0.0;
    NSLog(@"%d",currentX);
    currentY    += 45.0;
    
    UIImage *myImg = GetImage(@"search_button_change.png");
    UIButton *refresh = [UIButton buttonWithType:UIButtonTypeCustom];
    refresh.backgroundColor = [UIColor clearColor];
    refresh.frame = CGRectMake(self.hotKeyView.frame.size.width/2-myImg.size.width/2, currentY, myImg.size.width, myImg.size.height);
    
    [refresh setBackgroundImage:GetImage(@"search_button_change@2x.png") forState:UIControlStateNormal];
    [refresh addTarget:self action:@selector(requestToGetNewHot) forControlEvents:UIControlEventTouchUpInside];
    refresh.tag = 0x3838;
    [self.hotKeyView addSubview:refresh];
    
    [self.hotKeyView setContentSize:CGSizeMake(280, currentY +50)];
    
}

-(void)goSearch:(UIButton *)btn
{
    [self hideOthersView];
    // 保存 textfield 的字段
    
    ReXiaoShangPinVC *vc = [[ReXiaoShangPinVC alloc]init];
    vc.title_ = [btn.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//过滤字符串前后的空格
    vc.comeFromType = PushComeFromSouSuo;
    [self pushViewController:vc];
    [vc release];
    
    // 添加搜索字段到搜索历史
    NSMutableArray *searchArray = [self addStringAsSearchHistory:btn.titleLabel.text];
    self.historyArray = searchArray;
    [self.historyTabView reloadData];
   
    ///
//    MMDrawerController *mmvc = [MMDrawerController MMDrawerControllerWithName:btn.titleLabel.text withId:@"-2"];
//    // -2 代表是搜索进去的
//    [self pushViewController:mmvc];
    
}




// 添加搜索历史视图
#pragma mark - 添加搜索历史视图
-(void)createHistoryView
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSMutableArray *historyArr = [userDefaultes valueForKey:SEARCH_HISTORY];
    self.historyArray = historyArr;
    
    UITableView  *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, TITLEHEIGHT+75, self.view.frame.size.width, MainViewHeight - [self getTitleBarHeight] - 20 - BOTTOMHEIGHT -45) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorColor = RGBACOLOR(199, 199, 199, 1);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = YES;
    tableView.backgroundView = [[[UIView alloc]initWithFrame:tableView.frame]autorelease];
    tableView.backgroundView.backgroundColor = [UIColor clearColor];
    tableView.hidden = YES;
    self.historyTabView = tableView;
    [self.view addSubview:tableView];
    [tableView release];
    
    
    // 添加 tableview footer
    do {
        UIView *myView = [[[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, MainViewWidth, 140)]autorelease];
        
        UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [myButton setTitle:@"清除搜索记录" forState:UIControlStateNormal];
        [myButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [myButton setBackgroundImage:GETIMG(@"button3_press.png") forState:UIControlStateSelected];
        [myButton setBackgroundImage:GETIMG(@"button3.png") forState:UIControlStateNormal];
        [myButton setFrame:CGRectMake(10, 20, 300, 44)];
        [myButton addTarget:self action:@selector(clearHistory) forControlEvents:UIControlEventTouchUpInside];
        [myView addSubview:myButton];
        self.footView = myView;
        
        self.historyTabView.tableFooterView = myView;
    } while (0);
}

#pragma mark - Table view
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([self.historyArray count]==0) {
        self.footView.hidden = YES;
    }else
    {
        self.footView.hidden = NO;
    }
    return [self.historyArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SearchHistoryCell *cell = (SearchHistoryCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[[SearchHistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.labTitle.text = [self.historyArray objectAtIndex:indexPath.row];
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *searchString = [self.historyArray objectAtIndex:indexPath.row];
//    MMDrawerController *mmvc = [MMDrawerController MMDrawerControllerWithName:searchString withId:@"-2"];
//    // -2 代表是搜索进去的
//    [self pushViewController:mmvc];
    [self hideOthersView];
    
    ReXiaoShangPinVC *vc = [[ReXiaoShangPinVC alloc]init];
    vc.title_ = [searchString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//过滤字符串前后的空格
    vc.comeFromType = PushComeFromSouSuo;
    [self pushViewController:vc];
    [vc release];
}


#pragma mark - 添加搜索框视图
-(void)createSearchView
{
    UIImage *bgImg = GetImage(@"search_bg_search.png");
    UIView *searchContent = [[UIView alloc]initWithFrame:CGRectMake(0, TITLEHEIGHT+35, MainViewWidth, 45)];
    // 背景图
    do {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bgImg.size.width, bgImg.size.height)];
        imageView.userInteractionEnabled = NO;
        imageView.image = bgImg;
        [searchContent addSubview:imageView];
        [imageView release];
    } while (0);
    // 输入框背景
    do {
        UIImage *myImg = GETIMG(@"search_bg_search box.png");
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, myImg.size.width, myImg.size.height)];
        imageView.tag = SEARCHTAG+1;
        imageView.userInteractionEnabled = YES;
        imageView.image = myImg;
        self.TopBackgroudImgV = imageView;
        [searchContent addSubview:imageView];
        [imageView release];
    } while (0);
    
    // 搜索的图标
    do {
        UIImage *myImg = GetImage(@"search_icon_search.png");
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, bgImg.size.height/2-myImg.size.height/2, myImg.size.width, myImg.size.height)];
        imageView.userInteractionEnabled = YES;
        imageView.image = myImg;
        self.TopBackgroudImgV = imageView;
        [searchContent addSubview:imageView];
        [imageView release];
    } while (0);
    
    // 输入文字的 textfield
    do {
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(45, 5, 190, 35)];
        textField.tag = SEARCHTAG;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.delegate=self;
        textField.font=SYSTEMFONT(15);
        textField.returnKeyType = UIReturnKeyGo;
        textField.backgroundColor=[UIColor clearColor];
        textField.placeholder=@"请输入搜索字段";
        self.inputTextField = textField;
        [searchContent addSubview:textField];
        [textField release];
    } while (0);
    
    // 麦克风的按钮
    do {
        UIImage *myImg = GetImage(@"search_icon_vioce.png");
        UIButton *microPhone = [UIButton buttonWithType:UIButtonTypeCustom];
        microPhone.tag = SEARCHTAG +2;
        microPhone.backgroundColor = [UIColor clearColor];
        microPhone.frame = CGRectMake(320-10-myImg.size.width, bgImg.size.height/2-myImg.size.height/2, myImg.size.width, myImg.size.height);
        [microPhone setBackgroundImage:myImg forState:UIControlStateNormal];
        [microPhone addTarget:self action:@selector(microPhoneClick:) forControlEvents:UIControlEventTouchUpInside];
        [searchContent addSubview:microPhone];
    } while (0);
    
    // 取消按钮
    do {

        UIImage *myImg = GetImage(@"search_button_cansel.png");
        UIButton *cancelSearch = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelSearch.frame = CGRectMake(320-10-myImg.size.width, bgImg.size.height/2-myImg.size.height/2, myImg.size.width, myImg.size.height);
        
        cancelSearch.tag = SEARCHTAG +3;
        [cancelSearch setBackgroundImage:GetImage(@"search_button_cansel@2x.png") forState:UIControlStateNormal];
        [cancelSearch setBackgroundImage:GetImage(@"search_button_cansel_press@2x.png") forState:UIControlStateHighlighted];
        [cancelSearch addTarget:self action:@selector(cancelTextFiled:) forControlEvents:UIControlEventTouchUpInside];
        cancelSearch.hidden = YES;
        [searchContent addSubview:cancelSearch];
    } while (0);
    
    // 以下代码是为了点击一下回到全视图页面
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0.0, self.textInputView.frame.origin.y+self.textInputView.frame.size.height, MainViewWidth, MainViewHeight)];
    bgView.tag = SEARCHTAG +4;
    bgView.hidden = YES;
    bgView.backgroundColor = RGBACOLOR(57.0, 57.0, 57.0, 1);
    
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [myButton setFrame:CGRectMake(0.0, TITLEHEIGHT, bgView.frame.size.width, bgView.frame.size.height-TITLEHEIGHT)];
    [myButton addTarget:self action:@selector(cancelTextFiled:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:myButton];
    
    [self.view addSubview:bgView];
    [bgView release];
    
    self.textInputView = searchContent;
    [self.view addSubview:searchContent];
    [searchContent release];
}

//-(void)backToHome
//{
//
//}

-(void)microPhoneClick:(UIButton *)button
{
    if (!alertView) {
        alertView = [[MYAlertView alloc]initWithTitle:@"请说话" message:@"商品名称或类型如：衬衫、秋装" image:@"语音icon_未选中.png" delegate:self cancelButtonTitle:@"取消" anotherButtonTitle:nil];
    }else {
        [alertView beginTalking];
    }
    
    [alertView show];
    
    if (!self.iflySpeechRecognizer) {   //  开始录音
        [self initIflyRecognizer];
    }
    [self.iflySpeechRecognizer startListening];
}

#pragma mark MYAlertViewDelegate
- (void)myAlertView:(MYAlertView *)alertview clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex = %i",buttonIndex);
    
    if (buttonIndex == 0) {
        [self.iflySpeechRecognizer stopListening];
    }else {
        int sta = alertview.state;
        
        switch (sta) {
            case AlertViewStateBeginTalking:
                
                break;
            case AlertViewStateWasIdentificaing:
                
                break;
            case AlertViewStateidentificaSuccess:
            {
                if (self.strSpeak.length > 0) {
                    UITextField *txInput = (UITextField *)[self.textInputView viewWithTag:SEARCHTAG];
                    [txInput setText:self.strSpeak];
                    [self textFieldShouldReturn:txInput];
                }
            }
                break;
            case AlertViewStateIdentificaFailed:
            {
//                UIButton *temBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                temBtn.tag = SEARCHTAG +2;
//                [self microPhoneClick:temBtn];
                
                [alertView beginTalking];
                [self.iflySpeechRecognizer startListening];
            }
                break;
                
            default:
                break;
        }
    }
    
    
    
}

-(void)cancelTextFiled:(UIButton *)button
{
    UITextField *txInput = (UITextField *)[self.textInputView viewWithTag:SEARCHTAG];
    [txInput resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UIView *others = [self.view viewWithTag:OTHERSTAG];
    if (!others.isHidden) {
        others.hidden = !others.isHidden;
    }
    [UIView animateWithDuration:0.5 animations:^{
        // 移动 textfield 背景，把取消按钮显示出来，把麦克风隐藏
        [self.textInputView setFrame:CGRectMake(0, 0, 320, 45)];
        
        UIView *txBG = [self.textInputView viewWithTag:SEARCHTAG+1];
        [txBG setFrame:CGRectMake(txBG.frame.origin.x, txBG.frame.origin.y, 233, txBG.frame.size.height)];

        UIView *macPH = [self.textInputView viewWithTag:SEARCHTAG+2];
        macPH.hidden = YES;
        
        UIView *canBT = [self.textInputView viewWithTag:SEARCHTAG+3];
        canBT.hidden = NO;
        
        // 黑色背景出现
        UIView *corverBG = [self.view viewWithTag:SEARCHTAG+4];
        corverBG.frame = CGRectMake(0.0, 0, 320, 460);
        corverBG.hidden = NO;
        
    }];
    
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    
    [UIView animateWithDuration:0.5 animations:^{
        // 移动 textfield 背景，把取消隐藏，把麦克风显示出来
        [self.textInputView setFrame:CGRectMake(0, TITLEHEIGHT+35, 320, 45)];
        
        UIView *txBG = [self.textInputView viewWithTag:SEARCHTAG+1];
        [txBG setFrame:CGRectMake(txBG.frame.origin.x, txBG.frame.origin.y, 300, txBG.frame.size.height)];
        
        UIView *macPH = [self.textInputView viewWithTag:SEARCHTAG+2];
        macPH.hidden = NO;
        
        UIView *canBT = [self.textInputView viewWithTag:SEARCHTAG+3];
        canBT.hidden = YES;
        
        // 黑色背景隐藏
        UIView *corverBG = [self.view viewWithTag:SEARCHTAG+4];
        corverBG.frame = CGRectMake(0.0, TITLEHEIGHT+35, 320, 460);
        corverBG.hidden = YES;
    }];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            
    if ([aString length] > 25) {
        textField.text = [aString substringToIndex:25];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                                message:@"搜索内容长度在50个字之内"
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"确定"
//                                                      otherButtonTitles:nil];
//        alert.delegate = self;
//        [alert show];
//        [alert release];
        return NO;
    }

    return YES;
}

#pragma mark ### 请求搜索结果 ###
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //请求数据
    if ([textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length >0) {
//        MMDrawerController *mmvc = [MMDrawerController MMDrawerControllerWithName:textField.text withId:@"-2"];
//        // -2 代表是搜索进去的
//        [self pushViewController:mmvc];
        ReXiaoShangPinVC *vc = [[ReXiaoShangPinVC alloc]init];
        vc.title_ = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//过滤字符串前后的空格;
        
        vc.comeFromType = PushComeFromSouSuo;
        [self pushViewController:vc];
        [vc release];
        
        // 添加搜索字段到搜索历史
        NSMutableArray *searchArray = [self addStringAsSearchHistory:textField.text];
        self.historyArray = searchArray;
        [self.historyTabView reloadData];

    }

    [textField resignFirstResponder];
    return YES;
}

-(void)refreshHistoryTable:(NSNotification *)notification
{
    NSString *searchStr = notification.object;
    NSMutableArray *searchArray = [self addStringAsSearchHistory:searchStr];
    self.historyArray = searchArray;
    [self.historyTabView reloadData];
}

// 添加搜索字段到搜索历史
-(NSMutableArray *)addStringAsSearchHistory:(NSString * )strSearch
{
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSMutableArray *historyArr = [userDefaultes valueForKey:SEARCH_HISTORY];
    NSMutableArray *myArray = [NSMutableArray arrayWithArray:historyArr];
    
    NSString *textFieldText = [strSearch stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//过滤字符串前后的空格;
    
    BOOL shouldInput = YES;
    for (int i = 0; i< [myArray count]; i++) {
        NSString *str  = [myArray objectAtIndex:i];
        if ([str isEqualToString:textFieldText]) {
            shouldInput = NO;
        }
    }
    if (shouldInput) {
        if ([myArray count]==10) {
            [myArray removeLastObject];
        }
        [myArray insertObject:textFieldText atIndex:0];
    }
    [userDefaultes setValue:myArray forKey:SEARCH_HISTORY];
    return myArray;
}

#pragma mark - 添加右上角搜索按钮
- (void)createOtherSearch
{
    self.rightButton.hidden = NO;
    [self setRightButtonImage:@"search_icon_camera.png"];
    [self.rightButton addTarget:self action:@selector(showOtherSearch:) forControlEvents:UIControlEventTouchUpInside];
    
//    [self setMyRightButtonImage:@"search_icon_camera@2x.png" hightImage:@"search_icon_camera@2x.png"];
//    [self setMyRightButtonBackGroundImageView:@"search_icon_camera@2x.png" hightImage:@"search_icon_camera@2x.png"];
    
    
//    do {
//        UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        photoBtn.tag = SEARCHTAG +3;
//        UIImage *myIMG = GETIMG(@"search_icon_camera.png");
//        [photoBtn setImage:myIMG forState:UIControlStateNormal];
//        photoBtn.frame = CGRectMake(MainViewWidth-myIMG.size.width/2-20, TITLEHEIGHT/2-myIMG.size.height/2, myIMG.size.width, myIMG.size.height);
//        [photoBtn addTarget:self action:@selector(showOtherSearch:) forControlEvents:UIControlEventTouchUpInside];
//        photoBtn.hidden = NO;
//        [self.titleBar addSubview:photoBtn];
//    } while (0);
    // 添加弹出来得内容
    [self AddOtherSearch];
}

-(void)showOtherSearch:(UIButton *)button
{
    UIView *others = [self.view viewWithTag:OTHERSTAG];
    others.hidden = !others.isHidden;
}

-(void)AddOtherSearch
{
    UIImage *myImg = GETIMG(@"search_pop_bg.png");
    UIView *otherV = [[UIView alloc]initWithFrame:CGRectMake(0.0, TITLEHEIGHT, MainViewWidth, myImg.size.height)];
    otherV.tag = OTHERSTAG;
    //填充视图
    do {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, myImg.size.width, myImg.size.height)];
        imageView.userInteractionEnabled = YES;
        imageView.image = myImg;
        [otherV addSubview:imageView];
        [imageView release];
    } while (0);
    
    NSArray *myArr = [NSArray arrayWithObjects:@"search_pop_sel1@2x.png",@"search_pop_sel2@2x.png",@"search_pop_sel3@2x.png", nil];
    for (int i =0; i<3; i++) {
        UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        photoBtn.tag = i;
        
        UIImage *myIMG = GETIMG([myArr objectAtIndex:i]);
        photoBtn.frame = CGRectMake(i*320/3.0,0,myIMG.size.width,myIMG.size.height);
        [photoBtn addTarget:self action:@selector(clickOthersSearchButton:) forControlEvents:UIControlEventTouchUpInside];
        photoBtn.hidden = NO;
        [otherV addSubview:photoBtn];
    }
    
    otherV.hidden = YES;
    [self.view addSubview:otherV];
    [otherV release];
}


-(void)clickOthersSearchButton:(UIButton *)button
{
    UIView *others = [self.view viewWithTag:OTHERSTAG];
    others.hidden = YES;       // 点击隐藏黑边三个按钮
    
    
    
    switch (button.tag) {
        case 0:
        {
           //条码购
            BarCodeScanVC *codeVC = [[BarCodeScanVC alloc]init];
            [self pushViewController:codeVC];
            [codeVC release];
            
            break;
        }
        case 1:
        {
            BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
            if(!isCamera)//
            {
                [WCAlertView showAlertWithTitle:@"提示" message:@"您的设备没有摄像头" customizationBlock:^(WCAlertView *myAlertView) {
                    myAlertView.style = WCAlertViewStyleWhite;
                    myAlertView.labelTextColor=[UIColor blackColor];
                    myAlertView.buttonTextColor=[UIColor blueColor];
                } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                    nil;
                } cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
                return;
                
            }

            BuyByColorVC *colourView = [[BuyByColorVC alloc]init];
            [self pushViewController:colourView];
            SAFETY_RELEASE(colourView);
            //颜色购
            break;
        }
        case 2:
        {
            //摇一摇
            ShakeVC* shakeVC = [[ShakeVC alloc] init];
            [self pushViewController:shakeVC];
            [shakeVC release];
            break;
        }
            
        default:
            break;
    }
}

- (void)addTapButton
{
    UIButton *tapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tapBtn.frame = CGRectMake(0,TITLEHEIGHT,MainViewWidth,MainViewHeight-TITLEHEIGHT);
    [tapBtn addTarget:self action:@selector(tapOnBackground:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tapBtn];
}

-(void)tapOnBackground:(UIButton *)button
{
    UIView *others = [self.view viewWithTag:OTHERSTAG];
    if (!others.isHidden) {
        others.hidden = YES;
    }
}
-(void)hideOthersView
{
    UIView *others = [self.view viewWithTag:OTHERSTAG];
    if (!others.isHidden) {
        others.hidden = YES;
    }

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideOthersView];
}
-(void)clearHistory
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSMutableArray *historyArr = [userDefaultes valueForKey:SEARCH_HISTORY];
    NSMutableArray *myArray = [NSMutableArray arrayWithArray:historyArr];
    
    [myArray removeAllObjects];
    [userDefaultes setValue:myArray forKey:SEARCH_HISTORY];
    self.historyArray = myArray;
    
    [self.historyTabView reloadData];
    
}


// 请求网络热门关键词
#pragma mark ### 网络热门关键词 ###
- (void)requestToGetNewHot
{
    [self hideOthersView];
    
    [self.view addHUDActivityView:Loading];  //提示 加载中
    DSRequest *requestObj = [[DSRequest alloc]init];
    self.aRequest = requestObj;
    [requestObj release];
    requestObj.delegate = self;
    
    [requestObj requestDataWithInterface:GetPopularSearchWords param:[self GetPopularSearchWordsParam] tag:0];
    
}


-(void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError *)error
{
    [self.view removeHUDActivityView];        //加载失败  停止转圈
    NSLog(@"失败");
    switch (tag) {
        case 0:
        {
            
        }
            break;
            
        default:
            break;
    }
}

-(void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    [self.view removeHUDActivityView];        //加载成功  停止转圈
    if(tag == 0)
    {
        NSMutableArray *myArray = dataObj;
        if ([myArray count]==0) {
            [self.view addHUDLabelView:@"没有数据" Image:nil afterDelay:1];
        }
//        NSArray *aArray = [NSArray arrayWithObjects:@"长字段，常文字长字段，常文字长字段，常文字", @"长字段，常文字长字段，常文字长字段，常文字",@"长字段，常文字长字段，常文字长字段，常文字",@"长字段，常文字长字段，常文字长字段，常文字",@"长字段，常文字长字段，常文字长字段，常文字",@"长字段，常文字长字段，常文字长字段，常文字",@"长字段，常文字长字段，常文字长字段，常文字",nil];
//        [myArray addObjectsFromArray:aArray];
        [self refreshKeyWordViewBy:myArray];
    }
}

#pragma mark -- jiXuGuangGuangNotification
-(void)jiXuGuangGuang:(NSNotification*)noti
{
    UIWindow *win = ((AppDelegate*)[UIApplication sharedApplication].delegate).window;
    RootVC *vc =(RootVC*) win.rootViewController;
    //[vc clickTabButton:vc.buttons[0]];
    [vc showTableIndex:0];
}
#pragma mark -- UIAlterViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    return;
}

@end
