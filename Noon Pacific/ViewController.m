//
//  ViewController.m
//  Noon Pacific
//
//  Created by Aaron Zinman on 6/25/15.
//  Copyright (c) 2015 Aaron Zinman. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  [self.webView.mainFrame loadRequest:[NSURLRequest requestWithURL:
                                       [NSURL URLWithString:@"http://noonpacific.com"]]];
}

- (void)setRepresentedObject:(id)representedObject {
  [super setRepresentedObject:representedObject];
  // Update the view, if already loaded.
}

/*! @abstract Invoked when a script message is received from a webpage.
 @param userContentController The user content controller invoking the
 delegate method.
 @param message The script message received.
 */
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
  
}

@end
