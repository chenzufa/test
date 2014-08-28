//
//  GetInforVC.m
//  HaiLanZhiJia
//
//  Created by creaver on 13-11-28.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "GetInforVC.h"
#import "WCAlertView.h"
#import "DSRequest.h"
@interface GetInforVC ()<UITextViewDelegate,DSRequestDelegate>
{
    UITextView *myTextView;
    UILabel *morenLabel;
    UILabel *manyLabale;
}

@property(nonatomic,retain)DSRequest *aRequest;
@end

@implementation GetInforVC


- (void)dealloc
{
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
    [self setTitleString:@"意见反馈"];
    [self createMyButtonWithTitleAndImage];
    [self setMyRightButtonTitle:@"提交"];
    [self setMyRightButtonBackGroundImageView:@"button1.png" hightImage:@"button1_press.png"];
    [self initView];
    
	// Do any additional setup after loading the view.
}



-(void)initView
{
    UIEdgeInsets insert = UIEdgeInsetsMake(10, 10, 10, 10);
    UIImage *bgImg = GETIMG(@"bg_list.png");
    bgImg = [bgImg resizableImageWithCapInsets:insert];
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, TITLEHEIGHT+10, MainViewWidth-20, 170)];
    bgView.image = bgImg;
    bgView.userInteractionEnabled = YES;
    [self.view addSubview:bgView];
    [bgView release];
    
    myTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, MainViewWidth-20, 170)];
    myTextView.backgroundColor = [UIColor clearColor];
    myTextView.returnKeyType =UIReturnKeyDone;
    myTextView.font = SYSTEMFONT(15);
    myTextView.delegate = self;
    [bgView addSubview:myTextView];
    
    morenLabel =[[UILabel alloc]initWithFrame:CGRectMake(5, 8, 150, 20)];
    morenLabel.font = SYSTEMFONT(15);
    morenLabel.textColor = RGBCOLOR(214, 214, 214);
    morenLabel.backgroundColor = [UIColor clearColor];
    morenLabel.text = @"请写下你宝贵的意见";
    [myTextView addSubview:morenLabel];
    
    manyLabale = [[UILabel alloc]initWithFrame:CGRectMake(250, 240, 80, 20)];
    manyLabale.backgroundColor = [UIColor clearColor];
    manyLabale.font = SYSTEMFONT(15);
    manyLabale.text = @"0/100";
    [self.view addSubview:manyLabale];

}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    morenLabel.hidden = YES;
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    morenLabel.hidden = YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    NSString *temp = [textView.text stringByReplacingCharactersInRange:range withString:text];
    int length= temp.length;
    NSString *string = [NSString stringWithFormat:@"%d/100",length];
    manyLabale.text = string;
    if(length>100)
    {
        textView.text = [temp substringToIndex:100];
        [WCAlertView showAlertWithTitle:@"提示" message:@"你输入字数超过100字" customizationBlock:^(WCAlertView *alertView) {
            alertView.style = WCAlertViewStyleWhite;
            alertView.labelTextColor=[UIColor blackColor];
            alertView.buttonTextColor=[UIColor blueColor];
            [textView resignFirstResponder];
        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            
        } cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        NSString *string = @"100/100";
        manyLabale.text = string;
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if([textView.text isEqualToString: @""]|| textView.text == nil)
    {
        morenLabel.hidden = NO;
    }
    else
    {
        morenLabel.hidden = YES;;
    }
}

-(void)myRightButtonAction:(UIButton *)button
{
    if([myTextView.text isEqualToString:@"" ]||myTextView.text == nil)
    {
        [WCAlertView showAlertWithTitle:@"提示" message:@"请写下你宝贵的意见吧!" customizationBlock:^(WCAlertView *alertView) {
            alertView.style = WCAlertViewStyleWhite;
            alertView.labelTextColor=[UIColor blackColor];
            alertView.buttonTextColor=[UIColor blueColor];
        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            
        } cancelButtonTitle:nil otherButtonTitles:@"确认", nil];

    }
    else
    {
        [myTextView resignFirstResponder];
        [self initDate];
    }
}

-(void)initDate
{
    DSRequest *requestObj = [[DSRequest alloc]init];
    [self addHud:@"正在提交"];
    self.aRequest = requestObj;
    requestObj.delegate = self;
    [requestObj requestDataWithInterface:CustomerFeedback param:[self CustomerFeedbackParam:myTextView.text] tag:0];
    [requestObj release];
}

-(void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError *)error
{
    [self hideHud:nil];
    [self addFadeLabel:error.domain];
}

-(void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    [self hideHud:nil];
    StatusEntity* entity =  (StatusEntity *)dataObj;
    
    if(entity.response == 1)
    {
        [WCAlertView showAlertWithTitle:@"提示" message:@"反馈成功，谢谢!" customizationBlock:^(WCAlertView *alertView) {
            alertView.style = WCAlertViewStyleWhite;
            alertView.labelTextColor=[UIColor blackColor];
            alertView.buttonTextColor=[UIColor blueColor];
        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            
        } cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
    }
    else
    {
        [WCAlertView showAlertWithTitle:@"提示" message:@"反馈失败!" customizationBlock:^(WCAlertView *alertView) {
            alertView.style = WCAlertViewStyleWhite;
            alertView.labelTextColor=[UIColor blackColor];
            alertView.buttonTextColor=[UIColor blueColor];
        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            
        } cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
    }
}

//字数统计
-(int)countWord:(NSString*)s
{
    int i,n=[s length],l=0,a=0,b=0;
    unichar c;
    for(i=0;i<n;i++){
        c=[s characterAtIndex:i];
        if(isblank(c)){
            b++;
        }else if(isascii(c)){
            a++;
        }else{
            l++;
        }
    }
    if(a==0 && l==0) return 0;
    return l+(int)ceilf((float)(a+b)/2.0);
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *oneTouch = [touches anyObject];
    if(oneTouch.tapCount == 1)
    {
        [myTextView resignFirstResponder];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
