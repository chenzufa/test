//
//  MycollectionCell.h
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-21.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MycollectionCell;
@protocol MyCollectionCellDelegate <NSObject>

@optional
- (void)myCollectionCell:(MycollectionCell *)cell clickedDeleteButton:(UIButton *)btn;

@end

@interface MycollectionCell : UITableViewCell

@property (assign, nonatomic) id <MyCollectionCellDelegate> delegate;

- (void)setImgViewHead:(NSString *)strImage labTitle:(NSString *)strTitle labMoney:(NSString *)strMoney;
- (void)setBtnDeleteHidden:(BOOL)hidden;
- (void)setBtnDeleteTag:(int)tag;
@end
