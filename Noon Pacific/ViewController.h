//
//  ViewController.h
//  Noon Pacific
//
//  Created by Aaron Zinman on 6/25/15.
//  Copyright (c) 2015 Aaron Zinman. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@import WebKit;

@interface ViewController : NSViewController<NSUserInterfaceValidations, NSMenuDelegate>

@property(nonatomic, strong) IBOutlet WebView *webView;
@property(nonatomic, assign) BOOL loaded;

- (IBAction) play:(id) sender;
- (IBAction) pause:(id) sender;
- (IBAction) next:(id) sender;
- (IBAction) previous:(id) sender;

@end

