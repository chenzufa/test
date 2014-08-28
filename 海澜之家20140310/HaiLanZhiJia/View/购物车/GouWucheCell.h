//
//  GouWucheCell.h
//  HaiLanZhiJia
//
//  Created by 蒋遂明 on 13-11-26.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodEntity.h"
#import "ClickedImageDelegate.h"
@protocol GouwuCheChangeDelegate <NSObject>

-(void)selectGood:(GoodEntity  *)aGoodEntity;

-(void)changeSelected:(BOOL)select ofIndex:(int)index;
-(void)changeNumber:(NSString *)number ofIndex:(int)index;
-(void)deleteSelectedOfIndex:(int)index;
-(void)showNumberSelectorOfIndex:(int)index;

@end

@interface GouWucheCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic,assign)id<GouwuCheChangeDelegate>  delegate;
@property (nonatomic,retain)UIView *contentView;
@property (nonatomic) int                               cellIndex;
@property (nonatomic) BOOL                              isEditing;

@property (nonatomic,retain)GoodEntity                  *myEntity;
@property (nonatomic,retain)UIButton                     *btnNumber;
@property (nonatomic,retain)UILabel                     *labPrice;

@property (nonatomic,retain)NSArray                     *myEntityArr;

@property (nonatomic, assign)id <ClickedImageDelegate> clickedDelegate;
-(void)createCellByEntityArray:(NSArray *)entityArray;

@end
