//
//  SouSuoVC.h
//  HaiLanZhiJia
//
//  Created by 蒋遂明 on 13-11-20.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CommonViewController.h"
#import "SearchHistoryCell.h"
#import "iflyMSC/IFlySpeechRecognizer.h"
#import "BarCodeScanVC.h"
#import "MYAlertView.h"

#import "DSRequest.h"
#import "ReXiaoShangPinVC.h"

#import "MiaoShaVC.h"

@interface SouSuoVC : CommonViewController<DSRequestDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,IFlySpeechRecognizerDelegate,MYAlertViewDelegate>
{
    MYAlertView *alertView;
}

@property (nonatomic,retain)DSRequest               *aRequest;

@property (nonatomic,retain)UIScrollView      *hotKeyView;
@property (nonatomic,retain)UIView      *textInputView;
@property (nonatomic,retain)UITableView *historyTabView;
@property (nonatomic,retain)UITextField *inputTextField;
@property (nonatomic,retain)IFlySpeechRecognizer *iflySpeechRecognizer;

@property (nonatomic,retain)NSString *strSpeak;
@end
