//
//	TreatmentManager.m
//	DonatMG
//
//	Created by Goran Blažič on 07/07/14.
//	Copyright (c) 2014 renderspace.si. All rights reserved.
//

#import "TreatmentManager.h"
#import "SettingsManager.h"

@implementation TreatmentManager

@synthesize activeIndication;
@synthesize indicationActivation;

#define kHistoryArchiveKey @"history"

+ (NSString *)descriptionForIndication:(IndicationType)indication {
	switch (indication) {
		case kZaprtost:
			return @"kZaprtost";
			break;
		case kZgaga:
			return @"kZgaga";
			break;
		case kMagnezij:
			return @"kMagnezij";
			break;
		case kSladkorna:
			return @"kSladkorna";
			break;
		case kSlinavka:
			return @"kSlinavka";
			break;
		case kSecniKamni:
			return @"kSecniKamni";
			break;
		case kDebelost:
			return @"kDebelost";
			break;
		case kSrceOzilje:
			return @"kSrceOzilje";
			break;
		case kStres:
			return @"kStres";
			break;
		case kPocutje:
			return @"kPocutje";
			break;
		default:
			return @"";
			break;
	}
}

#pragma mark Singleton Methods

+ (id)sharedManager {
	static TreatmentManager *sharedTreatmentManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedTreatmentManager = [[self alloc] init];
	});
	return sharedTreatmentManager;
}

- (NSUInteger)activeIndication {
	return [[SettingsManager sharedManager] activeIndication];
}

- (NSDate *)indicationActivation {
	return [[SettingsManager sharedManager] indicationActivation];
}

- (NSString *)applicationDocumentsDirectory {
	NSURL *docDir = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
	return docDir.path;
}

- (NSString *)datafilePath {
	return [[self applicationDocumentsDirectory] stringByAppendingPathComponent:kApplicationDataFilename];
}

- (void)writeOutHistory {
	NSMutableData *data = [[NSMutableData alloc] init];
	NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	[archiver encodeObject:_calendarEntriesHistory forKey:kHistoryArchiveKey];
	[archiver finishEncoding];
	[data writeToFile:[self datafilePath] atomically:YES];
}

- (void)createDummyData {
#if DEBUG == 1
	DLog(@"Creating dummy data");

	_calendarEntriesHistory = [[NSMutableArray alloc] init];

	// we need today without the time
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *todayComponents = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[NSDate date]];
	NSDate *today = [gregorian dateFromComponents:todayComponents];

	// We start 4 days ago
	NSDate *dateToAdd = [today dateByAddingTimeInterval:-(4*60*60*24)];
	for (NSUInteger indication = kPocutje; indication > kUnknown; indication--) {
		for (NSUInteger count = 0; count < 3; count++) {
			[_calendarEntriesHistory addObject:[CalendarHistoryEntry entryWithDate:dateToAdd startDate:dateToAdd andIndicationType:indication]];
			// go to day before
			dateToAdd = [dateToAdd dateByAddingTimeInterval:-(60*60*24)];
		}
		// skip 2 days
		dateToAdd = [dateToAdd dateByAddingTimeInterval:-(2*60*60*24)];
	}

	// lets create some in the future as well (from yesterday), just for good measure
	dateToAdd = [today dateByAddingTimeInterval:-(60*60*24)];

	[[SettingsManager sharedManager] setIndicationActivation:dateToAdd];
	[[SettingsManager sharedManager] setActiveIndication:kMagnezij];
	for (NSUInteger count = 0; count < 5; count++) {
		[_calendarEntriesHistory addObject:[CalendarHistoryEntry entryWithDate:dateToAdd startDate:dateToAdd andIndicationType:kMagnezij]];
		// go to day after
		dateToAdd = [dateToAdd dateByAddingTimeInterval:60*60*24];
	}

	// write the history file, so the next run will read it instead of generating again
	[self writeOutHistory];
#endif
}

- (id)init {
	if (self = [super init]) {
		if ([[NSFileManager defaultManager] fileExistsAtPath:[self datafilePath]]) {
			NSData *data = [[NSData alloc] initWithContentsOfFile:[self datafilePath]];
			NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
			NSArray *historyData = [unarchiver decodeObjectForKey:kHistoryArchiveKey];
			[unarchiver finishDecoding];

			if (historyData) {
				_calendarEntriesHistory = [[NSMutableArray alloc] initWithArray:historyData];
			} else {
				[self createDummyData];
			}
		} else {
			[self createDummyData];
		}
	}
	return self;
}

- (void)dealloc {
}

