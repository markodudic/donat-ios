//
//	TreatmentManager.m
//	DonatMG
//
//	Created by Goran Blažič on 07/07/14.
//	Copyright (c) 2014 renderspace.si. All rights reserved.
//

#import "TreatmentManager.h"

@implementation TreatmentManager

#pragma mark Singleton Methods

+ (id)sharedManager {
	static TreatmentManager *sharedTreatmentManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedTreatmentManager = [[self alloc] init];
	});
	return sharedTreatmentManager;
}

- (id)init {
	if (self = [super init]) {
	}
	return self;
}

- (void)dealloc {
}

- (NSUInteger)numberOfInstructionsForIndication:(IndicationType)indication {
	switch (indication) {
		case kSrceOzilje:
		case kPocutje:
			return 1;
			break;
		case kZaprtost:
		case kDebelost:
		case kStres:
			return 2;
			break;
		case kZgaga:
		case kMagnezij:
		case kSladkorna:
		case kSlinavka:
			return 3;
			break;
		case kSecniKamni:
			return 4;
			break;
		default:
			return 0;
			break;
	}
}

- (NSArray *)stringsForIndication:(IndicationType)indication {
	switch (indication) {
		case kZaprtost:
			return @[
					 @[___(@"drinking_na_tesce"),
					   ___(@""),
					   ___(@"speed_hitro")],
					 @[___(@"drinking_pred_spanjem"),
					   ___(@""),
					   ___(@"speed_razmeroma_hitro")]
					];
			break;
		case kZgaga:
			return @[
					 @[___(@"drinking_veckrat_dnevno"),
					   ___(@""),
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_20_min_pred"),
					   ___(@""),
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_med_obroki"),
					   ___(@""),
					   ___(@"speed_pocasi")]
					 ];
			break;
		case kMagnezij:
			return @[
					 @[___(@"drinking_na_tesce"),
					   ___(@""),
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_opoldne"),
					   ___(@""),
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_zvecer"),
					   ___(@""),
					   ___(@"speed_pocasi")]
					 ];
			break;
		case kSladkorna:
			return @[
					 @[___(@"drinking_na_tesce"),
					   ___(@""),
					   ___(@"speed_razmeroma_hitro")],
					 @[___(@"drinking_pred_kosilom"),
					   ___(@""),
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_pred_vecerjo"),
					   ___(@""),
					   ___(@"speed_pocasi")]
					 ];
			break;
		case kSlinavka:
			return @[
					 @[___(@"drinking_na_tesce"),
					   ___(@""),
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_pred_kosilom"),
					   ___(@""),
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_pred_vecerjo"),
					   ___(@""),
					   ___(@"speed_pocasi")]
					 ];
			break;
		case kSecniKamni:
			return @[
					 // TODO: The first speed is not defined in the PDF
					 @[___(@"drinking_na_tesce"),
					   ___(@""),
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_pred_kosilom"),
					   ___(@""),
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_pred_vecerjo"),
					   ___(@""),
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_pred_spanjem"),
					   ___(@""),
					   ___(@"speed_pocasi")]
					 ];
			break;
		case kDebelost:
			return @[
					 @[___(@"drinking_na_tesce"),
					   ___(@""),
					   ___(@"speed_hitro")],
					 @[___(@"drinking_obcutek_lakote"),
					   ___(@""),
					   ___(@"speed_pocasi")]
					 ];
			break;
		case kSrceOzilje:
			return @[
					 @[___(@"drinking_3_4_dnevno"),
					   ___(@""),
					   ___(@"speed_pocasi")]
					 ];
			break;
		case kStres:
			return @[
					 @[___(@"drinking_na_tesce"),
					   ___(@""),
					   ___(@"speed_pocasi")],
					 @[___(@"drinking_pred_spanjem"),
					   ___(@""),
					   ___(@"speed_pocasi")]
					 ];
			break;
		case kPocutje:
			return @[
					 @[___(@"drinking_pred_jedjo"),
					   ___(@""),
					   ___(@"speed_pocasi")]
					 ];
			break;
		default:
			return nil;
			break;
	}
}

@end
