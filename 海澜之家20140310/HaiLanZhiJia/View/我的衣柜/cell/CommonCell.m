//
//  CommonCell.m
//  MeiLiYun
//
//  Created by summer on 13-9-30.
//  Copyright (c) 2013年 com.donson. All rights reserved.
//

#import "CommonCell.h"

@implementation CommonCell
{
    UIImageView *arrowImgView;
//    UILabel *lab;
//    UIImageView *backImgView ;
}

- (void)dealloc
{
    [arrowImgView release];
//    [lab release];
//    [backImgView release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        arrowImgView = [[UIImageView alloc]initWithImage:GetImage(@"icon_next.png")];
        [arrowImgView setFrame:CGRectMake(283, 0, arrowImgView.image.size.width, arrowImgView.image.size.height)];
        [arrowImgView setCenter:CGPointMake(arrowImgView.center.x, self.center.y)];
        [self addSubview:arrowImgView];
        
        
    }
    return self;
}

//- (void)createNumbersInCelladdNumbersAtCenterX:(float)x centerY:(float)y            //添加显示信息数量的圆点
//{
//    UIImage *img = GetImage(@"消息提示.png");
//    if (!backImgView) {
//        backImgView = [[UIImageView alloc]initWithImage:img];
//        [backImgView setFrame:CGRectMake(0, 0, GetImageWidth(img), GetImageHeight(img))];
//        [backImgView setCenter:CGPointMake(x, y)];
//        [backImgView setHidden:YES];
//    }
//    
//    if (!lab) {
//        lab = [[UILabel alloc]initWithFrame:CGRectMake(backImgView.frame.origin.x, backImgView.frame.origin.y - 1, backImgView.frame.size.width, backImgView.frame.size.height)];
//        [lab setFont:GETFONT(FontSizeSmall)];
//        [lab setBackgroundColor:[UIColor clearColor]];
//        [lab setTextColor:[UIColor whiteColor]];
//        [lab setTextAlignment:NSTextAlignmentCenter];
//        [lab setHidden:YES];
//    }
//    
//    [self addSubview:backImgView];
//    [self addSubview:lab];
//        
//}
//
//- (void)setNumber:(int)num
//{
//    if (num > 0) {
//        [backImgView setHidden:NO];
//        [lab setHidden:NO];
//        if (num > 99) {
//            [lab setText:@"N"];
//        }else [lab setText:[NSString stringWithFormat:@"%i",num]];
//
//    }else {
//        [backImgView setHidden:YES];
//        [lab setHidden:YES];
//    }
//}

- (void)setArrowCenterY:(float)y
{
    [arrowImgView setCenter:CGPointMake(arrowImgView.center.x, y)];
}

- (void)setArrowCenterX:(float)x Y:(float)y
{
    [arrowImgView setCenter:CGPointMake(x, y)];
}

- (void)setArrowHidden:(BOOL)hidden
{
    [arrowImgView setHidden:hidden];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
