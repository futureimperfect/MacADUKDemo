//
//  AppDelegate.h
//  WiFi Info
//
//  Created by James Barclay on 1/27/16.
//  Copyright © 2016 James Barclay. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSTextField *rssiLabel;
@property (weak) IBOutlet NSTextField *noiseLabel;
@property (weak) IBOutlet NSTextField *interfaceNameLabel;
@property (weak) IBOutlet NSTextField *txRateLabel;
@property (weak) IBOutlet NSTextField *channelLabel;
@property (weak) IBOutlet NSLevelIndicator *rssiLevelIndicator;

- (IBAction)openNetworkPreferences:(id)sender;

#define NSColorFromRGB(rgbValue) [NSColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define NSColorFromRGBWithAlpha(rgbValue,a) [NSColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

@end

