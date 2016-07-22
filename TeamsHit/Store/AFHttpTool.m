
//
//  AFHttpTool.m
//  RCloud_liv_demo
//
//  Created by Liv on 14-10-22.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//


#import "AFHttpTool.h"
#import "AFNetworking.h"
#import "RCDCommonDefine.h"


#define DevDemoServer @"http://119.254.110.241/" //Beijing SUN-QUAN 测试环境（北京）
#define ProDemoServer @"http://119.254.110.79:8080/" //Beijing Liu-Bei 线上环境（北京）
#define PrivateCloudDemoServer @"http://139.217.26.223/"//私有云测试

#define DemoServer @"http://api.sealtalk.im/" //线上正式环境
//#define DemoServer @"http://api.hitalk.im/" //测试环境

//#define ContentType @"text/plain"
#define ContentType @"application/json"

@implementation AFHttpTool

+ (AFHttpTool*)shareInstance
{
    static AFHttpTool* instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

+ (void)requestWihtMethod:(RequestMethodType)methodType
                      url:(NSString*)url
                   params:(NSDictionary*)params
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError* err))failure
{
    NSURL* baseURL = [NSURL URLWithString:DemoServer];
    //获得请求管理者
//    AFHTTPRequestOperationManager* mgr = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
//
//#ifdef ContentType
//    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:ContentType];
//#endif
//    mgr.requestSerializer.HTTPShouldHandleCookies = YES;
//    
    NSString *cookieString = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserCookies"];
//
//    if(cookieString)
//       [mgr.requestSerializer setValue: cookieString forHTTPHeaderField:@"Cookie"];

 
    // AFHTTPSessionManager
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    NSMutableSet *contentTypes = [[NSMutableSet alloc] initWithSet:manager.responseSerializer.acceptableContentTypes];
    [contentTypes addObject:@"text/html"];
    [contentTypes addObject:@"text/plain"];
    
    manager.requestSerializer.HTTPShouldHandleCookies = YES;
    manager.responseSerializer.acceptableContentTypes = contentTypes;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:ContentType];
    NSString *cookieString1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserCookies"];
    
    if(cookieString1)
        [manager.requestSerializer setValue: cookieString1 forHTTPHeaderField:@"Cookie"];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    switch (methodType) {
        case RequestMethodTypeGet:
        {
            //GET请求
//            [mgr GET:url parameters:params
//             success:^(AFHTTPRequestOperation* operation, NSDictionary* responseObj) {
//                 if (success) {
//                     
//                     success(responseObj);
//                 }
//             } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
//                 if (failure) {
//                     failure(error);
//                 }
//             }];
            
            
            [manager GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                if (success) {
                    
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                if (failure) {
                    failure(error);
                }
            }];
            
        }
            break;
            
        case RequestMethodTypePost:
        {
            //POST请求
//            [mgr POST:url parameters:params
//              success:^(AFHTTPRequestOperation* operation, NSDictionary* responseObj) {
//                  if (success) {
////                      NSString *cookieString = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserCookies"];
////                      
////                      if(cookieString)
////                      {
////                         success(responseObj);
////                          return;
////                      }
//                      if ([url isEqualToString:@"user/login"]) {
//                          NSString *cookieString = [[operation.response allHeaderFields] valueForKey:@"Set-Cookie"];
//                          NSMutableString *finalCookie = [NSMutableString new];
//                          //                      NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookieString];
//                          NSArray *cookieStrings = [cookieString componentsSeparatedByString:@","];
//                          for(NSString* temp in cookieStrings)
//                          {
//                              NSArray *tempArr = [temp componentsSeparatedByString:@";"];
//                              [finalCookie appendString:[NSString stringWithFormat:@"%@;",tempArr[0]]];
//                          }
//                          [[NSUserDefaults standardUserDefaults] setObject:finalCookie forKey:@"UserCookies"];
//                         [[NSUserDefaults standardUserDefaults] synchronize];
//                      }
//                      success(responseObj);
//                  }
//              } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
//                  if (failure) {
//                      failure(error);
//                  }
//              }];
            
            
            [manager POST:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                if ([url isEqualToString:@"user/login"]) {
//                    NSString *cookieString = [[task.response allHeaderFields] valueForKey:@"Set-Cookie"];
                    NSMutableString *finalCookie = [NSMutableString new];
                    //                      NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookieString];
                    NSArray *cookieStrings = [cookieString componentsSeparatedByString:@","];
                    for(NSString* temp in cookieStrings)
                    {
                        NSArray *tempArr = [temp componentsSeparatedByString:@";"];
                        [finalCookie appendString:[NSString stringWithFormat:@"%@;",tempArr[0]]];
                    }
                    [[NSUserDefaults standardUserDefaults] setObject:finalCookie forKey:@"UserCookies"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                success(responseObject);
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                if (failure) {
                    failure(error);
                }
            }];
            
            
        }
            break;
        default:
            break;
    }
}

