//
//	AppDelegate.m
//	DonatMG
//
//	Created by Goran Blažič on 28/06/14.
//	Copyright (c) 2014 renderspace.si. All rights reserved.
//

#import "AppDelegate.h"
#import "SettingsManager.h"
#import "LanguageManager.h"
#import "Appirater.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

	[LanguageManager sharedManager];

	// TODO: Change this to actual App ID when deploying!!!
	[Appirater setAppId:@"441050540"];
	[Appirater setDaysUntilPrompt:0];
	[Appirater setUsesUntilPrompt:0];
	[Appirater setSignificantEventsUntilPrompt:3];
	[Appirater setTimeBeforeReminding:2];

#if DEBUG == 1
	[Appirater setDebug:YES];
#else
	[Appirater setDebug:NO];
#endif

	if ([launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey]) {
		[[SettingsManager sharedManager] setNotificationFired:[launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey]];
	}

	[Appirater appLaunched:YES];

	return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	[Appirater appEnteredForeground:YES];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
	[[NSNotificationCenter defaultCenter] postNotificationName:kApplicationDidReceiveNotification object:self userInfo:@{@"notification": notification}];
}

@end
