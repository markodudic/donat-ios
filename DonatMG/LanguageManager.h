//
//	LanguageManager.h
//	DonatMG
//
//	Created by Goran Blažič on 07/06/14.
//	Copyright (c) 2014 goranche.net. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ___(key) [[LanguageManager sharedManager] localizedStringForKey:(key)]

// CHECK: this should work (without this manager), but the default behaviour is ... iffy
// and also, one can't override the default language this way
//#define ___(key) NSLocalizedString(key,nil)

#undef NSLocalizedString
#define NSLocalizedString(key,value) [[LanguageManager sharedManager] localizedStringForKey:(key)]

@interface LanguageManager : NSObject

@property (nonatomic, retain) NSMutableDictionary *i18nTable;
@property (nonatomic, retain) NSArray *languages;
@property (nonatomic, retain) NSString *currentLangId;

+ (id)sharedManager;

- (NSString *)localizedStringForKey:(NSString *)key;
- (void)setLanguageId:(NSString *)langId;

- (NSString *)idForLanguage:(NSString *)language;
- (NSString *)languageForId:(NSString *)langId;

@end
