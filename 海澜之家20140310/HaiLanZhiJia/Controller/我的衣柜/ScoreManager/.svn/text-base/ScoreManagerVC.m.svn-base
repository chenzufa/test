//
//  ScoreManagerVC.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-26.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "ScoreManagerVC.h"
#import "ScoreRecordVC.h"
@interface ScoreManagerVC ()

@end

@implementation ScoreManagerVC
{
    UILabel *labScore;
    UILabel *lab2;
    UITextView *textViewContents;
}

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
    [labScore release];
    [lab2 release];
    [textViewContents release];
    
    self.requestOjb.delegate = self;
    self.requestOjb = nil;
    
    self.entiScoreInfo = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setTitleString:@"积分管理"];
    [self createMyButtonWithTitleAndImage];
    [self setMyRightButtonTitle:@"积分记录"];
    [self setMyRightButtonBackGroundImageView:@"button2.png" hightImage:@"button2_press.png"];
    
    [self.view setBackgroundColor:RGBCOLOR(247, 247, 247)];
    
    [self performSelector:@selector(afterDelay) withObject:nil afterDelay:RequestTime];
    [self initUI];
//    [self request];
}

- (void)afterDelay
{
    [self request];
}

- (void)myRightButtonAction:(UIButton *)button
{
    ScoreRecordVC *recordVC = [[ScoreRecordVC alloc]init];
    recordVC.recored = self.entiScoreInfo.recored;
    [self pushViewController:recordVC];
    [recordVC release];
}

- (void)request
{
    [textViewContents addHUDActivityView:Loading];  //提示 加载中
    
    DSRequest *request = [[DSRequest alloc]init];
    self.requestOjb = request;
    request.delegate = self;
    [request requestDataWithInterface:ScoreInfo param:[self ScoreInfoParam] tag:1];
    [request release];
}

#pragma mark DSRequestDelegate
- (void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    NSLog(@"请求成功!");
    
    self.entiScoreInfo = (ScoreInfoEntity *)dataObj;
    [self reloadAllViewsData];
    [textViewContents removeHUDActivityView];        //加载成功  停止转圈
}

- (void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError *)error
{
    NSLog(@"请求失败");
    [textViewContents removeHUDActivityView];        //加载失败  停止转圈并弹出提示框
    [textViewContents addHUDLabelView:error.domain Image:nil afterDelay:2];
}

- (void)initUI
{
    UIImageView *imgViewUpBack = [[UIImageView alloc]initWithImage:GetImage(@"user_bg_jifen.png")];
    [imgViewUpBack setFrame:CGRectMake(0, TITLEHEIGHT, imgViewUpBack.image.size.width, imgViewUpBack.image.size.height)];
    
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 17 + TITLEHEIGHT, 78, FontSize15)];
    [lab1 setFont:SetFontSize(FontSize15)];
    [lab1 setTextColor:ColorFontBlack];
    [lab1 setText:@"我的积分："];
    
    labScore = [[UILabel alloc]initWithFrame:CGRectMake(lab1.frame.origin.x + lab1.frame.size.width , lab1.frame.origin.y, 10, FontSize15)];
    [labScore setFont:lab1.font];
    [labScore setText:@"0"];
    [labScore setTextColor:ColorFontRed];
    
    
    lab2 = [[UILabel alloc]initWithFrame:CGRectMake(labScore.frame.origin.x + labScore.frame.size.width, lab1.frame.origin.y, 20, FontSize15)];
    [lab2 setFont:lab1.font];
    [lab2 setBackgroundColor:[UIColor clearColor]];
    [lab2 setTextColor:lab1.textColor];
    [lab2 setText:@"分"];
    
    UILabel *lab3 = [[UILabel alloc]initWithFrame:CGRectMake(lab1.frame.origin.x, imgViewUpBack.frame.origin.y + imgViewUpBack.frame.size.height + 10, 200, FontSize15)];
    [lab3 setFont:lab1.font];
    [lab3 setTextColor:RGBCOLOR(0, 50, 149)];
    [lab3 setBackgroundColor:[UIColor clearColor]];
    [lab3 setText:@"积分兑换抵用券规则："];
    
    textViewContents = [[UITextView alloc]initWithFrame:CGRectMake(0, lab3.frame.origin.y + lab3.frame.size.height, MainViewWidth, MainViewHeight - lab3.frame.origin.y - lab3.frame.size.height - 20)];
    [textViewContents setFont:SetFontSize(FontSize10)];
    [textViewContents setTextColor:ColorFontBlack];
    [textViewContents setBackgroundColor:[UIColor clearColor]];
    [textViewContents setEditable:NO];    
    
    [self.view addSubview:imgViewUpBack];
    [self.view addSubview:lab1];
    [self.view addSubview:labScore];
    [self.view addSubview:lab2];
    [self.view addSubview:lab3];
    [self.view addSubview:textViewContents];
    
    [imgViewUpBack release];
    [lab1 release];
    [lab3 release];
    
}

- (void)reloadAllViewsData      //  更新所有控件数据
{
    if (self.entiScoreInfo.totalscore.length > 0) {
        [labScore setText:self.entiScoreInfo.totalscore];
    }
    
    CGSize labelSize = [labScore.text sizeWithFont:labScore.font constrainedToSize:CGSizeMake(120, labScore.frame.size.height) lineBreakMode:NSLineBreakByCharWrapping];
    [labScore setFrame:CGRectMake(labScore.frame.origin.x, labScore.frame.origin.y, labelSize.width, labScore.frame.size.height)];
    [lab2 setFrame:CGRectMake(labScore.frame.origin.x + labScore.frame.size.width + 3, lab2.frame.origin.y, lab2.frame.size.width, lab2.frame.size.height)];
    
    [textViewContents setText:self.entiScoreInfo.rule];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
