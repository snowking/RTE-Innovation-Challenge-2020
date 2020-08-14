//
//  ZKService.m
//  ZKBody
//
//  Created by King on 2019/11/12.
//  Copyright © 2019 King. All rights reserved.
//

#import "ZKService.h"
#import <CommonCrypto/CommonDigest.h>

@interface ZKService ()



@end

@implementation ZKService

static ZKService *_service = nil;

+(instancetype)sharedService{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_service) {
            _service = [[self alloc] init];
        }
    });
    
    return _service;
}

-(instancetype)init{
    
    self = [super init];
    
    if (self) {
        self.baseURL = @"https://bodyapi.zkong.me/api/";
        
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
        
        self.manager = manager;
    }
    
    return self;
}

-(NSString *)URLStringWithMethod:(NSString*)method{
    
    return [self.baseURL stringByAppendingFormat:@"%@",method];
    
}

- (NSURLSessionDataTask *)GET:(NSString *)method
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    
    return [self.manager GET:[self URLStringWithMethod:method] parameters:parameters progress:nil success:success failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // Process Error
        
        if (failure) {
            failure(task, error);
        }
    }];
}

- (nullable NSURLSessionDataTask *)POST:(NSString *)method
                             parameters:(nullable id)parameters
                               progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure{
    
    return [self.manager POST:[self URLStringWithMethod:method] parameters:parameters progress:uploadProgress success:success failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // Process Error
        
        if (failure) {
            failure(task, error);
        }
    }];
}


-(NSMutableString *)MD5With:(NSString *)str{
    
    const char *cStr = [str UTF8String];
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5( cStr, str.length, digest );
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
    
}

-(void)loginWithUsername:(NSString*)name password:(NSString*)password
                 success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                 failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NKBindValueToKeyForParameterToDic(@"tel", name, parameters);
    NKBindValueToKeyForParameterToDic(@"password", password, parameters);
    
    [self POST:@"memberLogin" parameters:parameters progress:^(NSProgress *uploadProgress) {
        
    } success:success failure:failure];
    
    
}

-(void)getMemberInfoWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                        failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NKBindValueToKeyForParameterToDic(@"token", self.token, parameters);
    [self GET:@"getMemberInfo" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([[responseObject objectOrNilForKey:@"status"] intValue] == 1) {
            [[ZKService sharedService] setUser:[ZKModelUser modelFromDic:responseObject[@"data"]]];
        }
        
        if (success) {
            success(task, responseObject);
        }
        
    } failure:failure];
    
}

-(void)generateWXQrcodeWithAmount:(NSNumber*)amount
                          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                          failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NKBindValueToKeyForParameterToDic(@"memberId", self.user.modelID, parameters);
    NKBindValueToKeyForParameterToDic(@"powerAmount", amount, parameters);
    NKBindValueToKeyForParameterToDic(@"totalFee", @(amount.intValue*10), parameters);
    [self GET:@"generateWXQrcode" parameters:parameters success:success failure:failure];
    
}

-(void)getChargeListWithpageNum:(NSNumber*)pageNum
                       pageSize:(NSNumber*)pageSize
                        orderID:(NSNumber*)orderID
                        success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                        failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (!pageNum) {
        pageNum = @(1);
    }
    if (!pageSize) {
        pageSize = @(20);
    }
    
    NKBindValueToKeyForParameterToDic(@"pageNum", pageNum, parameters);
    NKBindValueToKeyForParameterToDic(@"pageSize", pageSize, parameters);
    NKBindValueToKeyForParameterToDic(@"memberId", self.user.modelID, parameters);
    
    NSString *method = @"chargeRecords";
    if (orderID) {
        method = [method stringByAppendingFormat:@"/%@", orderID];
    }
    
    [self GET:method parameters:parameters success:success failure:failure];
    
}

-(void)getConsumeListWithpageNum:(NSNumber*)pageNum
                        pageSize:(NSNumber*)pageSize
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (!pageNum) {
        pageNum = @(1);
    }
    if (!pageSize) {
        pageSize = @(20);
    }
    
    NKBindValueToKeyForParameterToDic(@"pageNum", pageNum, parameters);
    NKBindValueToKeyForParameterToDic(@"pageSize", pageSize, parameters);
    NKBindValueToKeyForParameterToDic(@"memberId", self.user.modelID, parameters);
    
    NSString *method = @"consumeRecords";
    
    [self GET:method parameters:parameters success:success failure:failure];
    
}

-(void)getEnergyListWithpageNum:(NSNumber*)pageNum
                       pageSize:(NSNumber*)pageSize
                        keyword:(NSString*)keyword
                        success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                        failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (!pageNum) {
        pageNum = @(1);
    }
    if (!pageSize) {
        pageSize = @(20);
    }
    
    NKBindValueToKeyForParameterToDic(@"pageNum", pageNum, parameters);
    NKBindValueToKeyForParameterToDic(@"pageSize", pageSize, parameters);
    NKBindValueToKeyForParameterToDic(@"keyword", keyword, parameters);
    NKBindValueToKeyForParameterToDic(@"memberId", self.user.modelID, parameters);
    
    NSString *method = @"energyRecords";
    
    [self GET:method parameters:parameters success:success failure:failure];
    
    
}

