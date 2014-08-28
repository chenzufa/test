//
//  CashConponCell.h
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-25.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CashConponCell : UITableViewCell

- (void)setlabCardNum:(NSString *)strCardNum labMoney:(NSString *)strMoney lablimitTime:(NSString *)strlimitTime labState:(NSString *)strState type:(int)type;


-(void)setCellSelected:(BOOL)cellSelected;

@end
