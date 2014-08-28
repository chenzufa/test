//
//  MySegMentControl.m
//  MeiLiYun
//
//  Created by summer on 13-10-8.
//  Copyright (c) 2013年 com.donson. All rights reserved.
//

#import "MySegMentControl.h"

@implementation MySegMentControl
{
    NSString *twoImageNames;
    NSString *threeImageNames;
    NSString *fourImageNames;
    NSMutableArray *buttons;
}

- (void)dealloc
{
//    [twoImageNames release];
//    [threeImageNames release];
//    [fourImageNames release];
    [buttons release];
    
    self.segments = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *backGroundImgView = [[UIImageView alloc]init];//WithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [backGroundImgView setImage:GetImage(@"tab_bg.png")];
        [backGroundImgView setFrame:CGRectMake(0, 0, backGroundImgView.image.size.width, backGroundImgView.image.size.height)];
        
        [self addSubview:backGroundImgView];
        [backGroundImgView release];
        
        [self setFrame:CGRectMake(0, frame.origin.y, backGroundImgView.frame.size.width, backGroundImgView.frame.size.height)];
        
        twoImageNames = @"tab_sel2.png";
        threeImageNames = @"tab_sel3.png";
        fourImageNames = @"tab_sel4.png";
        
        buttons = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)createSegments
{
    
    for (int i = 0; i < self.segments.count; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button setTitle:[self.segments objectAtIndex:i] forState:UIControlStateNormal];
        [button.titleLabel setFont:SetFontSize(FontSize15)];
        [button setTitleColor:ColorFontBlack forState:UIControlStateNormal];
        [button setTitleColor:ColorFontBlue forState:UIControlStateSelected];
        [button setFrame:CGRectMake((self.frame.size.width * i )/ self.segments.count, 0, self.frame.size.width / self.segments.count, self.frame.size.height)];
        
        [button addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [buttons addObject:button];
        [self addSubview:button];
        
    }

    switch (self.segments.count) {
        case 2:
            for (int i = 0; i < buttons.count; i++) {
                UIButton *btn = [buttons objectAtIndex:i];
                [btn setBackgroundImage:[UIImage imageNamed:twoImageNames] forState:UIControlStateSelected];
                
            }
            break;
        case 3:
            for (int i = 0; i < buttons.count; i++) {
                UIButton *btn = [buttons objectAtIndex:i];
                [btn setBackgroundImage:[UIImage imageNamed:threeImageNames] forState:UIControlStateSelected];
                
            }
            break;
        case 4:
            for (int i = 0; i < buttons.count; i++) {
                UIButton *btn = [buttons objectAtIndex:i];
                [btn setBackgroundImage:[UIImage imageNamed:fourImageNames] forState:UIControlStateSelected];
                
            }
            break;
            
        default:
            break;
    }
    

    [self setSelectAnIndex:0];
}

- (void)setSelectAnIndex:(NSInteger)index
{
    UIButton *btn = [buttons objectAtIndex:index];
    [btn setSelected:YES];
}

- (void)clickedButton:(UIButton *)btn
{

    for (UIButton *btn in buttons) {
        [btn setSelected:NO];
    }
    
    [btn setSelected:YES];
    if ([self.delegate respondsToSelector:@selector(segmentControl:touchedAtIndex:)]) {
        
        [self.delegate segmentControl:self touchedAtIndex:btn.tag];
        
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
