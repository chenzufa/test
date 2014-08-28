//
//  PayMentVC.m
//  HaiLanZhiJia
//
//  Created by 蒋遂明 on 13-11-29.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "PayMentVC.h"

@interface PayMentVC ()

@property (nonatomic,retain)UIView *contentView;

@end

@implementation PayMentVC

@synthesize contentView;
@synthesize delegate;

-(void)dealloc
{
    self.contentView = nil;
    
    self.aRequest.delegate = nil;
    self.aRequest = nil;
    
    self.delegate = nil;
    
    [super dealloc];
}

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
    
    [self setTitleString:@"支付方式"];
    
    [self requestToPayType];
    
	// Do any additional setup after loading the view.
}

-(void)createSubViews:(NSArray *)myArray
{
    for (UIView *view in [self.view subviews]) {
        if (view != self.titleBar) {
           [view removeFromSuperview]; 
        }
    }
    
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0.0, TITLEHEIGHT, MainViewWidth, MainViewHeight-TITLEHEIGHT)];
    self.contentView = myView;
    [self.view addSubview:myView];
    [myView release];
    
    UILabel *aLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, MainViewWidth, 32)];
    [aLable setText:@"支付方式"];
    aLable.backgroundColor = [UIColor clearColor];
    aLable.textColor = TEXT_GRAY_COLOR;
    [aLable setFont:SYSTEMFONT(12)];
    [self.contentView addSubview:aLable];
    [aLable release];
    
    UIImage *aImg = GetImage(@"bg_list2_up.png");
    
    float beginY = 32.0;
    int number = [myArray count];
    for (int i =0; i< number; i++) {
        if (number==0) {
            NSLog(@"数据失败");
        }else if (number >0)
        {
            
            UIButton *aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [aBtn setFrame:CGRectMake(10,beginY + aImg.size.height*i, aImg.size.width, aImg.size.height)];
            aBtn.tag = i;
            
            [aBtn addTarget:self action:@selector(payBy:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *atLable = [[UILabel alloc]initWithFrame:CGRectMake(15,beginY + aImg.size.height*i, aImg.size.width, aImg.size.height)];
            
            PayTypeEntity* entity = [myArray objectAtIndex:i];
            [atLable setText:entity.name];
            atLable.userInteractionEnabled = NO;
            atLable.backgroundColor = [UIColor clearColor];
            atLable.textColor = TEXT_GRAY_COLOR;
            [atLable setFont:SYSTEMFONT(14)];
            
            if (i==0) {
                if (number ==1) {
                    [aBtn setBackgroundImage:GetImage(@"bg_list.png") forState:UIControlStateNormal];
                    [aBtn setBackgroundImage:GetImage(@"bg_list_press.png") forState:UIControlStateHighlighted];
                }else{
                    [aBtn setBackgroundImage:GetImage(@"bg_list2_up.png") forState:UIControlStateNormal];
                    [aBtn setBackgroundImage:GetImage(@"bg_list2_up_press.png") forState:UIControlStateHighlighted];
                }
            }else if (i==number-1){
                [aBtn setBackgroundImage:GetImage(@"bg_list2_down.png") forState:UIControlStateNormal];
                [aBtn setBackgroundImage:GetImage(@"bg_list2_down_press.png") forState:UIControlStateHighlighted];
            }else{
                [aBtn setBackgroundImage:GetImage(@"bg_list2_middle.png") forState:UIControlStateNormal];
                [aBtn setBackgroundImage:GetImage(@"bg_list2_middle_press.png") forState:UIControlStateHighlighted];
            }
            
            
            
            [self.contentView addSubview:aBtn];
            [self.contentView addSubview:atLable];
            [atLable release];
        }
        
    }
    for (int i = 0; i<number -1; i++) {
        if (i!=number-1) {
            UIImage *lineImg = GetImage(@"segmentation_line.png");
            UIImageView *lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10,beginY+(i+1)*aImg.size.height, lineImg.size.width, lineImg.size.height)];
            lineImgView.image = lineImg;
            [self.contentView addSubview:lineImgView];
            [lineImgView release];
        }
    }
    
    BOOL hasDefault = NO;
    for (int i = 0; i< [myArray count]; i++) {
        PayTypeEntity* entity = [myArray objectAtIndex:i];
        //如果是当前的支付方式，设置button为选中
//        if (self.myEntity && self.myEntity.typeId &&self.myEntity.typeId ==entity.typeId) {
        if (self.myEntity && self.myEntity.paycode &&[self.myEntity.paycode isEqualToString:entity.paycode]) {
            [self selectIndex:i];
            hasDefault = YES;
        }

    }
    // 如果没有默认的支付方式，选中第一个 添加红勾
    if (!hasDefault) {
        [self selectIndex:0];
    }
    
}


