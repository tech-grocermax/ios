//
//  GMParentController.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 30/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMParentController.h"
#import "GMLoginVC.h"

@interface GMParentController ()

@property (strong, nonatomic) UINavigationController *loginNavigationController;

@end

@implementation GMParentController

- (void)viewDidLoad {
    [super viewDidLoad];
    GMLoginVC *loginVC = [[GMLoginVC alloc] initWithNibName:@"GMLoginVC" bundle:nil];
    // Do any additional setup after loading the view from its nib.
    self.loginNavigationController = [[UINavigationController alloc]initWithRootViewController:loginVC];
    [self presentViewController:self.loginNavigationController animated:YES completion:nil];
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