- (NSUInteger)numberOfInstructionsForIndication:(IndicationType)indication {
	switch (indication) {
		case kSrceOzilje:
		case kPocutje:
			return 1;
			break;
		case kZaprtost:
		case kDebelost:
		case kStres:
			return 2;
			break;
		case kZgaga:
		case kMagnezij:
		case kSladkorna:
		case kSlinavka:
			return 3;
			break;
		case kSecniKamni:
			return 4;
			break;
		default:
			return 0;
			break;
	}
}

- (NSArray *)stringsForIndication:(IndicationType)indication {
	switch (indication) {
		case kZaprtost:
			return @[
					 @[___(@"drinking_na_tesce"),
					   [NSString stringWithFormat:@"%@ 3-8 %@", ___(@"temperature_toplo"), ___(@"volume_suffix")],
					   ___(@"speed_hitro")],
					 @[___(@"drinking_pred_spanjem"),
					   [NSString stringWithFormat:@"%@ 2 %@", ___(@"temperature_mlacno"), ___(@"volume_suffix")],
					   ___(@"speed_razmeroma_hitro")]
					];
			break;
		case kZgaga:
			return @[
					 @[___(@"drinking_veckrat_dnevno"),
					   [NSString stringWithFormat:@"%@ 1 %@", ___(@"temperature_sobna"), ___(@"volume_suffix")],
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_20_min_pred"),
					   [NSString stringWithFormat:@"%@ 1 %@", ___(@"temperature_sobna"), ___(@"volume_suffix")],
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_med_obroki"),
					   [NSString stringWithFormat:@"%@ 1 %@", ___(@"temperature_sobna"), ___(@"volume_suffix")],
					   ___(@"speed_pocasi")]
					 ];
			break;
		case kMagnezij:
			return @[
					 @[___(@"drinking_na_tesce"),
					   [NSString stringWithFormat:@"%@ 2 %@", ___(@"temperature_hladno"), ___(@"volume_suffix")],
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_opoldne"),
					   [NSString stringWithFormat:@"%@ 1 %@", ___(@"temperature_hladno"), ___(@"volume_suffix")],
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_zvecer"),
					   [NSString stringWithFormat:@"%@ 1 %@", ___(@"temperature_hladno"), ___(@"volume_suffix")],
					   ___(@"speed_pocasi")]
					 ];
			break;
		case kSladkorna:
			return @[
					 @[___(@"drinking_na_tesce"),
					   [NSString stringWithFormat:@"%@ 3 %@", ___(@"temperature_toplo"), ___(@"volume_suffix")],
					   ___(@"speed_razmeroma_hitro")],
					 @[___(@"drinking_pred_kosilom"),
					   [NSString stringWithFormat:@"%@ 1 %@", ___(@"temperature_hladno"), ___(@"volume_suffix")],
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_pred_vecerjo"),
					   [NSString stringWithFormat:@"%@ 1 %@", ___(@"temperature_hladno"), ___(@"volume_suffix")],
					   ___(@"speed_pocasi")]
					 ];
			break;
		case kSlinavka:
			return @[
					 @[___(@"drinking_na_tesce"),
					   [NSString stringWithFormat:@"%@ 3-5 %@", ___(@"temperature_mlacno"), ___(@"volume_suffix")],
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_pred_kosilom"),
					   [NSString stringWithFormat:@"%@ 2 %@", ___(@"temperature_toplo"), ___(@"volume_suffix")],
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_pred_vecerjo"),
					   [NSString stringWithFormat:@"%@ 2 %@", ___(@"temperature_mlacno"), ___(@"volume_suffix")],
					   ___(@"speed_pocasi")]
					 ];
			break;
		case kSecniKamni:
			return @[
					 // TODO: The first speed is not defined in the PDF
					 @[___(@"drinking_na_tesce"),
					   [NSString stringWithFormat:@"%@ 2 %@", ___(@"temperature_mlacno"), ___(@"volume_suffix")],
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_pred_kosilom"),
					   [NSString stringWithFormat:@"%@ 2 %@", ___(@"temperature_mlacno"), ___(@"volume_suffix")],
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_pred_vecerjo"),
					   [NSString stringWithFormat:@"%@ 2 %@", ___(@"temperature_mlacno"), ___(@"volume_suffix")],
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_pred_spanjem"),
					   [NSString stringWithFormat:@"%@ 2 %@", ___(@"temperature_mlacno"), ___(@"volume_suffix")],
					   ___(@"speed_pocasi")]
					 ];
			break;
		case kDebelost:
			return @[
					 @[___(@"drinking_na_tesce"),
					   [NSString stringWithFormat:@"%@ 3-5 %@", ___(@"temperature_toplo"), ___(@"volume_suffix")],
					   ___(@"speed_hitro")],
					 @[___(@"drinking_obcutek_lakote"),
					   [NSString stringWithFormat:@"%@ 1 %@", ___(@"temperature_hladno"), ___(@"volume_suffix")],
					   ___(@"speed_pocasi")]
					 ];
			break;
		case kSrceOzilje:
			return @[
					 @[___(@"drinking_3_4_dnevno"),
					   [NSString stringWithFormat:@"%@ 1 %@", ___(@"temperature_sobna"), ___(@"volume_suffix")],
					   ___(@"speed_pocasi")]
					 ];
			break;
		case kStres:
			return @[
					 @[___(@"drinking_na_tesce"),
					   [NSString stringWithFormat:@"%@ 3 %@", ___(@"temperature_hladno"), ___(@"volume_suffix")],
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_pred_spanjem"),
					   [NSString stringWithFormat:@"%@ 1-2 %@", ___(@"temperature_hladno"), ___(@"volume_suffix")],
					   ___(@"speed_pocasi")]
					 ];
			break;
		case kPocutje:
			return @[
					 @[___(@"drinking_pred_jedjo"),
					   [NSString stringWithFormat:@"%@ 1-2 %@", ___(@"temperature_hladno"), ___(@"volume_suffix")],
					   ___(@"speed_pocasi")]
					 ];
			break;
		default:
			return nil;
			break;
	}
}

