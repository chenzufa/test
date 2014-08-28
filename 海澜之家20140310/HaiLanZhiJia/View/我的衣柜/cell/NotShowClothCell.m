//
//  NotShowClothCell.m
//  HaiLanZhiJia
//
//  Created by chenzufa on 13-12-2.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "NotShowClothCell.h"

@implementation NotShowClothCell
@synthesize imgView = _imgView;
@synthesize name = _name;
@synthesize color = _color;
@synthesize date = _date;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initViews];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) initViews{
    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 12, 86, 86)];
    [_imgView setContentMode:UIViewContentModeScaleAspectFill];
    _imgView.clipsToBounds = YES;
    [self.contentView addSubview:_imgView];
    
    _name = [[UILabel alloc]initWithFrame:CGRectMake(110, 14, 195, 37)];
    [_name setFont:SetFontSize(FontSize15)];
    [_name setTextColor:ColorFontBlack];
    [_name setNumberOfLines:2];
    [_name setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:_name];
    
    _color = [[UILabel alloc] initWithFrame:CGRectMake(110, 57, 190, 30)];
    [_color setFont:SetFontSize(FontSize12)];
    _color.numberOfLines = 2;
    [_color setTextColor:ColorAndSize];
    [_color setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:_color];
    
    _date = [[UILabel alloc]initWithFrame:CGRectMake(110, 90, 180, FontSize12)];
    [_date setFont:SetFontSize(FontSize12)];
    [_date setTextColor:ColorFontgray];
    [_date setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:_date];
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(305, 50, 9, 15);
    [button setBackgroundImage:[UIImage imageNamed:@"icon_next@2x.png"] forState:UIControlStateNormal];
    [self.contentView addSubview:button];
}


- (void) dealloc
{
    [_imgView release]; _imgView = nil;
    [_name release]; _name = nil;
    [_color release];_color = nil;
    [_date release]; _date = nil;
    [super dealloc];
}
@end
