//
//  AddressManagerCell.h
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-22.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddressManagerCell;
@protocol AddressManagerCellDelegate <NSObject>

@optional
- (void)addressManagerCell:(AddressManagerCell *)cell clickedEditRow:(NSInteger)row;

@end

@interface AddressManagerCell : UITableViewCell

@property (assign, nonatomic) id <AddressManagerCellDelegate> delegate;

- (void)setselectAddress:(BOOL)selected;
- (void)setlabName:(NSString *)strName labTel:(NSString *)strTel labAdd:(NSString *)strAdd row:(NSInteger)row;
@end
