//
//	CalendarHistoryEntry.m
//	DonatMG
//
//	Created by Goran Blažič on 08/07/14.
//	Copyright (c) 2014 renderspace.si. All rights reserved.
//

#import "CalendarHistoryEntry.h"

@implementation CalendarHistoryEntry

@synthesize date = _date;
@synthesize startDate = _startDate;
@synthesize indicationType = _indicationType;
@synthesize notificationsSet = _notificationsSet;

- (id)init {
	if (self = [super init]) {
		_date = [NSDate date];
		_indicationType = kUnknown;
		_notificationsSet = NO;
	}
	return self;
}

+ (id)entryWithDate:(NSDate *)date startDate:(NSDate *)startDate andIndicationType:(IndicationType)indicationType {
	return [[CalendarHistoryEntry alloc] initWithDate:date startDate:startDate andIndicationType:indicationType];
}

- (id)initWithDate:(NSDate *)date startDate:(NSDate *)startDate andIndicationType:(IndicationType)indicationType {
	if (self = [super init]) {
		_date = date;
		_startDate = startDate;
		_indicationType = indicationType;
		_notificationsSet = NO;
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super init]) {
		_date = [aDecoder decodeObjectForKey:@"date"];
		_startDate = [aDecoder decodeObjectForKey:@"startDate"];
		_indicationType = [aDecoder decodeIntegerForKey:@"indication"];
		_notificationsSet = [aDecoder decodeBoolForKey:@"notificationsSet"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:_date forKey:@"date"];
	[aCoder encodeObject:_startDate forKey:@"startDate"];
	[aCoder encodeInteger:_indicationType forKey:@"indication"];
	[aCoder encodeBool:_notificationsSet forKey:@"notificationsSet"];
}

@end
