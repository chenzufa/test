//
//  ScanHistroyCell.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-28.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "ScanHistroyCell.h"

@implementation ScanHistroyCell
{
    UIButton *imgViewHead;
    UILabel *labTitle;
    UILabel *labTime;
}

- (void)dealloc
{
//    [imgViewHead release];
    [labTime release];
    [labTitle release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    UIImage *bgBtn = GetImage(@"home_photo2.png");
    imgViewHead = [UIButton buttonWithType:UIButtonTypeCustom];
    [imgViewHead setFrame:CGRectMake(10, 7, 87, 91)];
    [imgViewHead setShowsTouchWhenHighlighted:YES];
    [imgViewHead setContentEdgeInsets:UIEdgeInsetsMake(3, 3, 7, 3)];
    [imgViewHead setBackgroundImage:bgBtn forState:UIControlStateNormal];
    [self.contentView addSubview:imgViewHead];
    
    labTitle = [[UILabel alloc]initWithFrame:CGRectMake(105, 14, 200, 36)];
    [labTitle setFont:SetFontSize(FontSize15)];
    [labTitle setTextColor:ColorFontBlack];
    [labTitle setNumberOfLines:2];
    [self.contentView addSubview:labTitle];
    
    labTime = [[UILabel alloc]initWithFrame:CGRectMake(labTitle.frame.origin.x, labTitle.frame.origin.y + labTitle.frame.size.height + 25, labTitle.frame.size.width, FontSize12)];
    [labTime setFont:SetFontSize(FontSize12)];
    [labTime setTextColor:RGBCOLOR(124, 124, 124)];
    [self.contentView addSubview:labTime];
    
}

- (void)setImgViewHead:(NSString *)strImage labTitle:(NSString *)strTitle labTime:(NSString *)strTime
{
    [imgViewHead setImageWithURL:[NSURL URLWithString:strImage] forState:UIControlStateNormal];
    [labTitle setText:strTitle];
    [labTime setText:strTime];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
