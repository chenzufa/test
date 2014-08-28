//
//  CellUnitView.m
//  HaiLanZhiJia
//
//  Created by xiaojiaxi on 13-11-28.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CellUnitView.h"
#import "NetImageView.h"
#import <QuartzCore/QuartzCore.h>

@interface CellUnitView()
@property(nonatomic,retain)UIImageView *imageView_;
@property(nonatomic,retain)UILabel*nameLabel;
@property(nonatomic,retain)UILabel*jiaGeLabel;
@property(nonatomic,retain)UILabel*yanSeLabel;
@end

@implementation CellUnitView
-(void)dealloc
{
    [_nameLabel release];_nameLabel=nil;
    [_jiaGeLabel release];_jiaGeLabel=nil;
    [_yanSeLabel release];_yanSeLabel=nil;
    [_imageView_ release];_imageView_=nil;
    [_object release];_object=nil;
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame tagret:(SPGongGeCell*)cell tag:(int)theTag
{
    
    self = [super initWithFrame:frame];
    if (self)
    {
        CGFloat x = self.bounds.origin.x;
        CGFloat y = self.bounds.origin.y;
        CGFloat w = self.bounds.size.width;
        CGFloat h = self.bounds.size.height;
        
        UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, w, h)];
        view.image = [UIImage imageNamed:@"列表小图.png"];
        view.userInteractionEnabled = YES;
        [self addSubview:view];
        [view release];
        
        UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(x+3,y+3,w-6,h-12)];
        [view addSubview:imageV];
        imageV.userInteractionEnabled = YES;
        imageV.clipsToBounds = YES;
        self.imageView_=imageV;
        [imageV release];
        /*view.layer.shadowColor = [UIColor blackColor].CGColor;
        view.layer.shadowOffset = CGSizeMake(1.5,1);
        view.layer.shadowOpacity = 0.8;
        view.layer.shadowRadius = 1;
        UIBezierPath *path = [UIBezierPath bezierPath];
        w = view.bounds.size.width;
        h = view.bounds.size.height;
        x = view.bounds.origin.x;
        y = view.bounds.origin.y;
        CGPoint bottomLeft   = CGPointMake(x,y+h+1.5);
        CGPoint bottomRight  = CGPointMake(x+w,y+h+1.5);
        [path moveToPoint:bottomLeft];
        [path addQuadCurveToPoint:CGPointMake(x+(w/4),y+h)
                     controlPoint:CGPointMake(x+(w/8),y+h+0.75)];
        [path addQuadCurveToPoint:CGPointMake(x+(w/4)*3,y+h)
                     controlPoint:CGPointMake(x+(w/2),y+h)];
        [path addQuadCurveToPoint:bottomRight
                     controlPoint:CGPointMake(x+(w/4)*3,y+h+0.75)];
         view.layer.shadowPath = path.CGPath;*/
        
         x = self.bounds.origin.x;
         y = self.bounds.origin.y;
        UIImage *viewbtnI = GetImage(@"");
        UIButton *viewBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [viewBtn1 setBackgroundImage:viewbtnI forState:UIControlStateNormal];
        [viewBtn1 setBackgroundImage:GetImage(@"") forState:UIControlStateHighlighted];
        [viewBtn1 setFrame:CGRectMake(x,y,w,h)];
        [viewBtn1 addTarget:cell action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
        viewBtn1.tag = theTag;
        viewBtn1.backgroundColor = [UIColor clearColor];
        [view addSubview:viewBtn1];
        
        x=0;
        y=view.frame.size.height+view.frame.origin.y;
        w=152;
        h=(isBigeriOS7version)?40:35;
        UILabel *nameL = [[UILabel alloc]initWithFrame:CGRectMake(x,y,w,h)];
        nameL.backgroundColor = [UIColor clearColor];
        nameL.textAlignment = NSTextAlignmentCenter;
        nameL.font = [UIFont systemFontOfSize:15];
        nameL.textColor = RGBCOLOR(62,62,62);
        nameL.numberOfLines = 2;
        [self addSubview:nameL];
        self.nameLabel = nameL;
        [nameL release];
        
        y=nameL.frame.origin.y+nameL.frame.size.height;
        h=15;
        UILabel *jiaGeL = [[UILabel alloc]initWithFrame:CGRectMake(x,y,w,MAX(h, 15))];
        jiaGeL.backgroundColor = [UIColor clearColor];
        jiaGeL.textAlignment = NSTextAlignmentCenter;
        jiaGeL.font = [UIFont systemFontOfSize:14];
        jiaGeL.textColor = RGBCOLOR(220,40,49);
        jiaGeL.numberOfLines = 0;
        [self addSubview:jiaGeL];
        self.jiaGeLabel = jiaGeL;
        [jiaGeL release];
        
        y=jiaGeL.frame.origin.y+jiaGeL.frame.size.height;
        h=15;
        UILabel *yanSeL = [[UILabel alloc]initWithFrame:CGRectMake(x,y,w,MAX(h, 15))];
        yanSeL.backgroundColor = [UIColor clearColor];
        yanSeL.textAlignment = NSTextAlignmentLeft;
        yanSeL.font = [UIFont systemFontOfSize:14];
        yanSeL.textColor = RGBCOLOR(60,60,60);
        yanSeL.numberOfLines = 0;
        [self addSubview:yanSeL];
        self.yanSeLabel = yanSeL;
        [yanSeL release];
        
    }
    return self;

}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}
//-(void)clickedButton:(UIButton*)btn
//{
//  
//}
-(void)layoutSubviews
{
    [_imageView_ setImageWithURL:[NSURL URLWithString:_object.goodsimg] placeholderImage:[UIImage imageNamed:@""]];
    _nameLabel.text = _object.goodsname;
    NSString *xPStr = @"";
    if ([_object.price  hasPrefix:@"¥"])
    {
        xPStr = _object.price;
    }else
    {
        xPStr = [NSString stringWithFormat:@"¥%@",_object.price];
    }

    _jiaGeLabel.text = xPStr;

    /*CGSize size = [_object.goodsname sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(MAXFLOAT, 20)];
    if (size.width>152)
    {
        CGRect frame = _nameLabel.frame;
        frame.size.height = 40;
        _nameLabel.frame = frame;
        
        CGRect frame2 = _jiaGeLabel.frame;
        frame2.origin.y = _nameLabel.frame.origin.y+_nameLabel.frame.size.height;
        
    }*/
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
