//
//  IRWebRendererSampleTests.m
//  IRWebRendererSampleTests
//
//  Created by Evadne Wu on 6/15/12.
//  Copyright (c) 2012 Iridia Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IRWebRendererSampleTests.h"
#import "IRWebRenderer.h"

@implementation IRWebRendererSampleTests

- (void) testMultipleRendition {

	IRWebRenderer *renderer = [IRWebRenderer new];
	
	[renderer renderWithConfiguration: ^ (UIWebView *wv) {
	
		[wv setFrame:(CGRect){ 0, 0, 256, 256 }];
		[wv loadHTMLString:@"Sample" baseURL:nil];
	
	} completion: ^ (UIImage *image) {
	
		NSLog(@"image %@", image);
	
	}];
	
	[renderer renderWithConfiguration: ^ (UIWebView *wv) {
	
		NSURLRequest *ur = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://google.com"]];
		[wv setFrame:(CGRect){ 0, 0, 384, 384 }];
		[wv loadRequest:ur];
	
	} completion: ^ (UIImage *image) {
	
		NSLog(@"image %@", image);
	
	}];
	
	while (renderer.operationQueue.operationCount)
		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:5]];

}

- (NSUInteger) numberOfTestIterationsForTestWithSelector:(SEL)testMethod {

	return 1;

}

@end
