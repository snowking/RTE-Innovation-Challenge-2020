//
//  NKModel.h
//  NEXTKING
//
//  Created by King on 14/10/28.
//  Copyright (c) 2014年 King. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const NKWillLogoutNotificationKey;
extern NSString *const NKLoginFinishNotificationKey;

#define NKBindValueForParameter(value, param) \
if(value!=nil) {\
param = value;\
}\


#define NKBindValueWithKeyForParameterFromDic(key, param, dic) \
if([dic objectOrNilForKey:key]!=nil) {\
param = [dic objectOrNilForKey:key];\
}\

#define NKBindValueWithKeyForParameterFromCache(key, param, dic) \
if(!param) {\
param = [dic objectOrNilForKey:key];\
}\


#define NKBindValueToKeyForParameterToDic(key, param, dic) \
if(param != nil) {\
[dic setObject:param forKey:key];\
}\



@interface NKModel : NSObject{
    
}

@property (nonatomic, strong) NSDictionary *jsonDic;
@property (nonatomic, strong) NSString     *modelID;
@property (nonatomic, assign) CGFloat       cellHeight;

+(id)modelFromDic:(NSDictionary*)dic;
-(NSDictionary*)cacheDic;
+(id)modelFromCache:(NSDictionary*)cache;

@end

@interface NKMemoryCache : NSObject {
    
}
@property (nonatomic, strong) NSMutableDictionary *cachedUsers;

+(id)sharedMemoryCache;


@end


@interface NSDictionary (ForJsonNull)

- (id)objectOrNilForKey:(id)key;

@end

@interface NSMutableDictionary (SetNilForKey)

- (void)setObjectOrNil:(id)object forKey:(id)key;

@end


@interface NKMActionResult : NKModel

@property (nonatomic, strong) NSNumber *unique;

@end




@interface ZKModelUser : NKModel

@property (nonatomic, strong) NSNumber *chargeAmount;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSNumber *energyAmount;

@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSNumber *isTest;

@property (nonatomic, strong) NSString *inviteCode;


@end


@interface ZKModelProject : NKModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *projectDescription;

@property (nonatomic, strong) NSString *projectType;
@property (nonatomic, strong) NSNumber *projectTypeID;

@property (nonatomic, strong) NSString *viewType;
@property (nonatomic, strong) NSNumber *viewTypeID;

@property (nonatomic, strong) NSString *coverURL;
@property (nonatomic, strong) NSString *showPicUrls;
@property (nonatomic, strong) NSArray *images;

@property (nonatomic, strong) NSNumber *availableDeviceCount;
@property (nonatomic, strong) NSNumber *deviceCount;

@property (nonatomic, strong) NSNumber *chargeStandard;
@property (nonatomic, strong) NSString *durations;

@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *updateTime;

@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *weather;
@property (nonatomic, strong) NSString *businessTime;

@end
