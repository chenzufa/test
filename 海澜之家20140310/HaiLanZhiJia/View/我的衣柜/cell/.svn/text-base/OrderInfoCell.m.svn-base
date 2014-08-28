//
//  OrderInfoCell.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-12-5.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "OrderInfoCell.h"

@implementation OrderInfoCell
{
    UILabel *labLeft;
    UILabel *labRight;
    UIImageView *lineImgView;
}

- (void)dealloc
{
    [labRight release];
    [labLeft release];
    [lineImgView release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self initUI];
    }
    return self;
}

//  根据图片获取cell的背景
- (void)setBackgroundViewWithImage:(NSString *)strImage
{
    UIImageView *bgImgView = [[UIImageView alloc]initWithImage:GetImage(strImage)];
    [self setBackgroundView:bgImgView];
    [bgImgView release];
    if ([strImage isEqualToString:@"bg_list2_down.png"]) {
        [lineImgView setHidden:YES];
    }else [lineImgView setHidden:NO];
}

- (void)initUI
{
    labLeft = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 90, FontSize15)];
    [labLeft setFont:SetFontSize(FontSize15)];
    [labLeft setTextColor:ColorFontBlack];
    [self.contentView addSubview:labLeft];
    
    labRight = [[UILabel alloc]initWithFrame:CGRectMake(labLeft.frame.origin.x + labLeft.frame.size.width + 20, 5, 160, 36)];
    [labRight setFont:SetFontSize(FontSize12)];
    [labRight setNumberOfLines:2];
    [labRight setTextColor:RGBCOLOR(120, 120, 120)];
    [self.contentView addSubview:labRight];
    
    lineImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"segmentation_line.png"]]        ;
    [lineImgView setFrame:CGRectMake(00, self.frame.size.height - lineImgView.frame.size.height, lineImgView.image.size.width, lineImgView.image.size.height)];
    [self addSubview:lineImgView];
    
}

- (void)setlabLeft:(NSString *)strLeft labRight:(NSString *)strRight
{
    [labLeft setText:strLeft];
    [labRight setText:strRight];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
