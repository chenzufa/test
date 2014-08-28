//
//  NotShowClothCell.h
//  HaiLanZhiJia
//
//  Created by chenzufa on 13-12-2.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotShowClothCell : UITableViewCell

@property(nonatomic , retain)UIImageView* imgView;  //商品图片
@property(nonatomic , retain)UILabel* name;         //商品名字
@property(nonatomic , retain)UILabel* color;        //商品颜色大小
@property(nonatomic , retain)UILabel* date;         //购买日期

@end
