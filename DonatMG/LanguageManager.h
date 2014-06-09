//
//	LanguageManager.h
//	DonatMG
//
//	Created by Goran Blažič on 07/06/14.
//	Copyright (c) 2014 goranche.net. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ___(key) [[LanguageManager sharedManager] localizedStringForKey:(key)]

#undef NSLocalizedString
#define NSLocalizedString(key,value) [[LanguageManager sharedManager] localizedStringForKey:(key)]

@interface LanguageManager : NSObject

@property (nonatomic, retain) NSMutableDictionary *i18nTable;

+ (id)sharedManager;

- (NSString *)localizedStringForKey:(NSString *)key;
- (void)setLocale:(NSString *)lProjFile;

@end
