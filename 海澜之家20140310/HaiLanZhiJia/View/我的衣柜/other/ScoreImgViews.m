//
//  ScoreImgViews.m
//  MeiLiYun
//
//  Created by summer on 13-10-9.
//  Copyright (c) 2013年 com.donson. All rights reserved.
//

#import "ScoreImgViews.h"

@implementation ScoreImgViews
{
    NSMutableArray *imageViews;
    NSMutableArray *xingName;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
//        [self setBackgroundColor:[UIColor cyanColor]];
        [self initUI];
        
    }
    return self;
}

- (void)dealloc
{
    [imageViews release];
    [super dealloc];
}

- (void)initUI
{
    imageViews = [[NSMutableArray alloc]init];
    UIImage *scoreImg;
    UIImage *hightScoreImg;
    float jiange;
    if (self.frame.size.height > 100) {
        jiange = 25;
        scoreImg = GetImage(@"user_button_star.png");
        hightScoreImg = GetImage(@"user_button_star_sel.png");
    }else {
        jiange = 4;
        scoreImg = GetImage(@"user_icon_star2.png");
        hightScoreImg = GetImage(@"user_icon_star.png");
    }

    for (int i = 0; i < 5; i++) {
        UIButton *scoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [scoreBtn setImage:scoreImg forState:UIControlStateNormal];
        [scoreBtn setImage:hightScoreImg forState:UIControlStateSelected];
        [scoreBtn setImage:hightScoreImg forState:UIControlStateHighlighted];
        [scoreBtn setShowsTouchWhenHighlighted:YES];
        [scoreBtn setFrame:CGRectMake( i* (scoreImg.size.width + jiange), 0, scoreImg.size.width, scoreImg.size.height)];
        scoreBtn.tag = i;
        if (jiange == 25) { //  为大星星时才有点击功能
            [scoreBtn addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
        }else [self setUserInteractionEnabled:NO];
        
        [self addSubview:scoreBtn];
        
        [imageViews addObject:scoreBtn];
//        [scoreImgView release];
    }
    
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, 5 * scoreImg.size.width + jiange * 4, scoreImg.size.height)];
}

- (void)clicked:(UIButton *)btn
{
    for (UIButton *imageview in imageViews) {
        [imageview setSelected:NO];
    }
    
    for (int i = 0; i <= btn.tag; i++) {
        [[imageViews objectAtIndex:i]setSelected:YES];
    }
    
    if ([self.delegate respondsToSelector:@selector(scoreImgViews:clickedScore:)]) {
        [self.delegate scoreImgViews:self clickedScore:btn.tag + 1];
    }
}

- (void)scoreImageViewWithScore:(NSInteger)score
{
    
    for (UIButton *imageview in imageViews) {
        [imageview setSelected:NO];
    }
    
    if (score > 5) {
        return;
    }
    
    for (int i = 0; i < score; i++) {
        [[imageViews objectAtIndex:i]setSelected:YES];
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
