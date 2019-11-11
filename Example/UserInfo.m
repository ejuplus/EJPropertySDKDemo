//
//  UserInfo.m
//  LoginApp
//
//  Created by Fane on 2019/11/10.
//  Copyright © 2019 Fane. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
+ (instancetype)initWithDictionary:(NSDictionary*)dic{
    if (!dic || ![dic isKindOfClass:NSDictionary.class] || dic.count < 1) {
        return nil;
    }
    
    UserInfo *user = [[UserInfo alloc] init];
    NSString *memberId = [dic valueForKey:@"member_id"];
    if (![memberId isKindOfClass:NSString.class] ) {
        memberId = nil;
    }
    user.member_id = memberId;
    
    NSString *token = [dic valueForKey:@"access_token"];
    if (![token isKindOfClass:NSString.class] ) {
        token = nil;
    }
    user.access_token = token;

    NSString *account = [dic valueForKey:@"account"];
    if (![account isKindOfClass:NSString.class] ) {
        account = nil;
    }
    user.account = account;

    NSString *password = [dic valueForKey:@"password"];
    if (![password isKindOfClass:NSString.class] ) {
        password = nil;
    }
    user.password = password;

    
    return user;
}
@end
