//
//  MycollectionCell.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-21.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "MycollectionCell.h"

@implementation MycollectionCell
{
    UIButton *imgViewHead;
    UILabel *labTitle;
    UILabel *labMoney;
    
    UIButton *btnDelete;
}

- (void)dealloc
{
//    [imgViewHead release];
    [labTitle release];
    [labMoney release];
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

- (void)initUI
{
    UIImage *bgBtn = GetImage(@"home_photo2.png");
    imgViewHead = [UIButton buttonWithType:UIButtonTypeCustom];
    [imgViewHead setFrame:CGRectMake(15, 7, 87, 91)];
//    [imgViewHead setShowsTouchWhenHighlighted:YES];
    [imgViewHead setUserInteractionEnabled:NO];
    [imgViewHead setContentEdgeInsets:UIEdgeInsetsMake(3, 3, 7, 3)];
    [imgViewHead setBackgroundImage:bgBtn forState:UIControlStateNormal];
    [self.contentView addSubview:imgViewHead];
    
    labTitle = [[UILabel alloc]initWithFrame:CGRectMake(imgViewHead.frame.origin.x + imgViewHead.frame.size.width + 10, 14, 195, 36)];
    [labTitle setFont:SetFontSize(FontSize15)];
    [labTitle setTextColor:ColorFontBlack];
    [labTitle setNumberOfLines:2];
    [self.contentView addSubview:labTitle];
    
    labMoney = [[UILabel alloc]initWithFrame:CGRectMake(labTitle.frame.origin.x, labTitle.frame.origin.y + labTitle.frame.size.height + 25, 100, FontSize15)];
    [labMoney setFont:SetFontSize(FontSize15)];
    [labMoney setTextColor:ColorFontRed];
    [self.contentView addSubview:labMoney];
    
    btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDelete setImage:GetImage(@"button_delete.png") forState:UIControlStateNormal];
    [btnDelete setImage:GetImage(@"button_delete_press.png") forState:UIControlStateHighlighted];
    [btnDelete setFrame:CGRectMake(250, 62, btnDelete.imageView.image.size.width, btnDelete.imageView.image.size.height)];
    [btnDelete addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btnDelete];
    [btnDelete setHidden:YES];
}

- (void)setBtnDeleteHidden:(BOOL)hidden
{
    [btnDelete setHidden:hidden];
}

- (void)setBtnDeleteTag:(int)tag // 设置删除按钮的tag值
{
    [btnDelete setTag:tag];
}

- (void)clicked:(UIButton*)btn
{
    if ([self.delegate respondsToSelector:@selector(myCollectionCell:clickedDeleteButton:)]) {
        [self.delegate myCollectionCell:self clickedDeleteButton:btn];
    }
}

- (void)setImgViewHead:(NSString *)strImage labTitle:(NSString *)strTitle labMoney:(NSString *)strMoney
{
    [imgViewHead setImageWithURL:[NSURL URLWithString:strImage] forState:UIControlStateNormal];
    
    [labTitle setText:strTitle];
    
    [labMoney setText:[NSString stringWithFormat:@"￥%@",strMoney]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
