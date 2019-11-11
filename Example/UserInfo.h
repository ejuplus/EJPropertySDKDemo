//
//  UserInfo.h
//  LoginApp
//
//  Created by Fane on 2019/11/10.
//  Copyright © 2019 Fane. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInfo : NSObject
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *password;

@property (nonatomic, strong) NSString *member_id;
@property (nonatomic, strong) NSString *access_token;

+ (instancetype)initWithDictionary:(NSDictionary*)dic;

@end

NS_ASSUME_NONNULL_END