//login
+(void) loginWithEmail:(NSString *) email
              password:(NSString *) password
                   env:(int) env
                success:(void (^)(id response))success
                failure:(void (^)(NSError* err))failure
{
    NSDictionary *params = @{@"email":email,@"password":password,@"env":[NSString stringWithFormat:@"%d", env]};
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey :@"UserCookies"];
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"email_login_token"
                           params:params
                          success:success
                          failure:failure];
}

//check phone available
+(void) checkPhoneNumberAvailable:(NSString *) region
                      phoneNumber:(NSString *) phoneNumber
                          success:(void (^)(id response))success
                          failure:(void (^)(NSError* err))failure
{
    NSDictionary *params = @{@"region":region,
                             @"phone" :phoneNumber};

    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"user/check_phone_available"
                           params:params
                          success:success
                          failure:failure];
}

//get verification code
+(void) getVerificationCode:(NSString *) region
                phoneNumber:(NSString *) phoneNumber
                    success:(void (^)(id response))success
                    failure:(void (^)(NSError* err))failure
{
    NSDictionary *params = @{@"region":region,@"phone":phoneNumber};
    
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"user/send_code"
                           params:params
                          success:success
                          failure:failure];
}

//verfify verification code
+(void) verifyVerificationCode:(NSString *) region
                   phoneNumber:(NSString *) phoneNumber
              verificationCode:(NSString *) verificationCode
                       success:(void (^)(id response))success
                       failure:(void (^)(NSError* err))failure
{
    NSDictionary *params = @{@"region"  :region,
                             @"phone"   :phoneNumber,
                             @"code"    :verificationCode};

    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"user/verify_code"
                           params:params
                          success:success
                          failure:failure];
}

//reg nickname password verficationToken
+(void) registerWithNickname:(NSString *) nickname
                    password:(NSString *) password
            verficationToken:(NSString *) verficationToken
                     success:(void (^)(id response))success
                     failure:(void (^)(NSError* err))failure
{
    NSDictionary *params = @{@"nickname":nickname,
                             @"password":password,
                   @"verification_token":verficationToken};
    
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"user/register"
                           params:params
                          success:success
                          failure:failure];
}

//login
+(void) loginWithPhone:(NSString *) phone
              password:(NSString *) password
                region:(NSString *) region
               success:(void (^)(id response))success
               failure:(void (^)(NSError* err))failure
{
    NSDictionary *params = @{@"region":region,
                              @"phone":phone,
                           @"password":password};
    
    
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"user/login"
                           params:params
                          success:success
                          failure:failure];
}

//modify nickname
+(void) modifyNickname:(NSString *) userId
              nickname:(NSString *) nickname
               success:(void (^)(id response))success
               failure:(void (^)(NSError* err))failure
{
    NSDictionary *params = @{@"nickname":nickname};
    
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:[NSString stringWithFormat:@"/user/set_nickname?userId=%@",userId]
                           params:params
                          success:success
                          failure:failure];
}

//change password
+(void) changePassword:(NSString *) oldPwd
              newPwd:(NSString *) newPwd
               success:(void (^)(id response))success
               failure:(void (^)(NSError* err))failure
{
    NSDictionary *params = @{@"oldPassword":oldPwd,
                             @"newPassword":newPwd};
    
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"user/change_password"
                           params:params
                          success:success
                          failure:failure];
}

