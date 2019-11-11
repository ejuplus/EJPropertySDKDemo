//
//  ViewController.m
//  Example
//
//  Created by hbz on 2019/10/18.
//  Copyright © 2019 EJU. All rights reserved.
//

#import "ViewController.h"
//#import <EJPropertySDK/EJPropertySDK.h>
#import <EjuHKSDK/EjuHKManager.h>
#import "UserInfo.h"

#define ThirdLoginUrl  @"http://39.98.98.227/v2/corp_auth"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userTf;
@property (weak, nonatomic) IBOutlet UITextField *pwdTf;
@property (weak, nonatomic) IBOutlet UILabel *msgLab;

@property (weak, nonatomic) IBOutlet UIStackView *stackView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"三方登录";
    
    [EjuHKManager loginInvalid:^{
            NSLog(@"----------登录过期回调");
//        [self clearLocalUserWithMsg:@"登录过期"];
    }];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"Historyuserkey"];
    if (dic && [dic isKindOfClass:NSDictionary.class] && dic.count > 1) {
        self.userTf.text = [dic objectForKey:@"account"];
        self.pwdTf.text = [dic objectForKey:@"password"];
    }
    
    self.stackView.hidden = !dic;

    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - actions -

- (IBAction)loginBtnClick:(id)sender {
    [self clearLocalUserWithMsg:@""];
    
    if (self.userTf.text.length < 1) {
        [UIView animateWithDuration:0.3 animations:^{
            self.userTf.backgroundColor = UIColor.redColor;
        } completion:^(BOOL finished) {
            self.userTf.backgroundColor = UIColor.whiteColor;
        }];
        return;
    }
    
    if (self.pwdTf.text.length < 1) {
        [UIView animateWithDuration:.3 animations:^{
            self.pwdTf.backgroundColor = UIColor.redColor;
        } completion:^(BOOL finished) {
            self.pwdTf.backgroundColor = UIColor.whiteColor;
        }];

        return;
    }
    
    [self.view endEditing:YES];

    [self requestWith:[self postReqeustJsonFormatWithURL:ThirdLoginUrl params:@{@"account":self.userTf.text,@"password":self.pwdTf.text}]];
}

#pragma mark - note -
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];

    return YES;
}

- (IBAction)toNext:(UIButton*)sender {
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"Historyuserkey"];
    UserInfo *user = [UserInfo initWithDictionary:dic];

    if (sender.tag == 0) {
        [EjuHKManager pushToModuleWithType:EjuHKModuleTypeReport accessToken:user.access_token memberId:user.member_id communityId:@"65a3a176b6ab8c3d57cce31038e78ba2"];
    }
    else if (sender.tag == 1){
        [EjuHKManager pushToModuleWithType:EjuHKModuleTypeComplaint accessToken:user.access_token memberId:user.member_id communityId:@"65a3a176b6ab8c3d57cce31038e78ba2"];
    }
    

}

#pragma mark - request -

- (NSMutableURLRequest *)postReqeustJsonFormatWithURL:(NSString *)url params:(NSDictionary *)paramDic{
    NSMutableURLRequest *rq = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    rq.HTTPMethod = @"POST";
    rq.timeoutInterval = 10.0;
    
    if ([NSJSONSerialization isValidJSONObject:paramDic]) {
        NSData *
        postDatas = [NSJSONSerialization dataWithJSONObject:paramDic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc] initWithData:postDatas encoding:NSUTF8StringEncoding];
        str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        [rq setHTTPBody:[str dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [rq setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    return rq;
}

- (void)requestWith:(NSMutableURLRequest *)request
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];

    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data==nil) {
            [self clearLocalUserWithMsg:@"登录失败"];
            return ;
        }
        
        NSError *err;
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
        if (err || !resultDic ||
            ![resultDic isKindOfClass:NSDictionary.class] ||
            resultDic.count < 1) {
            [self clearLocalUserWithMsg:@"登录失败."];
            
            return;
        }
        
        NSDictionary *errMsg = [resultDic objectForKey:@"error"];
        if (errMsg && [errMsg isKindOfClass:NSDictionary.class] && errMsg.count > 0) {
            [self clearLocalUserWithMsg:[errMsg objectForKey:@"msg"]];
            return;
        }
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:resultDic];
        dispatch_async(dispatch_get_main_queue(), ^{
            [dic addEntriesFromDictionary:@{@"account":self.userTf.text,@"password":self.pwdTf.text}];
            [[NSUserDefaults standardUserDefaults] setObject:dic.copy forKey:@"Historyuserkey"];
            self.stackView.hidden = NO;
        });
    }] resume] ;
}

#pragma mark - help methos -
- (void)removeNote{
    self.msgLab.text = @"";
}
- (void)clearLocalUserWithMsg:(NSString*)msg{
    
    if ([NSThread isMainThread]) {
        self.stackView.hidden = YES;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Historyuserkey"];
        
        if (msg.length > 0) {
            self.msgLab.text = msg;
            [self performSelector:@selector(removeNote) withObject:self.msgLab afterDelay:1];
        }
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.stackView.hidden = YES;
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Historyuserkey"];
            
            if (msg.length > 0) {
                self.msgLab.text = msg;
                [self performSelector:@selector(removeNote) withObject:self.msgLab afterDelay:1];
            }
        });
    }

}


@end
