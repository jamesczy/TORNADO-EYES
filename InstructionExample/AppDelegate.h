//
//  AppDelegate.h
//  InstructionExample
//
//  Created by im360 immersive on 8/27/13.
//  Copyright (c) 2013 im360 immersive. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) IBOutlet ViewController *viewController;

@end
