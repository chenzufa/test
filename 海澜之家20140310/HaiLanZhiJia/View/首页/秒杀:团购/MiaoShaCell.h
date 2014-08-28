//
//  MiaoShaCell.h
//  HaiLanZhiJia
//
//  Created by 蒋遂明 on 13-11-25.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpecialBuyListEntity.h"

@protocol MiaoShaTuanGouCellDelegate <NSObject>

-(void)SelectedIndex:(int)index;

@end

@interface MiaoShaCell : UITableViewCell
{
    int _timeLeft;
}

@property (nonatomic,assign)id<MiaoShaTuanGouCellDelegate> delegate;
@property (nonatomic,retain)SpecialBuyEntity *buyEntity;
@property (nonatomic)int cellIndex;
@property (nonatomic)BOOL isMiaoSha;
@property (nonatomic)BOOL started;
@property (nonatomic)dispatch_source_t atimer;

-(void)resetViewByEntity:(SpecialBuyEntity **)entity;
-(void)resetTimer;

@end
