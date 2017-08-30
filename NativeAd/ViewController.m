//
//  ViewController.m
//  NativeAd
//
//  Created by Yun Peng Wang on 11/7/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "ViewController.h"
#import <Leanplum/Leanplum.h>

@import FBAudienceNetwork;

@interface ViewController ()
@property (strong, nonatomic) FBNativeAd *nativeAd;
@end

#define TOP_RIGHT_POSITION @"TopRight"
#define BOTTOM_RIGHT_POSITION @"BottomRight"
DEFINE_VAR_STRING(adChoicesCorner, @"TopRight")

DEFINE_VAR_STRING(adTitleLabelFont, @"AmericanTypewriter")
DEFINE_VAR_FLOAT(adTitleLabelFontSize, 15.0)
DEFINE_VAR_STRING(adBodyLabelFont, @"AmericanTypewriter")
DEFINE_VAR_FLOAT(adBodyLabelFontSize, 15.0)
DEFINE_VAR_STRING(adSocialContextLabelFont, @"AmericanTypewriter")
DEFINE_VAR_FLOAT(adSocialContextLabelFontSize, 15.0)
DEFINE_VAR_STRING(sponsoredLabelFont, @"AmericanTypewriter")
DEFINE_VAR_FLOAT(sponsoredLabelFontSize, 15.0)
DEFINE_VAR_STRING(sponsoredLabelText, @"Sponsored")

DEFINE_VAR_COLOR(ctaButtonColor, [UIColor colorWithRed:0/255.0 green:0/255.0 blue:255/255.0 alpha:1]);
DEFINE_VAR_DICTIONARY_WITH_OBJECTS_AND_KEYS(ctaButtonPosition,
                                            @310.0, @"x",
                                            @60.0, @"y",
                                            nil);


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [FBAdSettings setLogLevel:FBAdLogLevelLog];
    [FBAdSettings addTestDevice:@"b602d594afd2b0b327e07a06f36ca6a7e42546d0"];
    
// Create a native ad request with a unique placement ID (generate your own on the Facebook app settings).
// Use different ID for each ad placement in your app.
    FBNativeAd *nativeAd = [[FBNativeAd alloc] initWithPlacementID:@"150877198827978_150879382161093"];
    
// Set a delegate to get notified when the ad was loaded.
    nativeAd.delegate = self;
    
// Configure native ad to wait to call nativeAdDidLoad: until all ad assets are loaded
    nativeAd.mediaCachePolicy = FBNativeAdsCachePolicyAll;
    [nativeAd loadAd];
}

- (void)nativeAdDidLoad:(FBNativeAd *)nativeAd
{
    if (self.nativeAd) {
        [self.nativeAd unregisterView];
    }
    self.nativeAd = nativeAd;
    
// Create native UI using the ad metadata.
   
    [self.adCoverMediaView setNativeAd:nativeAd];    
    __weak typeof(self) weakSelf = self;
    [self.nativeAd.icon loadImageAsyncWithBlock:^(UIImage *image) {
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.adIconImageView.image = image;
    }];
    self.adStatusLabel.text = @"";
    
// Render native ads onto UIView
    
    
    [Leanplum onVariablesChanged:^() {
    //adTitleLabel changes based (font & size) on LP Variable
    self.adTitleLabel.text = self.nativeAd.title;
    self.adTitleLabel.font = [UIFont fontWithName:[adTitleLabelFont stringValue] size:[adTitleLabelFontSize floatValue]];
   
    //adBodyLabel changes based (font & size) on LP Variable
    self.adBodyLabel.text = self.nativeAd.body;
     self.adBodyLabel.font = [UIFont fontWithName:[adTitleLabelFont stringValue] size:[adTitleLabelFontSize floatValue]];
    //adSocialContextLabel changes based (font & size) on LP Variable
    self.adSocialContextLabel.text = self.nativeAd.socialContext;
    self.adSocialContextLabel.font = [UIFont fontWithName:[adTitleLabelFont stringValue] size:[adTitleLabelFontSize floatValue]];
    //sponsorLabel changes (font, size, & text)  based on LP Variable
    self.sponsoredLabel.text = [sponsoredLabelText stringValue];
    }];
    self.sponsoredLabel.font = [UIFont fontWithName:[adTitleLabelFont stringValue] size:[adTitleLabelFontSize floatValue]];
    
    
    //ctaButton color changes based on LP Variable
    [Leanplum onVariablesChanged:^() {
        [self.adCallToActionButton setTitle:self.nativeAd.callToAction
                                   forState:UIControlStateNormal];
        [self.adCallToActionButton setBackgroundColor:ctaButtonColor.colorValue];
        self.adCallToActionButton.center = CGPointMake([[ctaButtonPosition objectForKey:@"x"] floatValue],
                                                       [[ctaButtonPosition objectForKey:@"y"] floatValue]);
    }];
    
// Wire up UIView with the native ad; the whole UIView will be clickable.
    [nativeAd registerViewForInteraction:self.adUIView
                      withViewController:self];
    self.adChoicesView.nativeAd = nativeAd;
   
    //adChoicesLabel placement toggles based on LP Variable
    [Leanplum onVariablesChanged:^() {
    NSString *adPositioning = [adChoicesCorner stringValue];
    if([adPositioning isEqualToString:TOP_RIGHT_POSITION])
    {
        self.adChoicesView.corner = UIRectCornerTopRight;
    }
    else if([adPositioning isEqualToString:BOTTOM_RIGHT_POSITION])
    {
        self.adChoicesView.corner = UIRectCornerBottomRight;
    }
    }];
}

//Error Catching below
- (void)nativeAd:(FBNativeAd *)nativeAd didFailWithError:(NSError *)error
{
    NSLog(@"Native ad failed to load with error: %@", error);
}

- (void)nativeAdDidClick:(FBNativeAd *)nativeAd
{
    NSLog(@"Native ad was clicked.");
}

- (void)nativeAdDidFinishHandlingClick:(FBNativeAd *)nativeAd
{
    NSLog(@"Native ad did finish click handling.");
}

- (void)nativeAdWillLogImpression:(FBNativeAd *)nativeAd
{
    NSLog(@"Native ad impression is being captured.");
}

@end

