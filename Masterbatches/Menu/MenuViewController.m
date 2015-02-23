//
//  MenuViewController.m
//  Masterbatches
//
//  Created by Berik Visschers on 02-17.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuView.h"

@interface MenuViewController ()
@property (nonatomic, strong) IBOutlet MenuView *menuView;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak __typeof(self) weakSelf = self;
    self.menuView.menuActionHandler = ^(NSString *menuAction) {
        Class vcClass = NSClassFromString(menuAction);
        assert(vcClass);
        UIViewController *vc = [vcClass new];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
