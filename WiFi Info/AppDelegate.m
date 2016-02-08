//
//  AppDelegate.m
//  WiFi Info
//
//  Created by James Barclay on 1/27/16.
//  Copyright © 2016 James Barclay. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreWLAN/CoreWLAN.h>

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    _rssiLevelIndicator.minValue = -90;
    _rssiLevelIndicator.maxValue = -30;
    _rssiLevelIndicator.warningValue = -80;
    _rssiLevelIndicator.criticalValue = -85;
    _rssiLevelIndicator.levelIndicatorStyle = NSContinuousCapacityLevelIndicatorStyle;
    [self updateLabels:nil];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateLabels:) userInfo:nil repeats:YES];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    // Insert code here to tear down your application
}

- (IBAction)openNetworkPreferences:(id)sender
{
    [[NSWorkspace sharedWorkspace] openFile:@"/System/Library/PreferencePanes/Network.prefPane"];
}

- (NSAttributedString *)buildLabelColor:(NSString *)key withValue:(long)value
{
    NSDictionary *attrs = [self getRSSILabelColor:value];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    NSAttributedString *beginning = [[NSAttributedString alloc] initWithString:key];
    NSAttributedString *end = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld dBm", value] attributes:attrs];
    [attributedText appendAttributedString:beginning];
    [attributedText appendAttributedString:end];
    
    return attributedText;
}

- (NSAttributedString *)buildAttributedString:(NSString *)key withValue:(NSString *)value
{
    const CGFloat fontSize = 15;
    NSDictionary *attrs = @{NSFontAttributeName : [NSFont systemFontOfSize:fontSize]};
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    NSAttributedString *beginning = [[NSAttributedString alloc] initWithString:key];
    NSAttributedString *end = [[NSAttributedString alloc] initWithString:value attributes:attrs];
    [attributedText appendAttributedString:beginning];
    [attributedText appendAttributedString:end];
    
    return attributedText;
}

- (NSDictionary *)getRSSILabelColor:(long)val
{
    unsigned long long newVal;
    
    if (val < -80) {
        newVal = 0xFFB238;
    } else if (val < -70) {
        newVal = 0xF19143;
    } else if (val < 60) {
        newVal = 0xFF773D;
    } else {
        newVal = 0xF55536;
    }
    
    const CGFloat fontSize = 15;
    return @{NSForegroundColorAttributeName : NSColorFromRGBWithAlpha(newVal, 0.75),
             NSFontAttributeName : [NSFont systemFontOfSize:fontSize]};
}

- (void)updateLabels:(id)sender
{
    CWWiFiClient *client = [CWWiFiClient sharedWiFiClient];
    long rssi = (long)client.interface.rssiValue;
    long noise = (long)client.interface.noiseMeasurement;
    NSString *interfaceName = client.interface.interfaceName;
    double transmitRate = client.interface.transmitRate;
    NSUInteger channel = client.interface.wlanChannel.channelNumber;
    
    _rssiLevelIndicator.integerValue = rssi;
    
    NSAttributedString *rssiAttributedText = [self buildLabelColor:@"RSSI:  " withValue:rssi];
    [_rssiLabel setAttributedStringValue:rssiAttributedText];
    
    NSAttributedString *noiseAttributedText = [self buildAttributedString:@"Noise:  " withValue:[NSString stringWithFormat:@"%ld dBM", noise]];
    [_noiseLabel setAttributedStringValue:noiseAttributedText];
    
    NSAttributedString *interfaceNameAttributedText = [self buildAttributedString:@"Interface Name:  " withValue:interfaceName];
    [_interfaceNameLabel setAttributedStringValue:interfaceNameAttributedText];
    
    NSAttributedString *txRateAttributedText = [self buildAttributedString:@"Tx Rate:  " withValue:[NSString stringWithFormat:@"%0.0f Mbps", transmitRate]];
    [_txRateLabel setAttributedStringValue:txRateAttributedText];
    
    NSAttributedString *channelAttributedText = [self buildAttributedString:@"Channel:  " withValue:[NSString stringWithFormat:@"%lu", (unsigned long)channel]];
    [_channelLabel setAttributedStringValue:channelAttributedText];
}

@end
