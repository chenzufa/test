//
//  PKShowClothCell.h
//  HaiLanZhiJia
//
//  Created by chenzufa on 13-12-6.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "PKCollectionViewCell.h"

@protocol FaCelldelegate <NSObject>

-(void)selectPuBuCell:(int)index;

@end

@interface PKShowClothCell : PKCollectionViewCell

@property(nonatomic , retain)UIImageView* imageView;
@property(nonatomic , retain)UILabel* name;
@property(nonatomic,assign)id<FaCelldelegate> delgate;
- (void) initViews;

@end
