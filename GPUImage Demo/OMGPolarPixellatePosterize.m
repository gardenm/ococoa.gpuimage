//
//  CHGPUPolarPixellatePosterize.m
//  Telegramagram
//
//  Created by Matthew Garden on 12/12/2013.
//  Copyright (c) 2013 Matthew Garden. All rights reserved.
//

#import "OMGPolarPixellatePosterize.h"
#import "GLProgram.h"

NSString *const kGPUImagePolarPixellatePosterizeFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 uniform highp vec2 center;
 uniform highp vec2 pixelSize;
 uniform sampler2D inputImageTexture;
 
 void main()
 {
     highp vec2 normCoord = 2.0 * textureCoordinate - 1.0;
     highp vec2 normCenter = 2.0 * center - 1.0;
     
     normCoord -= normCenter;
     
     highp float r = length(normCoord); // to polar coords
     highp float phi = atan(normCoord.y, normCoord.x); // to polar coords
     
     r = r - mod(r, pixelSize.x) + 0.03;
     phi = phi - mod(phi, pixelSize.y);
     
     normCoord.x = r * cos(phi);
     normCoord.y = r * sin(phi);
     
     normCoord += normCenter;
     
     mediump vec2 textureCoordinateToUse = normCoord / 2.0 + 0.5;
     mediump vec4 color = texture2D(inputImageTexture, textureCoordinateToUse );
     
     color = color - mod(color, 0.1);
     gl_FragColor = color;
     
 }
 );

@implementation OMGPolarPixellatePosterize

#pragma mark -
#pragma mark Initialization and teardown

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImagePolarPixellatePosterizeFragmentShaderString]))
    {
        return nil;
    }
    
    pixelSizeUniform = [filterProgram uniformIndex:@"pixelSize"];
    centerUniform = [filterProgram uniformIndex:@"center"];
    
    self.pixelSize = CGSizeMake(0.05, 0.05);
    self.center = CGPointMake(0.5, 0.5);
    
    return self;
}

- (void)setPixelSize:(CGSize)pixelSize
{
    _pixelSize = pixelSize;
    
    [GPUImageContext useImageProcessingContext];
    [filterProgram use];
    GLfloat pixelS[2];
    pixelS[0] = _pixelSize.width;
    pixelS[1] = _pixelSize.height;
    glUniform2fv(pixelSizeUniform, 1, pixelS);
}

- (void)setCenter:(CGPoint)newValue;
{
    _center = newValue;
    
    [GPUImageContext useImageProcessingContext];
    [filterProgram use];
    
    GLfloat centerPosition[2];
    centerPosition[0] = _center.x;
    centerPosition[1] = _center.y;
    
    glUniform2fv(centerUniform, 1, centerPosition);
}

@end

