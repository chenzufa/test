//
//  SparateVC.m
//  HaiLanZhiJia
//
//  Created by creaver on 13-11-27.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "SparateVC.h"
#import "DSRequest.h"
@interface SparateVC ()<DSRequestDelegate>
{
       
    NSMutableArray *categayIdAry;//存放专题id的数组
    
    NSMutableArray *buttons;

    
    UIButton *firstBtn;
    
    NSMutableArray *flagAry;
    
    
    
}


@property(nonatomic,retain)NSMutableArray *categayAry;
@property(nonatomic,retain)NSMutableArray *selectCategay;
@property(nonatomic,retain)DSRequest *aRequest;

@end

@implementation SparateVC

- (void)dealloc
{
    //[titleAry release];
    [buttons release];
    [flagAry release];
    self.aRequest.delegate = nil;
    self.aRequest = nil;
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
    [self addHud:Loading];
    
    self.selectCategay = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectCategay"];
    
    
    flagAry = [[NSMutableArray alloc]initWithCapacity:0];

    [self initData];
        

    categayIdAry = [[NSMutableArray alloc]initWithCapacity:0];
    
    [self setTitleString:@"选择分类"];
    buttons = [[NSMutableArray alloc]initWithCapacity:0];
    
}

-(void)initData
{
    DSRequest *requestObj = [[DSRequest alloc]init];
    self.aRequest = requestObj;
    requestObj.delegate = self;
    [requestObj requestDataWithInterface:ShoppingMallCategory param:[self ShoppingMallCategoryParam] tag:0];
    [requestObj release];
}

-(void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError *)error
{
   [self addHud:error.domain];
}

-(void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    [self hideHud:nil];
    self.categayAry = (NSMutableArray *)dataObj;//所有分类列表
    //做标记，用户可能多选，也有可能选了后有不选了
    for(int i =0;i<self.categayAry.count;i++)
    {
        [flagAry addObject:@"0"];
    }
    [self initView];
}

