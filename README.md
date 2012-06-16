# IRWebRenderer

Renders `UIWebView` content in background.  Blessed somehow.

##	Usage

Do it the easy way:

	IRWebRenderer *renderer = [IRWebRenderer new];
	
	[renderer renderWithConfiguration: ^ (UIWebView *wv) {
	
		//	One
		
		[wv setFrame:(CGRect){ 0, 0, 256, 256 }];
		[wv loadHTMLString:@"Sample" baseURL:nil];
	
	} completion: ^ (UIImage *image) {
	
		NSLog(@"image %@", image);
	
	}];
	
	[renderer renderWithConfiguration: ^ (UIWebView *wv) {
	
		//	Another
	
		NSURLRequest *ur = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://google.com"]];
		[wv setFrame:(CGRect){ 0, 0, 384, 384 }];
		[wv loadRequest:ur];
	
	} completion: ^ (UIImage *image) {
	
		NSLog(@"image %@", image);
	
	}];

Or, use the underlying `IRWebRenditionOperation` in your own queue.

## Credits

[Evadne Wu](http://twitter.com/evadne) at [Iridia Productions](http://iridia.tw), 2012.