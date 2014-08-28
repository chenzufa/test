//
//  ShowContentsView.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-25.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "ShowContentsView.h"
#define TextViewTag 99


@implementation ShowContentsView
{
    UITextView *textView ;
}

- (void)dealloc
{
    [textView release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        [self initUI];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initUI];
        
    }
    return self;
}

- (void)initUI
{
    [self setFrame:CGRectMake(0, 0, MainViewWidth, MainViewHeight)];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainViewWidth, MainViewHeight)];
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:0.5];
    [view setUserInteractionEnabled:YES];
    [self addSubview:view];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    [view addGestureRecognizer:tap];
    [tap release];
    
    UIImageView *imgViewBackGround =[[UIImageView alloc]initWithImage:GetImage(@"bg_pop.png")];
    [imgViewBackGround setFrame:CGRectMake(0, 0, imgViewBackGround.image.size.width, imgViewBackGround.image.size.height)];
    [imgViewBackGround setCenter:CGPointMake(MainViewWidth / 2, (MainViewHeight) / 2)];
    [self addSubview:imgViewBackGround];
    
    textView = [[UITextView alloc]initWithFrame:imgViewBackGround.frame];
    [textView setFont:SetFontSize(FontSize12)];
    [textView setTextColor:ColorFontBlack];
//    [textView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:textView];
    [textView setEditable:NO];
    textView.tag = TextViewTag;
    
    [view release];
    [imgViewBackGround release];
}

- (void)tapView:(id)sender
{
    [self removeFromSuperview];
}

- (void)setContentsText:(NSString *)strtext
{
    [textView setText:strtext];
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
