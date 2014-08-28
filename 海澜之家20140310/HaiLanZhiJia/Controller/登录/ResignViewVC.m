//
//  ResignViewVC.m
//  HaiLanZhiJia
//
//  Created by creaver on 13-11-21.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "ResignViewVC.h"
#import "UIViewController+Hud.h"
@interface ResignViewVC (){
    UIView *_phoneView;
    UIView *_emailView;
    //手机注册的fild
    UITextField *_phoneFild;
    UITextField *_pwdFild;
    UITextField *_emailFildPh;
     //邮箱注册的fild
    UITextField *_emailFildEm;
    UITextField *_pwdFildEm;
    //手机注册的按钮状态
    BOOL isSharePwd;
    BOOL isAgree;//同意
     //邮箱注册的按钮状态
    BOOL isagreeEm;
    BOOL isShareEm;
    UIView *_confirmView;
    BOOL isPhoneRe; //是手机注册
    BOOL isEmailRe; //是邮箱注册
    BOOL isResignTimeOut;
    BOOL isLoginTimeOut;
    
}

@property(nonatomic,retain)NSString *someId;
@property(nonatomic,retain)NSString *deceiveToken;
@property(nonatomic,retain)NSString *ruleString;
@end

@implementation ResignViewVC




- (void)dealloc
{
    SAFETY_RELEASE(_phoneView);
    SAFETY_RELEASE(_phoneFild);
    SAFETY_RELEASE(_pwdFild);
    SAFETY_RELEASE(_emailFildPh);
    SAFETY_RELEASE(_confirmView);
    self.deceiveToken = nil;
    self.someId = nil;
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
//服务协议
-(void)initRuleDate
{
    DSRequest *requestObj = [[DSRequest alloc]init];
    requestObj.delegate = self;
    [requestObj requestDataWithInterface:GetRegulation param:[self GetRegulationParam:4] tag:4];
    [requestObj release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initRuleDate];
    [self setTitleString:@"注册"];
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.deceiveToken = [[NSUserDefaults standardUserDefaults] objectForKey:kkkDeviceToken];//设备token

    self.someId = [[NSUserDefaults standardUserDefaults] objectForKey:AnonymityId];//匿名用户id
    
    MySegMentControl *segment = [[MySegMentControl alloc]initWithFrame:CGRectMake(0, [self getTitleBarHeight], 50, 35)];
    segment.segments = [NSArray arrayWithObjects:@"手机注册",@"邮箱注册", nil];
    [segment createSegments];
    segment.delegate = self;
    [self.view addSubview:segment];
    isPhoneRe = YES;
    isAgree = YES;
    [self initPhoneView];
   
}



-(void)initEmailView
{
    if (!_emailView) {
        _emailView = [[UIView alloc]initWithFrame:CGRectMake(0, 35+TITLEHEIGHT,MainViewWidth, MainViewHeight-35-TITLEHEIGHT-20)];
        _emailView.backgroundColor = VIEW_BACKGROUND_COLOR;
        [self.view addSubview:_emailView];
        int height = GETIMG(@"log in_input bg.png").size.height;
        int weight = GETIMG(@"log in_input bg.png").size.width;
        NSArray *titleAry = [NSArray arrayWithObjects:@"Email",@"密码", nil];
        for (int i = 0; i<2; i++) {
            UIImageView *phoneImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10+(10+height)*i, weight, height)];
            phoneImgView.userInteractionEnabled = YES;
            phoneImgView.image = GETIMG(@"log in_input bg.png");
            [_emailView addSubview:phoneImgView];
            [phoneImgView release];
            UITextField * fild =[[UITextField alloc]initWithFrame:CGRectMake(5, 8, 300, 30)];
             fild.returnKeyType= UIReturnKeyDone;
            fild.delegate = self;
            if(i==1)
            {
                fild.secureTextEntry = YES;
            }
            if(i==0)
            {
                fild.keyboardType = UIKeyboardTypeEmailAddress;
            }
             fild.placeholder = [titleAry objectAtIndex:i];
            fild.tag = 200+i;
            fild.backgroundColor=[UIColor clearColor];
            fild.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            fild.clearButtonMode = UITextFieldViewModeWhileEditing;
            fild.delegate=self;
            fild.font=SYSTEMFONT(15);
            [phoneImgView addSubview:fild];
            [fild release];
            
        }
        
        _emailFildEm = [(UITextField *)[_emailView viewWithTag:200] retain];
        _pwdFildEm = [(UITextField *)[_emailView viewWithTag:201] retain];
        
        UIImage *choiceImg=GETIMG(@"log in_button_select2.png");
        UIButton *shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        shareBtn.tag = 7;
        shareBtn.frame=CGRectMake(10, 20+height*2+34/2, choiceImg.size.width, choiceImg.size.height);
        
        [shareBtn setBackgroundImage:choiceImg forState:UIControlStateNormal];
        [shareBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [shareBtn setBackgroundImage:GETIMG(@"log in_button_select1.png") forState:UIControlStateSelected];
        [_emailView addSubview:shareBtn];
        
        UILabel *autoLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 20+height*2+34/2, 100, 20)];
        autoLabel.text = @"显示密码";
        autoLabel.textColor = RGBCOLOR(154, 150, 150);
        autoLabel.backgroundColor = [UIColor clearColor];
        autoLabel.font = SYSTEMFONT(14);
        [_emailView addSubview:autoLabel];
        [autoLabel release];
        
        UIButton *agreeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        agreeBtn.tag = 5;
        agreeBtn.selected = YES;
        agreeBtn.frame=CGRectMake(100, 20+height*2+34/2, choiceImg.size.width, choiceImg.size.height);
        [agreeBtn setBackgroundImage:choiceImg forState:UIControlStateNormal];
        [agreeBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [agreeBtn setBackgroundImage:GETIMG(@"log in_button_select1.png") forState:UIControlStateSelected];
        [_emailView addSubview:agreeBtn];
        
        UILabel *agreeLabel = [[UILabel alloc]initWithFrame:CGRectMake(130, 20+height*2+34/2, 40, 20)];
        agreeLabel.text = @"同意";
        agreeLabel.textColor = RGBCOLOR(154, 150, 150);
        agreeLabel.backgroundColor = [UIColor clearColor];
        agreeLabel.font = SYSTEMFONT(14);
        [_emailView addSubview:agreeLabel];
        [agreeLabel release];
        
        UIButton *serviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        serviceBtn.frame = CGRectMake(160, 20+height*2+34/2, 150, 20);
        serviceBtn.tag = 6;
        serviceBtn.titleLabel.font = SYSTEMFONT(14);
        [serviceBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [serviceBtn setTitleColor:RGBCOLOR(11, 59, 154) forState:UIControlStateNormal];
        [serviceBtn setTitle:@"《海澜之家服务条款》" forState:UIControlStateNormal];
        [_emailView addSubview:serviceBtn];
        
        
        UIButton *handBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        handBtn.frame = CGRectMake(10, 20+height*2+34/2+14+20, GETIMG(@"button3.png").size.width, GETIMG(@"button3.png").size.height);
        handBtn.tag = 4;
        [handBtn setTitle:@"提交" forState:UIControlStateNormal];
        [handBtn setBackgroundImage:GETIMG(@"button3.png") forState:UIControlStateNormal];
        [handBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [handBtn setBackgroundImage:GETIMG(@"button3_press.png") forState:UIControlStateHighlighted];
        [_emailView addSubview:handBtn];

    }

}

-(void)initPhoneView
{
    if (!_phoneView) {
        _phoneView = [[UIView alloc]initWithFrame:CGRectMake(0, 35+TITLEHEIGHT,MainViewWidth, MainViewHeight-35-TITLEHEIGHT-20)];
        _phoneView.backgroundColor = VIEW_BACKGROUND_COLOR;
        [self.view addSubview:_phoneView];
        int height = GETIMG(@"log in_input bg.png").size.height;
        int weight = GETIMG(@"log in_input bg.png").size.width;
        NSArray *titleAry = [NSArray arrayWithObjects:@"手机号",@"密码",@"Email", nil];
        for (int i = 0; i<3; i++) {
            UIImageView *phoneImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10+(10+height)*i, weight, height)];
            phoneImgView.userInteractionEnabled = YES;
            phoneImgView.image = GETIMG(@"log in_input bg.png");
            [_phoneView addSubview:phoneImgView];
            [phoneImgView release];
            
            UITextField * fild =[[UITextField alloc]initWithFrame:CGRectMake(5, 8, 300, 30)];
            fild.delegate = self;
            fild.returnKeyType= UIReturnKeyDone;
            
            if(i==1)
            {
               fild.secureTextEntry = YES; 
            }
            if(i==0)
            {
                fild.keyboardType = UIKeyboardTypeNumberPad;
            }
            if(i==2)
            {
                fild.keyboardType = UIKeyboardTypeEmailAddress;
            }
            fild.placeholder = [titleAry objectAtIndex:i];
            fild.tag = 100+i;

            fild.backgroundColor=[UIColor clearColor];
            fild.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            fild.clearButtonMode = UITextFieldViewModeWhileEditing;
            fild.delegate=self;
            fild.font=SYSTEMFONT(15);
            [phoneImgView addSubview:fild];
            [fild release];
            
        }
        
        _phoneFild = [(UITextField *)[_phoneView viewWithTag:100] retain];
        _pwdFild = [(UITextField *)[_phoneView viewWithTag:101] retain];
        _emailFildPh = [(UITextField *)[_phoneView viewWithTag:102] retain];
        
        
        UIImage *choiceImg=GETIMG(@"log in_button_select2.png");
        UIButton *shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        shareBtn.tag = 1;
        shareBtn.frame=CGRectMake(10, 30+height*3+34/2, choiceImg.size.width, choiceImg.size.height);
        
        [shareBtn setBackgroundImage:choiceImg forState:UIControlStateNormal];
        [shareBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [shareBtn setBackgroundImage:GETIMG(@"log in_button_select1.png") forState:UIControlStateSelected];
        [_phoneView addSubview:shareBtn];
        
        UILabel *autoLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 30+height*3+34/2, 100, 20)];
        autoLabel.text = @"显示密码";
        autoLabel.textColor = RGBCOLOR(154, 150, 150);
        autoLabel.backgroundColor = [UIColor clearColor];
        autoLabel.font = SYSTEMFONT(14);
        [_phoneView addSubview:autoLabel];
        [autoLabel release];
        
        UIButton *agreeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        agreeBtn.tag = 2;
        agreeBtn.selected = YES;
        agreeBtn.frame=CGRectMake(100, 30+height*3+34/2, choiceImg.size.width, choiceImg.size.height);
        [agreeBtn setBackgroundImage:choiceImg forState:UIControlStateNormal];
        [agreeBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [agreeBtn setBackgroundImage:GETIMG(@"log in_button_select1.png") forState:UIControlStateSelected];
        [_phoneView addSubview:agreeBtn];
        
        UILabel *agreeLabel = [[UILabel alloc]initWithFrame:CGRectMake(130, 30+height*3+34/2, 40, 20)];
        agreeLabel.text = @"同意";
        agreeLabel.textColor = RGBCOLOR(154, 150, 150);
        agreeLabel.backgroundColor = [UIColor clearColor];
        agreeLabel.font = SYSTEMFONT(14);
        [_phoneView addSubview:agreeLabel];
        [agreeLabel release];
        
        UIButton *serviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        serviceBtn.frame = CGRectMake(160, 30+height*3+34/2, 150, 20);
        serviceBtn.tag = 3;
        serviceBtn.titleLabel.font = SYSTEMFONT(14);
        [serviceBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [serviceBtn setTitleColor:RGBCOLOR(11, 59, 154) forState:UIControlStateNormal];
        [serviceBtn setTitle:@"《海澜之家服务条款》" forState:UIControlStateNormal];
        [_phoneView addSubview:serviceBtn];
        
        
        UIButton *handBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        handBtn.frame = CGRectMake(10, 30+height*3+34/2+14+20, GETIMG(@"button3.png").size.width, GETIMG(@"button3.png").size.height);
        handBtn.tag = 4;
        [handBtn setTitle:@"提交" forState:UIControlStateNormal];
        [handBtn setBackgroundImage:GETIMG(@"button3.png") forState:UIControlStateNormal];
        [handBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [handBtn setBackgroundImage:GETIMG(@"button3_press.png") forState:UIControlStateHighlighted];
        [_phoneView addSubview:handBtn];
    }
    
}


-(void)clickButton:(UIButton *)btn
{
    //邮箱注册
    if(isEmailRe)
    {
        switch (btn.tag) {
                
                
            case 7://密码铭文
            {
                [_pwdFildEm resignFirstResponder];
                [_emailFildEm resignFirstResponder];
                btn.selected = !btn.selected;
                if(btn.selected)
                {
                    btn.selected = YES;
                    _pwdFildEm.secureTextEntry = NO;
                }
                else{
                    btn.selected = NO;
                    _pwdFildEm.secureTextEntry = YES;
                }
            }
                break;
                
            case 5://同意条款
            {
                isagreeEm = !isagreeEm;
                if(isagreeEm)
                {
                    isagreeEm = YES;
                    btn.selected = YES;
                }
                else{
                    isagreeEm = NO;
                    btn.selected = NO;
                }
 
            }
                break;
                
            case 6://弹出条款
            {
                [self popToview]; 
            }
                break;
                
            case 4:
            {
                //注册
                
                if(_emailFildEm.text==nil||[_emailFildEm.text isEqualToString:@""]||_pwdFildEm.text==nil||[_pwdFildEm.text isEqualToString:@""])
                {
                    
                    [WCAlertView showAlertWithTitle:@"提示" message:@"邮箱号或密码不能为空" customizationBlock:^(WCAlertView *alertView) {
                        alertView.style = WCAlertViewStyleWhite;
                        alertView.labelTextColor=[UIColor blackColor];
                        alertView.buttonTextColor=[UIColor blueColor];
                    } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                        nil;
                    } cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
                    return;
                }
                NSLog(@"%d",[self isValidateEmail:_emailFildEm.text]);
                if(![self isValidateEmail:_emailFildEm.text])
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
                
                if (_pwdFildEm.text.length < 6 || _pwdFildEm.text.length>16) {
                    
                    [WCAlertView showAlertWithTitle:@"提示" message:@"密码由6-16个字符组成" customizationBlock:^(WCAlertView *alertView) {
                        alertView.style = WCAlertViewStyleWhite;
                        alertView.labelTextColor=[UIColor blackColor];
                        alertView.buttonTextColor=[UIColor blueColor];
                    } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                        nil;
                    } cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
                    return;
                }
                if(!isagreeEm)
                {
                    [WCAlertView showAlertWithTitle:@"提示" message:@"请确定您已经同意并接受注册协议" customizationBlock:^(WCAlertView *alertView) {
                        alertView.style = WCAlertViewStyleWhite;
                        alertView.labelTextColor=[UIColor blackColor];
                        alertView.buttonTextColor=[UIColor blueColor];
                    } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                        nil;
                    } cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
                    return;
                }
                [self goResign];
            }
                break;
                
            default:
                break;
               
        }
         
        
    }
    //手机注册
    if(isPhoneRe)
    {
        switch (btn.tag) {
            case 1://密码明文
            {
                [_phoneFild resignFirstResponder];
                [_emailFildPh resignFirstResponder];
                [_phoneFild resignFirstResponder];
                btn.selected = !btn.selected;
                if(btn.selected)
                {
                    btn.selected = YES;
                    NSLog(@"%@",_pwdFild.text);
                    _pwdFild.secureTextEntry = NO;
                }
                else{
                    btn.selected = NO;
                    _pwdFild.secureTextEntry = YES;
                }

            }
                break;
                
            case 2://同意条款
            {
                isAgree = !isAgree;
                if(isAgree)
                {
                    btn.selected = YES;
                    isAgree = YES;
                }
                else{
                    isAgree = NO;
                    btn.selected = NO;
                }
 
            }
                break;
                
            case 3:
            {
                [self popToview];
            }
                break;
                
            case 4://注册
            {
                
               
                if(_phoneFild.text==nil||[_phoneFild.text isEqualToString:@""]||_pwdFild.text==nil||[_pwdFild.text isEqualToString:@""])
                {
                    
                    [WCAlertView showAlertWithTitle:@"提示" message:@"手机号或密码不能为空" customizationBlock:^(WCAlertView *alertView) {
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
                if(_emailFildPh.text.length>0)//如果用户有输入邮箱，则要对用户输入的邮箱进行判断是否合法
                {
                    if(![self isValidateEmail:_emailFildPh.text])
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
  
                }
                
                if (_pwdFild.text.length < 6 || _pwdFild.text.length>16) {
                    
                    [WCAlertView showAlertWithTitle:@"提示" message:@"密码由6-16个字符组成" customizationBlock:^(WCAlertView *alertView) {
                        alertView.style = WCAlertViewStyleWhite;
                        alertView.labelTextColor=[UIColor blackColor];
                        alertView.buttonTextColor=[UIColor blueColor];
                    } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                        nil;
                    } cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
                    return;
                }
                if(!isAgree)
                {
                    [WCAlertView showAlertWithTitle:@"提示" message:@"请确定您已经同意并接受注册协议" customizationBlock:^(WCAlertView *alertView) {
                        alertView.style = WCAlertViewStyleWhite;
                        alertView.labelTextColor=[UIColor blackColor];
                        alertView.buttonTextColor=[UIColor blueColor];
                    } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                        nil;
                    } cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
                    return;
                }
                [self goResign];
            }
                break;
                
            default:
                break;
            
        }
       
    }
    
 
}

-(void)popToview
{
    [self keyBordHid];
    if(_confirmView== nil)
    {
        _confirmView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainViewWidth, MainViewHeight-20)];
    }
    _confirmView.backgroundColor = [UIColor colorWithRed:10/255.0 green:10/255.0 blue:10/255.0 alpha:0.7];
    [self.view addSubview:_confirmView];
    
    UIImage *bgImage = GETIMG(@"bg_pop.png");
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 100, bgImage.size.width, bgImage.size.height)];
    bgView.image = bgImage;
    bgView.userInteractionEnabled = YES;
    
    UITextView *delegateView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
//    delegateView.text = @" 一、确认与接纳海澜\n之家服饰股份有限公司是一家集男装生产、销售为一体的大型服装企业。海澜之家品牌自2002年推出以来，以全国连锁、超大规模、男装自选的全新营销模式引发了中国服装市场的新一轮革命，其高品位、大众价的市场定位，款式多、品种全的货品选择，无干扰、自由自在的\"一站式\"选购方式迅速赢得了广大消费者的喜爱，海澜之家因此被称为\"男人的衣柜\" 。\n\"海澜之家\"（http://www.heilanhome.com/）是海澜之家服饰股份有限公司系统整合了纺织服装供应链优势与电子商务运营经验、顺应互联网消费潮流应运而生组建了服装电子商务网站。海澜之家服饰股份有限公司及其涉及到的产品、服务、相关软件的所有权和运营权归海澜之家服饰股份有限公司所有，海澜之家服饰股份有限公司享有对\"海澜之家\"一切活动的监督、提示、检查、纠正及处罚权利。用户通过注册程序阅读本服务条款点击\"提交\"完成注册，或以任何行为实际使用、享受\"海澜之家\"的服务，即表示用户与海澜之家服饰股份有限公司已达成协议，自愿接受本服务条款的所有内容。如用户不同意本服务条款的条件，则不能使用海澜之家.";
    delegateView.text = self.ruleString;
    delegateView.editable = NO;
    [bgView addSubview:delegateView];
    [delegateView release];
    [_confirmView addSubview:bgView];
    [bgView release];
    
    [self viewBounceInAnimation:_confirmView];
    
}



