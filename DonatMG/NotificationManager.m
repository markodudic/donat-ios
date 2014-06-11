//
//	NotificationManager.m
//	DonatMG
//
//	Created by Goran Blažič on 04/06/14.
//	Copyright (c) 2014 goranche.net. All rights reserved.
//

#import "NotificationManager.h"

@implementation NotificationManager

+ (id)sharedManager {
	static NotificationManager *sharedNotificationManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedNotificationManager = [[self alloc] init];
	});
	return sharedNotificationManager;
}

- (id)init {
	if (self = [super init]) {
	}
	return self;
}

@end
