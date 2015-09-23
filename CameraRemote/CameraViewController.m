//
//  CameraViewController.m
//  CameraRemote
//
//  Created by Gretchen Walker on 9/22/15.
//  Copyright (c) 2015 Punch Through Design. All rights reserved.
//

#import "CameraViewController.h"
#import "LBBeanListTableViewCell.h"
#import "PTDBeanManager.h"
#import "PTDBean.h"
#import <AVFoundation/AVFoundation.h>

static NSString *HCOBeanCellIdentifier = @"HCOBeanCellIdentifier";

@interface CameraViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) PTDBeanManager *beanManager;
@property (nonatomic, strong) NSMutableArray *beans;
@property (nonatomic, strong) UIImagePickerController *camera;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBarHidden = YES;
    self.bean.delegate = self;
    [self.bean releaseSerialGate];
    [self startCamera];

    [[NSNotificationCenter defaultCenter] addObserverForName:@"StillImageComplete" object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSData *data;
        UIImage *image;
        NSDictionary *info;

        data = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:(__bridge CMSampleBufferRef)(note.userInfo[@"SampleBuffer"])];
        image = [UIImage imageWithData:data];
        info = @{UIImagePickerControllerMediaType : @"public.image", UIImagePickerControllerOriginalImage : image};
        [self imagePickerController:self.camera didFinishPickingMediaWithInfo:info];
    }];
}

#pragma mark - Bean Delegate

- (void)bean:(PTDBean *)bean serialDataReceived:(NSData *)data
{
    if ( ((uint8_t*)data.bytes)[0] == 0x01 ) {
        [self.camera takePicture];
    }
}

#pragma mark - UIImagePicker

- (void)startCamera
{
    self.camera = [UIImagePickerController new];
    self.camera.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.camera.delegate = self;

    [self presentViewController:self.camera animated:NO completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image;

    image = info[UIImagePickerControllerOriginalImage];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);

    [self dismissViewControllerAnimated:NO completion:^{
        self.camera = nil;
        [self startCamera];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self performSegueWithIdentifier:@"unwindFromCameraSegue" sender:self];
}

@end



