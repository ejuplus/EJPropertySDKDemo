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
@property (weak, nonatomic) IBOutlet UITextField *tokenTf;
@property (weak, nonatomic) IBOutlet UILabel *userLab;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (nonatomic, strong) NSArray *users;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSString *key = [[NSUserDefaults standardUserDefaults] objectForKey:@"TestUserChangeKey"];
    if (!key || ![key isKindOfClass:NSString.class]) {
        NSDictionary *dic = self.users[0];
        self.userLab.text = [dic objectForKey:@"account"];
    }
    else{
        __block BOOL hasUser = NO;
        [self.users enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.allKeys.firstObject isEqualToString:key]) {
                self.userLab.text = [obj objectForKey:@"account"];
                hasUser = YES;
                *stop = YES;
            }
        }];
        
//        if (!hasUser) {
//            NSDictionary *dic = self.users[0];
//
//            self.userLab.text = [dic objectForKey:@"account"];
//            [[NSUserDefaults standardUserDefaults] setObject:self.userLab.text forKey:@"TestUserChangeKey"];
//        }
    }

    
}

- (NSArray *)users{
    if (!_users) {
        _users = @[
            @{@"account":@"18814188114",@"mId":@"12000ebb10ef8600"},
            @{@"account":@"18814188118",@"mId":@"120010bb10f30000"},
            @{@"account":@"18814188119",@"mId":@"120010bb113a7400"},
            @{@"account":@"13312888452",@"mId":@"12000ebb1acc8200"},
            @{@"account":@"18854654578",@"mId":@"12000ebb1b697400"},
            @{@"account":@"18814188106",@"mId":@"12000ebb10eba600"},
        ];
    }
    
    return _users;
}

- (IBAction)changeUserAction:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"切换账号" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [self.users enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:[obj objectForKey:@"account"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[NSUserDefaults standardUserDefaults] setObject:action.title forKey:@"TestUserChangeKey"];
            self.userLab.text = action.title;
        }];
        [alert addAction:action];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:cancel];
    
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)toNext:(id)sender {
    
    NSString *key = self.userLab.text;
    if (!key || key.length < 1) {
        return;
    }

    __block NSString *mId = nil;
    [self.users enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *account = [obj objectForKey:@"account"];
        if ([account isEqualToString:key]) {
            mId = [obj objectForKey:@"mId"];
            *stop = YES;
        }
    }];


    [EJReportRepairManager pushToReportRepairModuleWithAccessToken:self.tokenTf.text memberId:mId communityId:@"65a3a176b6ab8c3d57cce31038e78ba2" loginInvalid:^{
         //处理登录过期
            NSLog(@"----------登录过期");
     }];

}


@end
