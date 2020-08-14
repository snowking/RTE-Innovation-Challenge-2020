//
//  AppDelegate.m
//  ZKBody
//
//  Created by King on 2019/9/25.
//  Copyright © 2019 King. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZKBodyTerminate" object:nil];
    
}


@end