-(void)getMediaListWithpageNum:(NSNumber*)pageNum
                      pageSize:(NSNumber*)pageSize
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure{
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (!pageNum) {
        pageNum = @(1);
    }
    if (!pageSize) {
        pageSize = @(200);
    }
    
    NKBindValueToKeyForParameterToDic(@"pageNum", pageNum, parameters);
    NKBindValueToKeyForParameterToDic(@"pageSize", pageSize, parameters);
    NKBindValueToKeyForParameterToDic(@"memberId", self.user.modelID, parameters);
    
    NSString *method = @"getAllMedia";
    
    [self GET:method parameters:parameters success:success failure:failure];
    
}


-(void)clearAllBooks{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NKBindValueToKeyForParameterToDic(@"memberId", self.user.modelID, parameters);
    [self POST:@"setToException" parameters:parameters progress:^(NSProgress *uploadProgress) {
        
    } success:nil failure:nil];
    
}


-(void)sendMessageToKing:(NSString*)message{
    
    [self POST:@"pushNotice" parameters:[self finalParametersWithParameters:@{@"content":message}] progress:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
        
    }];
}

-(NSDictionary*)finalParametersWithParameters:(NSDictionary*)parameters{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parameters?parameters:@{}];
    
    if (self.user) {
        [dic setValue:self.user.modelID forKey:@"memberId"];
    }
    
    return dic;
}

-(NSDictionary*)getUsernameAndPassword{
    
    NSString *username = [[NSUserDefaults standardUserDefaults] valueForKey:@"ZKUSERNAME"];
    NSString *password = [[NSUserDefaults standardUserDefaults] valueForKey:@"ZKPASSWORD"];
    
    if (username && password) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NKBindValueToKeyForParameterToDic(@"username", username, dic);
        NKBindValueToKeyForParameterToDic(@"password", password, dic);
        
        return dic;
    }
    else{
        return nil;
    }
    
}
-(void)saveUsername:(NSString*)username password:(NSString*)password{
    
    if (username) {
        [[NSUserDefaults standardUserDefaults] setValue:username forKey:@"ZKUSERNAME"];
    }
    if (password) {
        [[NSUserDefaults standardUserDefaults] setValue:password forKey:@"ZKPASSWORD"];
    }
}

-(void)getSMSCodeWithPhone:(NSString*)phone type:(NSString*)type
                   success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                   failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NKBindValueToKeyForParameterToDic(@"tel", phone, parameters);
    NKBindValueToKeyForParameterToDic(@"type", type, parameters);
    [self GET:@"getCode" parameters:parameters success:success failure:failure];
    
}

-(void)getDataDictionarieWithType:(NSNumber*)type
                          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                          failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NKBindValueToKeyForParameterToDic(@"type", type, parameters);
    [self GET:@"dataDictionaries" parameters:parameters success:success failure:failure];
    
}

-(void)registerWithPhone:(NSString*)phone
                 smsCode:(NSString*)code
                password:(NSString*)password
                  invite:(NSString*)invite
                 success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                 failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NKBindValueToKeyForParameterToDic(@"tel", phone, parameters);
    NKBindValueToKeyForParameterToDic(@"password", password, parameters);
    NKBindValueToKeyForParameterToDic(@"code", code, parameters);
    NKBindValueToKeyForParameterToDic(@"inviteCode", invite, parameters);
    
    [self POST:@"register" parameters:parameters progress:^(NSProgress *uploadProgress) {
        
    } success:success failure:failure];
    
}

-(void)getProjectsWithType:(NSNumber*)type
                   pageNum:(NSNumber*)pageNum
                  pageSize:(NSNumber*)pageSize
                   keyword:(NSString*)keyword
                  viewType:(NSNumber*)viewType
                   success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                   failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (!pageNum) {
        pageNum = @(1);
    }
    if (!pageSize) {
        pageSize = @(20);
    }
    if (!type) {
        type = @(0);
    }
    if (!viewType) {
        viewType = @(0);
    }
    NKBindValueToKeyForParameterToDic(@"pageNum", pageNum, parameters);
    NKBindValueToKeyForParameterToDic(@"pageSize", pageSize, parameters);
    NKBindValueToKeyForParameterToDic(@"keyword", keyword, parameters);
    NKBindValueToKeyForParameterToDic(@"projectTypeId", type, parameters);
    NKBindValueToKeyForParameterToDic(@"viewTypeId", viewType, parameters);
    
    if (self.user.isTest) {
        NKBindValueToKeyForParameterToDic(@"isTest", self.user.isTest, parameters);
    }
    else{
        NKBindValueToKeyForParameterToDic(@"isTest", @(0), parameters);
    }
    
    //    NKBindValueToKeyForParameterToDic(@"isTest", self.user.isTest?self.user.isTest:@(0), parameters);
    
    [self GET:@"projects" parameters:parameters success:success failure:failure];
    
}

