//
//  IRWebRenditionOperation.m
//  IRWebRenderer
//
//  Created by Evadne Wu on 6/15/12.
//  Copyright (c) 2012 Iridia Productions. All rights reserved.
//

#import "IRWebRenditionOperation.h"

@interface IRWebRenditionOperation () <UIWebViewDelegate>

@property (nonatomic, readwrite, copy) IRWebRendererConfigurationBlock configurationBlock;
@property (nonatomic, readwrite, strong) UIImage *image;

@property (atomic, readwrite, assign, getter=isExecuting, setter=setExecuting:) BOOL executing;
@property (atomic, readwrite, assign, getter=isFinished, setter=setFinished:) BOOL finished;

+ (BOOL) canRenderInBackground;

@end

@implementation IRWebRenditionOperation
@synthesize configurationBlock = _configurationBlock;
@synthesize image = _image;
@synthesize executing = _executing;
@synthesize finished = _finished;

+ (BOOL) canRenderInBackground {

	static dispatch_once_t onceToken;
	static BOOL answer = NO;
	
	dispatch_once(&onceToken, ^{
	
		CGFloat systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
	
		if (systemVersion >= 6.0f)
			answer = YES;
			
	});
	
	return answer;

}

+ (UIWebView *) webView {

	static UIWebView *webView = nil;
	static dispatch_once_t onceToken;
	
	NSCParameterAssert([NSThread isMainThread]);
	
	dispatch_once(&onceToken, ^{
			
		webView = [[UIWebView alloc] initWithFrame:CGRectZero];
		
	});
	
	return webView;
	
}

- (id) init {

	return [self initWithConfigurationBlock:nil];

}

- (id) initWithConfigurationBlock:(IRWebRendererConfigurationBlock)block {

	NSCParameterAssert(block);
	
	self = [super init];
	if (!self)
		return nil;
	
	_configurationBlock = block;
	
	return self;

}

- (void) start {

	[super start];

	NSCParameterAssert(![NSThread isMainThread]);
	
	__weak IRWebRenditionOperation *wSelf = self;
	
	[[NSOperationQueue mainQueue] addOperationWithBlock:^{
	
		if (!wSelf)
			return;

		UIWebView *webView = [[wSelf class] webView];
		NSCParameterAssert(!webView.delegate);	//	things go wrong otherwise
		
		webView.delegate = wSelf;
		
		wSelf.configurationBlock(webView);
		wSelf.executing = YES;
		
	}];

}

- (BOOL) isConcurrent {
	
	return YES;

}

- (BOOL) executing {

	return _executing;

}

- (BOOL) finished {

	return _finished;

}

- (void) webViewDidFinishLoad:(UIWebView *)webView {

	NSCParameterAssert([NSThread isMainThread]);
	
	__weak IRWebRenditionOperation *wSelf = self;
	__weak UIWebView *wWebView = webView;
	
	BOOL const canRenderInBackground = [[self class] canRenderInBackground];
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
	
		if (!wWebView)
			return;
		
		UIGraphicsBeginImageContextWithOptions(wWebView.bounds.size, wWebView.opaque, 0.0f);
		CGContextRef ctx = UIGraphicsGetCurrentContext();
		
		dispatch_sync(dispatch_get_main_queue(), ^{
		
			[webView.layer layoutIfNeeded];
			
			if (!canRenderInBackground)
				[wWebView.layer renderInContext:ctx];

		});

		if (canRenderInBackground)
			[wWebView.layer renderInContext:ctx];
		
		UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
		wSelf.image = image;
		
		UIGraphicsEndImageContext();
		
		dispatch_async(dispatch_get_main_queue(), ^{
		
			[wSelf willChangeValueForKey:@"isFinished"];
			[wSelf willChangeValueForKey:@"isExecuting"];
		
			wSelf.executing = NO;
			wSelf.finished = YES;
			
			[wSelf didChangeValueForKey:@"isExecuting"];
			[wSelf didChangeValueForKey:@"isFinished"];
			
			NSLog(@"%@", wSelf);
			
			wWebView.delegate = nil;
		
		});
		
	});
	
}

@end
