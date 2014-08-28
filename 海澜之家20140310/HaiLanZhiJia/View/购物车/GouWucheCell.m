//
//  GouWucheCell.m
//  HaiLanZhiJia
//
//  Created by 蒋遂明 on 13-11-26.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "GouWucheCell.h"

@implementation GouWucheCell
@synthesize cellIndex;
@synthesize isEditing;

@synthesize myEntity;
@synthesize labPrice;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)createCellByEntityArray:(NSArray *)entityArray
{
    self.myEntityArr = entityArray;
    int editX = 0;
    int editMoreX = 0;
    if (self.isEditing) {
        editX = 12;
        editMoreX = 106;
    }else{
        editX = 35;
        editMoreX = 130;
    }
    
    self.myEntity = [entityArray objectAtIndex:0];
    
    
    for (UIView *view in [self.contentView subviews]) {
        [view removeFromSuperview];
    }
    
    int number = [entityArray count];
    UIView *contentV = nil;
    int entityY = 0;
    
    if (number==1) {
        contentV = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0, MainViewWidth, 110)];
        entityY = 0;
        
    }else
    {
        contentV = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0, MainViewWidth, 110*number+40)];
        entityY = 40;
    }
    
    
    contentV.backgroundColor = TEXT_BACKGROUD_COLOR;
    for (int i = 0; i< number; i++) {
        
        
        GoodEntity *aEntity = [entityArray objectAtIndex:i];
        
        UIView *entityView = [[UIView alloc]initWithFrame:CGRectMake(0.0, entityY, MainViewWidth, 110)];
        // 添加实体
        // 图片
        
        do {
            UIImage *myImg = GetImage(@"sale_photo_moren1.png");
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(editX, 10, 90, 90)];
            imageView.image = myImg;
            [imageView setImageWithURL:[NSURL URLWithString:aEntity.goodsimg]];
            [entityView addSubview:imageView];
            [imageView setUserInteractionEnabled:YES];
            [imageView release];
            
            imageView.tag = i;
            UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickItemAtIndex:)];
            [imageView addGestureRecognizer:tapGes];
            [tapGes release];
            
        } while (0);
        // 描述
        do {
            UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(editMoreX, 10, 190, 40.0)];
            myLabel.backgroundColor = [UIColor clearColor];
            myLabel.numberOfLines = 2;
            myLabel.textColor = TEXT_GRAY_COLOR;
            myLabel.font = SYSTEMFONT(12);
            [myLabel setText:aEntity.goodsname];
            
            [entityView addSubview:myLabel];
            [myLabel release];
        } while (0);
        do {
            UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(editMoreX, 50, 190, 35)];
            myLabel.backgroundColor = [UIColor clearColor];
            myLabel.numberOfLines = 2;
            myLabel.textColor = ColorAndSize;
            myLabel.font = SYSTEMFONT(10);
            [myLabel setText:[NSString stringWithFormat:@"颜色: %@\n尺码: %@",aEntity.color,aEntity.size]];
            
            [entityView addSubview:myLabel];
            [myLabel release];
        } while (0);
        
//        do {
//            UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(editMoreX, 66, 190, 15.0)];
//            myLabel.backgroundColor = [UIColor clearColor];
//            myLabel.numberOfLines = 2;
//            myLabel.textColor = TEXT_GRAY_COLOR;
//            myLabel.font = SYSTEMFONT(10);
//            [myLabel setText:aEntity.size];
//            
//            [entityView addSubview:myLabel];
//            [myLabel release];
//        } while (0);
        
//        UIView *entityView = [[UIView alloc]initWithFrame:CGRectMake(0.0, entityY, MainViewWidth, 110)];
        [contentV addSubview:entityView];
        [entityView release];
        
