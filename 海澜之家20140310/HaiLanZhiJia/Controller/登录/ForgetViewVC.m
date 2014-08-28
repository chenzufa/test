//
//  ForgetViewVC.m
//  HaiLanZhiJia
//
//  Created by creaver on 13-11-22.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "ForgetViewVC.h"
#import "MySegMentControl.h"
#import "WCAlertView.h"
@interface ForgetViewVC (){
    UIView *_phoneFdView;
    UIView *_emialFdView;
    UITextField *_phoneFild;
    UITextField *_newPhoneFild;
    UITextField *_emailFild;
    
    UILabel *_phoneRule;
    UILabel *_emileRule;
    
    BOOL isPhone;
    BOOL isEmail;
}

@end

@implementation ForgetViewVC

- (void)dealloc
{
    SAFETY_RELEASE(_phoneFdView);
    SAFETY_RELEASE(_emialFdView);
    [_emileRule release];
    [_phoneRule release];
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
//button1_press@2x.png
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createMyButtonWithTitleAndImage];
    [self setMyRightButtonTitle:@"提交"];
    [self setMyRightButtonBackGroundImageView:@"button1.png" hightImage:@"button1_press.png"];
    MySegMentControl *segment = [[MySegMentControl alloc]initWithFrame:CGRectMake(0, [self getTitleBarHeight], 50, 35)];
    segment.segments = [NSArray arrayWithObjects:@"手机找回",@"邮箱找回", nil];
    [segment createSegments];
    segment.delegate = self;
    [self.view addSubview:segment];
    [self setTitleString:@"找回密码"];
    [self phoneFindView];
    isPhone = YES;
}
////type	Int	请求类型：1.邮箱找回规则 2.手机找回规则 3.配送方式规则
//GetRegulation
-(void)initRuleData:(int)rule
{
    DSRequest *requestObj = [[DSRequest alloc]init];
    requestObj.delegate = self;
    self.aRequest = requestObj;//ForgetPasswd
    [requestObj requestDataWithInterface:GetRegulation param:[self GetRegulationParam:rule] tag:1];
    [requestObj release];
}


-(void)myRightButtonAction:(UIButton *)button

{
    //请求接口一样。自动判断是手机还是邮箱
   if(isPhone)
   {
       if(_phoneFild.text==nil||[_phoneFild.text isEqualToString:@""])
       {
           [WCAlertView showAlertWithTitle:@"提示" message:@"手机号不能为空" customizationBlock:^(WCAlertView *alertView) {
               alertView.style = WCAlertViewStyleWhite;
               alertView.labelTextColor=[UIColor blackColor];
               alertView.buttonTextColor=[UIColor blueColor];
           } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
               nil;
           } cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
           return;
       }
       
       if(![self isValidateMobile:_phoneFild.text])
       {
           [WCAlertView showAlertWithTitle:@"提示" message:@"请输入正确的手机号码" customizationBlock:^(WCAlertView *alertView) {
               alertView.style = WCAlertViewStyleWhite;
               alertView.labelTextColor=[UIColor blackColor];
               alertView.buttonTextColor=[UIColor blueColor];
           } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
               nil;
           } cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
           return;
       }
       [self xiugaiMima];
 
   }
    if(isEmail)
    {
        if(_emailFild.text == nil || [_emailFild.text isEqualToString:@""] )
        {
            [WCAlertView showAlertWithTitle:@"提示" message:@"邮箱号不能为空" customizationBlock:^(WCAlertView *alertView) {
                alertView.style = WCAlertViewStyleWhite;
                alertView.labelTextColor=[UIColor blackColor];
                alertView.buttonTextColor=[UIColor blueColor];
            } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                nil;
            } cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
            return;
        }
        if(![self isValidateEmail:_emailFild.text])
        {
            [WCAlertView showAlertWithTitle:@"提示" message:@"请输入正确的邮箱地址" customizationBlock:^(WCAlertView *alertView) {
                alertView.style = WCAlertViewStyleWhite;
                alertView.labelTextColor=[UIColor blackColor];
                alertView.buttonTextColor=[UIColor blueColor];
            } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                nil;
            } cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
            return;
        }
        [self xiugaiMima];
    }

}

