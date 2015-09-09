//
//  ViewController.m
//  DragResizeView
//
//  Created by Phon Visoth on 9/3/15.
//  Copyright (c) 2015 MCNC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    CGPoint offset;
    UIView *test;
    UIView *viewss;
    BOOL checkDirection;
    BOOL detectFinger;
    int totalTouch;
    AVCaptureVideoPreviewLayer* captureVideoPreviewLayer;
    CALayer *viewLayer;
}
@end

@implementation ViewController
@synthesize  session, videoDevice, videoInput, stillImageOutput;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    viewss = [[UIView alloc]initWithFrame:CGRectMake(0, 568/2, 320, 568/2)];
    [viewss setBackgroundColor:[UIColor blackColor]];
    [viewss setAlpha:0];
    [self.view addSubview:viewss];
    
    test = [[UIView alloc]initWithFrame:CGRectMake(0, 568/2, 320, 568/2)];
    [test setBackgroundColor:[UIColor blackColor]];
    [test setTag:1];
    [self.view addSubview:test];
    [self.view.superview setMultipleTouchEnabled:NO];
    [test setMultipleTouchEnabled:NO];
    
    
    self.session  = [[AVCaptureSession alloc]init];
    self.session.sessionPreset = AVCaptureSessionPresetPhoto;
    
    self.videoDevice = [self backCamera];
    self.videoInput = [AVCaptureDeviceInput deviceInputWithDevice:self.videoDevice error:nil];
    [self.session addInput:self.videoInput];
    captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [captureVideoPreviewLayer setName:@"cameraLayer"];
    
    viewLayer = [[self view] layer];
    [viewLayer setName:@"cameraLayer"];
    [viewLayer setMasksToBounds:YES];
    captureVideoPreviewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    [[captureVideoPreviewLayer connection]setVideoOrientation:AVCaptureVideoOrientationPortrait];
    captureVideoPreviewLayer.frame =viewss.frame;
    [captureVideoPreviewLayer setMasksToBounds:YES];

//    oriPos = CGRectMake(captureVideoPreviewLayer.frame.origin.x, captureVideoPreviewLayer.frame.origin.y, captureVideoPreviewLayer.frame.size.width, captureVideoPreviewLayer.frame.size.height) ;
    
    
    AVCaptureVideoDataOutput *output=[[AVCaptureVideoDataOutput alloc]init];
    [self.session addOutput:output];
    
    
    [viewLayer addSublayer:captureVideoPreviewLayer];
    
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    [self.session addOutput:stillImageOutput];
    [self.session startRunning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *aTouch = [touches anyObject];
    if(aTouch.view.tag ==1)
    {
        NSLog(@"------This is first view");
        offset = [aTouch locationInView:test];
        NSLog(@"Start");
    }
    
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    
    UITouch *aTouch = [touches anyObject];
    CGPoint location = [aTouch locationInView:self.view.superview];
    CGPoint prevLocation = [aTouch previousLocationInView:self.view.superview];

    if(aTouch.view.tag ==1){
        [viewss setFrame:CGRectMake(0, 0, 320, 568)];
      
        
        [UIView beginAnimations:@"Dragging A DraggableView" context:nil];
        if((location.y-offset.y) > 0 )
        {
            if(checkDirection){
             //    test.frame= CGRectMake(0, location.y-offset.y, self.view.frame.size.width, 568 + offset.y - (location.y));
              captureVideoPreviewLayer.frame = CGRectMake(0, location.y-offset.y, self.view.frame.size.width, 568 + offset.y - (location.y));
        

                checkDirection = YES;
                CGFloat percentage = test.frame.size.height/(568/2);
                [viewss setAlpha:percentage-1];
                NSLog(@"Percentag:%f",(1-percentage));
            }
        }
//        NSLog(@"location y:%f",location.y);
        
        if((568 + offset.y - (location.y)) < (568/2))
        {
//            NSLog(@"YEs");
            checkDirection =NO;
        }
        else
            checkDirection = YES;
        
        
        [UIView commitAnimations];
        if (location.x - prevLocation.x > 0) {
            //finger touch went right
        } else {
            //finger touch went left
        }
        if (location.y - prevLocation.y > 0) {
            //finger touch went upwards
            detectFinger=YES;
        } else {
            //finger touch went downwards
            detectFinger=NO;
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
       if(!detectFinger)
       {
            [UIView animateWithDuration:0.2f
                             animations:^{
                                 test.frame = CGRectMake(0, 0, self.view.frame.size.width, 568);
                                 captureVideoPreviewLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, 568);
                                 [viewss setAlpha:1];
                             }];
        }
        else
        {
            [UIView animateWithDuration:0.2f
                             animations:^{
                                 test.frame = CGRectMake(0, 568/2, 320, 568/2);
                                 captureVideoPreviewLayer.frame =   CGRectMake(0, 568/2, 320, 568/2);
                                 [viewss setAlpha:0];
                             }];
    
        }
    NSLog(@"end");
}


// Utility Function to get the back camera device
- (AVCaptureDevice *)backCamera
{
    //Get all available devices, loop through and get the back position camera
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == AVCaptureDevicePositionBack)
        {
            return device;
        }
    }
    return nil;
}


@end
