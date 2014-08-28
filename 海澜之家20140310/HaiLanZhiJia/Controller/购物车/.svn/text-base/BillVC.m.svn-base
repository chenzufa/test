//
//  BillVC.m
//  HaiLanZhiJia
//
//  Created by 蒋遂明 on 13-12-2.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#define BILL_TAG 0x500
#define HIDE_TAG 0x600
#import "BillVC.h"

@interface BillVC ()

@property (nonatomic,retain)UIView *contentView;


@end

@implementation BillVC

@synthesize contentView;
@synthesize delegate;

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
    [self setTitleString:@"发票信息"];
	// Do any additional setup after loading the view.
    
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0.0, TITLEHEIGHT, MainViewWidth, MainViewHeight-TITLEHEIGHT)];
    self.contentView = myView;
    [self.view addSubview:myView];
    [myView release];
    
    UIButton *tapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tapBtn setFrame:CGRectMake(0.0, TITLEHEIGHT, MainViewWidth, MainViewHeight-TITLEHEIGHT)];
    [tapBtn addTarget:self action:@selector(cancelText) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:tapBtn];
    [self.contentView sendSubviewToBack:tapBtn];
    
    
    [self createTitle];
    [self createContent];
    
    if (self.myEntity.isNeed) {
        [self selectIndex:0];
    }else{
        [self selectIndex:1];
    }
    
}

-(void)cancelText
{
    UITextField *titleText = (UITextField *)[self.contentView viewWithTag:(BILL_TAG +1)];
    [titleText resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)createTitle
{
    UILabel *aLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, MainViewWidth, 32)];
    [aLable setText:@"是否需要发票"];
    aLable.backgroundColor = [UIColor clearColor];
    aLable.textColor = TEXT_GRAY_COLOR;
    [aLable setFont:SYSTEMFONT(12)];
    [self.contentView addSubview:aLable];
    [aLable release];
    
    
    UIImage *aImg = GetImage(@"bg_list.png");
    NSArray *myArray = [NSArray arrayWithObjects:@"",@"", nil];
    float beginY = 25.0;
    int number = [myArray count];
    for (int i =0; i< number; i++) {
        if (number==0) {
            NSLog(@"数据失败");
        }else if (number ==1){
            
        }else if (number >1)
        {
            
            UIButton *aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [aBtn setFrame:CGRectMake(10,beginY + aImg.size.height*i, aImg.size.width, aImg.size.height)];
            aBtn.tag = HIDE_TAG +i;
//            aBtn.tag = i;
            
//            [aBtn addTarget:self action:@selector(deliverTime:) forControlEvents:UIControlEventTouchUpInside];
            
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
            
            if ( i==0) {
                
                for (int index =0; index<2; index++) {
                    UILabel *aLable = [[UILabel alloc]initWithFrame:CGRectMake(20+110*index, beginY, 35, 44)];
                    
                    aLable.backgroundColor = [UIColor clearColor];
                    aLable.textColor = TEXT_GRAY_COLOR;
                    [aLable setFont:SYSTEMFONT(14)];
                    
                    // 按钮
                    UIButton *aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [aBtn setFrame:CGRectMake(58+105*index,beginY+13, 22, 22)];
                    [aBtn setBackgroundImage:GetImage(@"car_button_gou@2x.png") forState:UIControlStateNormal];
                    aBtn.tag = index+0x400;
                    [aBtn addTarget:self action:@selector(slectBillType:) forControlEvents:UIControlEventTouchUpInside];
                    [aBtn setBackgroundImage:GetImage(@"car_button_gou_sel@2x.png") forState:UIControlStateSelected];
                    
                    if (index==0) {
                        [aLable setText:@"是"];
                    }else{
                        [aLable setText:@"否"];
                    }
                    [self.contentView addSubview:aLable];
                    [aLable release];
                    [self.contentView addSubview:aBtn];
                }
                
            }else if (i==1)
            {
                UITextField *titleText = nil;
                if (isBigeriOS7version) {
                    titleText= [[UITextField alloc]initWithFrame:CGRectMake(20,beginY + aImg.size.height*i, 280, 44)];
                }else{
                    titleText= [[UITextField alloc]initWithFrame:CGRectMake(20,14+beginY + aImg.size.height*i, 280, 44)];
                }
                
                titleText.delegate = self;
                titleText.returnKeyType = UIReturnKeyDone;
                titleText.tag = BILL_TAG +1;
                [titleText setPlaceholder:@"点击填写发票抬头"];
                
                // 设置发票信息
                if (self.myEntity.strContent && [self.myEntity.strContent length]>0) {
                    [titleText setText:self.myEntity.strContent];
                }
                
                [titleText setFont:SYSTEMFONT(12)];
                [self.contentView addSubview:titleText];
                [titleText release];
            }
            
        }
        
    }
    for (int i = 0; i<number -1; i++) {
        if (i!=number-1) {
            UIImage *lineImg = GetImage(@"division line.png");
            UIImageView *lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(11,beginY+(i+1)*aImg.size.height - 0.2, aImg.size.width - 2, 1)];
            lineImgView.image = lineImg;
            [self.contentView addSubview:lineImgView];
            [lineImgView release];
        }
    }
    
    
}



