//
//  BeizhuVC.m
//  HaiLanZhiJia
//
//  Created by 蒋遂明 on 13-12-3.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "BeizhuVC.h"

@interface BeizhuVC ()

@end

@implementation BeizhuVC
@synthesize delegate;

-(void)dealloc
{
    self.delegate = nil;
    UITextView *bView = (UITextView *)[self.view viewWithTag:0x500];
    bView.delegate = nil;
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
    [self setTitleString:@"备注"];
    
    [self createMyButtonWithTitleAndImage];
    [self setMyRightButtonTitle:@"提交"];
    [self setMyRightButtonBackGroundImageView:@"button1.png" hightImage:@"button1_press.png"];
    
    [self createTextView];
	// Do any additional setup after loading the view.
}

-(void)createTextView
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0.0, TITLEHEIGHT, MainViewWidth, MainViewHeight-TITLEHEIGHT)];
    [button addTarget:self action:@selector(hideTextView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIEdgeInsets inset = UIEdgeInsetsMake(10, 10, 10, 10);
    UIImage *bgI = [UIImage imageNamed:@"car_bg_card.png"];
    
    UIImageView *bgV=[[UIImageView alloc]initWithFrame:CGRectMake(10, TITLEHEIGHT+10, 300, 160)];
    bgV.image=[bgI resizableImageWithCapInsets:inset];;
    [self.view addSubview:bgV];
    [bgV release];
    
    UITextView *inputView = [[UITextView alloc]initWithFrame:CGRectMake(10, TITLEHEIGHT+10, 300, 160)];
    inputView.tag = 0x500;
    inputView.returnKeyType = UIReturnKeyDone;
    inputView.font = SYSTEMFONT(12);
    inputView.delegate = self;
    inputView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:inputView];
    [inputView release];
    
    UILabel *aLable = [[UILabel alloc]initWithFrame:CGRectMake(18, TITLEHEIGHT+17, 280, 12)];
    aLable.tag = 0x501;
    aLable.hidden = YES;
    [aLable setText:@"提示：请勿填写有关支付、收货、发票方面的信息"];
    [aLable setTextColor:ColorFontgray];
    aLable.font = SYSTEMFONT(12);
    aLable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:aLable];
    [aLable release];
    
    UITextView *bView = (UITextView *)[self.view viewWithTag:0x500];
    [bView setText:self.strNote];
    [self textViewDidEndEditing:bView];
    
    UILabel *infoLable = [[UILabel alloc]initWithFrame:CGRectMake(10, TITLEHEIGHT+185, 300, 14)];
    infoLable.tag = 0x502;
    infoLable.hidden = NO;
    infoLable.textAlignment = NSTextAlignmentRight;
    if (self.strNote) {
        int length = [self.strNote length];
        NSString *myStr =[NSString stringWithFormat:@"已输入%d字，还可以输入%d字",length,100-length];
        [infoLable setText:myStr];
    }else{
        [infoLable setText:@"已输入0字，还可以输入100字"];
    }
    
    
    [infoLable setTextColor:TEXT_GRAY_COLOR];
    infoLable.font = SYSTEMFONT(12);
    infoLable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:infoLable];
    [infoLable release];
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    UIView *aView = [self.view viewWithTag:0x501];
    aView.hidden = YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    UITextView *bView = (UITextView *)[self.view viewWithTag:0x500];
    if (bView.text.length==0) {
        UIView *aView = [self.view viewWithTag:0x501];
        aView.hidden = NO;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    NSString *temp = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    int length= temp.length;
    NSString *string = [NSString stringWithFormat:@"已输入%d字，还可以输入%d字",length,100-length];
    
    UILabel *aView = (UILabel *)[self.view viewWithTag:0x502];
    aView.hidden = NO;
    aView.text = string;
    
    
    if(length>100)
    {
        textView.text = [temp substringToIndex:100];
        [WCAlertView showAlertWithTitle:@"提示" message:@"你输入字数超过100字" customizationBlock:^(WCAlertView *alertView) {
            alertView.style = WCAlertViewStyleWhite;
            alertView.labelTextColor=[UIColor blackColor];
            alertView.buttonTextColor=[UIColor blueColor];
        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            
        } cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        
        NSString *string = @"已输入100字，还可以输入0字";
        UILabel *aView = (UILabel *)[self.view viewWithTag:0x502];
        aView.hidden = NO;
        aView.text = string;
        
        return NO;
    }
    
    return YES;
}


-(void)hideTextView{
    UITextView *bView = (UITextView *)[self.view viewWithTag:0x500];
    [bView resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)leftAction
//{
//    UITextView *bView = (UITextView *)[self.view viewWithTag:0x500];
//    [self.delegate sendFormMessage:InfoTypeBeizhu Object:bView.text];
//    
//    self.delegate = nil;
//    [super leftAction];
//}

- (void)myRightButtonAction:(UIButton *)button
{
    UITextView *bView = (UITextView *)[self.view viewWithTag:0x500];
    [self.delegate sendFormMessage:InfoTypeBeizhu Object:bView.text];
    [self.view.window addHUDLabelView:@"备注修改成功" Image:nil afterDelay:1.5];
    
    self.delegate = nil;
    [self popViewController];
    
}

@end
