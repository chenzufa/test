//
//  SPLieBiaoCell.h
//  HaiLanZhiJia
//
//  Created by xiaojiaxi on 13-11-27.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ShangPinLieBiaoObject.h"
#import "GoodEntity.h"
@interface SPLieBiaoCell : UITableViewCell
@property(nonatomic,retain)GoodEntity *object;
+(CGFloat)cellHeight:(GoodEntity*)entity;
@end
