//
//  NewRelicMonitorAppDelegate.h
//  NewRelicMonitor
//
//  Created by Jose Fernandez on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NewRelicMonitorAppDelegate : NSObject <NSApplicationDelegate, NSXMLParserDelegate> {
@private
    NSWindow *window;
    IBOutlet NSMenu *statusMenu;
    NSStatusItem *statusItem;
    NSXMLParser *responseParser;
	NSMutableDictionary *metricsDict;
    NSTimer *apiTimer;
}

@property (assign) IBOutlet NSWindow *window;
@property (retain, nonatomic) NSXMLParser *responseParser;
@property (retain, nonatomic) NSMutableDictionary *metricsDict;
@property (retain, nonatomic) NSTimer *apiTimer;

- (void)callApi;

@end