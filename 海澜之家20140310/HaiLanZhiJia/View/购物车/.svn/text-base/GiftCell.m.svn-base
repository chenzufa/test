//
//  GiftCell.m
//  HaiLanZhiJia
//
//  Created by 蒋遂明 on 13-11-28.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#define TAG 0x500

#import "GiftCell.h"

@implementation GiftCell

@synthesize delegate;
@synthesize entity;
@synthesize cellIndex;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createSubViews];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)createSubViews
{
    // 选择框
    do {
        UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
        myButton.tag = TAG +1;
        UIImage *myImg = GETIMG(@"car_button_select_press.png");
        [myButton setBackgroundImage:GETIMG(@"car_button_select_press.png") forState:UIControlStateSelected];
        [myButton setBackgroundImage:GETIMG(@"car_button_select.png") forState:UIControlStateNormal];
        [myButton setFrame:CGRectMake(11, 44, myImg.size.width, myImg.size.height)];
        [myButton addTarget:self action:@selector(changeSelect:) forControlEvents:UIControlEventTouchUpInside];
        myButton.userInteractionEnabled = NO;
        [self.contentView addSubview:myButton];

    } while (0);
    // 图片
    do {
        UIImage *myImg = GetImage(@"sale_photo_moren1.png");
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(35, 8, 90, 90)];
        imageView.tag = TAG +2;
        imageView.image = myImg;
        [self.contentView addSubview:imageView];
        [imageView release];
    } while (0);
    // 描述
    do {
        UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(130.0, 17, 190, 40.0)];
        myLabel.tag = TAG +3;
        myLabel.backgroundColor = [UIColor clearColor];
        myLabel.numberOfLines = 2;
        myLabel.textColor = TEXT_GRAY_COLOR;
        myLabel.font = SYSTEMFONT(12);
            
        [self.contentView addSubview:myLabel];
        [myLabel release];
    } while (0);
    do {
        UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(130.0, 62, 190, 12)];
        myLabel.tag = TAG +4;
        myLabel.backgroundColor = [UIColor clearColor];
        myLabel.numberOfLines = 2;
        myLabel.textColor = TEXT_GRAY_COLOR;
        myLabel.font = SYSTEMFONT(10);
        
        [self.contentView addSubview:myLabel];
        [myLabel release];
    } while (0);
    
    do {
        UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(130.0, 80, 190, 12.0)];
        myLabel.tag = TAG +5;
        myLabel.backgroundColor = [UIColor clearColor];
        myLabel.numberOfLines = 2;
        myLabel.textColor = TEXT_GRAY_COLOR;
        myLabel.font = SYSTEMFONT(10);
        [myLabel setText:@"180/104A(43)"];
        
        [self.contentView addSubview:myLabel];
        [myLabel release];
    } while (0);
    
    // 颜色尺码
    do {
        UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *myImg = GetImage(@"car_button_choose.png");
        [myButton setFrame:CGRectMake(235, 64, myImg.size.width, myImg.size.height)];
        [myButton setBackgroundImage:GETIMG(@"car_button_choose_press.png") forState:UIControlStateSelected];
        [myButton setBackgroundImage:GETIMG(@"car_button_choose.png") forState:UIControlStateNormal];
        [myButton addTarget:self action:@selector(selectColorSize:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:myButton];
        
    } while (0);
}

-(void)resetDateByEntity:(PresentationEntity *)aEntity ofIndex:(NSIndexPath *)index
{
    self.entity = aEntity;
    self.cellIndex = index;
    
    UIButton *checkBtn = (UIButton *)[self.contentView viewWithTag:(TAG +1)];
    checkBtn.selected = aEntity.isselect;
    
    if (aEntity.goodsimg) {
        UIImageView *photoV = (UIImageView *)[self.contentView viewWithTag:(TAG +2)];
        [photoV setImageWithURL:[NSURL URLWithString:aEntity.goodsimg]];
    }
    
    UILabel *descripLabel = (UILabel *)[self.contentView viewWithTag:(TAG +3)];
    descripLabel.text = aEntity.goodsname;
    
    UILabel *colorLabel = (UILabel *)[self.contentView viewWithTag:(TAG +4)];
    colorLabel.text = aEntity.selectcolor;
//    [colorLabel setText:[NSString stringWithFormat:@"颜色: %@ 尺码: %@",aEntity.selectcolor, aEntity.selectsize]];
    UILabel *sizeLabel = (UILabel *)[self.contentView viewWithTag:(TAG +5)];
    sizeLabel.text = aEntity.selectsize;
}

-(void)changeSelect:(UIButton *)button
{
    button.selected = !button.selected;
    
    //更改了是否选择
    if ([self.delegate respondsToSelector:@selector(giftSelected:ofIndex:)]) {
        [self.delegate giftSelected:button.selected ofIndex:self.cellIndex];
    }
    
}

-(void)selectColorSize:(UIButton *)button
{
    //更改颜色尺码
    if ([self.delegate respondsToSelector:@selector(selectSizeandColorOfIndex:)]) {
        [self.delegate selectSizeandColorOfIndex:self.cellIndex];
    }
    
}

- (void)setBtnSelected:(BOOL)selected{
    UIButton *selectButton = (UIButton *)[self.contentView viewWithTag: (TAG +1)];
    selectButton.selected = selected;
}

@end
