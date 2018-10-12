//
//  InterfaceController.h
//  SpriteKitWatchFace WatchKit Extension
//
//  Created by Steven Troughton-Smith on 09/10/2018.
//  Copyright © 2018 Steven Troughton-Smith. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
@import SpriteKit;

@interface InterfaceController : WKInterfaceController <SKSceneDelegate, WKCrownDelegate>

@property IBOutlet WKInterfaceSKScene * scene;
@end
