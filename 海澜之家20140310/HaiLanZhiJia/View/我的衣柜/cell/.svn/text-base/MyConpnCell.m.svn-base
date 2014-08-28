//
//  MyConpnCell.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-25.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "MyConpnCell.h"

@implementation MyConpnCell
{
    UILabel *label;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIEdgeInsets inset = UIEdgeInsetsMake(10, 10, 10, 10);
        UIImage *backImg = GetImage(@"bg_list.png");
        UIImage *selectBackImg = GetImage(@"bg_list_press.png");
        backImg = [backImg resizableImageWithCapInsets:inset];
        selectBackImg = [selectBackImg resizableImageWithCapInsets:inset];
        self.backgroundView = [[[UIImageView alloc]initWithImage:backImg]autorelease];
        self.selectedBackgroundView = [[[UIImageView alloc]initWithImage:selectBackImg]autorelease];
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    label = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 200, FontSize15)];
    [label setFont:SetFontSize(FontSize15)];
    [label setTextColor:ColorFontBlack];
    [self.contentView addSubview:label];
}

- (void)setLabelText:(NSString *)text
{
    [label setText:text];
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
