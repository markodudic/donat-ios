//
//	TreatmentManager.m
//	DonatMG
//
//	Created by Goran Blažič on 07/07/14.
//	Copyright (c) 2014 renderspace.si. All rights reserved.
//

#import "TreatmentManager.h"
#import "CalendarHistoryEntry.h"

@implementation TreatmentManager

#define kHistoryArchiveKey @"history"

#pragma mark Singleton Methods

+ (id)sharedManager {
	static TreatmentManager *sharedTreatmentManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedTreatmentManager = [[self alloc] init];
	});
	return sharedTreatmentManager;
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

	// We start 2 days ago
	NSDate *dateToAdd = [today dateByAddingTimeInterval:-(2*60*60*24)];
	for (NSUInteger indication = kPocutje; indication > kUnknown; indication--) {
		for (NSUInteger count = 0; count < 3; count++) {
			[_calendarEntriesHistory addObject:[CalendarHistoryEntry entryWithDate:dateToAdd andIndicationType:indication]];
			// go to day before
			dateToAdd = [dateToAdd dateByAddingTimeInterval:-(60*60*24)];
		}
		// skip 2 days
		dateToAdd = [dateToAdd dateByAddingTimeInterval:-(2*60*60*24)];
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
					   [NSString stringWithFormat:@"%@ 3-8%@", ___(@"temperature_toplo"), ___(@"volume_suffix")],
					   ___(@"speed_hitro")],
					 @[___(@"drinking_pred_spanjem"),
					   [NSString stringWithFormat:@"%@ 2%@", ___(@"temperature_mlacno"), ___(@"volume_suffix")],
					   ___(@"speed_razmeroma_hitro")]
					];
			break;
		case kZgaga:
			return @[
					 @[___(@"drinking_veckrat_dnevno"),
					   [NSString stringWithFormat:@"%@ 1%@", ___(@"temperature_sobna"), ___(@"volume_suffix")],
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_20_min_pred"),
					   [NSString stringWithFormat:@"%@ 1%@", ___(@"temperature_sobna"), ___(@"volume_suffix")],
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_med_obroki"),
					   [NSString stringWithFormat:@"%@ 1%@", ___(@"temperature_sobna"), ___(@"volume_suffix")],
					   ___(@"speed_pocasi")]
					 ];
			break;
		case kMagnezij:
			return @[
					 @[___(@"drinking_na_tesce"),
					   [NSString stringWithFormat:@"%@ 2%@", ___(@"temperature_hladno"), ___(@"volume_suffix")],
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_opoldne"),
					   [NSString stringWithFormat:@"%@ 1%@", ___(@"temperature_hladno"), ___(@"volume_suffix")],
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_zvecer"),
					   [NSString stringWithFormat:@"%@ 1%@", ___(@"temperature_hladno"), ___(@"volume_suffix")],
					   ___(@"speed_pocasi")]
					 ];
			break;
		case kSladkorna:
			return @[
					 @[___(@"drinking_na_tesce"),
					   [NSString stringWithFormat:@"%@ 3%@", ___(@"temperature_toplo"), ___(@"volume_suffix")],
					   ___(@"speed_razmeroma_hitro")],
					 @[___(@"drinking_pred_kosilom"),
					   [NSString stringWithFormat:@"%@ 1%@", ___(@"temperature_hladno"), ___(@"volume_suffix")],
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_pred_vecerjo"),
					   [NSString stringWithFormat:@"%@ 1%@", ___(@"temperature_hladno"), ___(@"volume_suffix")],
					   ___(@"speed_pocasi")]
					 ];
			break;
		case kSlinavka:
			return @[
					 @[___(@"drinking_na_tesce"),
					   [NSString stringWithFormat:@"%@ 3-5%@", ___(@"temperature_mlacno"), ___(@"volume_suffix")],
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_pred_kosilom"),
					   [NSString stringWithFormat:@"%@ 2%@", ___(@"temperature_toplo"), ___(@"volume_suffix")],
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_pred_vecerjo"),
					   [NSString stringWithFormat:@"%@ 2%@", ___(@"temperature_mlacno"), ___(@"volume_suffix")],
					   ___(@"speed_pocasi")]
					 ];
			break;
		case kSecniKamni:
			return @[
					 // TODO: The first speed is not defined in the PDF
					 @[___(@"drinking_na_tesce"),
					   [NSString stringWithFormat:@"%@ 2%@", ___(@"temperature_mlacno"), ___(@"volume_suffix")],
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_pred_kosilom"),
					   [NSString stringWithFormat:@"%@ 2%@", ___(@"temperature_mlacno"), ___(@"volume_suffix")],
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_pred_vecerjo"),
					   [NSString stringWithFormat:@"%@ 2%@", ___(@"temperature_mlacno"), ___(@"volume_suffix")],
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_pred_spanjem"),
					   [NSString stringWithFormat:@"%@ 2%@", ___(@"temperature_mlacno"), ___(@"volume_suffix")],
					   ___(@"speed_pocasi")]
					 ];
			break;
		case kDebelost:
			return @[
					 @[___(@"drinking_na_tesce"),
					   [NSString stringWithFormat:@"%@ 3-5%@", ___(@"temperature_toplo"), ___(@"volume_suffix")],
					   ___(@"speed_hitro")],
					 @[___(@"drinking_obcutek_lakote"),
					   [NSString stringWithFormat:@"%@ 1%@", ___(@"temperature_hladno"), ___(@"volume_suffix")],
					   ___(@"speed_pocasi")]
					 ];
			break;
		case kSrceOzilje:
			return @[
					 @[___(@"drinking_3_4_dnevno"),
					   [NSString stringWithFormat:@"%@ 1%@", ___(@"temperature_sobna"), ___(@"volume_suffix")],
					   ___(@"speed_pocasi")]
					 ];
			break;
		case kStres:
			return @[
					 @[___(@"drinking_na_tesce"),
					   [NSString stringWithFormat:@"%@ 3%@", ___(@"temperature_hladno"), ___(@"volume_suffix")],
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_pred_spanjem"),
					   [NSString stringWithFormat:@"%@ 1-2%@", ___(@"temperature_hladno"), ___(@"volume_suffix")],
					   ___(@"speed_pocasi")]
					 ];
			break;
		case kPocutje:
			return @[
					 @[___(@"drinking_pred_jedjo"),
					   [NSString stringWithFormat:@"%@ 1-2%@", ___(@"temperature_hladno"), ___(@"volume_suffix")],
					   ___(@"speed_pocasi")]
					 ];
			break;
		default:
			return nil;
			break;
	}
}

- (IndicationType)indicationForDate:(NSDate *)date {
//	DLog(@"Searching for %@", [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterFullStyle]);
	for (CalendarHistoryEntry *entry in _calendarEntriesHistory) {
		if ([date compare:entry.date] == NSOrderedSame) {
			return entry.indicationType;
		}
	}
	return kUnknown;
}

@end
