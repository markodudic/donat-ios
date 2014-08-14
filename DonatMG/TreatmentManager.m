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
	NSDate *today = [NSDate todayWithoutTime];

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
		_calendarEntriesHistory = [[NSMutableArray alloc] init];

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
		case kZgaga:
		case kZaprtost:
		case kDebelost:
		case kStres:
			return 2;
			break;
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

// Pass 0 (or less than first) as second parameter and only the first will be used
- (NSString *)volumeStringFrom:(NSInteger)first toNumber:(NSInteger)second {
	if ([[[LanguageManager sharedManager] currentLangId] isEqual:@"ru"]) {
		first *= 100;
		second *= 100;
	}
	if (second > first)
		return [NSString stringWithFormat:@"%d-%d %@", (int)first, (int)second, ___(@"volume_suffix")];
	else
		return [NSString stringWithFormat:@"%d %@", (int)first, ___(@"volume_suffix")];
}

- (NSArray *)stringsForIndication:(IndicationType)indication {
	switch (indication) {
		case kZaprtost:
			return @[
					 @[___(@"drinking_na_tesce"),
					   [self volumeStringFrom:3 toNumber:8],
//					   [NSString stringWithFormat:@"3-8 %@", ___(@"volume_suffix")],
					   ___(@"temperature_toplo"),
					   ___(@"speed_hitro")],
					 @[___(@"drinking_pred_spanjem-1"),
					   [self volumeStringFrom:2 toNumber:0],
//					   [NSString stringWithFormat:@"2 %@", ___(@"volume_suffix")],
					   ___(@"temperature_mlacno"),
					   ___(@"speed_razmeroma_hitro")]
                     ];
			break;
		case kZgaga:
			return @[
					 @[___(@"drinking_20_min_pred"),
					   [self volumeStringFrom:1 toNumber:0],
//					   [NSString stringWithFormat:@"1 %@", ___(@"volume_suffix")],
					   ___(@"temperature_sobna"),
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_med_obroki"),
					   [self volumeStringFrom:1 toNumber:0],
//					   [NSString stringWithFormat:@"1 %@", ___(@"volume_suffix")],
					   ___(@"temperature_sobna"),
					   ___(@"speed_pocasi")]
					 ];
			break;
		case kMagnezij:
			return @[
					 @[___(@"drinking_na_tesce"),
					   [self volumeStringFrom:2 toNumber:0],
//					   [NSString stringWithFormat:@"2 %@", ___(@"volume_suffix")],
					   ___(@"temperature_hladno"),
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_opoldne"),
					   [self volumeStringFrom:1 toNumber:0],
//					   [NSString stringWithFormat:@"1 %@", ___(@"volume_suffix")],
					   ___(@"temperature_hladno"),
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_zvecer"),
					   [self volumeStringFrom:1 toNumber:0],
//					   [NSString stringWithFormat:@"1 %@", ___(@"volume_suffix")],
					   ___(@"temperature_hladno"),
					   ___(@"speed_pocasi")]
					 ];
			break;
		case kSladkorna:
			return @[
					 @[___(@"drinking_na_tesce"),
					   [self volumeStringFrom:3 toNumber:0],
//					   [NSString stringWithFormat:@"3 %@", ___(@"volume_suffix")],
					   ___(@"temperature_toplo"),
					   ___(@"speed_razmeroma_hitro")],
					 @[___(@"drinking_pred_kosilom"),
					   [self volumeStringFrom:1 toNumber:0],
//					   [NSString stringWithFormat:@"1 %@", ___(@"volume_suffix")],
					   ___(@"temperature_hladno"),
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_pred_vecerjo"),
					   [self volumeStringFrom:1 toNumber:0],
//					   [NSString stringWithFormat:@"1 %@", ___(@"volume_suffix")],
					   ___(@"temperature_hladno"),
					   ___(@"speed_pocasi")]
					 ];
			break;
		case kSlinavka:
			return @[
					 @[___(@"drinking_na_tesce"),
					   [self volumeStringFrom:3 toNumber:5],
//					   [NSString stringWithFormat:@"3-5 %@", ___(@"volume_suffix")],
					   ___(@"temperature_mlacno"),
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_pred_kosilom"),
					   [self volumeStringFrom:2 toNumber:0],
//					   [NSString stringWithFormat:@"2 %@", ___(@"volume_suffix")],
					   ___(@"temperature_toplo"),
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_pred_vecerjo"),
					   [self volumeStringFrom:2 toNumber:0],
//					   [NSString stringWithFormat:@"2 %@", ___(@"volume_suffix")],
					   ___(@"temperature_mlacno"),
					   ___(@"speed_pocasi")]
					 ];
			break;
		case kSecniKamni:
			return @[
					 // TODO: The first speed is not defined in the PDF
					 @[___(@"drinking_na_tesce"),
					   [self volumeStringFrom:2 toNumber:0],
//					   [NSString stringWithFormat:@"2 %@", ___(@"volume_suffix")],
					   ___(@"temperature_mlacno"),
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_pred_kosilom"),
					   [self volumeStringFrom:2 toNumber:0],
//					   [NSString stringWithFormat:@"2 %@", ___(@"volume_suffix")],
					   ___(@"temperature_mlacno"),
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_pred_vecerjo"),
					   [self volumeStringFrom:2 toNumber:0],
//					   [NSString stringWithFormat:@"2 %@", ___(@"volume_suffix")],
					   ___(@"temperature_mlacno"),
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_pred_spanjem-6"),
					   [self volumeStringFrom:2 toNumber:0],
//					   [NSString stringWithFormat:@"2 %@", ___(@"volume_suffix")],
					   ___(@"temperature_mlacno"),
					   ___(@"speed_pocasi")]
					 ];
			break;
		case kDebelost:
			return @[
					 @[___(@"drinking_na_tesce"),
					   [self volumeStringFrom:3 toNumber:5],
//					   [NSString stringWithFormat:@"3-5 %@", ___(@"volume_suffix")],
					   ___(@"temperature_toplo"),
					   ___(@"speed_hitro")],
					 @[___(@"drinking_obcutek_lakote"),
					   [self volumeStringFrom:1 toNumber:0],
//					   [NSString stringWithFormat:@"1 %@",___(@"volume_suffix")],
					   ___(@"temperature_hladno"),
					   ___(@"speed_pocasi")]
					 ];
			break;
		case kSrceOzilje:
			return @[
					 @[___(@"drinking_3_4_dnevno"),
					   [self volumeStringFrom:1 toNumber:0],
//					   [NSString stringWithFormat:@"1 %@", ___(@"volume_suffix")],
					   ___(@"temperature_sobna"),
					   ___(@"speed_pocasi")]
					 ];
			break;
		case kStres:
			return @[
					 @[___(@"drinking_na_tesce"),
					   [self volumeStringFrom:3 toNumber:0],
//					   [NSString stringWithFormat:@"3 %@", ___(@"volume_suffix")],
					   ___(@"temperature_hladno"),
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_pred_spanjem"),
					   [self volumeStringFrom:1 toNumber:2],
//					   [NSString stringWithFormat:@"1-2 %@", ___(@"volume_suffix")],
					   ___(@"temperature_hladno"),
					   ___(@"speed_pocasi")]
					 ];
			break;
		case kPocutje:
			return @[
					 @[___(@"drinking_pred_jedjo"),
					   [self volumeStringFrom:1 toNumber:2],
//					   [NSString stringWithFormat:@"1-2 %@", ___(@"volume_suffix")],
					   ___(@"temperature_hladno"),
					   ___(@"speed_pocasi")]
					 ];
			break;
		default:
			return nil;
			break;
	}
}


