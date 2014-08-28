//
//  CellUnitView.h
//  HaiLanZhiJia
//
//  Created by xiaojiaxi on 13-11-28.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ShangPinLieBiaoObject.h"
#import "GoodEntity.h"
@class SPGongGeCell;

@interface CellUnitView : UIView
@property(nonatomic,retain)GoodEntity *object;
@property(nonatomic,retain)SPGongGeCell *cell;
- (id)initWithFrame:(CGRect)frame tagret:(SPGongGeCell*)cell tag:(int)theTag;
@end