//reset password
+(void) resetPassword:(NSString *) password
                vToken:(NSString *) verification_token
               success:(void (^)(id response))success
               failure:(void (^)(NSError* err))failure
{
    NSDictionary *params = @{@"password":password,
                             @"verification_token":verification_token};
    
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"user/reset_password"
                           params:params
                          success:success
                          failure:failure];
}

//get user info
+(void) getUserInfo:(NSString *) userId
               success:(void (^)(id response))success
               failure:(void (^)(NSError* err))failure
{
    [AFHttpTool requestWihtMethod:RequestMethodTypeGet
                              url:[NSString stringWithFormat:@"user/%@",userId]
                           params:nil
                          success:success
                          failure:failure];
}

//set user portraitUri
+(void) setUserPortraitUri:(NSString *) portraitUrl
               success:(void (^)(id response))success
               failure:(void (^)(NSError* err))failure
{
    NSDictionary *params = @{@"portraitUri":portraitUrl};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"user/set_portrait_uri"
                           params:params
                          success:success
                          failure:failure];
}

//invite user
+(void) inviteUser:(NSString *) userId
            success:(void (^)(id response))success
            failure:(void (^)(NSError* err))failure
{
    NSDictionary *params = @{@"friendId":userId,
                             @"message" :[NSString stringWithFormat:@"I am %@",userId]};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"friendship/invite"
                           params:params
                          success:success
                          failure:failure];
}

//find user by phone
+(void) findUserByPhone:(NSString *) Phone
            success:(void (^)(id response))success
            failure:(void (^)(NSError* err))failure
{
    [AFHttpTool requestWihtMethod:RequestMethodTypeGet
                              url:[NSString stringWithFormat:@"user/find/86/%@",Phone]
                           params:nil
                          success:success
                          failure:failure];
}

//reg email mobile username password
+(void) registerWithEmail:(NSString *) email
                   mobile:(NSString *) mobile
                 userName:(NSString *) userName
                 password:(NSString *) password
                   success:(void (^)(id response))success
                   failure:(void (^)(NSError* err))failure
{
    
    NSDictionary *params = @{@"email":email,
                             @"mobile":mobile,
                             @"username":userName,
                             @"password":password};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"reg"
                           params:params
                          success:success
                          failure:failure];
}

//get token
+(void) getTokenSuccess:(void (^)(id response))success
                failure:(void (^)(NSError* err))failure
{
    [AFHttpTool requestWihtMethod:RequestMethodTypeGet
                              url:@"token"
                           params:nil
                          success:success
                          failure:failure];
}


//get friends
+(void) getFriendsSuccess:(void (^)(id response))success
                  failure:(void (^)(NSError* err))failure
{
    //获取包含自己在内的全部注册用户数据
    [AFHttpTool requestWihtMethod:RequestMethodTypeGet
                              url:@"friends"
                           params:nil
                          success:success
                          failure:failure];
}

//get upload image token
+(void) getUploadImageTokensuccess:(void (^)(id response))success
                           failure:(void (^)(NSError* err))failure
{
    [AFHttpTool requestWihtMethod:RequestMethodTypeGet
                              url:@"user/get_image_token"
                           params:nil
                          success:success
                          failure:failure];
}

