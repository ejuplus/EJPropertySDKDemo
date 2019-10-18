# SDK接入
 ## 通过pod安装
 #### pod 'EJPropertySDK', :git=>'https://github.com/fanefane/spec.git'
 #### 接入的工程里Enable Bitcode 设置 NO
# SDK初始化
 ### AppDelegate里引入SDK 
 ```
 #import <EJPropertySDK/EJPropertySDK.h>
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
 
     //ChannelId 渠道Id 必填，themeColor主题色，是非必填 
     [EJPropertyKit initWithChannelId:@"120010bb3d3a8600" themeColor:@"#00B9AE"];
     
    return YES;
}
```
# 功能引入
导入SDK <br/>

#import <EJPropertySDK/EJPropertySDK.h>
在跳转的方法里添加
```
- (IBAction)toNext:(id)sender {

   //accessToken 接入方的token   communityId 接入方的小区id  loginInvalid 登录过期方法回调
   
    [EJReportRepairManager pushToReportRepairModuleWithAccessToken:@"NTYwNkQ4N0ZBQkNDOEIwMjhCNjEwMUI5OUQ0RjAzQUJCNkI2MDY2RTZCMDQxN0ZCRUVDNzYyRTI3Q0ZENUVGQg==" 
                                                       communityId:@"222222"
                                                       loginInvalid:^{
                                                      //处理登录过期
        
    }];];

}
```
