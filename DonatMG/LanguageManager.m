//
//	LanguageManager.m
//	DonatMG
//
//	Created by Goran Blažič on 07/06/14.
//  Copyright (c) 2014 goranche.net. All rights reserved.
//

#import "LanguageManager.h"

@implementation LanguageManager

@synthesize i18nTable = _i18nTable;

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

		NSArray *validLocalizations = [[NSBundle mainBundle] localizations];
		[self setLocale:[validLocalizations objectAtIndex:0]];

		NSLog(@"%s - %@", __FUNCTION__, validLocalizations);
	}
	return self;
}

- (void)setLocale:(NSString *)lProjFile {
	NSString *path = [[NSBundle mainBundle] pathForResource:@"Localizable.strings" ofType:@"" inDirectory:[NSString stringWithFormat:@"%@.lproj",lProjFile]];
	self.i18nTable = [NSDictionary dictionaryWithContentsOfFile:path];
}

- (NSString *)localizedStringForKey:(NSString *)key {
	NSString *possibleI18NString = [self.i18nTable objectForKey:key];
	if (!possibleI18NString) {
		return key;
	}
	return possibleI18NString;
}

@end
