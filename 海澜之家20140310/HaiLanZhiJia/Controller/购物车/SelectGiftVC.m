//
//  SelectGiftVC.m
//  HaiLanZhiJia
//
//  Created by 蒋遂明 on 13-11-28.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#define POP_TAG  0x500

#define IMAGE_RESIZE(image) [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)]
#import "SelectGiftVC.h"

@interface SelectGiftVC ()
{
}

@property (nonatomic,retain)UITableView    *myTableView;
@property (nonatomic,retain)NSMutableArray *colorBtnArray;
@property (nonatomic,retain)NSMutableArray *sizeBtnArray;
@property (nonatomic,retain)UIView         *myCorverView;
@property (nonatomic,retain)NSIndexPath    *currentSelectIndexPath; //用于修改颜色，尺码

@property (nonatomic,retain)NSMutableArray *giftArray;
@property (nonatomic,retain)NSMutableArray *presentationListArray;

@end

@implementation SelectGiftVC

@synthesize myTableView;
@synthesize colorBtnArray;
@synthesize sizeBtnArray;
@synthesize myCorverView;

@synthesize giftArray;
@synthesize presentationListArray;

@synthesize aRequest;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    self.myTableView    = nil;
    self.colorBtnArray  = nil;
    self.sizeBtnArray   = nil;
    self.myCorverView   = nil;
    
    self.giftArray        = nil;
    self.aRequest.delegate= nil;
    self.aRequest         = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleString:@"选择赠品"];
    
    self.currentSelectIndexPath = nil;
    currentIndex = -1;
    
    [self createDatas];
    
    
    UITableView  *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, TITLEHEIGHT, self.view.frame.size.width, MainViewHeight - [self getTitleBarHeight] - 20) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorColor = RGBACOLOR(199, 199, 199, 1);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = YES;
    tableView.backgroundView = [[[UIView alloc]initWithFrame:tableView.frame]autorelease];
    tableView.backgroundView.backgroundColor = [UIColor clearColor];
    tableView.tableFooterView = [[[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)]autorelease];
    self.myTableView = tableView;
    [self.view addSubview:tableView];
    [tableView release];
    
    
    self.colorBtnArray = [[[NSMutableArray alloc]init]autorelease];
    self.sizeBtnArray = [[[NSMutableArray alloc]init]autorelease];
    
    
    [self requestToServer];
//    [self showSelectColorSizeViewByArray:[NSArray arrayWithObjects:@"白色",@"油绿",@"大红",@"粉红",@"土黄",@"明黄", nil]];
	// Do any additional setup after loading the view.
}

-(void)requestToServer
{
    DSRequest *requestObj = [[DSRequest alloc]init];
    self.aRequest = requestObj;
    [requestObj release];
    requestObj.delegate = self;
    
    [requestObj requestDataWithInterface:ShoppingCarPresentationList param:[self ShoppingCarPresentationListParam] tag:0];
    
    [self.view addHUDActivityView:Loading];  //提示 加载中
}

-(void)createDatas
{
    self.giftArray = [[[NSMutableArray alloc]init]autorelease];
}

#pragma mark - Table view
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

-( CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *myLabel = [[[UILabel alloc]initWithFrame:CGRectMake(40, 0, 300, 45)]autorelease];
    myLabel.backgroundColor = RGBCOLOR(231, 231, 231);
    myLabel.textColor = TEXT_GRAY_COLOR;
    myLabel.font = SYSTEMFONT(16);
    PresentationListEntity *entity = [self.presentationListArray objectAtIndex:section];
    [myLabel setText:[NSString stringWithFormat:@"  %@", entity.presentationinfo]];
    
    return myLabel;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    
    return [self.presentationListArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    PresentationListEntity *entity = [self.presentationListArray objectAtIndex:section];
    
    return [entity.goodsinfo count];
    //    return [self.historyArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    GiftCell *cell = (GiftCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[GiftCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    PresentationListEntity *entity = [self.presentationListArray objectAtIndex:indexPath.section];
    PresentationEntity *aEntity =  [entity.goodsinfo objectAtIndex:indexPath.row];
    if (aEntity.isselect) {
        currentIndex = indexPath.row;
    }
    [cell resetDateByEntity:aEntity ofIndex:indexPath];
    cell.delegate = self;
    
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PresentationListEntity *entity =  [self.presentationListArray objectAtIndex:indexPath.section];
    PresentationEntity *bEntity = [entity.goodsinfo objectAtIndex:indexPath.row];
    
    if (currentIndex ==indexPath.row) {
        bEntity.isselect = !bEntity.isselect;
        if (!bEntity.isselect) {
            currentIndex = -1;
        }else{
            currentIndex = indexPath.row;
        }
    }else{
        
        if ([bEntity.selectcolor isKindOfClass:[NSNull class]] || [bEntity.selectcolor isEqualToString:@""]
            ||[bEntity.selectsize isKindOfClass:[NSNull class]] || [bEntity.selectsize isEqualToString:@""]) {
            
            self.currentSelectIndexPath = indexPath;
            PresentationListEntity *listentity =  [self.presentationListArray objectAtIndex:indexPath.section];
            PresentationEntity *myEntity = [listentity.goodsinfo objectAtIndex:indexPath.row];
            [self showSelectColorSizeViewByEntity:myEntity];
            [self showSelectView:YES];
        }else{
            for ( PresentationEntity *aEntity  in entity.goodsinfo) {
                aEntity.isselect = NO;
            }
            bEntity.isselect = YES;
            currentIndex = indexPath.row;
        }
        
    }
    
    
    [self.myTableView reloadData];
}

#pragma mark --- cell代理 --- 颜色尺码选择
// 颜色，大小
-(void)selectSizeandColorOfIndex:(NSIndexPath *)index
{
    self.currentSelectIndexPath = index;
    // 展示选择页面
    PresentationListEntity *entity =  [self.presentationListArray objectAtIndex:index.section];
    PresentationEntity *aEntity = [entity.goodsinfo objectAtIndex:index.row];
    
    [self showSelectColorSizeViewByEntity:aEntity];
    
    [self showSelectView:YES];
    
    
}

- (void)giftSelected:(BOOL)select ofIndex:(NSIndexPath *)index
{
    
    
    
    
}


//    [	{
//        “specialid”:”123”,
//        “goodsid”:”343”,
//        “color”:”黑色”,
//        “size”:”109/109A”
//    }
//     ……
//     ]
-(void)modifyRequestToSerVer
{
    // 组装数据 发送请求
    // 接受数据
    // 重载数据
    DSRequest *requestObj = [[DSRequest alloc]init];
    self.aRequest = requestObj;
    [requestObj release];
    requestObj.delegate = self;
    
    [requestObj requestDataWithInterface:ShoppingCarCommitPresentation param:[self ShoppingCarCommitPresentationParam:self.presentationListArray] tag:1];
    
    [self.view addHUDActivityView:Loading];  //提示 加载中
}



//
- (void)showSelectColorSizeViewByEntity:(PresentationEntity *)giftEntity;
{
    [self.myCorverView removeFromSuperview];
    self.myCorverView = nil;
    
    NSArray *myArray = giftEntity.colorarray;
//    if ([myArray count]==0) {
//        myArray = [NSArray arrayWithObject:@""];
//        giftEntity.colorarray = myArray;
//    }
    int number = [myArray count];
    NSLog(@"%d",number);
    
    UIView *corverView = [[UIView alloc]initWithFrame:CGRectMake(0.0, MainViewHeight, MainViewWidth, MainViewHeight)];
    corverView.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
    //corverView.backgroundColor = [UIColor redColor];
    corverView.tag = POP_TAG;
    
    
    UIButton *tapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tapBtn.frame = CGRectMake(0.0, 0, MainViewWidth, MainViewHeight);
    //myIMG.size.width,myIMG.size.height
    tapBtn.backgroundColor = [UIColor clearColor];
    [tapBtn addTarget:self action:@selector(hideSelectView) forControlEvents:UIControlEventTouchUpInside];
    [corverView addSubview:tapBtn];

    
    self.myCorverView = corverView;
    [self.view addSubview:corverView];
    [corverView release];
    
    

    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, MainViewWidth, MainViewHeight)];
    myView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *myImageV = [[UIImageView alloc]initWithImage:GetImage(@"bg_picker.png")];
    [myImageV setFrame:CGRectMake(0.0, 0.0, MainViewWidth, MainViewHeight)];
    [myView addSubview:myImageV];
    [myImageV release];
    
    
    int currentY = 15;
    // 颜色
    UILabel *aLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.0, currentY, 40.0, 31)];
    aLabel.backgroundColor = [UIColor clearColor];
    aLabel.numberOfLines = 1;
    aLabel.textColor = TEXT_GRAY_COLOR;
    aLabel.font = SYSTEMFONT(12);
    [aLabel setText:@"颜色："];
    [myView addSubview:aLabel];
    [aLabel release];
    
    myArray = giftEntity.colorarray;
    
