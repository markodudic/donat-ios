//
//	TreatmentManager.h
//	DonatMG
//
//	Created by Goran Blažič on 07/07/14.
//	Copyright (c) 2014 renderspace.si. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TreatmentManager : NSObject {
	NSMutableArray *_calendarEntriesHistory;
}

+ (id)sharedManager;

- (NSUInteger)numberOfInstructionsForIndication:(IndicationType)indication;
- (NSArray *)stringsForIndication:(IndicationType)indication;

- (IndicationType)indicationForDate:(NSDate *)date;

@end