- (IndicationType)indicationForDate:(NSDate *)date {
	CalendarHistoryEntry *entry = [self historyItemForDate:date];
	if (entry)
		return entry.indicationType;
	else
		return kUnknown;
}

- (CalendarHistoryEntry *)historyItemForDate:(NSDate *)date {
//	DLog(@"Searching for %@", [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterFullStyle]);
	for (CalendarHistoryEntry *entry in _calendarEntriesHistory) {
		if ([date compare:entry.date] == NSOrderedSame) {
			return entry;
		}
	}
	return nil;
}

- (NSArray *)calculateDrinkingDaysFromDate:(NSDate *)startDate tillDate:(NSDate *)endDate withDrinkDays:(NSInteger)drinkDays pauseDays:(NSInteger)pauseDays andCycles:(NSInteger)cycles {

	NSMutableArray *results = [[NSMutableArray alloc] init];

	NSInteger drink = 0;
	NSInteger pause = 1;
	NSInteger cycle = 1;

	// we need the date without the time
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *todayComponents = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:startDate];
	NSDate *date = [gregorian dateFromComponents:todayComponents];

	while ([date compare:endDate] == NSOrderedAscending) {
		if (drink < drinkDays) {
			[results addObject:date];
			drink++;
		} else {
			if (pause < pauseDays) {
				pause++;
			} else {
				if (cycle == cycles)
					break;
				cycle++;
				pause = 1;
				drink = 0;
			}
		}
		date = [date dateByAddingTimeInterval:(60*60*24)];
	}

	return results;
}

- (NSArray *)simpleDateTraversalFromDate:(NSDate *)startDate tillDate:(NSDate *)endDate {
	// we need the date without the time
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *todayComponents = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:startDate];
	NSDate *date = [gregorian dateFromComponents:todayComponents];

	NSMutableArray *results = [[NSMutableArray alloc] init];

	while ([date compare:endDate] == NSOrderedAscending) {
		[results addObject:date];
		date = [date dateByAddingTimeInterval:(60*60*24)];
	}

	return results;
}

- (NSArray *)drinkingDatesForIndication:(IndicationType)indication fromDate:(NSDate *)startDate andTillDate:(NSDate *)endDate {

	switch (indication) {
		case kZaprtost:
		case kSladkorna:
			return [self calculateDrinkingDaysFromDate:startDate tillDate:endDate withDrinkDays:5 pauseDays:2 andCycles:-1];
			break;
		case kSlinavka:
			return [self calculateDrinkingDaysFromDate:startDate tillDate:endDate withDrinkDays:42 pauseDays:21 andCycles:3];
			break;
		case kDebelost:
			return [self calculateDrinkingDaysFromDate:startDate tillDate:endDate withDrinkDays:90 pauseDays:30 andCycles:3];
			break;
		case kSrceOzilje:
		case kStres:
			return [self calculateDrinkingDaysFromDate:startDate tillDate:endDate withDrinkDays:60 pauseDays:30 andCycles:3];
		default: // kZgaga kMagnezij kSecniKamni kPocutje
			return [self simpleDateTraversalFromDate:startDate tillDate:endDate];
			break;
	}
}

