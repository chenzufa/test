//
//  GuideView.m
//  MeiLiYun
//
//  Created by summer on 13-10-14.
//  Copyright (c) 2013年 com.donson. All rights reserved.
//

#import "GuideView.h"
#import <QuartzCore/QuartzCore.h>
@implementation GuideView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUserInteractionEnabled:YES];
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    UIScrollView *sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, MainViewWidth, MainViewHeight)];
     [sv setContentSize:CGSizeMake(MainViewWidth * 4, MainViewHeight)];
    [sv setPagingEnabled:YES];
    [sv setBounces:NO];

    NSString *tempStr = @"_1136@2x.png";;
    if (!isIPhone5)
    {
       tempStr = @"_960@2x.png";
    }
   
    for (int i = 0; i < 4; i++)
    {
        NSString *imageName = [NSString stringWithFormat:@"%i%@",i+1,tempStr];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:GETIMG(imageName)];
        [imageView setFrame:CGRectMake(i * MainViewWidth, 0, 320, GETIMG(imageName).size.height/2)];
        [sv addSubview:imageView];
        [imageView release];
        
    }
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn1 setBackgroundImage:GetImage(@"guide_experience_button_confirm@2x.png") forState:UIControlStateNormal];
//    [btn1 setBackgroundImage:GetImage(@"guide_experience_button_confirm_press@2x.png") forState:UIControlStateHighlighted];
//    btn1.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn1 setFrame:CGRectMake(3 * MainViewWidth + 100, MainViewHeight-32-32, 120, 35)];
    [btn1 setBackgroundColor:[UIColor clearColor]];
    btn1.tag = 0;
    [btn1 addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [sv addSubview:btn1];
   
    
//    int h = 100;
//    if (!isIPhone5) {
//        h = 70;
//    }
    
    [btn1 setShowsTouchWhenHighlighted:NO];
    [self addSubview:sv];
    [sv release];
}

- (void)beginMissingAnimation
{
    [UIView beginAnimations:@"View Flip" context:nil];
    
    [UIView setAnimationDuration:2];
    self.alpha = 0;
    [UIView commitAnimations];
}

- (void)clicked:(UIButton *)btn
{
    [self beginMissingAnimation];
    if ([self.delegate respondsToSelector:@selector(guideView:clickedAtButtonIndex:)]) {
        [self.delegate guideView:self clickedAtButtonIndex:btn.tag];
    }
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
