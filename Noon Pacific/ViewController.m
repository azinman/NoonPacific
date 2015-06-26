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

- (void) pageDidLoad {
  self.loaded = YES;
  NSLog(@"Injecting javascript");
  NSString *jsPath = [[NSBundle mainBundle] pathForResource:@"injected" ofType:@"js"];
  NSData *jsData = [NSData dataWithContentsOfFile:jsPath];
  NSString *injectedScript = [[NSString alloc] initWithData:jsData encoding:NSUTF8StringEncoding];
  [self.webView.mainFrame.windowObject evaluateWebScript:injectedScript];
}

- (BOOL) isPlaying {
  NSLog(@"is playing: %@", [self.webView.mainFrame.windowObject evaluateWebScript:@"DesktopHelper.isPlaying()"]);
  return NO;
}

- (IBAction) play:(id)sender {
  [self.webView.mainFrame.windowObject evaluateWebScript:@"DesktopHelper.play()"];
}

- (IBAction) pause:(id)sender {
  [self.webView.mainFrame.windowObject evaluateWebScript:@"DesktopHelper.pause()"];
}

- (IBAction) next:(id)sender {
  [self.webView.mainFrame.windowObject evaluateWebScript:@"DesktopHelper.next()"];
}

- (IBAction) previous:(id)sender {
  [self.webView.mainFrame.windowObject evaluateWebScript:@"DesktopHelper.previous()"];
}

#pragma mark - Menu Bar delegate -------------------------------------------------------------------

- (BOOL) validateUserInterfaceItem:(id<NSValidatedUserInterfaceItem>)anItem {
  NSLog(@"Validate user interface item: %@", anItem);
  return YES;
}

- (BOOL) validateMenuItem:(NSMenuItem *)menuItem {
  NSLog(@"Validate menu item: %@", menuItem);
  return YES;
}

#pragma mark - Frame load delegates ----------------------------------------------------------------

/*!
 @method webView:didStartProvisionalLoadForFrame:
 @abstract Notifies the delegate that the provisional load of a frame has started
 @param webView The WebView sending the message
 @param frame The frame for which the provisional load has started
 @discussion This method is called after the provisional data source of a frame
 has started to load.
 */
