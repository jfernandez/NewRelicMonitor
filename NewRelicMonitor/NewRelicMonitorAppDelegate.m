//
//  NewRelicMonitorAppDelegate.m
//  NewRelicMonitor
//
//  Created by Jose Fernandez on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewRelicMonitorAppDelegate.h"
#import "ASIHTTPRequest.h"

@implementation NewRelicMonitorAppDelegate

@synthesize window;
@synthesize responseParser;
@synthesize metricsDict;
@synthesize apiTimer;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Instantiate the dictionary
    metricsDict = [[NSMutableDictionary alloc] initWithCapacity:9];
    
    // Instantiate the timer
    apiTimer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(callApi) userInfo:nil repeats:YES];
    
    [self callApi];
    }

- (void)callApi {
    NSLog(@"called API!");
    
    // https://rpm.newrelic.com/accounts/11042/applications/106245/threshold_values.xml
    // 0c3244d7f2494f511bd4f25a42e4ddfe6e2195293886c75

    
    NSURL *url = [NSURL URLWithString:@"https://rpm.newrelic.com/accounts/11042/applications/106245/threshold_values.xml"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"x-api-key" value:@"0c3244d7f2494f511bd4f25a42e4ddfe6e2195293886c75"];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSData *responseData = [request responseData];
        responseParser = [[NSXMLParser alloc] initWithData:responseData];
        [responseParser setDelegate:self];
        [responseParser parse];
        [responseParser release];
    }

}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDic {
	if ([elementName isEqualToString:@"threshold_value"]) {
        NSString *metricName = [attributeDic valueForKey:@"name"];
        NSString *metricValue = [attributeDic valueForKey:@"formatted_metric_value"];
        [metricsDict setValue:metricValue forKey:metricName];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSString *statusString = [metricsDict valueForKey:@"Apdex"];
    statusString = [statusString stringByAppendingString:@"   "];
    
    statusString = [statusString stringByAppendingString:[metricsDict valueForKey:@"Response Time"]];
    statusString = [statusString stringByAppendingString:@"   "];
    
    statusString = [statusString stringByAppendingString:[metricsDict valueForKey:@"Error Rate"]];
    statusString = [statusString stringByAppendingString:@"   "];
    
    statusString = [statusString stringByAppendingString:[metricsDict valueForKey:@"Throughput"]];
    [statusItem setTitle:statusString];
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
