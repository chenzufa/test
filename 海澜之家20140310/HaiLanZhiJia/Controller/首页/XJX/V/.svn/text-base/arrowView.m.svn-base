//
//  arrowView.m
//  HaiLanZhiJia
//
//  Created by xiaojiaxi on 13-11-27.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "arrowView.h"
#import <QuartzCore/QuartzCore.h>

@implementation arrowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    [self drawPrevButton:CGPointMake(0, 0)];
    [self drawNextButton:CGPointMake(0, 0)];
}

//画上
- (void)drawPrevButton:(CGPoint)leftTop
{
    if (_isTop==YES)
    {
        _R = 29;
        _G = 20;
        _B = 92;
    }else
    {
        _R = 174;
        _G = 169;
        _B = 169;
    }
	CGContextRef context = UIGraphicsGetCurrentContext();
    //设置画笔颜色
    CGContextSetRGBStrokeColor(context,_R/255.0,_G/255.0,_B/255.0,1);
    //设置填充颜色
    CGContextSetRGBFillColor(context,_R/255.0,_G/255.0,_B/255.0,1);
    CGContextMoveToPoint(context,0,self.bounds.size.height/2.0-1);
	CGContextAddLineToPoint(context, self.bounds.size.width/2,0);
	CGContextAddLineToPoint(context, self.bounds.size.width,self.bounds.size.height/2.0-1);
	CGContextAddLineToPoint(context,0,self.bounds.size.height/2.0-1);
	CGContextFillPath(context);
}
//画下
- (void)drawNextButton:(CGPoint)rightTop
{
    if (_isTop==YES)
    {
        _R = 29;
        _G = 20;
        _B = 92;
    }else
    {
        _R = 174;
        _G = 169;
        _B = 169;
    }
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context,_R/255.0,_G/255.0,_B/255.0,1);
    //设置填充颜色
    CGContextSetRGBFillColor(context,_R/255.0,_G/255.0,_B/255.0,1);
	CGContextMoveToPoint(context,0,self.bounds.size.height/2.0+1);
	CGContextAddLineToPoint(context,self.bounds.size.width,self.bounds.size.height/2.0+1);
	CGContextAddLineToPoint(context,self.bounds.size.width/2.0,self.bounds.size.height+1);
	CGContextAddLineToPoint(context, 0,self.bounds.size.height/2.0+1);
	CGContextFillPath(context);
}

@end
