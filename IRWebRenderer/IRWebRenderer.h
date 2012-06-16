//
//  IRWebRenderer.h
//  IRWebRenderer
//
//  Created by Evadne Wu on 6/15/12.
//  Copyright (c) 2012 Iridia Productions. All rights reserved.
//

#import "IRWebRendererDefines.h"

@interface IRWebRenderer : NSObject

- (void) renderWithConfiguration:(IRWebRendererConfigurationBlock)configurationBlock completion:(IRWebRendererCompletionBlock)completionBlock;

@property (nonatomic, readonly, strong) NSOperationQueue *operationQueue;

@end