-(void)slectBillType:(UIButton *)button
{
    [self selectIndex:(button.tag - 0x400)];
    
}

-(void)selectIndex:(int)index
{
    int anotherIndex = 0;
    
    UITextField *titleText = (UITextField *)[self.contentView viewWithTag:(BILL_TAG +1)];
    [titleText resignFirstResponder];
    
    UIButton *textBg1 = (UIButton *)[self.contentView viewWithTag:HIDE_TAG +0];
    UIView *textBg2 = [self.contentView viewWithTag:HIDE_TAG +1];
    
    
    UIView *fuzhaung1 = [self.contentView viewWithTag:HIDE_TAG +10];
    UIView *fuzhaung2 = [self.contentView viewWithTag:HIDE_TAG +11];
    UIView *fuzhaung3 = [self.contentView viewWithTag:HIDE_TAG +12];
    UIView *fuzhaung4 = [self.contentView viewWithTag:HIDE_TAG +13];
    
    if (index ==0) {
        //显示发票填写视图
        anotherIndex = 1;
        
        [textBg1 setBackgroundImage:GetImage(@"bg_list2_up.png") forState:UIControlStateNormal];
        [textBg1 setBackgroundImage:GetImage(@"bg_list2_up_press.png") forState:UIControlStateHighlighted];
        
        titleText.hidden = NO;
        textBg2.hidden = NO;
        fuzhaung1.hidden = NO;
        fuzhaung2.hidden = NO;
        fuzhaung3.hidden = NO;
        fuzhaung4.hidden = NO;
    }else{
        //隐藏发票填写视图
        anotherIndex = 0;
        
        [textBg1 setBackgroundImage:GetImage(@"bg_list.png") forState:UIControlStateNormal];
        [textBg1 setBackgroundImage:GetImage(@"bg_list_press.png") forState:UIControlStateHighlighted];
        
        titleText.hidden = YES;
        textBg2.hidden = YES;
        fuzhaung1.hidden = YES;
        fuzhaung2.hidden = YES;
        fuzhaung3.hidden = YES;
        fuzhaung4.hidden = YES;
    }
    
    
    
    
    
    UIButton *aBtn = (UIButton *)[self.contentView viewWithTag:0x400+index];
    aBtn.selected = YES;
    
    UIButton *anotherBtn = (UIButton *)[self.contentView viewWithTag:0x400+anotherIndex];
    anotherBtn.selected = NO;
    
    _currentIndex = index;
}



-(void)createContent
{
    UILabel *aLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 120, MainViewWidth, 32)];
    aLable.tag = HIDE_TAG +10;
    [aLable setText:@"发票内容"];
    aLable.backgroundColor = [UIColor clearColor];
    aLable.textColor = TEXT_GRAY_COLOR;
    [aLable setFont:SYSTEMFONT(12)];
    [self.contentView addSubview:aLable];
    [aLable release];

    UIImage *aImg = GetImage(@"bg_list.png");
    UIButton *aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    aBtn.tag = HIDE_TAG +11;
    [aBtn setFrame:CGRectMake(10,120+32, aImg.size.width, aImg.size.height)];
    [aBtn setBackgroundImage:aImg forState:UIControlStateNormal];
    [aBtn setBackgroundImage:GetImage(@"bg_list_press.png") forState:UIControlStateHighlighted];
    //    [aBtn addTarget:self action:@selector(payBy:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:aBtn];
    UILabel *atLable = [[UILabel alloc]initWithFrame:CGRectMake(15,120+32, aImg.size.width, aImg.size.height)];
    atLable.tag = HIDE_TAG +12;
    [atLable setText:@"服装"];
    atLable.userInteractionEnabled = NO;
    atLable.backgroundColor = [UIColor clearColor];
    atLable.textColor = TEXT_GRAY_COLOR;
    [atLable setFont:SYSTEMFONT(14)];
    [self.contentView addSubview:atLable];
    [atLable release];
    
    UIImage *checkImg = GetImage(@"icon_select.png");    //38
    UIImageView *checkImgView = [[UIImageView alloc] initWithFrame:CGRectMake(280,120+32+13, checkImg.size.width, checkImg.size.height)];
    checkImgView.tag = HIDE_TAG +13;
    checkImgView.image = checkImg;
    [self.contentView addSubview:checkImgView];
    [checkImgView release];
}

-(void)leftAction
{
    InvoceEntity *entity = [[[InvoceEntity alloc]init]autorelease];
    if (_currentIndex ==0) {
        entity.isNeed = YES;
    }else{
        entity.isNeed = NO;
    }
    
    entity.strTitle = @"服装";
    UITextField *titleText = (UITextField *)[self.contentView viewWithTag:(BILL_TAG +1)];
    if (titleText.text.length > 0) {
        entity.strContent = titleText.text;
    }else entity.strContent = @"";
    
    
    [self.delegate sendFormMessage:InfoTypeFaPiao Object:entity];
    
    self.delegate = nil;
    [super leftAction];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
