//
//  IRWebRenditionOperation.h
//  IRWebRenderer
//
//  Created by Evadne Wu on 6/15/12.
//  Copyright (c) 2012 Iridia Productions. All rights reserved.
//

#import "IRWebRendererDefines.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface IRWebRenditionOperation : NSOperation

- (id) initWithConfigurationBlock:(IRWebRendererConfigurationBlock)block;

@property (nonatomic, readonly, strong) UIImage *image;

@end
