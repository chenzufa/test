//
//  ChangePwdVC.m
//  HaiLanZhiJia
//
//  Created by creaver on 13-11-28.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "ChangePwdVC.h"
#import "WCAlertView.h"
#import <QuartzCore/QuartzCore.h>
#import "LoginViewCtrol.h"
@interface ChangePwdVC ()<UITextFieldDelegate>

{
    BOOL isShow;
    UITextField *oldFild;
    UITextField *newFild;
}

@end

@implementation ChangePwdVC

- (void)dealloc
{
    [oldFild release];
    [newFild release];
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
    
    [self setTitleString:@"修改密码"];
    [self createMyButtonWithTitleAndImage];
    [self setMyRightButtonTitle:@"完成"];
    [self setMyRightButtonBackGroundImageView:@"button1.png" hightImage:@"button1_press.png"];
    [self initView];
  
	// Do any additional setup after loading the view.
}

-(void)initView
{
    UIImageView *oldPwdView = [[UIImageView alloc]initWithFrame:CGRectMake(10,10+[self getTitleBarHeight], 300, 44)];
    oldPwdView.userInteractionEnabled = YES;
    oldPwdView.backgroundColor = RGBCOLOR(255, 255, 255);
    oldPwdView.layer.borderColor = RGBCOLOR(184,184,184).CGColor;
    oldPwdView.layer.cornerRadius = 3;
    oldPwdView.layer.borderWidth = 1;
    
    oldFild = [[UITextField alloc]initWithFrame:CGRectMake(5,2,290, 40)];
    oldFild.secureTextEntry = YES;
    oldFild.placeholder = @"旧密码(由6-16个字符组成)";
    oldFild.backgroundColor = [UIColor clearColor];
    oldFild.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    oldFild.clearButtonMode = UITextFieldViewModeWhileEditing;
    oldFild.delegate=self;
    oldFild.font=SYSTEMFONT(15);
    oldFild.returnKeyType= UIReturnKeyDone;
    [oldPwdView addSubview:oldFild];
    
    [self.view addSubview:oldPwdView];
    [oldPwdView release];
    
    UIImageView *newPwdView = [[UIImageView alloc]initWithFrame:CGRectMake(10,64+[self getTitleBarHeight],300, 44)];
    newPwdView.userInteractionEnabled = YES;
    newPwdView.backgroundColor = RGBCOLOR(255, 255, 255);
    [self.view addSubview:newPwdView];
    newPwdView.layer.borderColor = RGBCOLOR(184,184,184).CGColor;
    newPwdView.layer.cornerRadius = 3;
    newPwdView.layer.borderWidth = 1;
    [newPwdView release];
    
    newFild = [[UITextField alloc]initWithFrame:CGRectMake(5,2, 290,40)];
    newFild.secureTextEntry = YES;
    newFild.placeholder = @"新密码(由6-16个字符组成)";
    newFild.backgroundColor = [UIColor clearColor];
    newFild.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    newFild.clearButtonMode = UITextFieldViewModeWhileEditing;
    newFild.delegate=self;
    newFild.font=SYSTEMFONT(15);
    newFild.returnKeyType= UIReturnKeyDone;
    [newPwdView addSubview:newFild];

    UIImage *showImage=GETIMG(@"log in_button_select2@2x.png");
    UIButton *autoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    autoBtn.tag = 1;
    autoBtn.frame=CGRectMake(10,newPwdView.frame.origin.y+newPwdView.frame.size.height+15, showImage.size.width/2.0, showImage.size.height/2.0);
    [autoBtn setBackgroundImage:showImage forState:UIControlStateNormal];
    [autoBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [autoBtn setBackgroundImage:GETIMG(@"log in_button_select1@2x.png") forState:UIControlStateSelected];
    [self.view addSubview:autoBtn];
    UILabel *autoLabel = [[UILabel alloc]initWithFrame:CGRectMake(10+showImage.size.width/2+5, autoBtn.frame.origin.y, 100, 20)];
    autoLabel.text = @"显示密码";
    autoLabel.textColor = RGBCOLOR(154, 150, 150);
    autoLabel.backgroundColor = [UIColor clearColor];
    autoLabel.font = SYSTEMFONT(14);
    [self.view addSubview:autoLabel];
    [autoLabel release];

}

-(void)clickButton:(UIButton *)btn
{
    [oldFild resignFirstResponder];
    [newFild resignFirstResponder];
    
    btn.selected = !btn.selected;
    if(btn.selected)
    {
        [oldFild setSecureTextEntry:NO];
        [newFild setSecureTextEntry:NO];
        btn.selected = YES;
        
    }
    else
    {
        [oldFild setSecureTextEntry:YES];
        [newFild setSecureTextEntry:YES];

        btn.selected = NO;
    }
}


-(BOOL)checkPassword:(NSString *)password
{
     /* @"^[a-zA-Z]{1}([a-zA-Z0-9]|[_]|[.]){5,15}$"
       字母开头，由字母 数字 下划线 点 组成,长6-16 */
     /*@"[A-Z0-9a-z._]{6,16}" 由字母 数字 下划线 点 组成,长6-16*/
    NSString *Regex = @"\\w{6,16}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [predicate evaluateWithObject:password];
}
- (BOOL)chineseJudgeWithString:(NSString *)realname
{
    //\u4e00-\u9fa5
    NSString *realnameFilter = @"[\u2E80-\u9FFF]+$";
    NSPredicate *fliter = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",realnameFilter];
    return [fliter evaluateWithObject:realname];
}
-(void)myRightButtonAction:(UIButton *)button
{
    [self.view endEditing:YES];
    
    if(oldFild.text.length==0)
    {
        [self addFadeLabel:@"旧密码不能为空"];
        return;
    }else if (newFild.text.length==0)
    {
        [self addFadeLabel:@"新密码不能为空"];
        return;
    }else if (newFild.text.length<6)
    {
        [self addFadeLabel:@"新密码不能少于6个字符"];
        return;
    }else if (newFild.text.length>16)
    {
        [self addFadeLabel:@"新密码不能多于16个字符"];
        return;
    }else if ([self isBlankString:newFild.text])
    {
        [self addFadeLabel:@"新密码不能全为空格"];
        return;
    }else if([oldFild.text isEqualToString:newFild.text])
    {
        [self addFadeLabel:@"新旧密码不能相同"];
        return;
    }else
    {
        NSLog(@"%@ %@",oldFild.text,newFild.text);
        [self addHud:@"请稍候"];
        DSRequest *request = [[DSRequest alloc]init];
        request.delegate = self;
        [request requestDataWithInterface:ChangePassword param:[self ChangePasswordParam:oldFild.text newPass:newFild.text] tag:1];
        [request release];
    }
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *oneTouch = [touches anyObject];
    if(oneTouch.tapCount ==1)
    {
        [oldFild resignFirstResponder];
        [newFild resignFirstResponder];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark - DSRequestDelegate
-(void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    [self hideHud:nil];
    StatusEntity *entity = (StatusEntity*)dataObj;
    int a = entity.response;
    if (a==1)//success
    {
        [self addFadeLabel:@"修改密码成功"];
         oldFild.text=@"";
         newFild.text=@"";
        [[NSNotificationCenter defaultCenter] postNotificationName:LoginOut object:nil];
        [self popViewController];
    }else if(a==3)
    {
        [self addFadeLabel:@"旧密码错误"];
    }else
    {
        [self addFadeLabel:entity.failreason];
    }
}
-(void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError*)error
{
    [self hideHud:nil];
    [self addFadeLabel:error.domain];
}



@end
