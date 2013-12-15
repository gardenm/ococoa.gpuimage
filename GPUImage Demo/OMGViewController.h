//
//  OMGViewController.h
//  Telegramagram
//
//  Created by Matthew Garden on 12/12/2013.
//  Copyright (c) 2013 Matthew Garden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GPUImage.h>

@interface OMGViewController : UIViewController <UINavigationControllerDelegate>

@property (nonatomic, weak) IBOutlet GPUImageView *imageView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *pauseButton;

- (IBAction)photoFromAlbum:(id)sender;
- (IBAction)photoFromCamera;
- (IBAction)pauseCapture;

@end
