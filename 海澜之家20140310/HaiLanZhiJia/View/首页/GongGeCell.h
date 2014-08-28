//
//  GongGeCell.h
//  HaiLanZhiJia
//
//  Created by creaver on 13-11-26.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSCollectionViewCell.h"
@interface GongGeCell : PSCollectionViewCell

-(void)creatCell:(NSString *)urlString andName:(NSString *)nameString andMuch:(NSString *)muchString;

-(void)creatShaiDanCell:(NSString *)urlString andName:(NSString *)nameString;

@end
