//
//	IndicationViewController.m
//	DonatMG
//
//	Created by Goran Blažič on 01/06/14.
//	Copyright (c) 2014 goranche.net. All rights reserved.
//

#import "IndicationViewController.h"
#import "SettingsManager.h"

@interface IndicationViewController ()

@end

@implementation IndicationViewController

@synthesize indicationType = _indicationType;

@synthesize iconView = _iconView;
@synthesize titleLabel = _titleLabel;
@synthesize descriptionLabel = _descriptionLabel;

- (void)updateViewActivation {
	_amActive = [[SettingsManager sharedManager] activeIndication] == _indicationType;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.view insertSubview:[[UIImageView alloc] initWithImage:
							  [UIImage imageNamed:IS_IPHONE_5 ? @"back-5.png" : @"back-4.png"]]
					 atIndex:0];

	[self updateViewActivation];

	switch (_indicationType) {
		case kZaprtost:
			self.iconView.image = [UIImage imageNamed:@"icon_zaprtost.png"];
			self.titleLabel.text = ___(@"indication_1");
			self.descriptionLabel.text = ___(@"indication_1_desc");
			break;
		case kZgaga:
			self.iconView.image = [UIImage imageNamed:@"icon_zgaga.png"];
			self.titleLabel.text = ___(@"indication_2");
			self.descriptionLabel.text = ___(@"indication_2_desc");
			break;
		case kMagnezij:
			self.iconView.image = [UIImage imageNamed:@"icon_mg.png"];
			self.titleLabel.text = ___(@"indication_3");
			self.descriptionLabel.text = ___(@"indication_3_desc");
			break;
		case kSladkorna:
			self.iconView.image = [UIImage imageNamed:@"icon_sladkorna.png"];
			self.titleLabel.text = ___(@"indication_4");
			self.descriptionLabel.text = ___(@"indication_4_desc");
			break;
		case kSlinavka:
			self.iconView.image = [UIImage imageNamed:@"icon_slinavka.png"];
			self.titleLabel.text = ___(@"indication_5");
			self.descriptionLabel.text = ___(@"indication_5_desc");
			break;
		case kSecniKamni:
			self.iconView.image = [UIImage imageNamed:@"icon_secni_kamni.png"];
			self.titleLabel.text = ___(@"indication_6");
			self.descriptionLabel.text = ___(@"indication_6_desc");
			break;
		case kDebelost:
			self.iconView.image = [UIImage imageNamed:@"icon_debelost.png"];
			self.titleLabel.text = ___(@"indication_7");
			self.descriptionLabel.text = ___(@"indication_7_desc");
			break;
		case kSrceOzilje:
			self.iconView.image = [UIImage imageNamed:@"icon_srce_ozilje.png"];
			self.titleLabel.text = ___(@"indication_8");
			self.descriptionLabel.text = ___(@"indication_8_desc");
			break;
		case kStres:
			self.iconView.image = [UIImage imageNamed:@"icon_stres.png"];
			self.titleLabel.text = ___(@"indication_9");
			self.descriptionLabel.text = ___(@"indication_9_desc");
			break;
		case kPocutje:
			self.iconView.image = [UIImage imageNamed:@"icon_pocutje.png"];
			self.titleLabel.text = ___(@"indication_10");
			self.descriptionLabel.text = ___(@"indication_10_desc");
			break;
		default:
			// TODO: we have a problem
			break;
	}
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end