//upload file
+(void) uploadFile:(NSData *)fileData
            userId:(NSString *)userId
           success:(void (^)(id response))success
           failure:(void (^)(NSError* err))failure
{
    [AFHttpTool getUploadImageTokensuccess:^(id response) {
        if ([response[@"code"] integerValue] == 200) {
            NSDictionary *result = response[@"result"];
            NSString *defaultDomain = result[@"domain"];
            [DEFAULTS setObject:defaultDomain forKey:@"QiNiuDomain"];
            [DEFAULTS synchronize];
            
            //设置七牛的Token
            NSString *token = result[@"token"];
            NSMutableDictionary *params = [NSMutableDictionary new];
            [params setValue:token forKey:@"token"];
            
            //获取系统当前的时间戳
            NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
            NSTimeInterval now=[dat timeIntervalSince1970]*1000;
            NSString *timeString = [NSString stringWithFormat:@"%f", now];
            NSString *key = [NSString stringWithFormat:@"%@%@",userId,timeString];
            //去掉字符串中的.
            NSMutableString *str = [NSMutableString stringWithString:key];
            for (int i = 0; i < str.length; i++) {
                unichar c = [str characterAtIndex:i];
                NSRange range = NSMakeRange(i, 1);
                if (c == '.') { //此处可以是任何字符
                    [str deleteCharactersInRange:range];
                    --i;
                }
            }
            key = [NSString stringWithString:str];
            [params setValue:key forKey:@"key"];
            
            NSMutableDictionary *ret = [NSMutableDictionary dictionary];
            [params addEntriesFromDictionary:ret];
            
            NSString *url = @"http://upload.qiniu.com";
            
            NSData *imageData = fileData;
          
//            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//            [manager POST:url
//               parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//                   [formData appendPartWithFileData:imageData name:@"file" fileName:key mimeType:@"application/octet-stream"];
//               } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                   success(responseObject);
//               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                   NSLog(@"请求失败");
//               }];
            
            
            AFHTTPSessionManager *managers = [AFHTTPSessionManager manager];
            
            NSMutableSet *contentTypes = [[NSMutableSet alloc] initWithSet:managers.responseSerializer.acceptableContentTypes];
            [contentTypes addObject:@"text/html"];
            [contentTypes addObject:@"text/plain"];
            [contentTypes addObject:@"application/json"];
            [contentTypes addObject:@"text/json"];
            [contentTypes addObject:@"text/javascript"];
            [contentTypes addObject:@"text/xml"];
            [contentTypes addObject:@"image/*"];
            
            managers.responseSerializer.acceptableContentTypes = contentTypes;
            [managers POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                [formData appendPartWithFileData:imageData name:@"file" fileName:key mimeType:@"application/octet-stream"];
            } success:^(NSURLSessionDataTask *task, id responseObject) {
                success(responseObject);
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"请求失败");
            }];
            
        }
    } failure:^(NSError *err) {
        
    }];
}

//get square info
+(void) getSquareInfoSuccess:(void (^)(id response))success
                     Failure:(void (^)(NSError* err))failure
{
    [AFHttpTool requestWihtMethod:RequestMethodTypeGet
                              url:@"misc/demo_square"
                           params:nil
                          success:success
                          failure:failure];
}


//create group
+(void) createGroupWithGroupName:(NSString *) groupName
                 groupMemberList:(NSArray *) groupMemberList
                         success:(void (^)(id response))success
                         failure:(void (^)(NSError* err))failure
{
    NSDictionary *params = @{@"name":groupName,
                        @"memberIds":groupMemberList};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"group/create"
                           params:params
                          success:success
                          failure:failure];
}

//get groups
+(void) getAllGroupsSuccess:(void (^)(id response))success
                   failure:(void (^)(NSError* err))failure
{
    [AFHttpTool requestWihtMethod:RequestMethodTypeGet
                              url:@"get_all_group"
                           params:nil
                          success:success
                          failure:failure];
}

+(void) getMyGroupsSuccess:(void (^)(id response))success
                    failure:(void (^)(NSError* err))failure
{
//    [AFHttpTool requestWihtMethod:RequestMethodTypeGet
//                              url:@"get_my_group"
//                           params:nil
//                          success:success
//                          failure:failure];
    [AFHttpTool requestWihtMethod:RequestMethodTypeGet
                              url:@"user/groups"
                           params:nil
                          success:success
                          failure:failure];
    
}

//get group by id
+(void) getGroupByID:(NSString *) groupID
             success:(void (^)(id response))success
             failure:(void (^)(NSError* err))failure
{
//    [AFHttpTool requestWihtMethod:RequestMethodTypeGet
//                              url:@"get_group"
//                           params:@{@"id":groupID}
//                          success:success
//                          failure:failure];
    [AFHttpTool requestWihtMethod:RequestMethodTypeGet
                              url:[NSString stringWithFormat:@"group/%@",groupID]
                           params:nil
                          success:success
                          failure:failure];

}

