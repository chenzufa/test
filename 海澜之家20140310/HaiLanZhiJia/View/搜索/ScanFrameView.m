//
//  ScanFrameView.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-27.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "ScanFrameView.h"
#define Xx 18
#define Yy 45   // 边框Y轴坐标
@implementation ScanFrameView
{
    UIImageView *imgViewLine;
    NSTimer *timer;
}

- (void)dealloc
{
    [timer invalidate];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        
        imgViewLine = [[UIImageView alloc]initWithImage:GetImage(@"search_scan_line.png")];
        [imgViewLine setFrame:CGRectMake(Xx, Yy + 33 , imgViewLine.image.size.width,imgViewLine.image.size.height)];
        [self addSubview:imgViewLine];
        [imgViewLine release];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:4.5 target:self selector:@selector(startMoving) userInfo:nil repeats:YES];
        [timer fire];
        
        
        
    }
    return self;
}

- (void)startMoving
{
    [UIView animateWithDuration:2 animations:^(void)
     {
         [imgViewLine setFrame:CGRectMake(imgViewLine.frame.origin.x, Yy + 220, imgViewLine.frame.size.width, imgViewLine.frame.size.height)];
         
     }completion:^(BOOL finish)
     {
         if (finish) {
             
             [UIView animateWithDuration:2 animations:^(void){
                 [imgViewLine setFrame:CGRectMake(imgViewLine.frame.origin.x, Yy + 33, imgViewLine.frame.size.width, imgViewLine.frame.size.height)];
             }];
             
         }
     }];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor (context,  0, 0, 0, 0.7);//设置填充颜色
    
    UIImage *image = GetImage(@"search_scan_screen.png");
    //search_scan_line@@x
//    UIImage *image2 = GetImage(@"search_scan_line.png");
    CGContextFillRect(context, CGRectMake(0, 0, self.frame.size.height, Yy + 3 + 30));
    CGContextFillRect(context, CGRectMake(0, Yy + 3 + 30, Xx + 3, image.size.height - 6));
    CGContextFillRect(context, CGRectMake(Xx + image.size.width - 3, Yy + 3 + 30, Xx + 3, image.size.height - 6));
    CGContextFillRect(context, CGRectMake(0, Yy + image.size.height - 3 + 30, self.frame.size.width, self.frame.size.height - image.size.height - 50 + 30));
    
    CGContextDrawImage(context, CGRectMake(Xx, Yy + 30, image.size.width, image.size.height), image.CGImage);
//    CGContextDrawImage(context, CGRectMake(Xx, Yy + 30 + image.size.height / 2, image2.size.width, image2.size.height), image2.CGImage);
    
    
}


@end
