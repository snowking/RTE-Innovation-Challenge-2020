//
//  ZKViewController.m
//  ZKBody
//
//  Created by zddx_air on 2019/12/16.
//  Copyright © 2019 King. All rights reserved.
//

#import "ZKViewController.h"

@interface ZKViewController ()

@end

@implementation ZKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    self.view.autoresizingMask = NSViewMinXMargin | NSViewMaxXMargin | NSViewMinYMargin | NSViewMaxYMargin;
   
    if (self.navigationController) {
        self.view.frame = self.navigationController.view.bounds;
    }

}

-(void)viewWillLayout{
    [super viewWillLayout];
    
    self.view.wantsLayer = YES;
    if([self isDarkMode]){
        self.view.layer.backgroundColor = [NSColor colorFromHexString:@"#342620"].CGColor;
    }else{
        self.view.layer.backgroundColor = [NSColor whiteColor].CGColor;
    }
}

-(NSAlert*)showAlertWithText:(NSString*)text{

    return [self showAlertWithText:text completionHandler:nil];
    
}

-(NSAlert*)showAlertWithText:(NSString*)text completionHandler:(void (^ _Nullable)(NSModalResponse returnCode))handler{
    
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = @"提示";
    alert.informativeText = text;
    alert.icon = [NSImage imageNamed:@"icon_alert"];
    [alert beginSheetModalForWindow:[[NSApplication sharedApplication] keyWindow] completionHandler:handler];
    return alert;
}

-(void)addEvent:(NSString*)event{
    [[ZKService sharedService] addEventWithEvent:event success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
//    if ([[ZKService sharedService].user.phone isEqualToString:@"18069586919"]) {
//        [[ZKService sharedService] sendMessageToKing:event];
//    }
}


-(BOOL)isDarkMode{
    
    if (![NSApp respondsToSelector:@selector(effectiveAppearance)]) {
        return NO;
    }
    
     NSAppearance *apperance = NSApp.effectiveAppearance;
        if (@available(macOS 10.14, *)) {
            return  [apperance bestMatchFromAppearancesWithNames:@[NSAppearanceNameDarkAqua,NSAppearanceNameAqua]] == NSAppearanceNameDarkAqua;
        } else {
            return YES;
        }
        return NO;
}

@end
