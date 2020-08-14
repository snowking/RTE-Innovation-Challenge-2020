//
//  ZKService.h
//  ZKBody
//
//  Created by King on 2019/11/12.
//  Copyright © 2019 King. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "NKModel.h"


@interface ZKService : NSObject

@property (nonatomic, strong) NSString *baseURL;
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) ZKModelUser *user;

@property (nonatomic) BOOL playing;


+(instancetype)sharedService;

-(NSDictionary*)getUsernameAndPassword;
-(void)saveUsername:(NSString*)username password:(NSString*)password;
-(void)cleanUser;

-(NSMutableString *)MD5With:(NSString *)str;
-(NSString *)URLStringWithMethod:(NSString*)method;

-(void)sendMessageToKing:(NSString*)message;
-(NSDictionary*)finalParametersWithParameters:(NSDictionary*)parameters;

-(void)loginWithUsername:(NSString*)name password:(NSString*)password
                 success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                 failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure;

-(void)getMemberInfoWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                        failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure;

-(void)clearAllBooks;


-(void)getSMSCodeWithPhone:(NSString*)phone type:(NSString*)type
                   success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                   failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure;

-(void)getDataDictionarieWithType:(NSNumber*)type
success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure;


-(void)registerWithPhone:(NSString*)phone
                 smsCode:(NSString*)code
                password:(NSString*)password
                  invite:(NSString*)invite
                 success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                 failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure;

-(void)getProjectsWithType:(NSNumber*)type
                   pageNum:(NSNumber*)pageNum
                  pageSize:(NSNumber*)pageSize
                   keyword:(NSString*)keyword
                  viewType:(NSNumber*)viewType
                   success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                   failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure;

-(void)getDeviceListWithType:(NSNumber*)type
                     pageNum:(NSNumber*)pageNum
                    pageSize:(NSNumber*)pageSize
                     keyword:(NSString*)keyword
                   projectID:(NSString*)projectID
                     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                     failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure;

-(void)getChargeListWithpageNum:(NSNumber*)pageNum
                       pageSize:(NSNumber*)pageSize
                        orderID:(NSNumber*)orderID
                        success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                        failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure;

-(void)getEnergyListWithpageNum:(NSNumber*)pageNum
                       pageSize:(NSNumber*)pageSize
                        keyword:(NSString*)keyword
                        success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                        failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure;

-(void)getMediaListWithpageNum:(NSNumber*)pageNum
                      pageSize:(NSNumber*)pageSize
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure;

-(void)getConsumeListWithpageNum:(NSNumber*)pageNum
                        pageSize:(NSNumber*)pageSize
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure;

-(void)getProjectDetailWithID:(NSString*)projectID
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure;

-(void)getQueueWithProjectID:(NSString*)projectID
                     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                     failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure;

-(void)getDeviceInfoWithDeviceID:(NSString*)deviceID
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

-(void)getDroneStagesSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

-(void)playWithProjectID:(NSString*)projectID
             projectName:(NSString*)projectName
               totalTime:(NSNumber*)totalTime
                  amount:(NSNumber*)amount
                 success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                 failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure;

-(void)updateOrderWithID:(NSString*)orderID
                  status:(NSNumber*)status
                usedTime:(NSNumber*)usedTime
                 success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                 failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure;

-(void)addEventWithEvent:(NSString*)event
                 success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                 failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure;


-(void)generateWXQrcodeWithAmount:(NSNumber*)amount
                          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                          failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure;

-(void)verifyReceipt:(NSString*)receipt
           payAmount:(NSNumber*)amount
             success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
             failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure;


- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
parameters:(id)parameters
  progress:(void (^)(NSProgress *uploadProgress))uploadProgress
   success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
   failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure;


@end


