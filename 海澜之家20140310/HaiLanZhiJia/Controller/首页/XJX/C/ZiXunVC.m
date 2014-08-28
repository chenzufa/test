//
//  ZiXunVC.m
//  HaiLanZhiJia
//
//  Created by xiaojiaxi on 13-11-26.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "ZiXunVC.h"
#import "UIViewController+Hud.h"
#define kZiXunBtnTag 0x1111

@interface ZiXunVC ()<UITextViewDelegate>
@property(nonatomic,retain)UITextView *signView;//咨询textview
@property (nonatomic, retain)UIScrollView *scrollView;
@property (nonatomic, retain)UILabel *placeHolderlabel;

@end

@implementation ZiXunVC
-(void)dealloc
{
    [_signView release];_signView=nil;
    [_spId release]; _spId=nil;
    [_scrollView release];_scrollView=nil;
    [_placeHolderlabel release];_placeHolderlabel = nil;
    [super dealloc];
}
-(void)leftAction
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super leftAction];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initSubview];
}

#pragma mark - DSRequestDelegate
-(void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    [self hideHud:nil];
    StatusEntity *entity = (StatusEntity*)dataObj;
    int a = entity.response;
    if (a==1)//success
    {
        [self addFadeLabel:@"咨询提交成功"];
        [self performSelector:@selector(popSelf) withObject:nil afterDelay:1];
    }else
    {
        [self addFadeLabel:@"咨询提交失败,请重试"];
    }
}
-(void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError*)error
{
    [self hideHud:nil];
    [self addFadeLabel:@"咨询提交失败,请重试"];
}
-(void)popSelf
{
    NSString *content = _signView.text;
    content = [content stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@" " withString:@""];
    //过滤字符串前后的空格
    NSString *contentStr =[content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kZiXunSuccessNotification object:contentStr];
    [self leftAction];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)initSubview
{
    self.view.backgroundColor =RGBCOLOR(242, 242, 242);
    
    [self setTitleString:@"售前咨询"];
    
    UIImage *rightImage=[UIImage imageNamed:@"button1@2x.png"];
    CGFloat x = 250;
    CGFloat y = [self getTitleBarHeight]/2.0-rightImage.size.height/4.0;
    CGFloat w = rightImage.size.width/1.5;
    CGFloat h = rightImage.size.height/2.0;
    UIButton *ziXunBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ziXunBtn.tag = kZiXunBtnTag;
    ziXunBtn.frame = CGRectMake(x,y,w,h);
    [ziXunBtn setBackgroundImage:GETIMG(@"button1_press@2x.png") forState:UIControlStateHighlighted];
    [ziXunBtn setBackgroundImage:GETIMG(@"button1@2x.png") forState:UIControlStateNormal];
    [ziXunBtn setTitle:@"提交" forState:UIControlStateNormal];
    [ziXunBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleBar addSubview:ziXunBtn];
    
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0,[self getTitleBarHeight],MainViewWidth, MainViewHeight-[self getTitleBarHeight])];
    scroll.backgroundColor = [UIColor clearColor];
    scroll.contentSize = CGSizeMake(MainViewWidth,MainViewHeight);
    scroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scroll];
    self.scrollView = scroll;
    [scroll release];
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [self.scrollView addGestureRecognizer:singleRecognizer];
    [singleRecognizer release];
    //
    x=10;
    y=15;
    w=300;
    h=180;
    UIEdgeInsets inset = UIEdgeInsetsMake(10, 10, 10, 10);
    UIImage *bgI = [UIImage imageNamed:@"car_bg_card@2x.png"];
    
    UIImageView *bgV=[[UIImageView alloc]initWithFrame:CGRectMake(x,y,w,h)];
    bgV.image=[bgI resizableImageWithCapInsets:inset];;
    [self.scrollView addSubview:bgV];
    [bgV release];
    
    UILabel *placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(x+5, y+10, 290, 15)];
    placeHolderLabel.text = @"请输入咨询内容(100字以内)";
    placeHolderLabel.textColor = RGBCOLOR(209, 209, 209);
    [self.scrollView addSubview:placeHolderLabel];
    self.placeHolderlabel = placeHolderLabel;
    [placeHolderLabel release];
    
    UITextView *contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(x,y,w,h)];
    [contentTextView setTextColor:RGBCOLOR(60, 60, 60)];
    contentTextView.delegate = self;
    [contentTextView setBackgroundColor:[UIColor clearColor]];
    [contentTextView setFont:[UIFont systemFontOfSize:15]];
    contentTextView.scrollEnabled = YES;
    [self.scrollView addSubview:contentTextView];
    self.signView = contentTextView;
    contentTextView.returnKeyType= UIReturnKeyDone;
    [contentTextView release];
    
    float offsetY = bgV.frame.origin.y + bgV.frame.size.height + 5;
    UILabel* numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, offsetY, 300, 20)];
    numberLabel.backgroundColor = [UIColor clearColor];
    numberLabel.textAlignment = NSTextAlignmentRight;
    numberLabel.tag = 600;
    numberLabel.textColor = RGBCOLOR(209, 209, 209);
    numberLabel.text=@"0/100";
    [self.scrollView addSubview:numberLabel];
    [numberLabel release];
    
}
#pragma mark -- textViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.placeHolderlabel.hidden = YES;
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length==0) {
        self.placeHolderlabel.hidden = NO;
    }
    if (textView.text.length>100)
    {
        UILabel* label = (UILabel*)[self.scrollView viewWithTag:600];
        label.text = @"100/100";

    }else
    {
        UILabel* label = (UILabel*)[self.scrollView viewWithTag:600];
        label.text = [NSString stringWithFormat:@"%i/100",textView.text.length];
    }
}
- (void)textViewDidChange:(UITextView *)textView
{
    UILabel* label = (UILabel*)[self.scrollView viewWithTag:600];
    label.text = [NSString stringWithFormat:@"%i/100",textView.text.length];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
     //点击return键隐藏键盘
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    NSString *temp = [textView.text stringByReplacingCharactersInRange:range withString:text];
    int length= temp.length;
    NSString *string = [NSString stringWithFormat:@"%d/100",length];
    UILabel* label = (UILabel*)[self.scrollView viewWithTag:600];
    label.text = string;
    if(length>100)
    {
        textView.text = [temp substringToIndex:100];
        NSString *string = @"100/100";
        label.text = string;
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark -- UITapGestureRecognizer
-(void)handleSingleTap:(UITapGestureRecognizer*)tapGesture
{
    [self.view endEditing:YES];
    CGPoint location=[tapGesture locationInView:tapGesture.view];
    UIView *hitView=[tapGesture.view hitTest:location withEvent:nil];
    if ([hitView isKindOfClass:[UIButton class]])
    {
        return;
    }
}
#pragma mark -- btnClicked
-(void)buttonClicked:(UIButton*)btn
{
    [self.signView resignFirstResponder];

    if (_signView.text.length==0||[self isBlankString:_signView.text])
    {
        [self addFadeLabel:@"请输入您的问题"];
        return;
    }
    
    [self addHud:@"正在提交"];
    DSRequest *request = [[DSRequest alloc]init];
    request.delegate = self;
    NSString *content = _signView.text;
    content = [content stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"   " withString:@""];
    //过滤字符串前后的空格
    NSString *contentStr =[content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    [request requestDataWithInterface:ConsultCommit param:[self ConsultCommitParam:_spId question:contentStr] tag:1];
    [request release];
}
/*
 *判断字符串为空和只为空格解决办法
 */
-(BOOL)isBlankString:(NSString *)string
{
    if (string == nil)
    {
        return YES;
    }
    if (string == NULL)
    {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0)
    {
        return YES;
    }
    return NO;
}
@end
