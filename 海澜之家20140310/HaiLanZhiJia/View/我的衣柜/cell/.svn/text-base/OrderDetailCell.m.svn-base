//
//  OrderDetailCell.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-12-5.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "OrderDetailCell.h"

@implementation OrderDetailCell
{
//    UIImageView *imgViewHead;
    UILabel *labTitle;
    UILabel *labSize;
    UILabel *labMoney;
    UILabel *labCount;
}

- (void)dealloc
{
    [_imgViewHead release];
    [labTitle release];
    [labSize release];
    [labMoney release];
    [labCount release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initUI];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)setOtherRowBackGroundImageView  //  普通行的背景
{
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
    UIImage *img = [GetImage(@"bg_list2_middle.png") resizableImageWithCapInsets:insets];
    UIImage *imgbg = [GetImage(@"bg_list2_middle_press.png") resizableImageWithCapInsets:insets];
    [self setBackgroundView:[[[UIImageView alloc]initWithImage:img]autorelease]];
    [self setSelectedBackgroundView:[[[UIImageView alloc]initWithImage:imgbg]autorelease]];
}

- (void)setlastRowBackGroundImageView//   最后一行的背景
{
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
    UIImage *img = [GetImage(@"bg_list2_down.png") resizableImageWithCapInsets:insets];
    UIImage *imgbg = [GetImage(@"bg_list2_down_press.png") resizableImageWithCapInsets:insets];
    [self setBackgroundView:[[[UIImageView alloc]initWithImage:img]autorelease]];
    [self setSelectedBackgroundView:[[[UIImageView alloc]initWithImage:imgbg]autorelease]];
}

- (void)initUI
{
    _imgViewHead = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 90, 90)];
    [_imgViewHead setContentMode:UIViewContentModeScaleAspectFit];
    [_imgViewHead setUserInteractionEnabled:YES];
    [self.contentView addSubview:_imgViewHead];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickeImageView:)];
    [_imgViewHead addGestureRecognizer:tapGes];
    [tapGes release];
    
    UIImageView *imgvPresent = [[UIImageView alloc]initWithImage:GetImage(@"赠品-icon.png")];
    [imgvPresent setFrame:CGRectMake(_imgViewHead.frame.size.width - imgvPresent.frame.size.width, 0, imgvPresent.frame.size.width, imgvPresent.frame.size.height)];
    imgvPresent.tag = 189;
    [_imgViewHead addSubview:imgvPresent];
    [imgvPresent release];
    [imgvPresent setHidden:YES];
    
    labTitle = [[UILabel alloc]initWithFrame:CGRectMake(_imgViewHead.frame.origin.x + _imgViewHead.frame.size.width + 5, 12, 190, 30)];
    [labTitle setFont:SetFontSize(FontSize12)];
    [labTitle setTextColor:ColorFontBlack];
    [labTitle setNumberOfLines:2];
    [labTitle setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:labTitle];
    
    labSize = [[UILabel alloc]initWithFrame:CGRectMake(labTitle.frame.origin.x, labTitle.frame.origin.y + labTitle.frame.size.height , labTitle.frame.size.width, 25)];
    [labSize setFont:SetFontSize(FontSize10)];
    [labSize setNumberOfLines:2];
    [labSize setTextColor:ColorAndSize];
    [labSize setBackgroundColor:labTitle.backgroundColor];
    [self.contentView addSubview:labSize];

    
    labMoney = [[UILabel alloc]initWithFrame:CGRectMake(labTitle.frame.origin.x, labSize.frame.origin.y + labSize.frame.size.height + 10, labTitle.frame.size.width, FontSize10)];
    [labMoney setFont:SetFontSize(FontSize10)];
    [labMoney setTextColor:ColorFontRed];
    [labMoney setBackgroundColor:labTitle.backgroundColor];
    [self.contentView addSubview:labMoney];
    
    labCount = [[UILabel alloc]initWithFrame:CGRectMake(labTitle.frame.origin.x + labTitle.frame.size.width - 70, labMoney.frame.origin.y + 2, 70, FontSize10)];
    [labCount setFont:SetFontSize(FontSize10)];
    [labCount setTextColor:labSize.textColor];
    [labCount setBackgroundColor:[UIColor clearColor]];
    [labCount setTextAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:labCount];
}

- (void)setImgViewHead:(NSString *)strImage labTitle:(NSString *)strTitle labMoney:(NSString *)strMoney labSize:(NSString *)strSize goodsCount:(int)count ispresentation:(int)ispresentation
{
    [_imgViewHead setImageWithURL:[NSURL URLWithString:strImage] placeholderImage:GetImage(@"mall_details_photo.png")];
    
    UIImageView *zengpinimgv = (UIImageView *)[_imgViewHead viewWithTag:189];
    if (ispresentation == 0) {
        [zengpinimgv setHidden:YES];
    }else {
        [zengpinimgv setHidden:NO];
    }
    
    [labTitle setText:strTitle];
    [labSize setText:strSize];
    [labMoney setText:[NSString stringWithFormat:@"￥%@",strMoney]];
    [labCount setText:[NSString stringWithFormat:@"数量：%i",count]];
}

- (void)clickeImageView:(UITapGestureRecognizer *)tapGes
{
    if ([self.clickedDelegate respondsToSelector:@selector(clickedImageViewAtIndexPath:)]) {
        [self.clickedDelegate clickedImageViewAtIndexPath:[NSIndexPath indexPathForRow:tapGes.view.tag inSection:0]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
