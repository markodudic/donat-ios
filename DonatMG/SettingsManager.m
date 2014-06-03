//
//	SettingsManager.m
//	DonatMG
//
//	Created by Goran Blažič on 21/05/14.
//	Copyright (c) 2014 goranche.net. All rights reserved.
//

#import "SettingsManager.h"

#define kActiveIndicationKey @"activeIndication"

@implementation SettingsManager

@synthesize  activeIndication = _activeIndication;

#pragma mark Singleton Methods

+ (id)sharedManager {
	static SettingsManager *sharedSettingsManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedSettingsManager = [[self alloc] init];
	});
	return sharedSettingsManager;
}

- (id)init {
	if (self = [super init]) {
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

		_activeIndication = [defaults integerForKey:kActiveIndicationKey];
	}
	return self;
}

- (void)dealloc {
}

- (void)setActiveIndication:(NSUInteger)activeIndication {
	_activeIndication = activeIndication;

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:_activeIndication forKey:kActiveIndicationKey];
	[defaults synchronize];
}

@end