- (NSArray *)notificationIconsForIndication:(IndicationType)indication {
	switch (indication) {
		case kZaprtost:
			return @[
					 [NSNumber numberWithUnsignedInteger:todNaTesce],
					 [NSNumber numberWithUnsignedInteger:todPredSpanjem]
					 ];
			break;
		case kZgaga:
			return @[
					 [NSNumber numberWithUnsignedInteger:tod20minutPred],
					 [NSNumber numberWithUnsignedInteger:todMedObroki]
					 ];
			break;
		case kMagnezij:
			return @[
					 [NSNumber numberWithUnsignedInteger:todNaTesce],
					 [NSNumber numberWithUnsignedInteger:todOpoldne],
					 [NSNumber numberWithUnsignedInteger:todPredVecerjo]
					 ];
			break;
		case kSladkorna:
			return @[
					 [NSNumber numberWithUnsignedInteger:todNaTesce],
					 [NSNumber numberWithUnsignedInteger:todPredKosilom],
					 [NSNumber numberWithUnsignedInteger:todPredVecerjo]
					 ];
			break;
		case kSlinavka:
			return @[
					 [NSNumber numberWithUnsignedInteger:todNaTesce],
					 [NSNumber numberWithUnsignedInteger:todPredKosilom],
					 [NSNumber numberWithUnsignedInteger:todPredVecerjo]
					 ];
			break;
		case kSecniKamni:
			return @[
					 [NSNumber numberWithUnsignedInteger:todNaTesce],
					 [NSNumber numberWithUnsignedInteger:todPredKosilom],
					 [NSNumber numberWithUnsignedInteger:todPredVecerjo],
					 [NSNumber numberWithUnsignedInteger:todPredSpanjem]
					 ];
			break;
		case kDebelost:
			return @[
					 [NSNumber numberWithUnsignedInteger:todNaTesce],
					 [NSNumber numberWithUnsignedInteger:todPredKosilom],
					 [NSNumber numberWithUnsignedInteger:todPredVecerjo]
					 ];
			break;
		case kSrceOzilje:
			return @[
					 [NSNumber numberWithUnsignedInteger:todVeckratDnevno],
					 [NSNumber numberWithUnsignedInteger:todVeckratDnevno]
					 ];
			break;
		case kStres:
			return @[
					 [NSNumber numberWithUnsignedInteger:todNaTesce],
					 [NSNumber numberWithUnsignedInteger:todPredSpanjem]
					 ];
			break;
		case kPocutje:
			return @[
					 [NSNumber numberWithUnsignedInteger:todPredJedjo],
					 [NSNumber numberWithUnsignedInteger:todPredJedjo]
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

- (NSString *)imageForTimeOfDay:(TimeOfDayType)timeOfDay {
	switch (timeOfDay) {
		case todMedObroki:
			return @"icon_med_obroki.png";
			break;
		case todNaTesce:
			return @"icon_na_tesce.png";
			break;
		case todOpoldne:
			return @"icon_opoldne.png";
			break;
		case todPredJedjo:
			return @"icon_pred_jedjo.png";
			break;
		case todPredSpanjem:
			return @"icon_pred_spanjem.png";
			break;
		case todVeckratDnevno:
			return @"icon_veckrat_dnevno.png";
			break;
		case todZvecer:
			return @"icon_zvecer.png";
			break;
		case tod20minutPred:
			return @"icon_pred_jedjo.png";
			break;
		case todPredKosilom:
			return @"icon_pred_jedjo.png";
			break;
		case todPredVecerjo:
			return @"icon_pred_jedjo.png";
			break;
		case todObcutekLakote:
			return @"icon_ure.png";
			break;
		case tod34kratDnevno:
			return @"icon_ure.png";
			break;
		default:
			return nil;
			break;
	}
}

- (NSString *)textForTimeOfDay:(TimeOfDayType)timeOfDay {
	switch (timeOfDay) {
		case todMedObroki:
			return ___(@"drinking_med_obroki");
			break;
		case todNaTesce:
			return ___(@"drinking_na_tesce");
			break;
		case todOpoldne:
			return ___(@"drinking_opoldne");
			break;
		case todPredJedjo:
			return ___(@"drinking_pred_jedjo");
			break;
		case todPredSpanjem:
			return ___(@"drinking_pred_spanjem");
			break;
		case todVeckratDnevno:
			return ___(@"drinking_veckrat_dnevno");
			break;
		case todZvecer:
			return ___(@"drinking_zvecer");
			break;
		case tod20minutPred:
			return ___(@"drinking_20_min_pred");
			break;
		case todPredKosilom:
			return ___(@"drinking_pred_kosilom");
			break;
		case todPredVecerjo:
			return ___(@"drinking_pred_vecerjo");
			break;
		case todObcutekLakote:
			return ___(@"drinking_obcutek_lakote");
			break;
		case tod34kratDnevno:
			return ___(@"drinking_3_4_dnevno");
			break;
		default:
			return nil;
			break;
	}
}

- (NSArray *)calculateDrinkingDaysFromDate:(NSDate *)startDate tillDate:(NSDate *)endDate withDrinkDays:(NSInteger)drinkDays pauseDays:(NSInteger)pauseDays andCycles:(NSInteger)cycles {

	NSMutableArray *results = [[NSMutableArray alloc] init];

	NSInteger drink = 0;
	NSInteger pause = 1;
	NSInteger cycle = 1;

	// we need the date without the time
	NSDate *date = [startDate dateWithoutTime];

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
	NSDate *date = [startDate dateWithoutTime];

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

- (NSDictionary *)createUserInfoForIndication:(IndicationType)indication withStrings:(NSArray *)strings actionString:(NSString *)actionString andTimeOfDay:(NSInteger)time {
	NSMutableDictionary *result = [[NSMutableDictionary alloc] init];

	[result setValue:[NSNumber numberWithUnsignedInteger:indication] forKey:@"indication"];
	[result setValue:[NSNumber numberWithUnsignedChar:time] forKey:@"timeOfDay"];
	[result setValue:strings[2] forKey:@"amount"];
	[result setValue:strings[1] forKey:@"temperature"];
	[result setValue:strings[3] forKey:@"speed"];
	[result setValue:actionString forKey:@"actionString"];

	return result;
}

- (NSString *)createBodyStringWithAction:(NSString *)body andUserinfo:(NSDictionary *)info {
	return [NSString stringWithFormat:@"%@ %@ %@ %@", body, [info objectForKey:@"temperature"], [info objectForKey:@"amount"], [info objectForKey:@"speed"]];
}

- (void)setNotificationAtTime:(NSDate *)time withBody:(NSString *)body andUserInfo:(NSDictionary *)userInfo {
	if ([[NSDate date] compare:time] == NSOrderedAscending) {
		DLog(@"Setting notification for time %@", [NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterFullStyle]);
		UILocalNotification *testNotifation = [[UILocalNotification alloc] init];
		testNotifation.fireDate = time;
		testNotifation.alertBody = [self createBodyStringWithAction:body andUserinfo:userInfo];
		testNotifation.userInfo = userInfo;
		testNotifation.applicationIconBadgeNumber = 1;
		testNotifation.soundName = UILocalNotificationDefaultSoundName;
		[[UIApplication sharedApplication] scheduleLocalNotification:testNotifation];
	}
}

- (void)setNotificationPredZajtrkomForDate:(NSDate *)date withStrings:(NSArray *)strings timeOfDay:(NSInteger)time andIndication:(IndicationType)indication {
	NSDate *notificationTime = [[self combineDate:date withTimeComponents:[[SettingsManager sharedManager] breakfastTime]] dateByAddingTimeInterval:(-5*60)];

	[self setNotificationAtTime:notificationTime withBody:___(@"drinking_na_tesce") andUserInfo:[self createUserInfoForIndication:indication withStrings:strings actionString:___(@"drinking_na_tesce") andTimeOfDay:time]];
}

- (void)setNotificationPredKosilomForDate:(NSDate *)date withStrings:(NSArray *)strings timeOfDay:(NSInteger)time andIndication:(IndicationType)indication {
	NSDate *notificationTime = [[self combineDate:date withTimeComponents:[[SettingsManager sharedManager] lunchTime]] dateByAddingTimeInterval:(-5*60)];

	[self setNotificationAtTime:notificationTime withBody:___(@"drinking_pred_kosilom") andUserInfo:[self createUserInfoForIndication:indication withStrings:strings actionString:___(@"drinking_pred_kosilom") andTimeOfDay:time]];
}

- (void)setNotificationPredVecerjoForDate:(NSDate *)date withStrings:(NSArray *)strings timeOfDay:(NSInteger)time andIndication:(IndicationType)indication {
	NSDate *notificationTime = [[self combineDate:date withTimeComponents:[[SettingsManager sharedManager] dinnerTime]] dateByAddingTimeInterval:(-5*60)];

	[self setNotificationAtTime:notificationTime withBody:___(@"drinking_pred_vecerjo") andUserInfo:[self createUserInfoForIndication:indication withStrings:strings actionString:___(@"drinking_pred_vecerjo") andTimeOfDay:time]];
}

- (void)setNotificationPredSpanjemForDate:(NSDate *)date withStrings:(NSArray *)strings timeOfDay:(NSInteger)time andIndication:(IndicationType)indication {
	NSDate *notificationTime = [[self combineDate:date withTimeComponents:[[SettingsManager sharedManager] sleepingTime]] dateByAddingTimeInterval:(-5*60)];

	[self setNotificationAtTime:notificationTime withBody:___(@"drinking_pred_spanjem") andUserInfo:[self createUserInfoForIndication:indication withStrings:strings actionString:___(@"drinking_pred_spanjem") andTimeOfDay:time]];
}

- (void)setNotificationOpoldneForDate:(NSDate *)date withStrings:(NSArray *)strings timeOfDay:(NSInteger)time andIndication:(IndicationType)indication {
	NSDate *notificationTime = [[self combineDate:date withTime:[self noonTime]] dateByAddingTimeInterval:(-5*60)];

	[self setNotificationAtTime:notificationTime withBody:___(@"drinking_opoldne") andUserInfo:[self createUserInfoForIndication:indication withStrings:strings actionString:___(@"drinking_opoldne") andTimeOfDay:time]];
}

- (void)setNotificationsForZgagaWithStrings:(NSArray *)strings onDate:(NSDate *)date {
	// 20 min pred jedjo - 25 min pred vsakim obrokom

	// pred zajtrkom
	NSDate *notificationTime = [[self combineDate:date withTimeComponents:[[SettingsManager sharedManager] breakfastTime]] dateByAddingTimeInterval:(-30*60)];
	[self setNotificationAtTime:notificationTime withBody:___(@"drinking_pred_jedjo") andUserInfo:[self createUserInfoForIndication:kZgaga withStrings:strings actionString:___(@"drinking_pred_jedjo") andTimeOfDay:2]];

	//pred kosilom
	notificationTime = [[self combineDate:date withTimeComponents:[[SettingsManager sharedManager] lunchTime]] dateByAddingTimeInterval:(-25*60)];
	[self setNotificationAtTime:notificationTime withBody:___(@"drinking_pred_jedjo") andUserInfo:[self createUserInfoForIndication:kZgaga withStrings:strings actionString:___(@"drinking_pred_jedjo") andTimeOfDay:2]];

	// pred vecerjo
	notificationTime = [[self combineDate:date withTimeComponents:[[SettingsManager sharedManager] dinnerTime]] dateByAddingTimeInterval:(-25*60)];
	[self setNotificationAtTime:notificationTime withBody:___(@"drinking_pred_jedjo") andUserInfo:[self createUserInfoForIndication:kZgaga withStrings:strings actionString:___(@"drinking_pred_jedjo") andTimeOfDay:2]];

	// Med obroki in 1-2 uri po jedi - 1:30h po obroku

	// po zajtrku
	notificationTime = [[self combineDate:date withTimeComponents:[[SettingsManager sharedManager] breakfastTime]] dateByAddingTimeInterval:(90*60)];
	[self setNotificationAtTime:notificationTime withBody:___(@"drinking_med_obroki") andUserInfo:[self createUserInfoForIndication:kZgaga withStrings:strings actionString:___(@"drinking_med_obroki") andTimeOfDay:3]];

	// po kosilu
	notificationTime = [[self combineDate:date withTimeComponents:[[SettingsManager sharedManager] lunchTime]] dateByAddingTimeInterval:(90*60)];
	[self setNotificationAtTime:notificationTime withBody:___(@"drinking_med_obroki") andUserInfo:[self createUserInfoForIndication:kZgaga withStrings:strings actionString:___(@"drinking_med_obroki") andTimeOfDay:3]];

	// po vecerji
	notificationTime = [[self combineDate:date withTimeComponents:[[SettingsManager sharedManager] dinnerTime]] dateByAddingTimeInterval:(90*60)];
	[self setNotificationAtTime:notificationTime withBody:___(@"drinking_med_obroki") andUserInfo:[self createUserInfoForIndication:kZgaga withStrings:strings actionString:___(@"drinking_med_obroki") andTimeOfDay:3]];
}

- (void)setNotificationsForSrceOziljeWithStrings:(NSArray *)strings onDate:(NSDate *)date {
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDate *wakeTime = [gregorian dateFromComponents:[[SettingsManager sharedManager] wakeTime]];
	NSDate *sleepTime = [gregorian dateFromComponents:[[SettingsManager sharedManager] sleepingTime]];

	NSDate *start = [self combineDate:date withTime:wakeTime];
	NSDate *end = [self combineDate:date withTime:sleepTime];

	NSTimeInterval secondsbetween = [end timeIntervalSinceDate:start];
	NSTimeInterval period = secondsbetween / 3;

	NSDate *first = [start dateByAddingTimeInterval:period];
	NSDate *second = [first dateByAddingTimeInterval:period];

	[self setNotificationAtTime:start withBody:___(@"drinking_veckrat_dnevno") andUserInfo:[self createUserInfoForIndication:kSrceOzilje withStrings:strings actionString:___(@"drinking_veckrat_dnevno") andTimeOfDay:1]];
	[self setNotificationAtTime:first withBody:___(@"drinking_veckrat_dnevno") andUserInfo:[self createUserInfoForIndication:kSrceOzilje withStrings:strings actionString:___(@"drinking_veckrat_dnevno") andTimeOfDay:1]];
	[self setNotificationAtTime:second withBody:___(@"drinking_veckrat_dnevno") andUserInfo:[self createUserInfoForIndication:kSrceOzilje withStrings:strings actionString:___(@"drinking_veckrat_dnevno") andTimeOfDay:1]];
	[self setNotificationAtTime:end withBody:___(@"drinking_veckrat_dnevno") andUserInfo:[self createUserInfoForIndication:kSrceOzilje withStrings:strings actionString:___(@"drinking_veckrat_dnevno") andTimeOfDay:1]];
}

- (void)setNotificationsForDate:(NSDate *)date andIndication:(IndicationType)indication {
	NSArray *strings = [self stringsForIndication:indication];

	switch (indication) {
		case kZaprtost:
			[self setNotificationPredZajtrkomForDate:date withStrings:strings[0] timeOfDay:1 andIndication:indication];
			[self setNotificationPredSpanjemForDate:date withStrings:strings[1] timeOfDay:2 andIndication:indication];
			break;
		case kZgaga:
			[self setNotificationsForZgagaWithStrings:strings[0] onDate:date];
			break;
		case kMagnezij:
			[self setNotificationPredZajtrkomForDate:date withStrings:strings[0] timeOfDay:1 andIndication:indication];
			[self setNotificationOpoldneForDate:date withStrings:strings[1] timeOfDay:2 andIndication:indication];
			[self setNotificationPredVecerjoForDate:date withStrings:strings[2] timeOfDay:3 andIndication:indication];
			break;
		case kSladkorna:
			[self setNotificationPredZajtrkomForDate:date withStrings:strings[0] timeOfDay:1 andIndication:indication];
			[self setNotificationPredKosilomForDate:date withStrings:strings[1] timeOfDay:2 andIndication:indication];
			[self setNotificationPredVecerjoForDate:date withStrings:strings[2] timeOfDay:3 andIndication:indication];
			break;
		case kSlinavka:
			[self setNotificationPredZajtrkomForDate:date withStrings:strings[0] timeOfDay:1 andIndication:indication];
			[self setNotificationPredKosilomForDate:date withStrings:strings[1] timeOfDay:2 andIndication:indication];
			[self setNotificationPredVecerjoForDate:date withStrings:strings[2] timeOfDay:3 andIndication:indication];
			break;
		case kSecniKamni:
			[self setNotificationPredZajtrkomForDate:date withStrings:strings[0] timeOfDay:1 andIndication:indication];
			[self setNotificationPredKosilomForDate:date withStrings:strings[1] timeOfDay:2 andIndication:indication];
			[self setNotificationPredVecerjoForDate:date withStrings:strings[2] timeOfDay:3 andIndication:indication];
			[self setNotificationPredSpanjemForDate:date withStrings:strings[3] timeOfDay:4 andIndication:indication];
			break;
		case kDebelost:
			[self setNotificationPredZajtrkomForDate:date withStrings:strings[0] timeOfDay:1 andIndication:indication];
			[self setNotificationPredKosilomForDate:date withStrings:strings[1] timeOfDay:2 andIndication:indication];
			[self setNotificationPredVecerjoForDate:date withStrings:strings[1] timeOfDay:3 andIndication:indication];
			break;
		case kSrceOzilje:
			[self setNotificationsForSrceOziljeWithStrings:strings[0] onDate:date];
			break;
		case kStres:
			[self setNotificationPredZajtrkomForDate:date withStrings:strings[0] timeOfDay:1 andIndication:indication];
			[self setNotificationPredSpanjemForDate:date withStrings:strings[1] timeOfDay:2 andIndication:indication];
			break;
		case kPocutje:
			[self setNotificationPredZajtrkomForDate:date withStrings:strings[0] timeOfDay:1 andIndication:indication];
			[self setNotificationPredKosilomForDate:date withStrings:strings[0] timeOfDay:2 andIndication:indication];
			[self setNotificationPredVecerjoForDate:date withStrings:strings[0] timeOfDay:3 andIndication:indication];
			break;
		default:
			break;
	}
}

- (void)startTreatmentForIndication:(IndicationType)indication fromDate:(NSDate *)date {
	[self cancelActiveTreatment];

	NSArray *daysToDrink = [self drinkingDatesForIndication:indication fromDate:date andTillDate:[date dateByAddingTimeInterval:(60*60*24*365)]];

	for (NSDate *entryDate in daysToDrink)
		[_calendarEntriesHistory addObject:[CalendarHistoryEntry entryWithDate:entryDate startDate:date andIndicationType:indication]];

	[self writeOutHistory];

	[[SettingsManager sharedManager] setActiveIndication:indication];
	[[SettingsManager sharedManager] setIndicationActivation:date];

	[self checkForUnsetNotifications];
}

- (void)cancelActiveTreatment {
	if (self.activeIndication != kUnknown) {

		// we need today without the time
		NSDate *today = [NSDate todayWithoutTime];

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

- (void)recalculateTreatment {
	if (self.activeIndication != kUnknown) {
		IndicationType indication = self.activeIndication;
		NSDate *activation = self.indicationActivation;

		[self startTreatmentForIndication:indication fromDate:activation];
	}
}

#pragma mark - Local Notification handling

- (void)checkForUnsetNotifications {
	// No need to do anything if no indication is active
	if (self.activeIndication == kUnknown)
		return;

	// Check for the minimum number of active notifications
	if ([[[UIApplication sharedApplication] scheduledLocalNotifications] count] > kMinNumberOfNotifications)
		return;

	for (CalendarHistoryEntry *entry in _calendarEntriesHistory) {
		NSTimeInterval timeInterval = [entry.date timeIntervalSinceNow];
		if (timeInterval > 0 && timeInterval < kSetNotificationsForDays * 86400 && !entry.notificationsSet) {
			[self setNotificationsForDate:entry.date andIndication:entry.indicationType];
			entry.notificationsSet = YES;
		}
	}

	[self writeOutHistory];
}

@end
