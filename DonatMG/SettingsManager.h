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

+ (id)sharedManager;

@end
