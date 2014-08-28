//
//  ShowClothCell.m
//  HaiLanZhiJia
//
//  Created by chenzufa on 13-12-2.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "ShowClothCell.h"

@implementation ShowClothCell
@synthesize imgView = _imgView;
@synthesize name = _name;
@synthesize color = _color;
@synthesize content = _content;
@synthesize smallImgs = _smallImgs;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
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
    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 7, 86, 86)];
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
    
    _content = [[UILabel alloc] initWithFrame:CGRectMake(10, 105, 290, 15)];
     _content.numberOfLines = 0;
    _content.backgroundColor = [UIColor clearColor];
    [_content setFont:[UIFont systemFontOfSize:14]];
    [_content setTextColor:RGBCOLOR(181, 175, 175)];
    [_content setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:nil];
    [_content addGestureRecognizer:tap];
    [tap release];
    
    [self.contentView addSubview:_content];
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(305, 50, 9, 15);
    [button setBackgroundImage:[UIImage imageNamed:@"icon_next@2x.png"] forState:UIControlStateNormal];
    [self.contentView addSubview:button];
    
    _smallImgs = [[ViewWithImages alloc] initWithFrame:CGRectMake(20, 0, 0, 0)];
    _smallImgs.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_smallImgs];
}

- (void)setSmallimgsWithArray:(NSArray*)array{
    for (UIView * view in _smallImgs.subviews) {
        [view removeFromSuperview];
    }
    _smallImgs.images = nil;
    _smallImgs.images = (NSMutableArray*)array;
    [_smallImgs createImageViews];
}

- (void) dealloc
{
    [_imgView release]; _imgView = nil;
    [_name release]; _name = nil;
    [_color release];_color = nil;
    [_smallImgs release];_smallImgs = nil;
    [_content release];_content = nil;
    [super dealloc];
}

@end
