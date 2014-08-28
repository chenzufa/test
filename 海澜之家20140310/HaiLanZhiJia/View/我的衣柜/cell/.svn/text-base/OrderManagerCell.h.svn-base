//
//  OrderManagerCell.h
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-21.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CommonCell.h"
@class OrderManagerCell;
@protocol OrderMagagerCellDelegate <NSObject>

@optional
- (void)orderManagerCell:(OrderManagerCell *)cell clickedAtButtonIndex:(NSInteger)i cellType:(NSInteger)type;  //type  标记cell的类型是进行中  已完成 还是无效订单

@end

@interface OrderManagerCell : CommonCell

typedef enum{
    
    CellTypeGoing,
    CellTypeFinish,
    CellTypeNoService
    
}CellType;

@property (nonatomic, assign) id <OrderMagagerCellDelegate> delegate;
@property (nonatomic, retain) OrderEntity *myEntity;
@property (nonatomic, assign) CellType cellType;



-(void)setContentsByOrderEntity:(OrderEntity *)entity;
@end
