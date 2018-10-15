//
//  ViewController.m
//  SpriteKitWatchFace
//
//  Created by Steven Troughton-Smith on 09/10/2018.
//  Copyright © 2018 Steven Troughton-Smith. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <WCSessionDelegate>
@property (weak, nonatomic) IBOutlet UILabel *themeLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
    
    
    
}

- (void)sendNewTheme {
    NSString *counterString = [NSString stringWithFormat:@"%d", 19];
    NSDictionary *applicationData = [[NSDictionary alloc] initWithObjects:@[counterString] forKeys:@[@"counterValue"]];
    
    [[WCSession defaultSession] sendMessage:applicationData
                               replyHandler:^(NSDictionary *reply) {
                                   //handle reply from iPhone app here
                               }
                               errorHandler:^(NSError *error) {
                                   //catch any errors here
                               }
     ];
}

- (IBAction)test:(id)sender {
    [self sendNewTheme];
}


@end
