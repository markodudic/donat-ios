//
//	CalendarHistoryEntry.h
//	DonatMG
//
//	Created by Goran Blažič on 08/07/14.
//	Copyright (c) 2014 renderspace.si. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalendarHistoryEntry : NSObject <NSCoding>

@property (nonatomic, retain) NSDate *date;
@property (nonatomic, assign) IndicationType indicationType;

+ (id)entryWithDate:(NSDate *)date andIndicationType:(IndicationType)indicationType;
- (id)initWithDate:(NSDate *)date andIndicationType:(IndicationType)indicationType;

@end
