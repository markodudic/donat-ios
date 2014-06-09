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

@implementation SettingsManager

@synthesize activeIndication = _activeIndication;
@synthesize appLanguage = _appLanguage;

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

	// TODO: set the actual language for the app
	// http://stackoverflow.com/questions/10259695/translating-ios-app-to-unsupported-non-standard-languages
	// http://stackoverflow.com/questions/19262627/localization-in-ios-7-selects-the-language-settings-used-previously
}

@end