//set group portraitUri
+(void) setGroupPortraitUri:(NSString *) portraitUrl
                    groupId:(NSString *) groupId
                    success:(void (^)(id response))success
                    failure:(void (^)(NSError* err))failure
{
    NSDictionary *params = @{@"groupId":groupId,
                             @"portraitUri":portraitUrl};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"group/set_portrait_uri"
                           params:params
                          success:success
                          failure:failure];
}

//get group members by id
+(void) getGroupMembersByID:(NSString *) groupID
             success:(void (^)(id response))success
             failure:(void (^)(NSError* err))failure
{
    [AFHttpTool requestWihtMethod:RequestMethodTypeGet
                              url:[NSString stringWithFormat:@"group/%@/members",groupID]
                           params:nil
                          success:success
                          failure:failure];
    
}

//join group by groupId
+(void) joinGroupWithGroupId:(NSString *) groupID
                     success:(void (^)(id response))success
                     failure:(void (^)(NSError* err))failure
{
    NSDictionary *params = @{@"groupId":groupID};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"group/join"
                           params:params
                          success:success
                          failure:failure];
}

//add users into group
+(void) addUsersIntoGroup:(NSString *) groupID
                  usersId:(NSMutableArray *)usersId
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError* err))failure
{
    NSDictionary *params = @{@"groupId":groupID,
                             @"memberIds":usersId};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"group/add"
                           params:params
                          success:success
                          failure:failure];
}

//kick users out of group
+(void) kickUsersOutOfGroup:(NSString *) groupID
                  usersId:(NSMutableArray *)usersId
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError* err))failure
{
    NSDictionary *params = @{@"groupId":groupID,
                             @"memberIds":usersId};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"group/kick"
                           params:params
                          success:success
                          failure:failure];
}

//quit group with groupId
+(void) quitGroupWithGroupId:(NSString *) groupID
                    success:(void (^)(id response))success
                    failure:(void (^)(NSError* err))failure
{
    NSDictionary *params = @{@"groupId":groupID};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"group/quit"
                           params:params
                          success:success
                          failure:failure];
}

//dismiss group with groupId
+(void) dismissGroupWithGroupId:(NSString *) groupID
                     success:(void (^)(id response))success
                     failure:(void (^)(NSError* err))failure
{
    NSDictionary *params = @{@"groupId":groupID};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"group/dismiss"
                           params:params
                          success:success
                          failure:failure];
}

//rename group with groupId
+(void) renameGroupWithGroupId:(NSString *) groupID
                     GroupName:(NSString *) groupName
                        success:(void (^)(id response))success
                        failure:(void (^)(NSError* err))failure
{
    NSDictionary *params = @{@"groupId":groupID,
                                @"name":groupName};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"group/rename"
                           params:params
                          success:success
                          failure:failure];
}

//create group
+(void) createGroupWithName:(NSString *) name
                    success:(void (^)(id response))success
                    failure:(void (^)(NSError* err))failure
{
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"create_group"
                           params:@{@"name":name}
                          success:success
                          failure:failure];
}

//join group
+(void) joinGroupByID:(int) groupID
              success:(void (^)(id response))success
              failure:(void (^)(NSError* err))failure
{
    [AFHttpTool requestWihtMethod:RequestMethodTypeGet
                              url:@"join_group"
                           params:@{@"id":[NSNumber numberWithInt:groupID]}
                          success:success
                          failure:failure];
}

//quit group
+(void) quitGroupByID:(int) groupID
              success:(void (^)(id response))success
              failure:(void (^)(NSError* err))failure
{
    [AFHttpTool requestWihtMethod:RequestMethodTypeGet
                              url:@"quit_group"
                           params:@{@"id":[NSNumber numberWithInt:groupID]}
                          success:success
                          failure:failure];
}


+(void)updateGroupByID:(int)groupID
         withGroupName:(NSString *)groupName
     andGroupIntroduce:(NSString *)introduce
               success:(void (^)(id))success
               failure:(void (^)(NSError *))failure
{
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"update_group"
                           params:@{@"id":[NSNumber numberWithInt:groupID],@"name":groupName,@"introduce":introduce}
                          success:success
                          failure:failure];
}