//修改密码
-(void)xiugaiMima
{
    NSLog(@"修改密码");
    [_emailFild resignFirstResponder];
    [_phoneFild resignFirstResponder];
    [_newPhoneFild resignFirstResponder];
    [self initData];
    [self addHud:@"正在发送"];
}


#pragma mark ----数据请求
-(void)initData
{
    DSRequest *requestObj = [[DSRequest alloc]init];
    requestObj.delegate = self;
    self.aRequest = requestObj;//ForgetPasswd
    NSString *phoneString = _phoneFild.text?_phoneFild.text:@"";
    NSString *emailString = _emailFild.text?_emailFild.text:@"";
    [requestObj requestDataWithInterface:ForgetPasswd param:[self ForgetPasswdParam:phoneString email:emailString] tag:0];
    [requestObj release];
    
}

#pragma mark ----数据请求OK
-(void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    [self hideHud:nil];
    switch (tag) {
        case 0:
        {
            StatusEntity* entity = (StatusEntity *)dataObj;
            if(isPhone)
            {
               if(entity.response ==1)
               {
                   [WCAlertView showAlertWithTitle:@"提示" message:@"短信已发送，请注意查收" customizationBlock:^(WCAlertView *alertView) {
                       alertView.style = WCAlertViewStyleWhite;
                       alertView.labelTextColor=[UIColor blackColor];
                       alertView.buttonTextColor=[UIColor blueColor];
                   } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                       nil;
                   } cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
               }
                if(entity.response == 2)
                {
                    NSString *message = entity.failmsg;
                    [WCAlertView showAlertWithTitle:@"提示" message:message customizationBlock:^(WCAlertView *alertView) {
                        alertView.style = WCAlertViewStyleWhite;
                        alertView.labelTextColor=[UIColor blackColor];
                        alertView.buttonTextColor=[UIColor blueColor];
                    } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                        nil;
                    } cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
                }
            }
            if(isEmail)
            {
                if(entity.response ==1)
                {
                    [WCAlertView showAlertWithTitle:@"提示" message:@"邮件已发送,请注意查收" customizationBlock:^(WCAlertView *alertView) {
                        alertView.style = WCAlertViewStyleWhite;
                        alertView.labelTextColor=[UIColor blackColor];
                        alertView.buttonTextColor=[UIColor blueColor];
                    } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                        nil;
                    } cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
                }
                if(entity.response == 2)
                {
                    NSString *message = entity.failmsg;
                    [WCAlertView showAlertWithTitle:@"提示" message:message customizationBlock:^(WCAlertView *alertView) {
                        alertView.style = WCAlertViewStyleWhite;
                        alertView.labelTextColor=[UIColor blackColor];
                        alertView.buttonTextColor=[UIColor blueColor];
                    } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                        nil;
                    } cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
                }
 
            }
           

        }
            break;
            
        case 1:
        {
            if(isPhone)
            {
                _phoneRule.text = (NSString *)dataObj;
                CGSize size = [_phoneRule.text sizeWithFont:SYSTEMFONT(10) constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:NSLineBreakByWordWrapping];
                _phoneRule.frame = CGRectMake(10, 60, 300, size.height);
            }
            else
            {
                _emileRule.text = (NSString *)dataObj;
                CGSize size = [_emileRule.text sizeWithFont:SYSTEMFONT(10) constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:NSLineBreakByWordWrapping];
                _emileRule.frame = CGRectMake(10, 60, 300, size.height);
            }
  
        }
        break;
        default:
            break;
    }
}
#pragma mark ----数据请求fail
-(void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError *)error
{
    NSLog(@"失败%@",error);
    [self hideHud:nil];
    [self addFadeLabel:error.domain];
}

