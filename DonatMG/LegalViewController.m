//
//	LegalViewController.m
//	DonatMG
//
//	Created by Goran Blažič on 29/06/14.
//	Copyright (c) 2014 renderspace.si. All rights reserved.
//

#import "LegalViewController.h"

@interface LegalViewController ()

@end

@implementation LegalViewController

@synthesize legalLabel = _legalLabel;
@synthesize scrollView = _scrollView;
@synthesize contentHeight = _contentHeight;

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.view insertSubview:[[UIImageView alloc] initWithImage:
							  [UIImage imageNamed:IS_IPHONE_5 ? @"back-5.png" : @"back-4.png"]]
					 atIndex:0];

	NSString *fileName = [[NSBundle mainBundle] pathForResource:___(@"rules_html") ofType:nil];
	NSData *htmlData = [NSData dataWithContentsOfFile:fileName];

	NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									[NSNumber numberWithFloat:1.0], NSTextSizeMultiplierDocumentOption,
//									@"default.css", DTDefaultStyleSheet,
									fileName, NSBaseURLDocumentOption,
									nil];

	NSAttributedString *attrString = [[NSAttributedString alloc] initWithHTMLData:htmlData options:options documentAttributes:NULL];

	CGFloat width = self.legalLabel.bounds.size.width;
	CGRect rect = [attrString boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];

	self.legalLabel.attributedText = attrString;
	self.legalLabel.frame = CGRectMake(20.0f, 20.0f, rect.size.width, rect.size.height);
	self.scrollView.contentSize = CGSizeMake(rect.size.width + 40.0f, rect.size.height-80.0f);

	self.legalLabel.hidden = YES;

	CGRect frame = _legalLabel.frame;
	_textView = [[DTAttributedTextView alloc] initWithFrame:frame];
	_textView.backgroundColor = [UIColor clearColor];

	// we draw images and links via subviews provided by delegate methods
	_textView.shouldDrawImages = NO;
	_textView.shouldDrawLinks = NO;
	_textView.textDelegate = self;

	_textView.attributedString = attrString;

	[_scrollView addSubview:_textView];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (void)linkPushed:(DTLinkButton *)button {
	NSURL *URL = button.URL;
	if ([[UIApplication sharedApplication] canOpenURL:[URL absoluteURL]]) {
		[[UIApplication sharedApplication] openURL:[URL absoluteURL]];
	} else if ([[URL scheme] isEqual:@"mailto"]) {
		if ([MFMailComposeViewController canSendMail]) {
			MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
			mailViewController.mailComposeDelegate = self;
			[mailViewController setSubject:@""];
			[mailViewController setToRecipients:@[[URL resourceSpecifier]]];
			[self presentViewController:mailViewController animated:YES completion:nil];
		}
	} else {
		if (![URL host] && ![URL path]) {
			// possibly a local anchor link
			NSString *fragment = [URL fragment];
			if (fragment) {
				[_textView scrollToAnchorNamed:fragment animated:NO];
			}
		}
	}
}

#pragma mark - DTAttributedTextContentViewDelegate

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttributedString:(NSAttributedString *)string frame:(CGRect)frame {
	NSDictionary *attributes = [string attributesAtIndex:0 effectiveRange:NULL];

	NSURL *URL = [attributes objectForKey:DTLinkAttribute];
	NSString *identifier = [attributes objectForKey:DTGUIDAttribute];

	DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:frame];
	button.URL = URL;
	button.minimumHitSize = CGSizeMake(25, 25); // adjusts it's bounds so that button is always large enough
	button.GUID = identifier;

	// get image with normal link text
	UIImage *normalImage = [attributedTextContentView contentImageWithBounds:frame options:DTCoreTextLayoutFrameDrawingDefault];
	[button setImage:normalImage forState:UIControlStateNormal];

	// get image for highlighted link text
	UIImage *highlightImage = [attributedTextContentView contentImageWithBounds:frame options:DTCoreTextLayoutFrameDrawingDrawLinksHighlighted];
	[button setImage:highlightImage forState:UIControlStateHighlighted];

	// use normal push action for opening URL
	[button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];

	return button;
}

#pragma mark - 
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
