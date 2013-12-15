//
//  CHGPUPolarPixellatePosterize.h
//  Telegramagram
//
//  Created by Matthew Garden on 12/12/2013.
//  Copyright (c) 2013 Matthew Garden. All rights reserved.
//

// http://indieambitions.com/idevblogaday/learning-opengl-gpuimage/

#import "GPUImageFilter.h"

@interface OMGPolarPixellatePosterize : GPUImageFilter {
    GLint centerUniform, pixelSizeUniform;
}

// The center about which to apply the distortion, with a default of (0.5, 0.5)
@property (nonatomic) CGPoint center;
// The amount of distortion to apply, from (-2.0, -2.0) to (2.0, 2.0), with a default of (0.05, 0.05)
@property (nonatomic) CGSize pixelSize;

@end
