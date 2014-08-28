//
//  BuyForColourVC.h
//  HaiLanZhiJia
//
//  Created by creaver on 13-11-26.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CommonViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreImage/CoreImage.h>
#import <CoreVideo/CoreVideo.h>
#import "SparateVC.h"


#import "DSRequest.h"
@interface BuyForColourVC : CommonViewController<AVCaptureVideoDataOutputSampleBufferDelegate,DSRequestDelegate>{
}

@end


AVCaptureSession *capSession;
AVAssetWriter *assetWriter;
AVCaptureVideoPreviewLayer *videoPreviewLayer;
AVCaptureStillImageOutput *stillImageOutput;
AVCaptureVideoDataOutput *videoDataOutput;

AVAssetWriterInput *assetWriterAudioIn;
AVAssetWriterInput *assetWriterVideoIn;