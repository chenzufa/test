//
//  SearchHistoryCell.m
//  HaiLanZhiJia
//
//  Created by 蒋遂明 on 13-11-25.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "SearchHistoryCell.h"

@implementation SearchHistoryCell
@synthesize labTitle;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.0, 0.0, MainViewWidth, 45.0)];
        myLabel.backgroundColor = [UIColor clearColor];
        myLabel.textColor = TEXT_GRAY_COLOR;
        myLabel.font = SYSTEMFONT(14);
        self.labTitle = myLabel;
        
        [self.contentView addSubview:myLabel];
        [myLabel release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
