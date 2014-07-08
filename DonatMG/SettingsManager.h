//
//	SettingsManager.h
//	DonatMG
//
//	Created by Goran Blažič on 21/05/14.
//	Copyright (c) 2014 goranche.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsManager : NSObject

@property (nonatomic, assign) NSUInteger activeIndication;
@property (nonatomic, retain) NSDate *indicationActivation;
@property (nonatomic, retain) NSString *appLanguage;

@property (nonatomic, retain) NSDateComponents *wakeTime;
@property (nonatomic, retain) NSDateComponents *breakfastTime;
@property (nonatomic, retain) NSDateComponents *lunchTime;
@property (nonatomic, retain) NSDateComponents *dinnerTime;
@property (nonatomic, retain) NSDateComponents *sleepingTime;

@property (nonatomic, assign) NSUInteger numberOfMeals;

@property (nonatomic, retain) UILocalNotification *notificationFired;

+ (id)sharedManager;

@end