- (NSDate *)noonTime {
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *timeComponents = [[NSDateComponents alloc] init];
	[timeComponents setHour:12];
	[timeComponents setMinute:00];
	return [gregorian dateFromComponents:timeComponents];
}

- (NSDate *)combineDate:(NSDate *)date withTime:(NSDate *)time {
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *dateComponents = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date];
	NSDateComponents *timeComponents = [gregorian components:NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:time];
	[dateComponents setHour:timeComponents.hour];
	[dateComponents setMinute:timeComponents.minute];
	return [gregorian dateFromComponents:dateComponents];
}

- (NSDate *)combineDate:(NSDate *)date withTimeComponents:(NSDateComponents *)time {
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *dateComponents = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date];
	[dateComponents setHour:time.hour];
	[dateComponents setMinute:time.minute];
	return [gregorian dateFromComponents:dateComponents];
}

- (NSDictionary *)createUserInfoForIndication:(IndicationType)indication withStrings:(NSArray *)strings andTimeOfDay:(NSInteger)time {
	NSMutableDictionary *result = [[NSMutableDictionary alloc] init];

	[result setValue:[NSNumber numberWithUnsignedInteger:indication] forKey:@"indication"];
	[result setValue:[NSNumber numberWithUnsignedChar:time] forKey:@"timeOfDay"];
	[result setValue:strings[0] forKey:@"amount"];
	[result setValue:strings[1] forKey:@"temperature"];
	[result setValue:strings[2] forKey:@"speed"];

	return result;
}

- (void)setNotificationAtTime:(NSDate *)time withBody:(NSString *)body andUserInfo:(NSDictionary *)userInfo {
	if ([[NSDate date] compare:time] == NSOrderedAscending) {
		UILocalNotification *testNotifation = [[UILocalNotification alloc] init];
		testNotifation.fireDate = time;
		testNotifation.alertBody = body;
		testNotifation.userInfo = userInfo;
		[[UIApplication sharedApplication] scheduleLocalNotification:testNotifation];
	}
}

- (void)setNotificationPredZajtrkomForDate:(NSDate *)date withStrings:(NSArray *)strings andIndication:(IndicationType)indication {
	NSDate *notificationTime = [[self combineDate:date withTimeComponents:[[SettingsManager sharedManager] breakfastTime]] dateByAddingTimeInterval:(-5*60)];

	[self setNotificationAtTime:notificationTime withBody:@"pred zajtrkom" andUserInfo:[self createUserInfoForIndication:indication withStrings:strings andTimeOfDay:1]];
}

- (void)setNotificationPredKosilomForDate:(NSDate *)date withStrings:(NSArray *)strings andIndication:(IndicationType)indication {
	NSDate *notificationTime = [[self combineDate:date withTimeComponents:[[SettingsManager sharedManager] lunchTime]] dateByAddingTimeInterval:(-5*60)];

	[self setNotificationAtTime:notificationTime withBody:@"pred kosilom" andUserInfo:[self createUserInfoForIndication:indication withStrings:strings andTimeOfDay:2]];
}

- (void)setNotificationPredVecerjoForDate:(NSDate *)date withStrings:(NSArray *)strings andIndication:(IndicationType)indication {
	NSDate *notificationTime = [[self combineDate:date withTimeComponents:[[SettingsManager sharedManager] dinnerTime]] dateByAddingTimeInterval:(-5*60)];

	[self setNotificationAtTime:notificationTime withBody:@"pred vecerjo" andUserInfo:[self createUserInfoForIndication:indication withStrings:strings andTimeOfDay:3]];
}

- (void)setNotificationPredSpanjemForDate:(NSDate *)date withStrings:(NSArray *)strings andIndication:(IndicationType)indication {
	NSDate *notificationTime = [[self combineDate:date withTimeComponents:[[SettingsManager sharedManager] sleepingTime]] dateByAddingTimeInterval:(-5*60)];

	[self setNotificationAtTime:notificationTime withBody:@"pred spanjem" andUserInfo:[self createUserInfoForIndication:indication withStrings:strings andTimeOfDay:3]];
}

- (void)setNotificationPredPoldneForDate:(NSDate *)date withStrings:(NSArray *)strings andIndication:(IndicationType)indication {
	NSDate *notificationTime = [[self combineDate:date withTime:[self noonTime]] dateByAddingTimeInterval:(-5*60)];

	[self setNotificationAtTime:notificationTime withBody:@"pred poldne" andUserInfo:[self createUserInfoForIndication:indication withStrings:strings andTimeOfDay:2]];
}

