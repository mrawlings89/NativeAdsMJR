//
//  StartViewController.m
//  NativeAd
//
//  Created by Michael Rawlings on 8/24/17.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "StartViewController.h"
#import <Leanplum/Leanplum.h>


@interface StartViewController ()

@end

@implementation StartViewController

- (IBAction)nextView{
        [self performSegueWithIdentifier:@"next" sender:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
