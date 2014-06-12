//
//	SettingsManager.m
//	DonatMG
//
//	Created by Goran Blažič on 21/05/14.
//	Copyright (c) 2014 goranche.net. All rights reserved.
//

#import "SettingsManager.h"

#define kActiveIndicationKey @"activeIndication"
#define kAppLanguageKey @"appLanguage"
#define kNumberOfMeals @"numberOfMeals"

@implementation SettingsManager

@synthesize activeIndication = _activeIndication;
@synthesize appLanguage = _appLanguage;
@synthesize numberOfMeals = _numberOfMeals;

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
		_appLanguage = [defaults stringForKey:kAppLanguageKey];

		_numberOfMeals = [defaults integerForKey:kNumberOfMeals];
		if (_numberOfMeals < 1)
			_numberOfMeals = 3;
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

- (void)setAppLanguage:(NSString *)appLanguage {
	_appLanguage = appLanguage;

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:_appLanguage forKey:kAppLanguageKey];
	[defaults synchronize];
}

- (void)setNumberOfMeals:(NSUInteger)numberOfMeals {
	_numberOfMeals = numberOfMeals;

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:_numberOfMeals forKey:kNumberOfMeals];
	[defaults synchronize];
}

@end
