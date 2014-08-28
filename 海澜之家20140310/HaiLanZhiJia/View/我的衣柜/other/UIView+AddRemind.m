//
//  UIView+SetNumber.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-12-25.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "UIView+AddRemind.h"

@implementation UIView (AddRemind)

- (void)showRedCircleRemind:(BOOL)show
{
    UIImageView *bgimg = (UIImageView *)[self viewWithTag:99];
    
    if (!bgimg) {
        bgimg = [[UIImageView alloc]initWithImage:GetImage(@"user_icon_remind.png")];
        [bgimg setTag:99];
        [bgimg setFrame:CGRectMake(self.frame.size.width - 10, 3, bgimg.image.size.width, bgimg.image.size.height)];
        [self addSubview:bgimg];
        
        [bgimg release];
    }
    
    [bgimg setHidden:!show];

}

@end
