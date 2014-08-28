//
//  PullImageCell.h
//  HaiLanZhiJia
//
//  Created by creaver on 13-11-25.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "PKCollectionViewCell.h"

@protocol pubuCelldelegate <NSObject>

-(void)selectPuBuCell:(int)index;

@end

@interface PullImageCell : PKCollectionViewCell


@property(nonatomic,retain)UIImageView *imageView;
@property(nonatomic,retain)UILabel *titleLable;
@property(nonatomic,assign)id<pubuCelldelegate> delgate;

-(void)creatCell:(NSString *)urlString andName:(NSString *)nameString andMuch:(NSString *)muchString andIndex:(int)indexCell;
+(float)getCellHeight :(GoodEntity *)goodEntity andIndex:(int)indexCell;
- (id)initWithFrame:(CGRect)frame;
@end
//PKCollectionViewCell