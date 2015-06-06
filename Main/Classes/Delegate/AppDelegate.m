//
//  AppDelegate.m
//  E-Report for iOS
//
//  Created by Nur Imelia on 08/03/15.
//  Copyright (c) 2015 Nur Imelia. All rights reserved.
//

#import "AppDelegate.h"
#import "CategoryViewController.h"
#import <Parse/Parse.h>

#define SYSTEM_VERSION_LESS_THAN(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // [Optional] Power your app with Local Datastore. For more info, go to
    // https://parse.com/docs/ios_guide#localdatastore/iOS
    [Parse enableLocalDatastore];

    // Initialize Parse.
    [Parse setApplicationId:@"Jr1ThYd3sxuT307hVFfAAiTJpgBQgb5x7AAM8nX0"
        clientKey:@"vFmNh59v7ykmEBb2XtQcChHCIvo7QbPLZBRwxMZl"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
//    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
//    testObject[@"foo"] = @"bar";
//    [testObject saveInBackground];
    
    // Set default ACLs
    PFACL *defaultACL = [PFACL ACL];
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    self.window.tintColor = [UIColor colorWithRed:0.0 green:0.6 blue:0.298 alpha:1.0];

    return YES;
}

- (void)saveData
{
    UINavigationController *navigationController = (UINavigationController *)self
    .window.rootViewController;
    CategoryViewController *controller = (CategoryViewController *)[
                                                                    navigationController.viewControllers objectAtIndex:0];
    [controller.dataModel saveChecklists];
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self saveData];
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

//- (void)applicationDidBecomeActive:(UIApplication *)application
//{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
