//
//	LanguageManager.m
//	DonatMG
//
//	Created by Goran Blažič on 07/06/14.
//  Copyright (c) 2014 goranche.net. All rights reserved.
//

#import "LanguageManager.h"
#import "SettingsManager.h"

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
			NSArray *supportedLanguages = [NSArray arrayWithObjects:@"en", @"hr", @"it", @"ru", nil];
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

	_languages = @[@"English", @"Italian", @"Russian", @"Croatian"];

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
	} else if ([language isEqualToString:@"Italian"]) {
		return @"it";
	} else if ([language isEqualToString:@"Russian"]) {
		return @"ru";
	} else if ([language isEqualToString:@"Croatian"]) {
		return @"hr";
	} else
		return nil;
}

- (NSString *)languageForId:(NSString *)langId {
	if ([langId isEqualToString:@"en"]) {
		return @"English";
	} else if ([langId isEqualToString:@"it"]) {
		return @"Italian";
	} else if ([langId isEqualToString:@"ru"]) {
		return @"Russian";
	} else if ([langId isEqualToString:@"hr"]) {
		return @"Croatian";
	} else
		return nil;
}

@end
