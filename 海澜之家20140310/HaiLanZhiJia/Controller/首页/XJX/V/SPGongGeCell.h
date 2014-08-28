//
//  GongGeCell.h
//  HaiLanZhiJia
//
//  Created by xiaojiaxi on 13-11-27.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "ShangPinLieBiaoObject.h"
#import "GoodEntity.h"
@class SPGongGeCell;
@protocol SPGongGeCellDelegate <NSObject>
@optional
-(void)cell:(SPGongGeCell*)cell imageBtnClicked:(UIButton*)btn;
@end

@interface SPGongGeCell : UITableViewCell
@property(nonatomic,retain)NSArray *objects;
@property(nonatomic,assign)id<SPGongGeCellDelegate>delegate;
+(CGFloat)cellHeight:(GoodEntity*)entity;
//-(void)initSubview;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier rankCount:(int)rankCount;
@end