//        UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        myButton.tag = i;
//        [myButton setFrame:CGRectMake(0.0, entityY, MainViewWidth, 110)];
//        [myButton addTarget:self action:@selector(clickItemAtIndex:) forControlEvents:UIControlEventTouchUpInside];
//        [contentV addSubview:myButton];
        
        entityY += 110;
    }
    
    // 添加选择按钮、个数编辑 、金钱
    do {
        GoodEntity *aEntity = [entityArray objectAtIndex:0];
        
        UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *myIMG = GETIMG(@"car_button_gou_sel.png");
        
        [myButton setImage:GETIMG(@"car_button_select_press.png") forState:UIControlStateSelected];
        [myButton setImage:GETIMG(@"car_button_select.png") forState:UIControlStateNormal];
        [myButton setImageEdgeInsets:UIEdgeInsetsMake(myButton.imageView.image.size.height / 2, myButton.imageView.image.size.width / 2, myButton.imageView.image.size.height / 2, myButton.imageView.image.size.width / 2)];
        [myButton addTarget:self action:@selector(changeSelect:) forControlEvents:UIControlEventTouchUpInside];
//        [myButton setBackgroundColor:[UIColor redColor]];
        if (aEntity.isselect) {
            myButton.selected = YES;
        }
        
        UILabel *moneyLabel1 = [[UILabel alloc]init];
        moneyLabel1.backgroundColor = [UIColor clearColor];
        moneyLabel1.textColor = TEXT_GRAY_COLOR;
        moneyLabel1.font = SYSTEMFONT(12);
        [moneyLabel1 setText:@"套装:"];
        
        UILabel *moneyLabel2 = [[UILabel alloc]init];
        moneyLabel2.backgroundColor = [UIColor clearColor];
        moneyLabel2.textColor = TEXT_RED_COLOR;
        moneyLabel2.font = SYSTEMFONT(12);
        [moneyLabel2 setText:[NSString stringWithFormat:@"¥%@",aEntity.price]];
        
        UIButton *minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [minusButton setBackgroundImage:GETIMG(@"car_button_reduce_press.png") forState:UIControlStateSelected];
        [minusButton setBackgroundImage:GETIMG(@"car_button_reduce.png") forState:UIControlStateNormal];
        [minusButton addTarget:self action:@selector(minusNumber) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [addButton setBackgroundImage:GETIMG(@"car_button_add_press.png") forState:UIControlStateSelected];
        [addButton setBackgroundImage:GETIMG(@"car_button_add.png") forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addNumber) forControlEvents:UIControlEventTouchUpInside];
        
        
        UILabel *nbDscripLabel = [[UILabel alloc]init];
        nbDscripLabel.backgroundColor = [UIColor clearColor];
        nbDscripLabel.textAlignment = NSTextAlignmentRight;
        nbDscripLabel.textColor = TEXT_GRAY_COLOR;
        nbDscripLabel.font = SYSTEMFONT(12);
        [nbDscripLabel setText:@"数量:"];
        
        UIImage *myImg = GetImage(@"car_button_gou.png");
        UIImageView *numberImage = [[UIImageView alloc] init];
        numberImage.image = myImg;
//        car_button_gou@2x.png
        
        // 添加商品个数点击
        /*
        UILabel *numberLabel = [[UILabel alloc]init];
        self.labNumber = numberLabel;
        numberLabel.backgroundColor = [UIColor clearColor];
        numberLabel.textAlignment = NSTextAlignmentCenter;
        numberLabel.textColor = TEXT_GRAY_COLOR;
        numberLabel.font = SYSTEMFONT(12);
        [numberLabel setText:[NSString stringWithFormat:@"%d",aEntity.count]];
        */
        UIButton *numberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [numberBtn setTitle:[NSString stringWithFormat:@"%d",aEntity.count] forState:UIControlStateNormal];
        [numberBtn setTitleColor:TEXT_GRAY_COLOR forState:UIControlStateNormal];
        [numberBtn.titleLabel setFont:SYSTEMFONT(12)];
        [numberBtn addTarget:self action:@selector(numbClick) forControlEvents:UIControlEventTouchUpInside];
        self.btnNumber = numberBtn;
        
         
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteButton setBackgroundImage:GETIMG(@"button_delete_press.png") forState:UIControlStateSelected];
        [deleteButton setBackgroundImage:GETIMG(@"button_delete.png") forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        
        if (!self.isEditing) {
            if (number==1) {
                myButton.frame = CGRectMake(0,45 - 11,myIMG.size.width * 2,myIMG.size.height * 2);
                nbDscripLabel.frame = CGRectMake(200, 48, 80, 26);
                numberBtn.frame = CGRectMake(280, 48, 26, 26);
                numberImage.frame = CGRectMake(280, 48, 26, 26);
                moneyLabel1.hidden = YES;
                [moneyLabel2 setFrame:CGRectMake(editMoreX, 84, 200, 15)];
                nbDscripLabel.hidden = YES;

            
            }else
            {
                myButton.frame = CGRectMake(0,0,myIMG.size.width * 2,myIMG.size.height * 2);
                nbDscripLabel.frame = CGRectMake(200, 8, 80, 26);
                numberBtn.frame = CGRectMake(280, 8, 26, 26);
                numberImage.frame = CGRectMake(280, 8, 26, 26);
                [moneyLabel1 setFrame:CGRectMake(35.0, 8, 40, 26)];
                [moneyLabel2 setFrame:CGRectMake(72, 8, 100, 26)];
                nbDscripLabel.hidden = NO;
                
                
            }
            minusButton.hidden = YES;
            addButton.hidden = YES;
            deleteButton.hidden = YES;
        }else
        {
            if (number==1) {
                myButton.hidden = YES;
                nbDscripLabel.frame = CGRectMake(200, 48, 80, 26);
                numberBtn.frame = CGRectMake(250, 77, 26, 26);
                numberImage.frame = CGRectMake(250, 77, 26, 26);
                moneyLabel1.hidden = YES;
                [moneyLabel2 setFrame:CGRectMake(editMoreX, 86, 200, 20)];
                nbDscripLabel.hidden = YES;
                
                minusButton.frame = CGRectMake(218, 77, 26, 26);
                addButton.frame = CGRectMake(282, 77, 26, 26);
                deleteButton.frame =CGRectMake(250, 40, 60, 26);
                
            }else
            {
                myButton.hidden = YES;
                numberBtn.frame = CGRectMake(157, 8, 26, 26);
                numberImage.frame = CGRectMake(157, 8, 26, 26);
                [moneyLabel1 setFrame:CGRectMake(editX, 8, 40, 26)];
                [moneyLabel2 setFrame:CGRectMake(58.0, 8, 100, 26)];
                nbDscripLabel.hidden = YES;
                
                minusButton.frame = CGRectMake(123, 8, 26, 26);
                addButton.frame = CGRectMake(189, 8, 26, 26);
                deleteButton.frame =CGRectMake(250, 8, 60, 26);
            }
            minusButton.hidden = NO;
            addButton.hidden = NO;
            deleteButton.hidden = NO;
        }

        [contentV addSubview:myButton];
        [contentV addSubview:moneyLabel1];
        [moneyLabel1 release];
        [contentV addSubview:moneyLabel2];
        [moneyLabel2 release];
        
        [contentV addSubview:nbDscripLabel];
        [nbDscripLabel release];
        [contentV addSubview:numberImage];
        [numberImage release];
        [contentV addSubview:numberBtn];
        [contentV addSubview:addButton];
        [contentV addSubview:minusButton];
        [contentV addSubview:deleteButton];
    
    } while (0);

    [self.contentView addSubview:contentV];
    [contentV release];
    
}

