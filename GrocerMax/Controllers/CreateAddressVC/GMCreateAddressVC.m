//
//  GMCreateAddressVC.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 20/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMCreateAddressVC.h"
#import "GMRegisterInputCell.h"
#import "PlaceholderAndValidStatus.h"
#import "GMUserModal.h"



@interface GMCreateAddressVC ()

@property (weak, nonatomic) IBOutlet UITableView *addressTableView;

@property (nonatomic, strong) GMUserModal *userModal;

@property (nonatomic, strong) UITextField *currentTextField;


@end

@implementation GMCreateAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
