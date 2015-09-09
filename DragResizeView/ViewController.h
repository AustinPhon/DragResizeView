//
//  ViewController.h
//  DragResizeView
//
//  Created by Phon Visoth on 9/3/15.
//  Copyright (c) 2015 MCNC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) AVCaptureSession *session;
@property (strong) AVCaptureDevice *videoDevice;
@property (strong) AVCaptureDeviceInput *videoInput;
@property (strong) AVCaptureStillImageOutput *stillImageOutput;

@end

