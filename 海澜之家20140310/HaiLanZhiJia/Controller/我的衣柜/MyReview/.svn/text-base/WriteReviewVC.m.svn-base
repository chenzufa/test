//
//  WhiteReviewVC.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-28.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "WriteReviewVC.h"

@interface WriteReviewVC ()

@end

@implementation WriteReviewVC
{
    UILabel *labP;
    UITextView *textv;
    
    int compositescore;     //	综合评分
    int appearancescore;	//	外观评分
    int comfortscore;		//  舒适度评分
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
    [labP release];
    [textv release];
    self.requestOjb.delegate = nil;
    self.requestOjb = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setTitleString:@"发表评论"];
    [self createMyButtonWithTitleAndImage];
    [self setMyRightButtonTitle:@"发表"];
    [self setMyRightButtonBackGroundImageView:@"button1.png" hightImage:@"button1_press.png"];
    
    [self initUI];
    
}

- (void)myRightButtonAction:(UIButton *)button
{
    [self request];
}

- (void)initUI
{
    UIImageView *imgViewInput = [[UIImageView alloc]initWithImage:GetImage(@"bg_in put2.png")];
    [imgViewInput setFrame:CGRectMake(10, 54, imgViewInput.image.size.width, imgViewInput.image.size.height)];
    [self.view addSubview:imgViewInput];
    
    textv = [[UITextView alloc]initWithFrame:imgViewInput.frame];
    [textv setBackgroundColor:[UIColor clearColor]];
    [textv setFont:SetFontSize(FontSize15)];
    [textv setTextColor:ColorFontBlack];
    textv.delegate = self;
    [self.view addSubview:textv];
    
    //////////  给键盘添加按钮  点击收起键盘
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    [topView setBarStyle:UIBarStyleBlack];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
    [topView setItems:buttonsArray];
    [textv setInputAccessoryView:topView];
    
    ////  提示label 编辑时消失 
    labP = [[UILabel alloc]initWithFrame:CGRectMake(textv.frame.origin.x + 8, textv.frame.origin.y + 10, 150, FontSize15)];
    [labP setTextColor:RGBCOLOR(222, 222, 222)];
    [labP setFont:SetFontSize(FontSize15)];
    [labP setText:@"请填写评论内容"];
    [self.view addSubview:labP];
    
    UIImage *imgBtn;
    NSString *strTitle;
    for (int i = 0; i<3; i++) {
        switch (i) {
            case 0:
                imgBtn = GetImage(@"bg_list2_up.png");
                strTitle = @"综合";
                break;
            case 1:
                imgBtn = GetImage(@"bg_list2_middle.png");
                strTitle = @"外观";
                break;
            case 2:
                imgBtn = GetImage(@"bg_list2_down.png");
                strTitle = @"舒适度";
                break;
                
            default:
                strTitle = nil;
                break;
        }
        UIImageView *imageView = [[UIImageView alloc]initWithImage:imgBtn];
        [imageView setFrame:CGRectMake(10, 255 + imgBtn.size.height * i, imgBtn.size.width, imgBtn.size.height)];
        [self.view addSubview:imageView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.origin.x + 10, imageView.frame.origin.y + 15, 60, FontSize15)];
        [label setFont:SetFontSize(FontSize15)];
        [label setTextColor:ColorFontBlack];
        [label setText:strTitle];
        [self.view addSubview:label];
        
        ScoreImgViews *scoreView = [[ScoreImgViews alloc]initWithFrame:CGRectMake(75, 266 + imageView.frame.size.height * i, 150, 110)];
        [scoreView scoreImageViewWithScore:0];
        scoreView.delegate = self;
        scoreView.tag = i;
        [self.view addSubview:scoreView];
        
        if (i < 2) {
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y + imageView.frame.size.height - 1, imageView.frame.size.width, 1)];
            [lineView setBackgroundColor:[UIColor lightGrayColor]];
            [self.view addSubview:lineView];
            [lineView release];
        }
        
        [imageView release];
        [label release];
        [scoreView release];
    }
    
    
    
    [imgViewInput release];
    [topView release];
    [btnSpace release];
    [doneButton release];
}

- (void)request
{
    if (compositescore != 0 && appearancescore != 0 &&comfortscore != 0 && textv.text.length > 0) {
        [self.view addHUDActivityView:Loading];  //提示 加载中
        
        if (!self.requestOjb) {
            DSRequest *request = [[DSRequest alloc]init];
            self.requestOjb = request;
            request.delegate = self;
            [request release];
        }
        
        
        [self.requestOjb requestDataWithInterface:PublishComment param:[self PublishCommentParam:self.entiComment.goodsid ordernumber:self.entiComment.ordernumber sizeandcolor:self.entiComment.sizeandcolor ordergoodsid:self.entiComment.ordergoodsid compositescore:compositescore appearancescore:appearancescore comfortscore:comfortscore comment:textv.text] tag:1];
    }else {
        
        NSString *strRemind;
        if (textv.text.length == 0){
            strRemind = @"请填写评分内容";
        }else if (compositescore == 0) {
            strRemind = @"综合还没有评分哦";
        }else if (appearancescore == 0){
            strRemind = @"外观还没有评分哦";
        }else {
            strRemind = @"舒适度还没有评分哦";
        }
        
        WCAlertView *alert = [[WCAlertView alloc]initWithTitle:nil message:strRemind delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert setStyle:WCAlertViewStyleWhite];
        [alert show];
        [alert release];
    }
    
}

#pragma mark DSRequestDelegate
- (void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    NSLog(@"请求成功!");
    [self.view removeHUDActivityView];        //加载成功  停止转圈
    
    StatusEntity *entiSta = (StatusEntity *)dataObj;
    
    if (entiSta.response == 1) {
        [self.view.window addHUDLabelView:@"评论发表成功" Image:nil afterDelay:2];
        [self popViewController];
        
        if ([self.backDelegate respondsToSelector:@selector(writeReviewVCDisMissedandReloadData)]) {
            [self.backDelegate writeReviewVCDisMissedandReloadData];
        }

    }else {
        [self.view.window addHUDLabelView:@"操作失败" Image:nil afterDelay:2];
    }
    
    
}

- (void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError *)error
{
    NSLog(@"请求失败");
    [self.view removeHUDActivityView];        //加载失败  停止转圈并弹出提示框
    [self.view addHUDLabelView:error.domain Image:nil afterDelay:2];
}

#pragma mark ScoreImgViewsDelegate  
- (void)scoreImgViews:(ScoreImgViews *)scoreView clickedScore:(int)score
{
    NSLog(@"scoreView.tag = %i   score = %i",scoreView.tag,score); ///点击五角星进行打分
    switch (scoreView.tag) {
        case 0:
            compositescore = score;
            break;
        case 1:
            appearancescore = score;
            break;
        case 2:
            comfortscore = score;
            break;
            
        default:
            break;
    }
}

-(void)dismissKeyBoard      //收起键盘
{
    [textv resignFirstResponder];
}

#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [labP setHidden:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        [labP setHidden:NO];
    }
    [textView resignFirstResponder];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
