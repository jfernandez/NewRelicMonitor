//
//  NewRelicMonitorAppDelegate.m
//  NewRelicMonitor
//
//  Created by Jose Fernandez on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewRelicMonitorAppDelegate.h"
#import "ASIHTTPRequest.h"
#import "GDataXMLNode.h"

@implementation NewRelicMonitorAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // https://rpm.newrelic.com/accounts/11042/applications/106245/threshold_values.xml
    // 0c3244d7f2494f511bd4f25a42e4ddfe6e2195293886c75
    
    NSURL *url = [NSURL URLWithString:@"https://rpm.newrelic.com/accounts/11042/applications/106245/threshold_values.xml"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"x-api-key" value:@"0c3244d7f2494f511bd4f25a42e4ddfe6e2195293886c75"];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSError *error;
        GDataXMLDocument *doc = [GDataXMLDocument alloc];
        [doc initWithXMLString:response options:0 error:&error];
        
        NSLog(@"%@", doc.rootElement);
    
        
        [doc release];
        //NSLog(@"%@", response);
    }
}

-(void)awakeFromNib{
    NSStatusBar *bar = [NSStatusBar systemStatusBar];
    statusItem = [bar statusItemWithLength:NSVariableStatusItemLength];
    [statusItem retain];
    [statusItem setMenu:statusMenu];
    [statusItem setTitle:@"Status"];
    [statusItem setHighlightMode:YES];
}

@end