- (void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame {
  NSLog(@"didStartProvisionalLoadForFrame: %@", frame);
  if (!frame.parentFrame) {
    NSLog(@"Unmarking loaded");
    self.loaded = NO;
  }
}

/*!
 @method webView:didReceiveServerRedirectForProvisionalLoadForFrame:
 @abstract Notifies the delegate that a server redirect occurred during the provisional load
 @param webView The WebView sending the message
 @param frame The frame for which the redirect occurred
 */
- (void)webView:(WebView *)sender didReceiveServerRedirectForProvisionalLoadForFrame:(WebFrame *)frame {
  NSLog(@"didReceiveServerRedirectForProvisionalLoadForFrame: %@", frame);
}

/*!
 @method webView:didFailProvisionalLoadWithError:forFrame:
 @abstract Notifies the delegate that the provisional load has failed
 @param webView The WebView sending the message
 @param error The error that occurred
 @param frame The frame for which the error occurred
 @discussion This method is called after the provisional data source has failed to load.
 The frame will continue to display the contents of the committed data source if there is one.
 */
- (void)webView:(WebView *)sender didFailProvisionalLoadWithError:(NSError *)error forFrame:(WebFrame *)frame {
  NSLog(@"didFailProvisionalLoadWithError: %@ for frame %@", error, frame);
}

/*!
 @method webView:didCommitLoadForFrame:
 @abstract Notifies the delegate that the load has changed from provisional to committed
 @param webView The WebView sending the message
 @param frame The frame for which the load has committed
 @discussion This method is called after the provisional data source has become the
 committed data source.
 
 In some cases, a single load may be committed more than once. This happens
 in the case of multipart/x-mixed-replace, also known as "server push". In this case,
 a single location change leads to multiple documents that are loaded in sequence. When
 this happens, a new commit will be sent for each document.
 */
- (void)webView:(WebView *)sender didCommitLoadForFrame:(WebFrame *)frame {
  NSLog(@"didCommitLoadForFrame for frame %@", frame);
}

/*!
 @method webView:didReceiveTitle:forFrame:
 @abstract Notifies the delegate that the page title for a frame has been received
 @param webView The WebView sending the message
 @param title The new page title
 @param frame The frame for which the title has been received
 @discussion The title may update during loading; clients should be prepared for this.
 */
- (void)webView:(WebView *)sender didReceiveTitle:(NSString *)title forFrame:(WebFrame *)frame {
  NSLog(@"didReceiveTitle %@ for frame %@", title, frame);
}

/*!
 @method webView:didReceiveIcon:forFrame:
 @abstract Notifies the delegate that a page icon image for a frame has been received
 @param webView The WebView sending the message
 @param image The icon image. Also known as a "favicon".
 @param frame The frame for which a page icon has been received
 */
- (void)webView:(WebView *)sender didReceiveIcon:(NSImage *)image forFrame:(WebFrame *)frame {
  NSLog(@"didReceiveIcon %@ for frame %@", image, frame);
}

/*!
 @method webView:didFinishLoadForFrame:
 @abstract Notifies the delegate that the committed load of a frame has completed
 @param webView The WebView sending the message
 @param frame The frame that finished loading
 @discussion This method is called after the committed data source of a frame has successfully loaded
 and will only be called when all subresources such as images and stylesheets are done loading.
 Plug-In content and JavaScript-requested loads may occur after this method is called.
 */
- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {
  NSLog(@"didFinishLoadForFrame for frame %@ with parent %@", frame, frame.parentFrame);
  if (!frame.parentFrame) {
    [self pageDidLoad];
  }
}

/*!
 @method webView:didFailLoadWithError:forFrame:
 @abstract Notifies the delegate that the committed load of a frame has failed
 @param webView The WebView sending the message
 @param error The error that occurred
 @param frame The frame that failed to load
 @discussion This method is called after a data source has committed but failed to completely load.
 */
- (void)webView:(WebView *)sender didFailLoadWithError:(NSError *)error forFrame:(WebFrame *)frame {
  NSLog(@"didFailLoadWithError: %@ for frame %@", error, frame);
}

/*!
 @method webView:didChangeLocationWithinPageForFrame:
 @abstract Notifies the delegate that the scroll position in a frame has changed
 @param webView The WebView sending the message
 @param frame The frame that scrolled
 @discussion This method is called when anchors within a page have been clicked.
 */
- (void)webView:(WebView *)sender didChangeLocationWithinPageForFrame:(WebFrame *)frame {
  NSLog(@"didChangeLocationWithinPageForFrame for frame %@", frame);
}

/*!
 @method webView:willPerformClientRedirectToURL:delay:fireDate:forFrame:
 @abstract Notifies the delegate that a frame will perform a client-side redirect
 @param webView The WebView sending the message
 @param URL The URL to be redirected to
 @param seconds Seconds in which the redirect will happen
 @param date The fire date
 @param frame The frame on which the redirect will occur
 @discussion This method can be used to continue progress feedback while a client-side
 redirect is pending.
 */
- (void)webView:(WebView *)sender willPerformClientRedirectToURL:(NSURL *)URL delay:(NSTimeInterval)seconds fireDate:(NSDate *)date forFrame:(WebFrame *)frame {
  NSLog(@"willPerformClientRedirectToURL %@ for frame %@", URL, frame);
}

/*!
 @method webView:didCancelClientRedirectForFrame:
 @abstract Notifies the delegate that a pending client-side redirect has been cancelled
 @param webView The WebView sending the message
 @param frame The frame for which the pending redirect was cancelled
 @discussion A client-side redirect can be cancelled if a frame changes location before the timeout.
 */
- (void)webView:(WebView *)sender didCancelClientRedirectForFrame:(WebFrame *)frame {
  NSLog(@"didCancelClientRedirectForFrame for frame %@", frame);
}

/*!
 @method webView:willCloseFrame:
 @abstract Notifies the delegate that a frame will be closed
 @param webView The WebView sending the message
 @param frame The frame that will be closed
 @discussion This method is called right before WebKit is done with the frame
 and the objects that it contains.
 */
- (void)webView:(WebView *)sender willCloseFrame:(WebFrame *)frame {
  NSLog(@"willCloseFrame %@", frame);
}

/*!
 @method webView:didClearWindowObject:forFrame:
 @abstract Notifies the delegate that the JavaScript window object in a frame has
 been cleared in preparation for a new load. This is the preferred place to set custom
 properties on the window object using the WebScriptObject and JavaScriptCore APIs.
 @param webView The webView sending the message.
 @param windowObject The WebScriptObject representing the frame's JavaScript window object.
 @param frame The WebFrame to which windowObject belongs.
 @discussion If a delegate implements both webView:didClearWindowObject:forFrame:
 and webView:windowScriptObjectAvailable:, only webView:didClearWindowObject:forFrame:
 will be invoked. This enables a delegate to implement both methods for backwards
 compatibility with older versions of WebKit.
 */
- (void)webView:(WebView *)webView didClearWindowObject:(WebScriptObject *)windowObject forFrame:(WebFrame *)frame {
  NSLog(@"didClearWindowObject %@ for frame %@", windowObject, frame);
}

/*!
 @method webView:didCreateJavaScriptContext:contextForFrame:
 @abstract Notifies the delegate that a new JavaScript context has been created created.
 @param webView The WebView sending the message.
 @param context The JSContext representing the frame's JavaScript window object.
 @param frame The WebFrame to which the context belongs.
 @discussion If a delegate implements webView:didCreateJavaScriptContext:forFrame: along with either
 webView:didClearWindowObject:forFrame: or webView:windowScriptObjectAvailable:, only
 webView:didCreateJavaScriptContext:forFrame will be invoked. This enables a delegate to implement
 multiple versions to maintain backwards compatibility with older versions of WebKit.
 */
- (void)webView:(WebView *)webView didCreateJavaScriptContext:(JSContext *)context forFrame:(WebFrame *)frame {
  NSLog(@"didCreateJavaScriptContext %@ for frame %@", context, frame);
}

@end

@implementation WebFrame(Description)
- (NSString *) description {
  NSURL *url = self.provisionalDataSource.request.URL;
  if (!url) url = self.dataSource.request.URL;
  return [NSString stringWithFormat:@"[WebFrame name=%@ url=%@]", self.name, url];
}
@end