-(void)initView
{
    
    UIButton *allButton= [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    allButton.tag = 0;
    allButton.frame = CGRectMake(25, TITLEHEIGHT+15, 70, 70);
    allButton.backgroundColor=[UIColor clearColor];
    allButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [allButton setBackgroundImage:GETIMG(@"search_colour_button_bg.png") forState:UIControlStateNormal];
    [allButton setBackgroundImage:GETIMG(@"search_colour_button_bg_sel.png") forState:UIControlStateSelected];
    [allButton setTitle:@"全部" forState:UIControlStateNormal];
    firstBtn = [allButton retain];
    [allButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [allButton addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:allButton];
    int max =0;
    
   for (int i=0; i<self.categayAry.count; i++)
    {
        MallCategoryEntity* entity = [self.categayAry objectAtIndex:i];

        UIButton *iconButton= [UIButton buttonWithType:UIButtonTypeCustom];
       
        iconButton.tag = i+1;
        iconButton.frame = CGRectMake(25+(70+30)*((i+1)%3), TITLEHEIGHT+15+(i+1)/3*(70+20), 70, 70);
        iconButton.backgroundColor=[UIColor clearColor];
        [iconButton setBackgroundImage:GETIMG(@"search_colour_button_bg.png") forState:UIControlStateNormal];
        [iconButton setBackgroundImage:GETIMG(@"search_colour_button_bg_sel.png") forState:UIControlStateSelected];
        iconButton.titleLabel.font = [UIFont systemFontOfSize:15];
        if(entity.categoryname.length>4)
        {
            iconButton.titleLabel.numberOfLines = 2;
        }
        [iconButton setTitle:entity.categoryname forState:UIControlStateNormal];
        
        [self.view addSubview:iconButton];
        
        [iconButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [buttons addObject:iconButton];
        [iconButton addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchUpInside];
        max = i;
        
    }
     NSLog(@"%d",max);
    /*
     得到最后一个按钮，确定键的位置
     */
    UIButton *lastBtn =[buttons objectAtIndex:max];
    int flag=0;
    if(self.selectCategay.count>0)
    {
        for (int i=0; i<self.categayAry.count; i++)
        {
            NSString *string = [self.selectCategay objectAtIndex:i];
            if([string isEqualToString:@"1"])
            {
                flag++;
                UIButton *selectButton = (UIButton *)[buttons objectAtIndex:i];
                selectButton.selected = YES;
                
            }
        }
 
    }
    if(flag == self.categayAry.count)
    {
        allButton.selected = YES;
    }
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *btnImage = GETIMG(@"search_colour_button_confirm.png");
    [confirmBtn addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.tag = 100;
    confirmBtn.frame = CGRectMake(204/2, lastBtn.frame.origin.y+70+50, btnImage.size.width, btnImage.size.height);
//    confirmBtn.frame = CGRectMake(204/2, (max/3+2)*70+(max/3+2)*20+TITLEHEIGHT, btnImage.size.width, btnImage.size.height);
    [confirmBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    [confirmBtn setBackgroundImage:GETIMG(@"search_colour_button_confirm_press.png") forState:UIControlStateHighlighted];
    [self.view addSubview:confirmBtn];

}

-(void)pressButton:(UIButton *)btn

{
    if(btn.tag == 0)//全部
    {
        btn.selected = !btn.selected;
        if(btn.selected)
        {
            btn.selected = YES;
            for (UIButton *button in buttons)
            {
                button.selected = YES;
            }
            for (int i=0; i<self.categayAry.count; i++) {
                [flagAry replaceObjectAtIndex:i withObject:@"1"];
            }
        }
        else{
            btn.selected = NO;
            for (int i=0; i<self.categayAry.count; i++) {
                [flagAry replaceObjectAtIndex:i withObject:@"0"];
            }
            for (UIButton *btn in buttons) {
                btn.selected = NO;
            }
        }
    }
   else if(btn.tag ==100)//确定
    {
        for (int k=0; k<buttons.count; k++)
        {
            UIButton *oneBtn =(UIButton *)[buttons objectAtIndex:k];
            if(oneBtn.selected)
            {
                [flagAry replaceObjectAtIndex:k withObject:@"1"];
            }
        }

        int flag =0;
        for (NSString *string in flagAry)
        {
            
            if([string isEqualToString:@"0"])
            {
                flag++;
            }
        }
        if(flag == self.categayAry.count)
        {
            [WCAlertView showAlertWithTitle:@"提示" message:@"亲，这么多总会有你喜欢的!" customizationBlock:^(WCAlertView *alertView) {
                alertView.style = WCAlertViewStyleWhite;
                alertView.labelTextColor=[UIColor blackColor];
                alertView.buttonTextColor=[UIColor blueColor];
            } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                nil;
            } cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
            return;
        }
        for (int i =0; i<self.categayAry.count; i++) {
            NSString *flagStr = [flagAry objectAtIndex:i];
            if([flagStr isEqualToString:@"1"])
            {
                MallCategoryEntity* entity = [self.categayAry objectAtIndex:i];
                [categayIdAry addObject:entity.categoryid];//存放专题id的数组
            }
        }
        
        NSDictionary *idDic = [NSDictionary dictionaryWithObject:categayIdAry forKey:@"categayId"];
    
       [[NSNotificationCenter defaultCenter]postNotificationName:@"idName" object:nil userInfo:idDic];
        NSLog(@"!!!!%@",flagAry);
        [[NSUserDefaults standardUserDefaults] setObject:flagAry forKey:@"selectCategay"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"!!!!!%@",categayIdAry);
        [self popViewController];
    }
    
    else//分类按钮
    {
        btn.selected = !btn.selected;
        if(btn.selected)
        {
            btn.selected = YES;
            [flagAry replaceObjectAtIndex:btn.tag-1 withObject:@"1"];
            
        }
        else{
            [flagAry replaceObjectAtIndex:btn.tag-1 withObject:@"0"];
            btn.selected = NO;
            firstBtn.selected = NO;
        }
        int allflag=0;
        //是否选择全部按钮
        for (UIButton *button in buttons)
        {
           if(button.selected)
           {
               allflag++;
           }
            if(allflag==buttons.count)
            {
                firstBtn.selected = YES;
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
