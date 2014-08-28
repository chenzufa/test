//
//  DSSegmentControl.m
//  CHYSliderDemo
//
//  Created by xiaojiaxi on 13-09-15.
//  Copyright (c) 2013年 ciderstudios.com. All rights reserved.
//

#import "DSSegmentControl.h"


@interface DSSegmentControl()
@property(nonatomic,retain)NSMutableArray *buttons;
@end;
@implementation DSSegmentControl
-(void)dealloc
{
    [_backgroundImage release];
    [_normalImages release];
    [_highlightImages release];
    [_buttons release];
    [_titles release];
    [_colorH release];
    [_colorN release];
    [_biaoMianImages release];
    self.delegate=nil;
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        if (_buttons==nil)
        {
            self.buttons = [NSMutableArray arrayWithCapacity:0];
        }else
        {
            [_buttons removeAllObjects];
        }
    }
    return self;
}

-(void)initSegmentControl
{
    UIImage *bgImage = [UIImage imageNamed:self.backgroundImage];
    UIImageView *backGroundImgView = [[UIImageView alloc]initWithFrame:self.bounds];
    backGroundImgView.userInteractionEnabled = YES;
    backGroundImgView.image = bgImage;
    [self addSubview:backGroundImgView];
    [backGroundImgView release];
    
    int count = MAX(self.normalImages.count, MAX(self.titles.count, self.highlightImages.count));
    for (int i = 0; i <count; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i+1111;
        if (self.titles.count>0)
        {
            [button setTitle:[self.titles objectAtIndex:i] forState:UIControlStateNormal];
            [button setTitle:[self.titles objectAtIndex:i] forState:UIControlStateSelected];
            [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
            [button setTitleColor:_colorN forState:UIControlStateNormal];
            [button setTitleColor:_colorH forState:UIControlStateSelected];
        }
        if (self.normalImages.count>0)
        {
            [button setBackgroundImage:[UIImage imageNamed:[self.normalImages objectAtIndex:i]] forState:UIControlStateNormal];
        }
        if (self.highlightImages.count>0)
        {
            [button setBackgroundImage:[UIImage imageNamed:[self.highlightImages objectAtIndex:i]] forState:UIControlStateHighlighted];
            [button setBackgroundImage:[UIImage imageNamed:[self.highlightImages objectAtIndex:i]] forState:UIControlStateSelected];
        }
        if ([self.biaoMianImages[i] intValue]==1)
        {
            if (i==2)
            {
#define biaoMianimage1 @"mall_icon_price_up@2x.png"
#define biaoMianimage2 @"mall_icon_price_down@2x.png"
#define biaoMianimage4 @"mall_icon_price_nor@2x.png"
                [button setImage:[UIImage imageNamed:biaoMianimage4] forState:UIControlStateNormal];
                //[button setImage:[UIImage imageNamed:biaoMianimage1] forState:UIControlStateSelected];
                button.titleEdgeInsets = UIEdgeInsetsMake(0,0, 0,30);
                button.imageEdgeInsets = UIEdgeInsetsMake(14, 50,14,20);
            }
            if (i==3)
            {
#define biaoMianimage3 @"search_icon_search_tab@2x.png"
                //[button setImage:[UIImage imageNamed:biaoMianimage3] forState:UIControlStateNormal];
                button.titleEdgeInsets = UIEdgeInsetsMake(0,0,0,0);
               // button.imageEdgeInsets = UIEdgeInsetsMake(14,0,14,30);
            }
            
        }
        CGFloat x = (self.frame.size.width/count)*i;
        CGFloat y = 0;
        CGFloat w = self.frame.size.width /count;
        CGFloat h = self.bounds.size.height;
        [button setFrame:CGRectMake(x,y,w,h)];
        [button addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
        [_buttons addObject:button];
        [self addSubview:button];
        
    }
    [self setSelectedBtnAnIndex:0];
}

- (void)setSelectedBtnAnIndex:(NSInteger)index
{
    UIButton *btn = (UIButton*)[_buttons objectAtIndex:index];
    btn.selected = YES;
}

- (void)clickedButton:(UIButton *)btn
{
    for (UIButton *btn in self.buttons)
    {
        btn.selected = NO;
    }
     btn.selected = YES;
    if (self.delegate&&[self.delegate respondsToSelector:@selector(segmentControl:clickedAtIndex: button:)])
    {
        [self.delegate segmentControl:self clickedAtIndex:btn.tag-1111 button:btn];
    }
}

@end
