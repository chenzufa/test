//
//  DeliverVC.m
//  HaiLanZhiJia
//
//  Created by 蒋遂明 on 13-12-2.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "DeliverVC.h"

@interface DeliverVC ()

@property (nonatomic,retain)UIView *contentView;

@end

@implementation DeliverVC

@synthesize contentView;

-(void)dealloc
{
    self.contentView = nil;
    
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
    
    [self setTitleString:@"配运方式"];
    
	// Do any additional setup after loading the view.
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0.0, TITLEHEIGHT, MainViewWidth, MainViewHeight-TITLEHEIGHT)];
    self.contentView = myView;
    [self.view addSubview:myView];
    [myView release];
    
    [self createType];
    [self createTime];
    
    [self requestDeliverRule];
    
}

-(void)createType
{
    UILabel *aLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, MainViewWidth, 32)];
    [aLable setText:@"配运方式"];
    aLable.backgroundColor = [UIColor clearColor];
    aLable.textColor = TEXT_GRAY_COLOR;
    [aLable setFont:SYSTEMFONT(12)];
    [self.contentView addSubview:aLable];
    [aLable release];
    
    UIImage *aImg = GetImage(@"bg_list.png");
    UIButton *aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [aBtn setFrame:CGRectMake(10,32, aImg.size.width, aImg.size.height)];
    aBtn.tag = 0;
    [aBtn setBackgroundImage:aImg forState:UIControlStateNormal];
    [aBtn setBackgroundImage:GetImage(@"bg_list_press.png") forState:UIControlStateHighlighted];
//    [aBtn addTarget:self action:@selector(payBy:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:aBtn];
    UILabel *atLable = [[UILabel alloc]initWithFrame:CGRectMake(15,32, aImg.size.width, aImg.size.height)];
    [atLable setText:@"第三方快递"];
    atLable.userInteractionEnabled = NO;
    atLable.backgroundColor = [UIColor clearColor];
    atLable.textColor = TEXT_GRAY_COLOR;
    [atLable setFont:SYSTEMFONT(14)];
    [self.contentView addSubview:atLable];
    [atLable release];
    
    UIImage *checkImg = GetImage(@"icon_select.png");    //38
    UIImageView *checkImgView = [[UIImageView alloc] initWithFrame:CGRectMake(280,32+13, checkImg.size.width, checkImg.size.height)];
    checkImgView.image = checkImg;
    [self.contentView addSubview:checkImgView];
    [checkImgView release];
    
}

-(void)createTime
{
    UILabel *aLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 75, MainViewWidth, 32)];
    [aLable setText:@"送货时间"];
    aLable.backgroundColor = [UIColor clearColor];
    aLable.textColor = TEXT_GRAY_COLOR;
    [aLable setFont:SYSTEMFONT(12)];
    [self.contentView addSubview:aLable];
    [aLable release];
    
    UIImage *aImg = GetImage(@"bg_list2_up.png");
    NSArray *myArray = [NSArray arrayWithObjects:@"工作日、双休日与假日均送",@"只工作日送货（双休日、假日不用送）",@"只双休日、假日送货（工作日不用送）", nil];
    float beginY = 100.0;
    int number = [myArray count];
    for (int i =0; i< number; i++) {
        if (number==0) {
            NSLog(@"数据失败");
        }else if (number ==1){
            
        }else if (number >1)
        {
            
            UIButton *aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [aBtn setFrame:CGRectMake(10,beginY + aImg.size.height*i, aImg.size.width, aImg.size.height)];
            aBtn.tag = i;
            
            [aBtn addTarget:self action:@selector(deliverTime:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *atLable = [[UILabel alloc]initWithFrame:CGRectMake(15,beginY + aImg.size.height*i, aImg.size.width, aImg.size.height)];
            [atLable setText:[myArray objectAtIndex:i]];
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
    
    // 添加红勾
    int index = self.myEntity.deliverTime;
    if (index>=0 && index <3) {
        [self selectIndex:self.myEntity.deliverTime];
    }
    
}

- (void)createShengMing:(NSString *)strRule
{
//    CGSize size = [strRule sizeWithFont:SYSTEMFONT(14) constrainedToSize:CGSizeMake(300, MAXFLOAT)];
//    UILabel *atLable = [[UILabel alloc]initWithFrame:CGRectMake(15,100+44*3+20, size.width, size.height)];
//    atLable.numberOfLines = 999;
//    [atLable setText:strRule];
//    atLable.userInteractionEnabled = NO;
//    atLable.backgroundColor = [UIColor redColor];
//    atLable.textColor = ColorFontgray;
//    [atLable setFont:SYSTEMFONT(12)];
//    [self.contentView addSubview:atLable];
//    [atLable release];
    UITextView *textv = [[UITextView alloc]initWithFrame:CGRectMake(5, 100+44*3+5, 310, self.contentView.frame.size.height - (100+44*3+5) - 25)];
    [textv setFont:SetFontSize(FontSize12)];
    [textv setBackgroundColor:[UIColor clearColor]];
    [textv setTextColor:ColorFontgray];
//    [textv setUserInteractionEnabled:NO];
    [textv setEditable:NO];
    [self.contentView addSubview:textv];
    [textv setText:strRule];
    [textv release];
}

//配送协议
-(void)requestDeliverRule
{
    DSRequest *requestObj = [[DSRequest alloc]init];
    self.aRequest = requestObj;
    requestObj.delegate = self;
    [requestObj requestDataWithInterface:GetRegulation param:[self GetRegulationParam:3] tag:1];
    [requestObj release];
}

- (void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError *)error
{
    if (tag == 1) {
        
    }
}
- (void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    if (tag == 1) {
        if (dataObj && ![dataObj isKindOfClass:[NSNull class]] && ![dataObj isEqualToString:@""]) {
            [self createShengMing:dataObj];
        }
    }
}

-(void)deliverTime:(UIButton *)button
{
    int myTag = button.tag;
    [self selectIndex:myTag];
}

-(void)selectIndex:(int)index
{
    float imgHeight = GetImage(@"bg_list2_up.png").size.height;
    UIImageView *myImgV = (UIImageView *)[self.contentView viewWithTag:0x500];
    if (!myImgV) {
        UIImage *checkImg = GetImage(@"icon_select.png");    //38
        UIImageView *checkImgView = [[UIImageView alloc] initWithFrame:CGRectMake(280,100+13+imgHeight*index, checkImg.size.width, checkImg.size.height)];
        checkImgView.tag = 0x500;
        checkImgView.image = checkImg;
        myImgV = checkImgView;
        [self.contentView addSubview:checkImgView];
        [checkImgView release];
    }
    [myImgV setFrame:CGRectMake(280,100+13+imgHeight*index, myImgV.frame.size.width, myImgV.frame.size.height)];
    
    _currentIndex = index;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)leftAction
{
    if ([self.delegate respondsToSelector:@selector(sendFormMessage:Object:)]) {
        DeliverEntity *entity = [[DeliverEntity alloc]init];
        entity.deliverby = 1;
        entity.deliverTime = _currentIndex;
        [self.delegate sendFormMessage:InfoTypeDeliver Object:entity];
        [entity release];
    }

    self.delegate = nil;
    [super leftAction];
}

@end
