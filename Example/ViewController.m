//
//  ViewController.m
//  Example
//
//  Created by hbz on 2019/10/18.
//  Copyright © 2019 EJU. All rights reserved.
//

#import "ViewController.h"
#import <EJPropertySDK/EJPropertySDK.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)toNext:(id)sender {
 
    [EJReportRepairManager pushToReportRepairModuleWithAccessToken:@"NTYwNkQ4N0ZBQkNDOEIwMjhCNjEwMUI5OUQ0RjAzQUJCNkI2MDY2RTZCMDQxN0ZCRUVDNzYyRTI3Q0ZENUVGQg==" communityId:@"222222"
                             loginInvalid:^{
        //处理登录过期
         
     }];
}

@end
