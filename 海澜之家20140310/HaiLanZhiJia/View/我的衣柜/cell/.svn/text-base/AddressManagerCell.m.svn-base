//
//  AddressManagerCell.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-22.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "AddressManagerCell.h"

@implementation AddressManagerCell
{
    UIImageView *imgViewSelectd;
    UILabel *labName;
    UILabel *labTel;
    UILabel *labAdd;
    UIButton *btnEdit;
}

- (void)dealloc
{
    [imgViewSelectd release];
    [labName release];
    [labTel release];
    [labName release];
    [labAdd release];
//    [imgViewEdit release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIEdgeInsets inset = UIEdgeInsetsMake(10, 10, 10, 10);
        UIImage *backImg = GetImage(@"bg_list.png");
//        UIImage *selectBackImg = GetImage(@"bg_list_press.png");
        backImg = [backImg resizableImageWithCapInsets:inset];
//        selectBackImg = [selectBackImg resizableImageWithCapInsets:inset];
        self.backgroundView = [[[UIImageView alloc]initWithImage:backImg]autorelease];
//        self.selectedBackgroundView = [[[UIImageView alloc]initWithImage:selectBackImg]autorelease];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    /////////选择地址的那个打钩图片  
//    imgViewSelectd = [[UIImageView alloc]initWithImage:GetImage(@"icon_select.png")];
//    [imgViewSelectd setFrame:CGRectMake(2, 25, imgViewSelectd.image.size.width, imgViewSelectd.image.size.height)];
//    [imgViewSelectd setHidden:YES];
//    [self.contentView addSubview:imgViewSelectd];
    
    imgViewSelectd = [[UIImageView alloc]initWithImage:GetImage(@"user_icon_addess.png")];
    [imgViewSelectd setFrame:CGRectMake(300 - imgViewSelectd.image.size.width, 68 - imgViewSelectd.image.size.height, imgViewSelectd.image.size.width, imgViewSelectd.image.size.height)];
    [imgViewSelectd setHidden:YES];
    [self.contentView addSubview:imgViewSelectd];
    
    labName = [[UILabel alloc]initWithFrame:CGRectMake(5, 8, 100, FontSize15 + 4)];//CGRectMake(25, 11, 80, FontSize15)];
    [self.contentView addSubview:labName];
    [labName setFont:SetFontSize(FontSize15)];
    [labName setTextColor:ColorFontBlack];
    
    
    labTel = [[UILabel alloc]initWithFrame:CGRectMake(labName.frame.size.width + 10, labName.frame.origin.y, 130, labName.frame.size.height)];//CGRectMake(130, labName.frame.origin.y, 130, FontSize15)];
    [self.contentView addSubview:labTel];
    [labTel setFont:SetFontSize(FontSize15)];
    [labTel setTextColor:ColorFontBlack];
    
    
    labAdd = [[UILabel alloc]initWithFrame:CGRectMake(labName.frame.origin.x, 31, 230, 12 * 2 + 6)];
    [self.contentView addSubview:labAdd];
    [labAdd setFont:SetFontSize(FontSize12)];
    [labAdd setTextColor:RGBCOLOR(120, 120, 120)];
    
    [labAdd setNumberOfLines:2];
    
    btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];//[[UIImageView alloc]initWithImage:GetImage(@"car_icon_address_edit.png")];
    [btnEdit setImage:GetImage(@"car_icon_address_edit.png") forState:UIControlStateNormal];
    [btnEdit setImage:GetImage(@"car_icon_address_edit.png") forState:UIControlStateHighlighted];
    [btnEdit setFrame:CGRectMake(275 - 20, 28 - 20, btnEdit.imageView.image.size.width + 40, btnEdit.imageView.image.size.height + 40)];
    [btnEdit setImageEdgeInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [btnEdit addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btnEdit];
}

- (void)setlabName:(NSString *)strName labTel:(NSString *)strTel labAdd:(NSString *)strAdd row:(NSInteger)row
{
    [labName setText:strName];
    [labTel setText:strTel];
    NSString *tempAdd = [strAdd stringByReplacingOccurrencesOfString:@" " withString:@""];
    [labAdd setText:tempAdd];
    [btnEdit setTag:row];
}

- (void)clicked:(UIButton *)btn
{
    if ( [self.delegate respondsToSelector:@selector(addressManagerCell:clickedEditRow:)]) {
        [self.delegate addressManagerCell:self clickedEditRow:btn.tag];
    }
}

- (void)setselectAddress:(BOOL)selected
{
    [imgViewSelectd setHidden:!selected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
//    [imgViewSelectd setHidden:NO];
    // Configure the view for the selected state
}

@end