-(void)goResign
{
    [self keyBordHid];
    isResignTimeOut = YES;
    [self performSelector:@selector(reginFaiOverTime) withObject:nil afterDelay:10];
    DSRequest *requestObj = [[DSRequest alloc]init];
    requestObj.delegate = self;
   // self.aRequest = requestObj;
    if(isPhoneRe)
    {
       // NSString *emileString = _emailFildPh.text?_emailFildPh.text:@"";
        [requestObj requestDataWithInterface:Register param:[self RegisterParam:_phoneFild.text email:@"" password:_pwdFild.text token:self.deceiveToken type:2] tag:0];
    }
    if(isEmailRe)
    {
        [requestObj requestDataWithInterface:Register param:[self RegisterParam:@"" email:_emailFildEm.text password:_pwdFildEm.text token:self.deceiveToken type:2] tag:0];
    }
    [self addHud:@"正在注册"];
    [requestObj release];
    
    
}



-(void)hidHud
{
    [self hideHud:nil];
}

#pragma mark ---DSRequest delegate

-(void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError *)error
{
    if(tag == 0)
    {
        isResignTimeOut = NO;
        [self performSelector:@selector(hidHud) withObject:nil afterDelay:0.1];
 
    }
    if(tag ==1)
    {
        isLoginTimeOut = NO;
         [self performSelector:@selector(hidHud) withObject:nil afterDelay:0.1];
    }
    if(tag ==4)
    {
        
    }
    [self addFadeLabel:error.domain];
    
   
}

