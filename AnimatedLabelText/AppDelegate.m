//
//  AppDelegate.m
//  AnimatedLabelText
//
//  Created by 9haomi on 2021/12/8.
//

#import "AppDelegate.h"
#import "JbbAnimatedLabelTextViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:[[JbbAnimatedLabelTextViewController alloc]init]];
    [self.window makeKeyAndVisible];
    return YES;
}



@end
