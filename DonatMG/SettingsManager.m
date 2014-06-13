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
#define kWakeTime @"wakeTime"
#define kBreakfastTime @"breakfastTime"
#define kLunchTime @"lunchTime"
#define kDinnerTime @"dinnerTime"
#define kSleepingTime @"sleepingTime"
#define kNumberOfMeals @"numberOfMeals"

#define kDefaultWakeTime createTimeWithHour:7 andMinutes:30
#define kDefaultBreakfastTime createTimeWithHour:7 andMinutes:45
#define kDefaultLunchTime createTimeWithHour:12 andMinutes:00
#define kDefaultDinnerTime createTimeWithHour:17 andMinutes:30
#define kDefaultSleepingTime createTimeWithHour:10 andMinutes:30

@implementation SettingsManager

@synthesize activeIndication = _activeIndication;
@synthesize appLanguage = _appLanguage;
@synthesize wakeTime = _wakeTime;
@synthesize breakfastTime = _breakfastTime;
@synthesize lunchTime = _lunchTime;
@synthesize dinnerTime = _dinnerTime;
@synthesize sleepingTime = _sleepingTime;
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

- (void)storeTime:(NSDateComponents *)time forKey:(NSString *)key {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:time] forKey:key];
	[defaults synchronize];
}

- (NSDateComponents *)createTimeWithHour:(NSUInteger)hour andMinutes:(NSUInteger)minutes {
	NSDateComponents *result = [[NSDateComponents alloc] init];
	[result setHour:hour];
	[result setMinute:minutes];
	return result;
}

- (id)init {
	if (self = [super init]) {
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

		_activeIndication = [defaults integerForKey:kActiveIndicationKey];
		_appLanguage = [defaults stringForKey:kAppLanguageKey];

		NSData *tempData = nil;

		tempData = [defaults dataForKey:kWakeTime];
		if (tempData)
			_wakeTime = (NSDateComponents *)[NSKeyedUnarchiver unarchiveObjectWithData:tempData];
		else
			_wakeTime = [self kDefaultWakeTime];

		tempData = [defaults dataForKey:kBreakfastTime];
		if (tempData)
			_breakfastTime = (NSDateComponents *)[NSKeyedUnarchiver unarchiveObjectWithData:tempData];
		else
			_breakfastTime = [self kDefaultBreakfastTime];

		tempData = [defaults dataForKey:kLunchTime];
		if (tempData)
			_lunchTime = (NSDateComponents *)[NSKeyedUnarchiver unarchiveObjectWithData:tempData];
		else
			_lunchTime = [self kDefaultLunchTime];

		tempData = [defaults dataForKey:kDinnerTime];
		if (tempData)
			_dinnerTime = (NSDateComponents *)[NSKeyedUnarchiver unarchiveObjectWithData:tempData];
		else
			_dinnerTime = [self kDefaultDinnerTime];

		tempData = [defaults dataForKey:kSleepingTime];
		if (tempData)
			_sleepingTime = (NSDateComponents *)[NSKeyedUnarchiver unarchiveObjectWithData:tempData];
		else
			_sleepingTime = [self kDefaultSleepingTime];

		_numberOfMeals = [defaults integerForKey:kNumberOfMeals];
		if (_numberOfMeals < 3)
			_numberOfMeals = 3;
		if (_numberOfMeals > 5)
			_numberOfMeals = 5;
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

- (void)setWakeTime:(NSDateComponents *)wakeTime {
	_wakeTime = wakeTime;
	[self storeTime:_wakeTime forKey:kWakeTime];
}

- (void)setBreakfastTime:(NSDateComponents *)breakfastTime {
	_breakfastTime = breakfastTime;
	[self storeTime:_breakfastTime forKey:kBreakfastTime];
}

- (void)setLunchTime:(NSDateComponents *)lunchTime {
	_lunchTime = lunchTime;
	[self storeTime:_lunchTime forKey:kLunchTime];
}

- (void)setDinnerTime:(NSDateComponents *)dinnerTime {
	_dinnerTime = dinnerTime;
	[self storeTime:_dinnerTime forKey:kDinnerTime];
}

- (void)setSleepingTime:(NSDateComponents *)sleepingTime {
	_sleepingTime = sleepingTime;
	[self storeTime:_sleepingTime forKey:kSleepingTime];
}

@end