-(void)payBy:(UIButton *)button
{
    int myTag = button.tag;
    [self selectIndex:myTag];
    
//    if (self.isOrderDetail == YES) {
////        
////        DSRequest *requestObj = [[DSRequest alloc]init];
////        self.aRequest = requestObj;
////        [requestObj release];
////        requestObj.delegate = self;
////        
////        [requestObj requestDataWithInterface:ChangeOrderPaytype param:[self ChangeOrderPaytypeParam:@“” paytypeid:@“”] tag:0];
////        
////        [self.view addHUDActivityView:Loading];  //提示 加载中
//        
//        if ([self.delegate respondsToSelector:@selector(sendFormMessage:Object:)]){
//            [self.delegate sendFormMessage:InfoTypeZhiFu Object:[self.payMentTypeArray objectAtIndex:_currentIndex]];
//        }
//        self.delegate = nil;
//        [super leftAction];
//    }
}

-(void)selectIndex:(int)index
{
    float imgHeight = GetImage(@"bg_list2_up.png").size.height;
    UIImageView *myImgV = (UIImageView *)[self.contentView viewWithTag:0x500];
    if (!myImgV) {
        UIImage *checkImg = GetImage(@"icon_select.png");    //38
        UIImageView *checkImgView = [[UIImageView alloc] initWithFrame:CGRectMake(280,32+13+imgHeight*index, checkImg.size.width, checkImg.size.height)];
        checkImgView.tag = 0x500;
        checkImgView.image = checkImg;
        myImgV = checkImgView;
        [self.contentView addSubview:checkImgView];
        [checkImgView release];
    }
    [myImgV setFrame:CGRectMake(280,32+13+44*index, myImgV.frame.size.width, myImgV.frame.size.height)];

    _currentIndex = index;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)requestToPayType
{
    DSRequest *requestObj = [[DSRequest alloc]init];
    self.aRequest = requestObj;
    [requestObj release];
    requestObj.delegate = self;
    
    [requestObj requestDataWithInterface:GetPayType param:[self GetPayTypeParam] tag:0];
    
    [self.view addHUDActivityView:Loading];  //提示 加载中
}

-(void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError *)error
{
    NSLog(@"失败");
    [self.view removeHUDActivityView];        //加载成功  停止转圈
}

-(void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    if(tag == 0)
    {
        self.payMentTypeArray = dataObj;
        [self createSubViews:self.payMentTypeArray];

        
        //        PayTypeEntity* entity=[[PayTypeEntity alloc] init];
//        entity.name=[dicTemp valueForKey:@"name"];
//        entity.typeId=[dicTemp valueForKey:@"typeid"];
    }
    [self.view removeHUDActivityView];        //加载成功  停止转圈
    
}


-(void)leftAction
{
//    if (self.isOrderDetail == YES) {
//        [super leftAction];
//        return;
//    }
    
    PayTypeEntity *entity = [self.payMentTypeArray objectAtIndex:_currentIndex];
    if (self.myEntity && self.myEntity.paycode &&[self.myEntity.paycode isEqualToString:entity.paycode]) {
        [super leftAction];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(sendFormMessage:Object:)]){
        [self.delegate sendFormMessage:InfoTypeZhiFu Object:entity];
    }
    self.delegate = nil;
    [super leftAction];
}

@end