-(void)reginFaiOverTime
{
    [self hideHud:nil];
    if(isResignTimeOut)
    {
        [self addFadeLabel:@"注册超时"];
    }
}
-(void)loginFaiOverTime
{
    [self hideHud:nil];
    if(isLoginTimeOut)
    {
        [self addFadeLabel:@"登录超时"];
    }
}

-(void)requestDataSuccess:(id)dataObj tag:(int)tag
{
   
    RegisterLoginEntity *entity =(RegisterLoginEntity *)dataObj;
    [self hideHud:nil];
    switch (tag) {
        case 0://注册
        {
            isResignTimeOut = NO;
            if(entity.response == 1)
            {
                
                [self GoLogin];//登录
            }
            else
            {
                [self addFadeLabel:entity.failmsg];
            }
//            else if(entity.response == 2)
//            {
//                [self addFadeLabel:@"注册失败"];
//            }
//            else if(entity.response == 3)
//            {
//                [self addFadeLabel:@"此用户名已经存在"];
//                
//            }

        }
            break;
        case 1://登录
        {
            isLoginTimeOut = NO;
            if(entity.response == 1)
            {
                
                 //保存用户信息(判断用户是否登录)
                [[NSUserDefaults standardUserDefaults]setObject:entity.userid forKey:UserId];
                [[NSUserDefaults standardUserDefaults]setObject:entity.token forKey:Token];
                [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",1] forKey:@"logintype"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccess object:nil];
                //自动登录用
                NSDictionary *userInforData = [NSDictionary dictionaryWithObjectsAndKeys:
                                               entity.userid,@"userName",
                                               entity.token,@"userPwd", nil];
                [[NSUserDefaults standardUserDefaults]setObject:userInforData forKey:@"userLoginData"];
                NSLog(@"%@",userInforData);
                [[NSUserDefaults standardUserDefaults]synchronize];

             //   [self initPushOn];//开启推送(在root里面开启推送)
                [self popToRoot];
                
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"MyWardReload" object:nil userInfo:nil];
            }
            else
            {
               [self addFadeLabel:@"登录失败"];
            }
            
        }
            
        case 3:
        {
           //推送
        }

            break;
        case 4:
        {
            self.ruleString = (NSString *)dataObj;
            //推送
        }
            
            break;
        default:
            break;
    }
    }