//    if ([myArray count]==0) {
//        myArray = [NSArray arrayWithObject:@""];
//        giftEntity.colorarray = myArray;
//    }
    number = [myArray count];
    
    for (int i = 0; i<number; i++) {
        // 每行3个
        //添加按钮
        UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *myIMG = GETIMG(@"car_bg_card.png");
        [myButton setTitle:[myArray objectAtIndex:i] forState:UIControlStateNormal];
        [myButton.titleLabel setFont:SYSTEMFONT(12)];
        [myButton setTitleColor:TEXT_GRAY_COLOR forState:UIControlStateNormal];
        
        [myButton setBackgroundImage:IMAGE_RESIZE(myIMG) forState:UIControlStateNormal];
        [myButton setBackgroundImage:IMAGE_RESIZE(GETIMG(@"car_bg_card_sel.png")) forState:UIControlStateSelected];

        int xLong = i %3;
        myButton.frame = CGRectMake(50+90*xLong,currentY,82,31);
        [myButton addTarget:self action:@selector(selectColor:) forControlEvents:UIControlEventTouchUpInside];
        [myView addSubview:myButton];
        
        if (i==number-1) {
            currentY += 41;
        }else if((i+1)%3==0) {
            currentY += 36;
        }
        
        // 设置是否勾选已经选中的
        if ([giftEntity.selectsize length]!=0&&[giftEntity.selectcolor isEqualToString:[giftEntity.colorarray objectAtIndex:i]]) {
            myButton.selected = YES;
        }else{
            myButton.selected = NO;
        }
        
        [self.colorBtnArray addObject:myButton];
    }
    if ([giftEntity.colorarray count]==0) {
        currentY += 41;
    }
    currentY +=5;
    
    // 尺码
    UILabel *bLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.0, currentY, 40.0, 31)];
    bLabel.backgroundColor = [UIColor clearColor];
    bLabel.numberOfLines = 1;
    bLabel.textColor = TEXT_GRAY_COLOR;
    bLabel.font = SYSTEMFONT(12);
    [bLabel setText:@"尺码："];
    [myView addSubview:bLabel];
    [bLabel release];
    
#pragma mark -- 140314
    NSArray *sizeAndStore = nil;
    if (giftEntity.colorandsizes.count>0)
    {
        NSDictionary *colorSizeDic = [giftEntity.colorandsizes objectAtIndex:0];
        if ([colorSizeDic objectForKey:@"sizeandstore"])
        {
            sizeAndStore = [colorSizeDic objectForKey:@"sizeandstore"];
        }
    }
    NSArray *sizeArray = sizeAndStore;
//    if ([sizeArray count]==0) {
//        sizeArray = [NSArray arrayWithObject:@""];
//        giftEntity.sizearray = sizeArray;
//    }
    int sizeNumber = [sizeArray count];
    
    for (int i = 0; i<sizeNumber; i++)
    {
        // 每行2个
        //添加按钮
        UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *myIMG = GETIMG(@"car_bg_card.png");  //138
        [myButton setTitle:[[sizeArray objectAtIndex:i]objectForKey:@"size"] forState:UIControlStateNormal];
        [myButton.titleLabel setFont:SYSTEMFONT(12)];
        [myButton setTitleColor:TEXT_GRAY_COLOR forState:UIControlStateNormal];
        
        [myButton setBackgroundImage:IMAGE_RESIZE(myIMG) forState:UIControlStateNormal];
        int xLong = i %2;
        [myButton setBackgroundImage:IMAGE_RESIZE(GETIMG(@"car_bg_card_sel.png")) forState:UIControlStateSelected];
        [myButton setBackgroundImage:GetImage(@"mall_button_size_dis@2x.png") forState:UIControlStateDisabled];
        myButton.frame = CGRectMake(50+138*xLong,currentY,127,31);
        //myIMG.size.width,myIMG.size.height
        [myButton addTarget:self action:@selector(selectSize:) forControlEvents:UIControlEventTouchUpInside];
        [myView addSubview:myButton];
        if ([[[sizeArray objectAtIndex:i]objectForKey:@"store"] intValue]==1)
        {
            myButton.enabled=YES;
        }else
        {
            myButton.enabled = NO;
        }
        if (i==sizeNumber -1) {
            currentY += 41;
        }else if((i+1)%2==0) {
            currentY += 36;
        }
        
        // 设置是否勾选已经选中的
        if ([giftEntity.selectsize length]!=0&&[giftEntity.selectsize isEqualToString:[[sizeArray objectAtIndex:i]objectForKey:@"size"]]) {
            
            myButton.selected = YES;
        }else{
            myButton.selected = NO;
        }
        
        
        [self.sizeBtnArray addObject:myButton];
    }
    
    if ([sizeArray count]==0) {
        currentY += 41;
    }
    currentY +=30;

    [myView setFrame:CGRectMake(0.0, MainViewHeight-currentY, MainViewWidth, currentY)];
    [self.myCorverView addSubview:myView];
    [myView release];
    
    
