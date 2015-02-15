//
//	MainViewController.m
//	DonatMG
//
//	Created by Goran Blažič on 29/06/14.
//	Copyright (c) 2014 renderspace.si. All rights reserved.
//

#import "MainViewController.h"
#import "SettingsManager.h"
#import "TreatmentManager.h"
#import "IndicationCell.h"
#import "IndicationViewController.h"
#import "NotificationViewController.h"
#import "Appirater.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize headerView = _headerView;
@synthesize headerLabel = _headerLabel;

- (void)calendar {
	[self performSegueWithIdentifier:@"showCalendar" sender:self];
}

- (void)settings {
	[self performSegueWithIdentifier:@"showSettings" sender:self];
}

- (void)viewDidLoad {
	[super viewDidLoad];

	self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IS_IPHONE_5 ? @"back-5.png" : @"back-4.png"]];

	UIBarButtonItem *calendarItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"calendar.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(calendar)];

	UIBarButtonItem *settingsItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"settings.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(settings)];

	NSArray *buttonsArray = @[settingsItem, calendarItem];
	self.navigationItem.rightBarButtonItems = buttonsArray;

	UIImage *image = [[UIImage imageNamed:@"moments-title.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:nil action:nil];
	barButton.customView = [[UIImageView alloc] initWithImage:image];
	self.navigationItem.leftBarButtonItem = barButton;

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotification:) name:kApplicationDidReceiveNotification object:nil];

	UILocalNotification *notification = [[SettingsManager sharedManager] notificationFired];
	if (notification)
		[self fireNotification:notification];
}

- (void)viewDidUnload {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kApplicationDidReceiveNotification object:nil];
}

- (void)fireNotification:(UILocalNotification *)notification {
	// see http://stackoverflow.com/a/2777460/305149 for possible visibility issues
	// in that case, this method should be wrapped in an if clause like this:
	//	if (self.isViewLoaded && self.view.window) {
	//  }
	// although in that case I'm not sure how to actually handle the notification.

	// set the title so the "back" button will be shown
	self.title = ___(@"settings_title");

	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	NotificationViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"notificationViewController"];
	viewController.notification = notification;
	[self.navigationController pushViewController:viewController animated:YES];
}

- (void)didReceiveNotification:(NSNotification *)notification {
	NSDictionary *userInfo = notification.userInfo;
	UILocalNotification *localNotification = [userInfo objectForKey:@"notification"];

	[self fireNotification:localNotification];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
	[self.headerLabel setFont:kTextFont];
	[self.headerLabel setText:___(@"home_screen_title")];

	CGSize maxSize = CGSizeMake(self.headerView.frame.size.width - 40.0f, MAXFLOAT);
	CGRect labelRect = [self.headerLabel.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.headerLabel.font} context:nil];

	CGRect viewRect = self.headerView.frame;

	viewRect.size = CGSizeMake(viewRect.size.width, labelRect.size.height + 20.0f);
	[self.headerView setFrame:viewRect];

	[self.headerLabel removeFromSuperview];
	labelRect.origin = CGPointMake(20.0f, 10.0f);
	[self.headerLabel setFrame:labelRect];
	[self.headerView addSubview:self.headerLabel];

	[self.tableView setTableHeaderView:self.headerView];

	// hide the title while view controller is visible
	self.title = @"";

	[self.tableView reloadData];

	[super viewWillAppear:animated];

	[Appirater setCustomAlertTitle:___(@"rate_title")];
	[Appirater setCustomAlertMessage:___(@"rate_message")];
	[Appirater setCustomAlertCancelButtonTitle:___(@"rate_cancel")];
	[Appirater setCustomAlertRateButtonTitle:___(@"rate_ratenow")];
	[Appirater setCustomAlertRateLaterButtonTitle:___(@"rate_later")];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 11;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *langId = [[LanguageManager sharedManager] currentLangId];
    if (indexPath.row == 3 && ([langId isEqualToString:@"it"] || [langId isEqualToString:@"ru"])) {
        return 0;
    } else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	IndicationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"indicationCell" forIndexPath:indexPath];

    NSString *langId = [[LanguageManager sharedManager] currentLangId];
    
	// our indications start from 1
	switch (indexPath.item + 1) {
		case kZaprtost:
			cell.tag = kZaprtost;
			cell.imageView.image = [UIImage imageNamed:@"icon_zaprtost.png"];
			cell.titleLabel.text = ___(@"indication_1");
			break;
		case kZgaga:
			cell.tag = kZgaga;
			cell.imageView.image = [UIImage imageNamed:@"icon_zgaga.png"];
			cell.titleLabel.text = ___(@"indication_2");
			break;
        case kMagnezij:
            cell.tag = kMagnezij;
            cell.imageView.image = [UIImage imageNamed:@"icon_mg.png"];
            cell.titleLabel.text = ___(@"indication_3");
            break;
        case kDetox:
            if ([langId isEqualToString:@"it"] || [langId isEqualToString:@"ru"]) {
                cell.hidden = true;
            }
            else {
                cell.hidden = false;
            }
            cell.tag = kDetox;
            cell.imageView.image = [UIImage imageNamed:@"icon_detox.png"];
            cell.titleLabel.text = ___(@"indication_4");
            break;
		case kSladkorna:
			cell.tag = kSladkorna;
			cell.imageView.image = [UIImage imageNamed:@"icon_sladkorna.png"];
			cell.titleLabel.text = ___(@"indication_5");
			break;
		case kSlinavka:
			cell.tag = kSlinavka;
			cell.imageView.image = [UIImage imageNamed:@"icon_slinavka.png"];
			cell.titleLabel.text = ___(@"indication_6");
			break;
		case kSecniKamni:
			cell.tag = kSecniKamni;
			cell.imageView.image = [UIImage imageNamed:@"icon_secni_kamni.png"];
			cell.titleLabel.text = ___(@"indication_7");
			break;
		case kDebelost:
			cell.tag = kDebelost;
			cell.imageView.image = [UIImage imageNamed:@"icon_debelost.png"];
			cell.titleLabel.text = ___(@"indication_8");
			break;
		case kSrceOzilje:
			cell.tag = kSrceOzilje;
			cell.imageView.image = [UIImage imageNamed:@"icon_srce_ozilje.png"];
			cell.titleLabel.text = ___(@"indication_9");
			break;
		case kStres:
			cell.tag = kStres;
			cell.imageView.image = [UIImage imageNamed:@"icon_stres.png"];
			cell.titleLabel.text = ___(@"indication_10");
			break;
		case kPocutje:
			cell.tag = kPocutje;
			cell.imageView.image = [UIImage imageNamed:@"icon_pocutje.png"];
			cell.titleLabel.text = ___(@"indication_11");
			break;
		default:
			break;
	}

	cell.active = [[TreatmentManager sharedManager] activeIndication] == cell.tag;

	[cell.titleLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0f]];

	UIView * selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
	[selectedBackgroundView setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.2f]];
	[cell setSelectedBackgroundView:selectedBackgroundView];

	return cell;
}

#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// This shouldn't be needed, as selection isn't used, but still...
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	IndicationCell *cell = (IndicationCell *)[tableView cellForRowAtIndexPath:indexPath];

	[self performSegueWithIdentifier:@"showIndication" sender:cell];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// set the title so the "back" button will be shown
	self.title = ___(@"settings_title");

	if ([segue.identifier isEqualToString:@"showIndication"]) {
		IndicationViewController *indicationController = (IndicationViewController *)[segue destinationViewController];
		indicationController.indicationType = [(UITableViewCell *)sender tag];
	}
}

@end
