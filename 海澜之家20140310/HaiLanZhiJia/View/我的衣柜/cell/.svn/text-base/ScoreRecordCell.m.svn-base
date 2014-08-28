//
//  ScoreRecordCell.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-26.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "ScoreRecordCell.h"

@implementation ScoreRecordCell
{
    UILabel *labTime;
    UILabel *labMessage;
}

- (void)dealloc
{
    [labTime release];
    [labMessage release];
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
    labTime = [[UILabel alloc]initWithFrame:CGRectMake(10, 6, 300, FontSize12)];
    [labTime setFont:SetFontSize(FontSize12)];
    [labTime setTextColor:RGBCOLOR(150, 150, 150)];
    [labTime setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:labTime];
    
    labMessage = [[UILabel alloc]initWithFrame:CGRectMake(labTime.frame.origin.x, labTime.frame.origin.y + labTime.frame.size.height + 6, labTime.frame.size.width, FontSize15)];
    [labMessage setFont:SetFontSize(FontSize15)];
    [labMessage setTextColor:ColorFontRed];
    [labMessage setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:labMessage];
}

- (void)setLabTime:(NSString *)strTime labMessage:(NSString *)strMessage
{
    [labTime setText:strTime];
    [labMessage setText:strMessage];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
