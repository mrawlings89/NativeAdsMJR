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

DEFINE_VAR_STRING(sponsoredLabel, @"Partner Content")
DEFINE_VAR_STRING(adChoicesCorner, @"TopRight")

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
    self.adTitleLabel.text = self.nativeAd.title;
    self.adBodyLabel.text = self.nativeAd.body;
    self.adSocialContextLabel.text = self.nativeAd.socialContext;
    self.sponsoredLabel.text = sponsoredLabel.stringValue;
    
    [self.adCallToActionButton setTitle:self.nativeAd.callToAction
                               forState:UIControlStateNormal];
    
    
    // Wire up UIView with the native ad; the whole UIView will be clickable.
    [nativeAd registerViewForInteraction:self.adUIView
                      withViewController:self];
    
    self.adChoicesView.nativeAd = nativeAd;
    //if stringvalue = right
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

