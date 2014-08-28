//
//  ShowClothCell.h
//  HaiLanZhiJia
//
//  Created by chenzufa on 13-12-2.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewWithImages.h"
@class ShowClothCell;
@protocol ShowClothCellDelegate <NSObject>

- (void)selectImgAtView:(ShowClothCell*)cell andIndex:(NSInteger)index;

@end

@interface ShowClothCell : UITableViewCell<ViewWithImagesDelegate>

@property(nonatomic , assign)id<ShowClothCellDelegate> delegate;
@property(nonatomic , retain)UIImageView* imgView;  //商品图片
@property(nonatomic , retain)UILabel* name;         //商品名字
@property(nonatomic , retain)UILabel* color;        //商品颜色大小
@property(nonatomic , retain)UILabel* content;      //晒单评价内容
@property(nonatomic , retain)ViewWithImages* smallImgs; //小图查看

- (void)setSmallimgsWithArray:(NSArray*)array;

@end
