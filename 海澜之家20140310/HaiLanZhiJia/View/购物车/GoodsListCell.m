//
//  GoodsListCell.m
//  HaiLanZhiJia
//
//  Created by 蒋遂明 on 13-12-3.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "GoodsListCell.h"

@implementation GoodsListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        [self createSubViews];
    }
    return self;
}

- (void)resetSubViewsByEntity:(GoodEntity *)entity row:(int)row
{
    self.backgroundColor = [UIColor clearColor];
    for (UIView *view in [self.contentView subviews]) {
        [view removeFromSuperview];
    }
    // 白色背景
    do {
        
        
    } while (0);
    // 图片
    do {
        UIImage *myImg = GetImage(@"sale_photo_moren1.png");
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 90, 90)];
        imageView.image = myImg;
        [imageView setImageWithURL:[NSURL URLWithString:entity.goodsimg]];
        [self.contentView addSubview:imageView];
        [imageView setUserInteractionEnabled:YES];
        [imageView release];
        imageView.tag = row;
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickeImageView:)];
        [imageView addGestureRecognizer:tapGes];
        [tapGes release];
        
        UIImageView *imgvPresent = [[UIImageView alloc]initWithImage:GetImage(@"赠品-icon.png")];
        [imgvPresent setFrame:CGRectMake(imageView.frame.size.width - imgvPresent.frame.size.width, 0, imgvPresent.frame.size.width, imgvPresent.frame.size.height)];
        [imageView addSubview:imgvPresent];
        [imgvPresent release];
        [imgvPresent setHidden:YES];
        if (entity.ispresentation == 0) {
            [imgvPresent setHidden:YES];
        }else {
            [imgvPresent setHidden:NO];
        }
    } while (0);
    // 描述
    do {
        UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 17, 190, 40.0)];
        myLabel.backgroundColor = [UIColor clearColor];
        myLabel.numberOfLines = 2;
        myLabel.textColor = TEXT_GRAY_COLOR;
        myLabel.font = SYSTEMFONT(12);
        [myLabel setText:entity.goodsname];
        
        [self.contentView addSubview:myLabel];
        [myLabel release];
    } while (0);
    do {
        UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(110.0, 50, 190, 25)];
        myLabel.backgroundColor = [UIColor clearColor];
        myLabel.numberOfLines = 2;
        myLabel.textColor = ColorAndSize;
        myLabel.font = SYSTEMFONT(10);
        [myLabel setText:entity.sizeandcolor];
        
        [self.contentView addSubview:myLabel];
        [myLabel release];
    } while (0);
    
//    // 颜色尺码
//    do {
//        UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(140.0, 62, 190, 12.0)];
//        myLabel.backgroundColor = [UIColor clearColor];
//        myLabel.numberOfLines = 2;
//        myLabel.textColor = TEXT_GRAY_COLOR;
//        myLabel.font = SYSTEMFONT(10);
//        [myLabel setText:entity.sizeandcolor];
//        
//        [self.contentView addSubview:myLabel];
//        [myLabel release];
//    } while (0);
    
    // 金钱
    do {
        UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(110.0, 80, 190, 12.0)];
        myLabel.backgroundColor = [UIColor clearColor];
        myLabel.numberOfLines = 1;
        myLabel.textColor = TEXT_RED_COLOR;
        myLabel.font = SYSTEMFONT(10);
        [myLabel setText:[NSString stringWithFormat:@"¥%@",entity.price]];
        
        [self.contentView addSubview:myLabel];
        [myLabel release];
        
    } while (0);
    // 数量
    do {
        UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 80, 100, 12.0)];
        myLabel.textAlignment = NSTextAlignmentRight;
        myLabel.backgroundColor = [UIColor clearColor];
        myLabel.numberOfLines = 1;
        myLabel.textColor = TEXT_GRAY_COLOR;
        myLabel.font = SYSTEMFONT(10);
        [myLabel setText:[NSString stringWithFormat:@"数量： %d",entity.count]];
        
        [self.contentView addSubview:myLabel];
        [myLabel release];
        
    } while (0);
    
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
