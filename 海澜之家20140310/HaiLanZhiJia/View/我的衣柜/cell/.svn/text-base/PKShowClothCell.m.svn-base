//
//  PKShowClothCell.m
//  HaiLanZhiJia
//
//  Created by chenzufa on 13-12-6.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "PKShowClothCell.h"

@implementation PKShowClothCell
@synthesize imageView = _imageView;
@synthesize name = _name;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        [self initViews];
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _name = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    return self;
}
/*
 胡鹏添加
 */
-(void)clickPuBuCell:(UITapGestureRecognizer *)sender
{
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)sender;
    NSLog(@"ddddddddd:%d",[singleTap view].tag);//selectell
    int tag = [singleTap view].tag;
    if(self.delgate &&[self.delgate respondsToSelector:@selector(selectPuBuCell:)])
    {
        [self.delgate selectPuBuCell:tag];
    }
    
}

- (void) initViews
{
    
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.userInteractionEnabled  = YES;
    _imageView.clipsToBounds = YES;
    [self addSubview:_imageView];
    /*
     胡鹏加（用第三方的时候有的cell不能接受点击事件，自己加个UITapGestureRecognizer）
     */
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickPuBuCell:)];
    [_imageView addGestureRecognizer:tap];
    UIView *singleTapView = [tap view];
    singleTapView.tag = self.tag ;
    [tap release];
    
    
    _name.frame = CGRectMake(0, 0, 150, 10);
    _name.font = [UIFont systemFontOfSize:14];
    _name.backgroundColor = [UIColor clearColor];
    [self addSubview:_name];
}

- (void)dealloc{
    _imageView = nil;
    _name = nil;
    [super dealloc];
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
