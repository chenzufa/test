//
//  SingleCell.h
//  HaiLanZhiJia
//
//  Created by creaver on 13-11-26.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleCell : UITableViewCell


-(void)creatCell:(NSString *)imageString andName:(NSString *)nameString andMuch:(NSString *)muchString;
+(float)getCellHeight:(GoodEntity *)goodEntity;
@end