-(void)minusNumber
{
    int i = [self.btnNumber.titleLabel.text intValue];
    if (i>1) {
        i--;
    }
    [self.btnNumber.titleLabel setText:[NSString stringWithFormat:@"%d",i]];
    
    [self refreshPrice];
}
-(void)addNumber
{
    int i = [self.btnNumber.titleLabel.text intValue];
    i++;
    [self.btnNumber.titleLabel setText:[NSString stringWithFormat:@"%d",i]];
    
    [self refreshPrice];
}

-(void)numbClick{
    if ([self.delegate respondsToSelector:@selector(showNumberSelectorOfIndex:)]) {
        [self.delegate showNumberSelectorOfIndex:self.cellIndex];
    }
}

// 发送个数
-(void)refreshPrice
{
    int i = [self.btnNumber.titleLabel.text intValue];
    
    self.labPrice.text = [NSString stringWithFormat:@"¥%d",[self.myEntity.price intValue] *i];
    
    [self.delegate changeNumber:self.btnNumber.titleLabel.text ofIndex:self.cellIndex];
}

// 删除商品
-(void)deleteAction
{
    [self.delegate deleteSelectedOfIndex:self.cellIndex];
}

// 查看商品（通过商品id）
-(void)clickItemAtIndex:(UITapGestureRecognizer *)tapGes
{
    
    
    GoodEntity *aEntity =[self.myEntityArr objectAtIndex:tapGes.view.tag];
    
    if ([self.delegate respondsToSelector:@selector( selectGood:)]) {
        [self.delegate selectGood:aEntity];
    }
}

// 更改是否选择
-(void)changeSelect:(UIButton *)button
{
    button.selected = !button.selected;
    
    
    [self.delegate changeSelected:button.selected ofIndex:self.cellIndex];
}


@end
