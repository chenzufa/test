//
//  BangdingView.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-25.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "BangdingView.h"

@implementation BangdingView
{
    UITextField *textFieldCardNum;
    UITextField *textFieldPsd;
}

- (void)dealloc
{
    [textFieldCardNum release];
    if (textFieldPsd) {
        [textFieldPsd release];
    }
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
//        [self initUI];
    }
    return self;
}

- (void)initUI
{
    UIImage *backimg = GetImage(@"bg_in put.png");
    for (int i = 0; i < self.ifHasPsd; i++) {
        UIImageView *backimgv = [[UIImageView alloc]initWithImage:backimg];
        [backimgv setFrame:CGRectMake(10, 10 + 59 * i, backimgv.image.size.width, backimgv.image.size.height)];
        [self addSubview:backimgv];
        [backimgv release];
    }
    
    textFieldCardNum = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, backimg.size.width - 20, backimg.size.height)];
    [textFieldCardNum setBorderStyle:UITextBorderStyleNone];
    [textFieldCardNum setPlaceholder:@"卡号"];
    textFieldCardNum.delegate = self;
    [textFieldCardNum setFont:SetFontSize(FontSize15)];
    textFieldCardNum.tag = 100;
    [textFieldCardNum setReturnKeyType:UIReturnKeyDone];
    [textFieldCardNum setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self addSubview:textFieldCardNum];
    
    int h = 15;
    if (self.ifHasPsd == 2) {
        h = 35;
        textFieldPsd = [[UITextField alloc]initWithFrame:CGRectMake(textFieldCardNum.frame.origin.x, textFieldCardNum.frame.origin.y + 59, textFieldCardNum.frame.size.width, textFieldCardNum.frame.size.height)];
        [textFieldPsd setBorderStyle:UITextBorderStyleNone];
        [textFieldPsd setPlaceholder:@"密码"];
        textFieldPsd.delegate = self;
        [textFieldPsd setSecureTextEntry:YES];
        textFieldPsd.tag = textFieldCardNum.tag + 1;
        [textFieldPsd setFont:textFieldCardNum.font];
        [textFieldPsd setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [textFieldPsd setReturnKeyType:UIReturnKeyDone];
        [self addSubview:textFieldPsd];
    }
    
    
    
    UIImage *imgRedBtn = GetImage(@"button3.png");
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setBackgroundImage:imgRedBtn forState:UIControlStateNormal];
    [button1 setBackgroundImage:GetImage(@"button3_press.png") forState:UIControlStateHighlighted];
    [button1 setFrame:CGRectMake(textFieldCardNum.frame.origin.x - 10, textFieldCardNum.frame.origin.y + textFieldCardNum.frame.size.height + textFieldPsd.frame.size.height + h, imgRedBtn.size.width, imgRedBtn.size.height)];
    [button1 setTitle:@"确定绑定" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button1.titleLabel setFont:SetFontSize(18)];
    button1.tag = 0;
    [button1 addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button1];
    
    UIImage *imgWhiteBtn = GetImage(@"bg_list.png");
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setBackgroundImage:imgWhiteBtn forState:UIControlStateNormal];
    [button2 setBackgroundImage:GetImage(@"bg_list_press.png") forState:UIControlStateHighlighted];
    [button2 setFrame:CGRectMake(button1.frame.origin.x, button1.frame.origin.y + button1.frame.size.height + 25, imgWhiteBtn.size.width, imgWhiteBtn.size.height)];
    [button2 setTitle:@"扫描绑定" forState:UIControlStateNormal];
    [button2 setTitleColor:ColorFontBlack forState:UIControlStateNormal];
    [button2 setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 210)];
    [button2.titleLabel setFont:button1.titleLabel.font];
    button2.tag = 1;
    [button2 addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button2];
    
    UIImageView *arrowImgView = [[UIImageView alloc]initWithImage:GetImage(@"icon_next.png")];
    [arrowImgView setFrame:CGRectMake(283 + button2.frame.origin.x, button2.frame.origin.y + 15, arrowImgView.image.size.width, arrowImgView.image.size.height)];
    [self addSubview:arrowImgView];
    
    
    [arrowImgView release];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)clickedButton:(UIButton *)btn       //按钮点击事件
{
    if ([textFieldCardNum isFirstResponder]) {
        [textFieldCardNum resignFirstResponder];
    }
    if (textFieldPsd.isFirstResponder) {
        [textFieldPsd resignFirstResponder];
    }
    if ([self.delegate respondsToSelector:@selector(bangdingView:clickedAnIndex:cardNum:passWord:)]) {
        [self.delegate bangdingView:self clickedAnIndex:btn.tag cardNum:textFieldCardNum.text passWord:textFieldPsd.text];
    }
}

- (void)cleanTextField
{
    [textFieldCardNum setText:nil];
    [textFieldPsd setText:nil];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
