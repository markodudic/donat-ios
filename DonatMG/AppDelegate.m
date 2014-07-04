//
//	AppDelegate.m
//	DonatMG
//
//	Created by Goran Blažič on 28/06/14.
//	Copyright (c) 2014 renderspace.si. All rights reserved.
//

#import "AppDelegate.h"
#import "SettingsManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

	if ([launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey]) {
		DLog(@"%@", [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey]);
		[[SettingsManager sharedManager] setNotificationFired:[launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey]];
	}

	return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
	[[NSNotificationCenter defaultCenter] postNotificationName:kApplicationDidReceiveNotification object:self userInfo:notification.userInfo];
}

@end
