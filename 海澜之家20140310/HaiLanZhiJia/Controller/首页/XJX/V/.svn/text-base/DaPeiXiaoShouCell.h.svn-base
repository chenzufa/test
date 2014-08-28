//
//  DaPeiXiaoShouCell.h
//  HaiLanZhiJia
//
//  Created by xiaojiaxi on 13-11-26.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuitDetailEntity.h"
@class DaPeiXiaoShouCell;
@protocol DaPeiXiaoShouCellDelegate <NSObject>
@optional
-(void)cell:(DaPeiXiaoShouCell*)cell btnClicked:(UIButton*)btn;
@end

@interface DaPeiXiaoShouCell : UITableViewCell
@property(nonatomic,retain)SuitEntity *object;
@property(nonatomic,assign)id<DaPeiXiaoShouCellDelegate> delegate;
+(CGFloat)cellHeight:(SuitDetailEntity*)entity;
@end
