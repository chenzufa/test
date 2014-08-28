//
//  RecentBrowseCell.m
//  HaiLanZhiJia
//
//  Created by chenzufa on 13-12-2.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "RecentBrowseCell.h"

@implementation RecentBrowseCell
@synthesize imgView = _imgView;
@synthesize name = _name;
@synthesize price = _price;

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
//    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 7, 86, 86)];
//    [_imgView setContentMode:UIViewContentModeScaleAspectFill];
//    [self.contentView addSubview:_imgView];
    
    UIImage *bgBtn = GetImage(@"home_photo2.png");
    _imgView = [UIButton buttonWithType:UIButtonTypeCustom];
    [_imgView setFrame:CGRectMake(15, 7, 87, 91)];
    //    [imgViewHead setShowsTouchWhenHighlighted:YES];
    [_imgView setUserInteractionEnabled:NO];
    [_imgView setContentEdgeInsets:UIEdgeInsetsMake(3, 3, 7, 3)];
    [_imgView setBackgroundImage:bgBtn forState:UIControlStateNormal];
    [self.contentView addSubview:_imgView];
    
    _name = [[UILabel alloc]initWithFrame:CGRectMake(110, 14, 195, 36)];
    [_name setFont:SetFontSize(FontSize15)];
    [_name setTextColor:ColorFontBlack];
    [_name setNumberOfLines:2];
    [_name setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:_name];
    
    _price = [[UILabel alloc]initWithFrame:CGRectMake(110, 72, 100, FontSize15)];
    [_price setFont:SetFontSize(FontSize15)];
    [_price setTextColor:ColorFontRed];
    [_price setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:_price];
}

- (void) layoutSubviews{
    [super layoutSubviews];
}

- (void) dealloc
{
//    [_imgView release]; _imgView = nil;
    [_name release]; _name = nil;
    [_price release]; _price = nil;
    [super dealloc];
}

@end
