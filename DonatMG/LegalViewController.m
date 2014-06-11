//
//	LegalViewController.m
//	DonatMG
//
//	Created by Goran Blažič on 03/06/14.
//	Copyright (c) 2014 goranche.net. All rights reserved.
//

#import "LegalViewController.h"
#import "DTCoreText.h"

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
//		@"default.css", DTDefaultStyleSheet,
		fileName, NSBaseURLDocumentOption,
	nil];

	NSAttributedString *attrString = [[NSAttributedString alloc] initWithHTMLData:htmlData options:options documentAttributes:NULL];

	CGFloat width = self.legalLabel.bounds.size.width;
	CGRect rect = [attrString boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];

	self.legalLabel.attributedText = attrString;
	self.contentHeight.constant = rect.size.height;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end