-(void)GoLogin
{
    //登录超时
    isLoginTimeOut = YES;
    [self performSelector:@selector(loginFaiOverTime) withObject:nil afterDelay:10];
    DSRequest *requestObj = [[DSRequest alloc]init];
    requestObj.delegate = self;
    if(isPhoneRe)
    {
      
        [requestObj requestDataWithInterface:Login param:[self LoginParam:_phoneFild.text password:_pwdFild.text type:@"1" thirdtoken:@"" anonymityid:self.someId token:self.deceiveToken] tag:1];
        
    }
    if(isEmailRe)
    {
        [requestObj requestDataWithInterface:Login param:[self LoginParam:_emailFildEm.text password:_pwdFildEm.text type:@"1" thirdtoken:@"" anonymityid:self.someId token:self.deceiveToken] tag:1];
    }
   
    [self addHud:@"正在登录"];
    [requestObj release];
}

-(void)initPushOn
{
    DSRequest *requestObj = [[DSRequest alloc]init];
    requestObj.delegate = self;
    [requestObj requestDataWithInterface:PushSetting param:[self PushSettingParam:self.deceiveToken status:2 provinceid:@"0"] tag:3];
    [requestObj release];
}


#pragma mark --MySegMentControl delegate
- (void)segmentControl:(MySegMentControl *)setMentControl touchedAtIndex:(NSInteger)index
{
    NSLog(@"%d",index);
    switch (index) {
        case 0:
        {
            isPhoneRe =YES;
            isEmailRe =NO;
            _phoneView.hidden = NO;
            _emailView.hidden =YES;
            
        }
            break;
        case 1:
        {
            isPhoneRe =NO;
            isEmailRe =YES;
            isagreeEm = YES;
            _phoneView.hidden = YES;
            _emailView.hidden =NO;
            [self initEmailView];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark ----UITextField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容

   if((textField == _pwdFild)||(textField == _pwdFildEm))
   {
       if ([toBeString length] > 16) { //如果输入框内容大于20则弹出警告
           textField.text = [toBeString substringToIndex:16];
           [WCAlertView showAlertWithTitle:@"提示" message:@"输入密码已经超过16位" customizationBlock:^(WCAlertView *alertView) {
               alertView.style = WCAlertViewStyleWhite;
               alertView.labelTextColor=[UIColor blackColor];
               alertView.buttonTextColor=[UIColor blueColor];
           } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
               nil;
           } cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
           return NO;
       }

   }
    return YES;
}

#pragma mark ----UITouch delegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *oneTouch = [touches anyObject];
    if(oneTouch.tapCount==1)
    {
        [self viewBounceOutAnimation:_confirmView];
        [self keyBordHid];
    }
}

#pragma mark --animation
-(void)viewBounceInAnimation:(UIView*)view
{
    view.hidden = NO;
    [self zoomIn:view andAnimationDuration:0.2 andWait:YES sx:0 sy:0 ex:1 ey:1];
    [self zoomOut:view andAnimationDuration:0.08 andWait:YES sx:1 sy:1 ex:0.8 ey:0.8];
    [self zoomIn:view andAnimationDuration:0.08 andWait:YES sx:0.8 sy:0.8 ex:1 ey:1];
}
-(void)viewBounceOutAnimation:(UIView*)view
{
  
    [self zoomOut:view andAnimationDuration:0.08 andWait:YES sx:1 sy:1 ex:0.8 ey:0.8];
    [self zoomIn:view andAnimationDuration:0.08 andWait:YES sx:0.8 sy:0.8 ex:1 ey:1];
    [self zoomOut:view andAnimationDuration:0.2 andWait:YES sx:1 sy:1 ex:0 ey:0];
      view.hidden = YES;
    
}


- (void)zoomIn: (UIView *)view andAnimationDuration: (float) duration andWait:(BOOL) wait sx:(CGFloat)sx sy:(CGFloat)sy ex:(CGFloat)ex ey:(CGFloat)ey
{
    //wait =  YES wait to finish animation
    __block BOOL done = wait;
    view.transform = CGAffineTransformMakeScale(sx, sy);
    [UIView animateWithDuration:duration animations:^{
        //view.transform = CGAffineTransformIdentity;
        view.transform = CGAffineTransformMakeScale(ex, ey);
        //view.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        done = NO;
    }];
    // wait for animation to finish
    while (done == YES)
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
}
- (void)zoomOut: (UIView *)view andAnimationDuration: (float) duration andWait:(BOOL) wait sx:(CGFloat)sx sy:(CGFloat)sy ex:(CGFloat)ex ey:(CGFloat)ey
{
    //wait =  YES wait to finish animation
    __block BOOL done = wait;
    view.transform = CGAffineTransformMakeScale(sx,sy);
    [UIView animateWithDuration:duration animations:^{
        view.transform = CGAffineTransformIdentity;
        view.transform = CGAffineTransformMakeScale(ex,ey);
        //view.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        done = NO;
    }];
    // wait for animation to finish
    while (done == YES)
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
}


-(void)keyBordHid
{
    [_phoneFild resignFirstResponder];
    [_pwdFild resignFirstResponder];
    [_emailFildPh resignFirstResponder];
    [_emailFildEm resignFirstResponder];
    [_pwdFildEm resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    //中国邮箱
//    if(isRight)
//    {
//        NSArray *array = [email componentsSeparatedByString:@"."];
//        NSString *string = [array lastObject];
//        if([string isEqualToString:@"com"]||[string isEqualToString:@"net"]||[string isEqualToString:@"cn"])
//        {
//            return YES;
//        }
//        else
//        {
//            return NO;
//        }
//    }
//    return NO;
   
}

@end
