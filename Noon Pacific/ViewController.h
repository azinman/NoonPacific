//
//  ViewController.h
//  Noon Pacific
//
//  Created by Aaron Zinman on 6/25/15.
//  Copyright (c) 2015 Aaron Zinman. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@import WebKit;

@interface ViewController : NSViewController<
WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>

@property(nonatomic, strong) IBOutlet WebView *webView;

@end