- (void)setNotificationsForDate:(NSDate *)date andIndication:(IndicationType)indication {
	NSArray *strings = [self stringsForIndication:indication];

	switch (indication) {
		case kZaprtost:
			[self setNotificationPredZajtrkomForDate:date withStrings:strings[0] andIndication:indication];
			[self setNotificationPredSpanjemForDate:date withStrings:strings[1] andIndication:indication];
			break;
		case kZgaga:
			// TODO: ??
			break;
		case kMagnezij:
			[self setNotificationPredZajtrkomForDate:date withStrings:strings[0] andIndication:indication];
			[self setNotificationPredPoldneForDate:date withStrings:strings[1] andIndication:indication];
			[self setNotificationPredVecerjoForDate:date withStrings:strings[2] andIndication:indication];
			break;
		case kSladkorna:
			[self setNotificationPredZajtrkomForDate:date withStrings:strings[0] andIndication:indication];
			[self setNotificationPredKosilomForDate:date withStrings:strings[1] andIndication:indication];
			[self setNotificationPredVecerjoForDate:date withStrings:strings[2] andIndication:indication];
			break;
		case kSlinavka:
			[self setNotificationPredZajtrkomForDate:date withStrings:strings[0] andIndication:indication];
			[self setNotificationPredKosilomForDate:date withStrings:strings[1] andIndication:indication];
			[self setNotificationPredVecerjoForDate:date withStrings:strings[2] andIndication:indication];
			break;
		case kSecniKamni:
			[self setNotificationPredZajtrkomForDate:date withStrings:strings[0] andIndication:indication];
			[self setNotificationPredKosilomForDate:date withStrings:strings[1] andIndication:indication];
			[self setNotificationPredVecerjoForDate:date withStrings:strings[2] andIndication:indication];
			[self setNotificationPredSpanjemForDate:date withStrings:strings[3] andIndication:indication];
			break;
		case kDebelost:
			[self setNotificationPredZajtrkomForDate:date withStrings:strings[0] andIndication:indication];
			[self setNotificationPredKosilomForDate:date withStrings:strings[1] andIndication:indication];
			[self setNotificationPredVecerjoForDate:date withStrings:strings[1] andIndication:indication];
			break;
		case kSrceOzilje:
			// TODO: ??
			break;
		case kStres:
			[self setNotificationPredZajtrkomForDate:date withStrings:strings[0] andIndication:indication];
			[self setNotificationPredSpanjemForDate:date withStrings:strings[1] andIndication:indication];
			break;
		case kPocutje:
			[self setNotificationPredZajtrkomForDate:date withStrings:strings[0] andIndication:indication];
			[self setNotificationPredKosilomForDate:date withStrings:strings[0] andIndication:indication];
			[self setNotificationPredVecerjoForDate:date withStrings:strings[0] andIndication:indication];
			break;
		default:
			break;
	}
}

- (void)startTreatmentForIndication:(IndicationType)indication fromDate:(NSDate *)date {
	[self cancelActiveTreatment];

	NSArray *daysToDrink = [self drinkingDatesForIndication:indication fromDate:date andTillDate:[date dateByAddingTimeInterval:(60*60*24*365)]];

	NSUInteger count = 0;

	for (NSDate *entryDate in daysToDrink) {
		[_calendarEntriesHistory addObject:[CalendarHistoryEntry entryWithDate:entryDate startDate:date andIndicationType:indication]];

		// for now set notifications for 10 days, good for testing, needs to be removed
		if (count++ < 11)
			[self setNotificationsForDate:entryDate andIndication:indication];
	}

	[self writeOutHistory];

	[[SettingsManager sharedManager] setActiveIndication:indication];
	[[SettingsManager sharedManager] setIndicationActivation:date];
}

- (void)cancelActiveTreatment {
	if (self.activeIndication != kUnknown) {

		// we need today without the time
		NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		NSDateComponents *todayComponents = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[NSDate date]];
		NSDate *today = [gregorian dateFromComponents:todayComponents];

		NSMutableArray *removeItems = [[NSMutableArray alloc] init];

		for (CalendarHistoryEntry *entry in _calendarEntriesHistory) {
			if ([today compare:entry.date] != NSOrderedDescending) {
				[removeItems addObject:entry];
			}
		}

		for (CalendarHistoryEntry *entry in removeItems)
			[_calendarEntriesHistory removeObject:entry];

		[self writeOutHistory];
	}

	[[UIApplication sharedApplication] cancelAllLocalNotifications];

	[[SettingsManager sharedManager] setActiveIndication:kUnknown];
	[[SettingsManager sharedManager] setIndicationActivation:[NSDate date]];
}

@end