+(void)getFriendListFromServer:(NSString *)userId
                       Success:(void (^)(id))success
                              failure:(void (^)(NSError *))failure
{
    //获取除自己之外的好友信息
    [AFHttpTool requestWihtMethod:RequestMethodTypeGet
                              url:[NSString stringWithFormat:@"friendship/all?userId=%@",userId]
                           params:nil
                          success:success
                          failure:failure];
}


+(void)searchFriendListByEmail:(NSString*)email success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [AFHttpTool requestWihtMethod:RequestMethodTypeGet
                              url:@"seach_email"
                           params:@{@"email":email}
                          success:success
                          failure:failure];
}

+(void)searchFriendListByName:(NSString*)name
                      success:(void (^)(id))success
                      failure:(void (^)(NSError *))failure
{
    [AFHttpTool requestWihtMethod:RequestMethodTypeGet
                              url:@"seach_name"
                           params:@{@"username":name}
                          success:success
                          failure:failure];
}

+(void)requestFriend:(NSString*)userId
             success:(void (^)(id))success
             failure:(void (^)(NSError *))failure
{
    NSLog(@"%@",NSLocalizedStringFromTable(@"Request_Friends_extra", @"RongCloudKit", nil));
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"request_friend"
                           params:@{@"id":userId, @"message": NSLocalizedStringFromTable(@"Request_Friends_extra", @"RongCloudKit", nil)} //Request_Friends_extra
                          success:success
                          failure:failure];
}

+(void)processInviteFriendRequest:(NSString*)friendUserId
                     currentUseId:(NSString*)currentUserId
                             time:(NSString*)now
                          success:(void (^)(id))success
                          failure:(void (^)(NSError *))failure
{
    NSDictionary *params = @{@"friendId":friendUserId,
                             @"currentUserId":currentUserId,
                             @"time":now};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"agree"
                           params:params
                          success:success
                          failure:failure];
}

+(void)processInviteFriendRequest:(NSString*)friendUserId
                          success:(void (^)(id))success
                          failure:(void (^)(NSError *))failure
{
    NSDictionary *params = @{@"friendId":friendUserId};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"friendship/agree"
                           params:params
                          success:success
                          failure:failure];
}


+(void)processRequestFriend:(NSString*)userId
               withIsAccess:(BOOL)isAccess
                    success:(void (^)(id))success
                    failure:(void (^)(NSError *))failure
{

    NSString *isAcept = isAccess ? @"1":@"0";
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"process_request_friend"
                           params:@{@"id":userId,@"is_access":isAcept}
                          success:success
                          failure:failure];
}

+(void) deleteFriend:(NSString*)userId
            success:(void (^)(id))success
            failure:(void (^)(NSError *))failure
{
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"delete_friend"
                           params:@{@"id":userId}
                          success:success
                          failure:failure];
}

+(void)getUserById:(NSString*) userId
           success:(void (^)(id response))success
           failure:(void (^)(NSError* err))failure
{
    [AFHttpTool requestWihtMethod:RequestMethodTypeGet
                              url:@"profile"
                           params:@{@"id":userId}
                          success:success
                          failure:failure];
}

//加入黑名单
+(void)addToBlacklist:(NSString *)userId
              success:(void (^)(id response))success
              failure:(void (^)(NSError* err))failure
{
    NSDictionary *params = @{@"friendId":userId};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"user/add_to_blacklist"
                           params:params
                          success:success
                          failure:failure];
}

//从黑名单中移除
+(void)removeToBlacklist:(NSString *)userId
              success:(void (^)(id response))success
              failure:(void (^)(NSError* err))failure
{
    NSDictionary *params = @{@"friendId":userId};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"user/remove_from_blacklist"
                           params:params
                          success:success
                          failure:failure];
}

//获取黑名单列表
+(void)getBlacklistsuccess:(void (^)(id response))success
                   failure:(void (^)(NSError* err))failure
{
    [AFHttpTool requestWihtMethod:RequestMethodTypeGet
                              url:@"user/blacklist"
                           params:nil
                          success:success
                          failure:failure];
}

+(void)updateName:(NSString*) userName
           success:(void (^)(id response))success
           failure:(void (^)(NSError* err))failure
{
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"update_profile"
                           params:@{@"username":userName}
                          success:success
                          failure:failure];
}
@end