-(void)getDeviceListWithType:(NSNumber*)type
                     pageNum:(NSNumber*)pageNum
                    pageSize:(NSNumber*)pageSize
                     keyword:(NSString*)keyword
                   projectID:(NSString*)projectID
                     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                     failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (!pageNum) {
        pageNum = @(1);
    }
    if (!pageSize) {
        pageSize = @(20);
    }
    if (!type) {
        type = @(0);
    }
    
    NKBindValueToKeyForParameterToDic(@"pageNum", pageNum, parameters);
    NKBindValueToKeyForParameterToDic(@"pageSize", pageSize, parameters);
    NKBindValueToKeyForParameterToDic(@"keyword", keyword, parameters);
    NKBindValueToKeyForParameterToDic(@"typeId", type, parameters);
    NKBindValueToKeyForParameterToDic(@"projectId", projectID, parameters);
    
    [self GET:@"devices" parameters:parameters success:success failure:failure];
    
    
}

-(void)getDeviceInfoWithDeviceID:(NSString*)deviceID
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure{
    
    [self GET:[NSString stringWithFormat:@"devices/%@", deviceID] parameters:nil success:success failure:failure];
}

-(void)getDroneStagesSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                     failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NKBindValueToKeyForParameterToDic(@"pageNum", @(1), parameters);
    NKBindValueToKeyForParameterToDic(@"pageSize", @(1000), parameters);
    NKBindValueToKeyForParameterToDic(@"no", @(0), parameters);
    NKBindValueToKeyForParameterToDic(@"statusNo", @(0), parameters);
    NKBindValueToKeyForParameterToDic(@"deviceTypeId", @(7), parameters);
    
    [self GET:@"stages" parameters:parameters success:success failure:failure];
    
    
    
    
}


-(void)getProjectDetailWithID:(NSString*)projectID
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure{
    
    [self GET:[@"projects/" stringByAppendingFormat:@"%@", projectID] parameters:nil success:success failure:failure];
}

-(void)getQueueWithProjectID:(NSString*)projectID
                     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                     failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NKBindValueToKeyForParameterToDic(@"projectId", projectID, parameters);
    [self GET:@"getQueue" parameters:parameters success:success failure:failure];
}

-(void)playWithProjectID:(NSString*)projectID
             projectName:(NSString*)projectName
               totalTime:(NSNumber*)totalTime
                  amount:(NSNumber*)amount
                 success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                 failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NKBindValueToKeyForParameterToDic(@"projectId", projectID, parameters);
    NKBindValueToKeyForParameterToDic(@"projectName", projectName, parameters);
    NKBindValueToKeyForParameterToDic(@"totalTime", totalTime, parameters);
    NKBindValueToKeyForParameterToDic(@"amount", amount, parameters);
    NKBindValueToKeyForParameterToDic(@"memberId", self.user.modelID, parameters);
    NKBindValueToKeyForParameterToDic(@"memberTel", self.user.phone, parameters);
    
    [self POST:@"consumeRecords" parameters:parameters progress:^(NSProgress *uploadProgress) {
        
    } success:success failure:failure];
    
    
}

-(void)verifyReceipt:(NSString*)receipt
           payAmount:(NSNumber*)amount
             success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
             failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NKBindValueToKeyForParameterToDic(@"receiptData", receipt, parameters);
    NKBindValueToKeyForParameterToDic(@"payAmount", amount, parameters);
    NKBindValueToKeyForParameterToDic(@"memberId", self.user.modelID, parameters);
    
    
    [self POST:@"verifyReceipt" parameters:parameters progress:^(NSProgress *uploadProgress) {
        
    } success:success failure:failure];
    
}

-(void)updateOrderWithID:(NSString*)orderID
                  status:(NSNumber*)status
                usedTime:(NSNumber*)usedTime
                 success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                 failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NKBindValueToKeyForParameterToDic(@"status", status, parameters);
    NKBindValueToKeyForParameterToDic(@"usedTime", usedTime, parameters);
    
    [self POST:[@"consumeRecords/" stringByAppendingFormat:@"%@", orderID] parameters:parameters progress:^(NSProgress *uploadProgress) {
        
    } success:success failure:failure];
    
}

-(void)addEventWithEvent:(NSString*)event
                 success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                 failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NKBindValueToKeyForParameterToDic(@"description", event, parameters);
    NKBindValueToKeyForParameterToDic(@"memberId", self.user.modelID, parameters);
    NKBindValueToKeyForParameterToDic(@"memberTel", self.user.phone, parameters);
    
    [self POST:@"events" parameters:parameters progress:^(NSProgress *uploadProgress) {
        
    } success:success failure:failure];
}


-(void)cleanUser{
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"ZKUSERNAME"];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"ZKPASSWORD"];
    self.token = nil;
    self.user = nil;
}

@end