//    }
    
}

#pragma mark ### 隐藏的时候，发送选择结果 ###
-(void)hideSelectView
{
    //
    
    
    
    [self showSelectView:NO];
}

#pragma ### 

-(void)showSelectView:(BOOL)show
{
    
    CGRect rect = self.myCorverView.frame;
    
    [UIView animateWithDuration:0.5 animations:^{
        if (!show) {
            [self.myCorverView setFrame:CGRectMake(rect.origin.x, MainViewHeight, rect.size.width, rect.size.height)];
            
            // 设置为当前编辑的商品为选中
            PresentationListEntity *entity =  [self.presentationListArray objectAtIndex:self.currentSelectIndexPath.section];
            PresentationEntity *bEntity = [entity.goodsinfo objectAtIndex:self.currentSelectIndexPath.row];
            
            if (![bEntity.selectcolor isKindOfClass:[NSNull class]] && ![bEntity.selectcolor isEqualToString:@""]
                &&![bEntity.selectsize isKindOfClass:[NSNull class]] && ![bEntity.selectsize isEqualToString:@""])
            {
                for ( PresentationEntity *aEntity  in entity.goodsinfo) {
                    aEntity.isselect = NO;
                }
                bEntity.isselect = YES;
                currentIndex = self.currentSelectIndexPath.row;
                [self.myTableView reloadData];
                
                //选中后，自动发送请求回退到上一个页面
                [self modifyRequestToSerVer];
                
            }
        }else
        {
            [self.myCorverView setFrame:CGRectMake(rect.origin.x, 0, rect.size.width, rect.size.height)];
        }
        
    }];
}

-(void)selectColor:(UIButton *)button
{
    // 更新颜色   当页面消失时统一提交
    PresentationListEntity *entity = [self.presentationListArray objectAtIndex:self.currentSelectIndexPath.section];
    PresentationEntity *aEntity =  [entity.goodsinfo objectAtIndex:self.currentSelectIndexPath.row];

    aEntity.selectcolor = button.titleLabel.text;
    
    for (UIButton *myBtn in self.colorBtnArray) {
        myBtn.selected = NO;
    }
    button.selected = YES;
}

-(void)selectSize:(UIButton *)button
{
    // 更新大小   当页面消失时统一提交
    PresentationListEntity *entity = [self.presentationListArray objectAtIndex:self.currentSelectIndexPath.section];
    PresentationEntity *aEntity =  [entity.goodsinfo objectAtIndex:self.currentSelectIndexPath.row];
    
    aEntity.selectsize = button.titleLabel.text;
    
    for (UIButton *myBtn in self.sizeBtnArray) {
        myBtn.selected = NO;
    }
    button.selected = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)leftAction
{
    // 如果有赠品列表，则发送请求
    if (self.presentationListArray && [self.presentationListArray count]>0) {
        [self modifyRequestToSerVer];
    }else{
        [super leftAction];
    }
    // 如果没有，则直接返回上一级
    
}

-(void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError *)error
{
    if (tag ==1) {
        [super leftAction];
        [self addFadeLabel:@"提交赠品信息失败"];
    }else{
        [self addFadeLabel:@"暂无赠品信息"];
    }
    
    [self.view removeHUDActivityView];        //加载失败  停止转圈
}

-(void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    if(tag == 0)
    {
        
        self.presentationListArray = dataObj;
        
        [self.myTableView reloadData];
    }
    
    if(tag == 1)
    {
        
        // 更改完成，退回到上一个的页面
        CommitPresentationEntity* entity = dataObj;
        if ([self.delegate respondsToSelector:@selector(PresentCommittedReturnInfo:)]) {
            [self.delegate PresentCommittedReturnInfo:entity];
        }
        
        self.delegate = nil;
        self.aRequest.delegate = nil;
        self.aRequest = nil;
        //[self addFadeLabel:@"修改赠品成功"];
        [super leftAction];
        
    }
    [self.view removeHUDActivityView];        //加载成功  停止转圈
    
}

@end
