//
//  IRWebRenderer.m
//  IRWebRenderer
//
//  Created by Evadne Wu on 6/15/12.
//  Copyright (c) 2012 Iridia Productions. All rights reserved.
//

#import "IRWebRenderer.h"
#import "IRWebRenditionOperation.h"

@interface IRWebRenderer () <UIWebViewDelegate>
@property (nonatomic, readwrite, strong) NSOperationQueue *operationQueue;
@end

@implementation IRWebRenderer
@synthesize operationQueue = _operationQueue;

- (id) init {

	self = [super init];
	if (!self)
		return nil;
	
	_operationQueue = [[NSOperationQueue alloc] init];
	_operationQueue.maxConcurrentOperationCount = 1;
	
	return self;

}

- (void) renderWithConfiguration:(IRWebRendererConfigurationBlock)configurationBlock completion:(IRWebRendererCompletionBlock)completionBlock {

	IRWebRenditionOperation *operation = [[IRWebRenditionOperation alloc] initWithConfigurationBlock:^(UIWebView *webView) {

		configurationBlock(webView);
		
	}];
	
	__weak IRWebRenditionOperation *wOperation = operation;
	
	[operation setCompletionBlock:^{
	
		completionBlock(wOperation.image);
		
	}];

	[self.operationQueue addOperation:operation];
	
}

@end