#pragma mark -- 初始化ui
-(void)phoneFindView
{
   
    if(_phoneFdView == nil)
    {
         
       [self initRuleData:2];//手机找回规则
        _phoneFdView = [[UIView alloc]initWithFrame:CGRectMake(0, 35+TITLEHEIGHT,MainViewWidth, MainViewHeight-35-TITLEHEIGHT-20)];
        [self.view addSubview:_phoneFdView];
        int height = GETIMG(@"log in_input bg.png").size.height;
        int weight = GETIMG(@"log in_input bg.png").size.width;
        
        UIImageView *phoneImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, weight, height)];
        phoneImgView.userInteractionEnabled = YES;
        phoneImgView.image = GETIMG(@"log in_input bg.png");
        [_phoneFdView addSubview:phoneImgView];
        [phoneImgView release];
        

        UITextField * fild =[[UITextField alloc]initWithFrame:CGRectMake(5, 8, 300, 30)];
        fild.delegate = self;
        fild.keyboardType = UIKeyboardTypeNumberPad;
        fild.returnKeyType = UIReturnKeyDone;
        fild.tag = 10;
        [fild becomeFirstResponder];
       _phoneFild = fild;
        fild.placeholder = @"注册手机号码";
        fild.backgroundColor=[UIColor clearColor];
        fild.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        fild.clearButtonMode = UITextFieldViewModeWhileEditing;
        fild.delegate=self;
        fild.font=SYSTEMFONT(15);
        [phoneImgView addSubview:fild];
        [fild release];
        
        
        _phoneRule = [[UILabel alloc]initWithFrame:CGRectMake(10, 20+height+10, 300, 20)];
        _phoneRule.numberOfLines = 0;
        _phoneRule.font=SYSTEMFONT(10);
        _phoneRule.backgroundColor = [UIColor clearColor];
        _phoneRule.textColor= RGBCOLOR(60, 60, 60);
        [_phoneFdView addSubview:_phoneRule];
        
        
    }

}

-(void)emailFindView
{
  
   if(_emialFdView == nil)
   {
       [self initRuleData:1];//邮箱找回规则
       _emialFdView = [[UIView alloc]initWithFrame:CGRectMake(0, 35+TITLEHEIGHT,MainViewWidth, MainViewHeight-35-TITLEHEIGHT-20)];
       [self.view addSubview:_emialFdView];
       int height = GETIMG(@"log in_input bg.png").size.height;
       int weight = GETIMG(@"log in_input bg.png").size.width;
       UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, weight, height)];
       bgView.userInteractionEnabled = YES;
       bgView.image = GETIMG(@"log in_input bg.png");
       [_emialFdView addSubview:bgView];
       [bgView release];
       
       UITextField * fild =[[UITextField alloc]initWithFrame:CGRectMake(5, 8, 300, 30)];
       fild.delegate = self;
       fild.keyboardType = UIKeyboardTypeEmailAddress;
       fild.returnKeyType= UIReturnKeyDone;
       fild.placeholder = @"请输入你的邮箱";
       fild.tag = 13;
       _emailFild = fild;
       
       fild.backgroundColor=[UIColor clearColor];
       fild.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
       fild.clearButtonMode = UITextFieldViewModeWhileEditing;
       fild.delegate=self;
       fild.font=SYSTEMFONT(15);
       [bgView addSubview:fild];
       [fild release];
       
       _emileRule = [[UILabel alloc]initWithFrame:CGRectMake(10, 10+height+10, 300, 20)];
        _emileRule.font=SYSTEMFONT(10);
       _emileRule.numberOfLines = 0;
       _emileRule.backgroundColor = [UIColor clearColor];
       _emileRule.textColor = RGBCOLOR(60, 60, 60);
       [_emialFdView addSubview:_emileRule];

   }
    
}

- (void)segmentControl:(MySegMentControl *)setMentControl touchedAtIndex:(NSInteger)index
{
    switch (index) {
        case 0://手机
        {
            [_phoneFild becomeFirstResponder];
            [_emailFild resignFirstResponder];
             _emailFild.text = nil;
//            [_emailFild resignFirstResponder];
            isPhone = YES;
            isEmail = NO;
            _phoneFdView.hidden = NO;
            _emialFdView.hidden = YES;
        }
            break;
            
        case 1:
        {
           
            _phoneFild.text = nil;
//            [_phoneFild resignFirstResponder];
            isPhone = NO;
            isEmail = YES;
            [self emailFindView];
            [_emailFild becomeFirstResponder];
            [_phoneFild resignFirstResponder];
            _phoneFdView.hidden = YES;
            _emialFdView.hidden = NO;
        }
            break;
            
        default:
            break;
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *oneTouch = [touches anyObject];
    if(oneTouch.tapCount == 1)
    {
        [_emailFild resignFirstResponder];
        [_phoneFild resignFirstResponder];
    }
}

#pragma mark ---判断手机号是否合法
-(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

#pragma mark ---邮箱验证
-(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
