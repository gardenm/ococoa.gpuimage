//
//  OMGViewController.h
//  Telegramagram
//
//  Created by Matthew Garden on 12/12/2013.
//  Copyright (c) 2013 Matthew Garden. All rights reserved.
//

#import "OMGViewController.h"
#import "OMGPolarPixellatePosterize.h"

static NSString *const kGlassFilterName = @"iOS Glass";
static NSString *const kOldeTimeFilterName = @"Olde Time";
static NSString *const kKuwaharaFilterName = @"Oils";

@interface OMGViewController () <UIImagePickerControllerDelegate, UIActionSheetDelegate>

@property (strong) GPUImageVideoCamera *videoCamera;
@property (copy) NSArray *filterNames;
@property (copy) NSString *filterName;

@end

@implementation OMGViewController

- (void)viewDidLoad
{
    self.filterNames = @[ kGlassFilterName, kOldeTimeFilterName, kKuwaharaFilterName ];
}

#pragma mark - Live capture

- (IBAction)photoFromCamera
{   
    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionBack];
    
    OMGPolarPixellatePosterize *custom = [[OMGPolarPixellatePosterize alloc] init];
    
    GPUImageVignetteFilter *vignette = [[GPUImageVignetteFilter alloc] init];
    [vignette setValue:@(0.25) forKey:@"vignetteStart"];
    vignette.vignetteEnd = 1.0;
    
    GPUVector3 color = { 0.0, 1.0, 0.0 };
    vignette.vignetteColor = color;
    
    [self.videoCamera addTarget:custom];
    [custom addTarget:vignette];
    [vignette addTarget:self.imageView];
    
    self.pauseButton.enabled = YES;
    [self.videoCamera startCameraCapture];
}

- (IBAction)pauseCapture
{
    self.pauseButton.enabled = NO;
    [self.videoCamera stopCameraCapture];
}

#pragma mark - Album

- (IBAction)photoFromAlbum:(id)sender
{
    UIActionSheet *filterActionSheet = [[UIActionSheet alloc] initWithTitle:@"Filters!"
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                     destructiveButtonTitle:nil
                                                          otherButtonTitles:kGlassFilterName, kOldeTimeFilterName, kKuwaharaFilterName, nil];
    
    [filterActionSheet showFromBarButtonItem:sender animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    GPUImagePicture *image = [[GPUImagePicture alloc] initWithImage:info[UIImagePickerControllerOriginalImage]
                                    smoothlyScaleOutput:YES];
    
    NSArray *filters;
    if ([self.filterName isEqualToString:kGlassFilterName])
    {
        filters = @[ [[GPUImageiOSBlurFilter alloc] init] ];
    }
    else if ([self.filterName isEqualToString:kOldeTimeFilterName])
    {
        filters = @[ [[GPUImageSepiaFilter alloc] init],
                     [[GPUImageVignetteFilter alloc] init] ];
    }
    else if ([self.filterName isEqualToString:kKuwaharaFilterName])
    {
        filters = @[ [[GPUImageKuwaharaFilter alloc] init] ];
    }
    
    [image addTarget:filters.firstObject];
    if (filters.count > 1)
    {
        [filters.firstObject addTarget:filters.lastObject];
    }
    [filters.lastObject addTarget:self.imageView];
    
    [image processImage];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex < 0)
    {
        return;
    }
    
    self.filterName = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
    photoPicker.delegate = self;
    photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:photoPicker animated:YES completion:NULL];
}

@end
