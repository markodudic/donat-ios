//
//	LanguageManager.m
//	DonatMG
//
//	Created by Goran Blažič on 07/06/14.
//  Copyright (c) 2014 goranche.net. All rights reserved.
//

#import "LanguageManager.h"
#import "SettingsManager.h"
#import "Appirater.h"

@implementation LanguageManager

@synthesize i18nTable = _i18nTable;
@synthesize languages = _languages;
@synthesize currentLangId = _currentLangId;

+ (id)sharedManager {
	static LanguageManager *sharedLanguageManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedLanguageManager = [[self alloc] init];
	});
	return sharedLanguageManager;
}

- (id)init {
	if (self = [super init]) {
		self.i18nTable = [NSMutableDictionary dictionary];

		NSString *setLanguage = [[SettingsManager sharedManager] appLanguage];
		if (!setLanguage) {
			NSArray *supportedLanguages = [NSArray arrayWithObjects:@"en", @"hr", @"it", @"ru", @"sl", @"de", nil];
			NSArray *preferredLanguages = [NSLocale preferredLanguages];
			for (NSString *language in preferredLanguages) {
				if (!setLanguage) {
					if ([supportedLanguages containsObject:language])
						setLanguage = language;
				}
			}
		}
		[self setLanguageId:setLanguage ? setLanguage : kDefaultLanguage];
	}

    _languages = @[@"English", @"Slovenščina", @"Русский", @"Hrvatski", @"Italiano", @"Deutch"];

	return self;
}

- (void)setLanguageId:(NSString *)langId {
	NSString *path = [[NSBundle mainBundle] pathForResource:@"Localizable.strings" ofType:@"" inDirectory:[NSString stringWithFormat:@"%@.lproj",langId]];
	self.i18nTable = [NSDictionary dictionaryWithContentsOfFile:path];
	self.currentLangId = langId;
}

- (NSString *)localizedStringForKey:(NSString *)key {
	NSString *possibleI18NString = [self.i18nTable objectForKey:key];
	if (!possibleI18NString) {
		return key;
	}
	return possibleI18NString;
}

- (NSString *)idForLanguage:(NSString *)language {
	if ([language isEqualToString:@"English"]) {
		return @"en";
	} else if ([language isEqualToString:@"Italiano"]) {
		return @"it";
	} else if ([language isEqualToString:@"Русский"]) {
		return @"ru";
	} else if ([language isEqualToString:@"Hrvatski"]) {
		return @"hr";
    } else if ([language isEqualToString:@"Slovenščina"]) {
        return @"sl";
    } else if ([language isEqualToString:@"Deutch"]) {
        return @"de";
	} else
		return nil;
}

- (NSString *)languageForId:(NSString *)langId {
	if ([langId isEqualToString:@"en"]) {
		return @"English";
	} else if ([langId isEqualToString:@"it"]) {
		return @"Italiano";
	} else if ([langId isEqualToString:@"ru"]) {
		return @"Русский";
	} else if ([langId isEqualToString:@"hr"]) {
		return @"Hrvatski";
    } else if ([langId isEqualToString:@"sl"]) {
        return @"Slovenščina";
    } else if ([langId isEqualToString:@"de"]) {
        return @"Deutch";
	} else
		return nil;
}

- (NSString *)stringForMonth:(unsigned short)month {
	switch (month) {
		case 1:
			return ___(@"month_1");
			break;
		case 2:
			return ___(@"month_2");
			break;
		case 3:
			return ___(@"month_3");
			break;
		case 4:
			return ___(@"month_4");
			break;
		case 5:
			return ___(@"month_5");
			break;
		case 6:
			return ___(@"month_6");
			break;
		case 7:
			return ___(@"month_7");
			break;
		case 8:
			return ___(@"month_8");
			break;
		case 9:
			return ___(@"month_9");
			break;
		case 10:
			return ___(@"month_10");
			break;
		case 11:
			return ___(@"month_11");
			break;
		case 12:
			return ___(@"month_12");
			break;
		default:
			return nil;
			break;
	}
}

- (NSString *)stringForDay:(unsigned short)day {
	if (day > 7)
		return nil;

	return [___(@"days_localized") substringWithRange:NSMakeRange(day - 1, 1)];
}

@end
