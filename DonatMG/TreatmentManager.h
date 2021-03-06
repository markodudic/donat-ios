//
//	TreatmentManager.h
//	DonatMG
//
//	Created by Goran Blažič on 07/07/14.
//	Copyright (c) 2014 renderspace.si. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+DateTools.h"
#import "CalendarHistoryEntry.h"

@interface TreatmentManager : NSObject {
	NSMutableArray *_calendarEntriesHistory;
}

@property (nonatomic, readonly, getter = activeIndication) NSUInteger activeIndication;
@property (nonatomic, readonly, getter = indicationActivation) NSDate *indicationActivation;

+ (id)sharedManager;

+ (NSString *)descriptionForIndication:(IndicationType)indication;

- (NSUInteger)numberOfInstructionsForIndication:(IndicationType)indication;
- (NSArray *)stringsForIndication:(IndicationType)indication;
- (NSArray *)notificationIconsForIndication:(IndicationType)indication;

- (NSString *)imageForTimeOfDay:(TimeOfDayType)timeOfDay;
- (NSString *)textForTimeOfDay:(TimeOfDayType)timeOfDay;

- (IndicationType)indicationForDate:(NSDate *)date;
- (CalendarHistoryEntry *)historyItemForDate:(NSDate *)date;

- (void)startTreatmentForIndication:(IndicationType)indication fromDate:(NSDate *)date;
- (void)cancelActiveTreatment;
- (void)recalculateTreatment;

- (void)checkForUnsetNotifications;

@end
