//
//  GiftCell.h
//  HaiLanZhiJia
//
//  Created by 蒋遂明 on 13-11-28.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresentationEntity.h"

@protocol GiftSizeColorDelegate <NSObject>

-(void)selectSizeandColorOfIndex:(NSIndexPath *)indexPath;
-(void)giftSelected:(BOOL)select ofIndex:(NSIndexPath *)indexPath;

@end

@interface GiftCell : UITableViewCell

@property (nonatomic,assign)id<GiftSizeColorDelegate>   delegate;
@property (nonatomic,retain)PresentationEntity          *entity;
@property (nonatomic,retain) NSIndexPath                       *cellIndex;

-(void)resetDateByEntity:(PresentationEntity *)aEntity ofIndex:(NSIndexPath *)indexPath;

@end
