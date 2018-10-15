//
//  InterfaceController.h
//  SpriteKitWatchFace WatchKit Extension
//
//  Created by Steven Troughton-Smith on 09/10/2018.
//  Copyright © 2018 Steven Troughton-Smith. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import <WatchConnectivity/WatchConnectivity.h>
#import <CoreLocation/CoreLocation.h>
@import SpriteKit;

@interface InterfaceController : WKInterfaceController <WCSessionDelegate, SKSceneDelegate, WKCrownDelegate, CLLocationManagerDelegate>

@property IBOutlet WKInterfaceSKScene * scene;
@property CLLocationManager *locationManager;
@end
