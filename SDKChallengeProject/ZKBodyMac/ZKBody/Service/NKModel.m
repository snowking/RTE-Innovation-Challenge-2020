//
//  NKModel.m
//  NEXTKING
//
//  Created by King on 14/10/28.
//  Copyright (c) 2014年 King. All rights reserved.
//

#import "NKModel.h"

NSString *const NKWillLogoutNotificationKey = @"NKWillLogoutNotificationKey";
NSString *const NKLoginFinishNotificationKey = @"NKLoginFinishNotificationKey";



@implementation NKModel

+(id)modelFromDic:(NSDictionary*)dic{
    
    NKModel *model = [[self alloc] init];
    model.jsonDic = dic;

    if ([dic objectOrNilForKey:@"id"]) {
        model.modelID = [NSString stringWithFormat:@"%@", [dic objectOrNilForKey:@"id"]];
    }
    return model;
}

-(NSDictionary*)cacheDic{
    return self.jsonDic;
}

+(id)modelFromCache:(NSDictionary*)cache{
    return [self modelFromDic:cache];
}

@end


@implementation NSDictionary (ForJsonNull)

- (id)objectOrNilForKey:(id)key {
    id object = [self objectForKey:key];
    if(object == [NSNull null]) {
        return nil;
    }
    return object;
}

@end

@implementation NSMutableDictionary (SetNilForKey)

- (void)setObjectOrNil:(id)object forKey:(id)key {
    if(!object) {
        [self removeObjectForKey:key];
        return;
    }
    [self setObject:object forKey:key];
}

@end


@implementation NKMemoryCache


-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NKWillLogoutNotificationKey object:nil];
    
}

static NKMemoryCache *_sharedMemoryCache = nil;

+(id)sharedMemoryCache{
    
    if (!_sharedMemoryCache) {
        @synchronized(self){
            _sharedMemoryCache = [[self alloc] init];
        }
    }
    
    return _sharedMemoryCache;
}

-(void)logout:(NSNotification*)noti{
    
    [self.cachedUsers removeAllObjects];

    
}

-(id)init{
    self = [super init];
    if (self) {
        self.cachedUsers = [NSMutableDictionary dictionary];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout:) name:NKWillLogoutNotificationKey object:nil];
        
    }
    return self;
}

@end


@implementation NKMActionResult

+(id)modelFromDic:(NSDictionary*)dic{
    
    
    NKMActionResult *result = [super modelFromDic:dic];
    
    NKBindValueWithKeyForParameterFromDic(@"unique", result.unique, dic);
    
    return result;
}

@end


@implementation ZKModelUser

+(id)modelFromDic:(NSDictionary *)dic{
    
    ZKModelUser *model = [super modelFromDic:dic];
    
    NKBindValueWithKeyForParameterFromDic(@"chargeAmount", model.chargeAmount, dic);
    NKBindValueWithKeyForParameterFromDic(@"createTime", model.createTime, dic);
    NKBindValueWithKeyForParameterFromDic(@"energyAmount", model.energyAmount, dic);
    NKBindValueWithKeyForParameterFromDic(@"tel", model.phone, dic);
    NKBindValueWithKeyForParameterFromDic(@"isTest", model.isTest, dic);
    
    NKBindValueWithKeyForParameterFromDic(@"inviteCode", model.inviteCode, dic);
    
    
    return model;
    
}

@end

@implementation ZKModelProject

+(id)modelFromDic:(NSDictionary *)dic{
    
    ZKModelProject *model = [super modelFromDic:dic];
    
    NKBindValueWithKeyForParameterFromDic(@"name", model.name, dic);
    NKBindValueWithKeyForParameterFromDic(@"description", model.projectDescription, dic);
    
    NKBindValueWithKeyForParameterFromDic(@"projectType", model.projectType, dic);
    NKBindValueWithKeyForParameterFromDic(@"projectTypeId", model.projectTypeID, dic);
    
    NKBindValueWithKeyForParameterFromDic(@"viewType", model.viewType, dic);
    NKBindValueWithKeyForParameterFromDic(@"viewTypeId", model.viewTypeID, dic);
    
    NKBindValueWithKeyForParameterFromDic(@"coverUrl", model.coverURL, dic);
    NKBindValueWithKeyForParameterFromDic(@"showPicUrls", model.showPicUrls, dic);
    
    NSArray *array = [model.showPicUrls componentsSeparatedByString:@","];
    model.images = array;
    
    NKBindValueWithKeyForParameterFromDic(@"availableDeviceCount", model.availableDeviceCount, dic);
    NKBindValueWithKeyForParameterFromDic(@"deviceCount", model.deviceCount, dic);
    
    NKBindValueWithKeyForParameterFromDic(@"chargeStandard", model.chargeStandard, dic);
    NKBindValueWithKeyForParameterFromDic(@"durations", model.durations, dic);
    
    NKBindValueWithKeyForParameterFromDic(@"createTime", model.createTime, dic);
    NKBindValueWithKeyForParameterFromDic(@"updateTime", model.updateTime, dic);
    
    NKBindValueWithKeyForParameterFromDic(@"location", model.location, dic);
    
    NSString *weatherString = [dic objectOrNilForKey:@"weather"];
    
    if (weatherString) {
        NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:[weatherString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingFragmentsAllowed error:nil];
        if (weatherDic) {
            weatherString = weatherDic[@"weather"];
        }
    }
    
    model.weather = weatherString;
    
    if (model.weather && [model.weather length]>0) {
        model.projectDescription = [NSString stringWithFormat:@"，当地天气：%@\n\n%@", model.weather, model.projectDescription];
    }
    else{
        model.projectDescription = [NSString stringWithFormat:@"\n\n%@", model.projectDescription];
    }
    
  
    NSString *timeString = [dic objectOrNilForKey:@"businessTime"];
    NSArray *times = [NSJSONSerialization JSONObjectWithData:[timeString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingFragmentsAllowed error:nil];

    if ([times count] == 2) {
        NSString *beginTime = [[times objectAtIndex:0] substringFromIndex:11];
        NSString *endTime = [[times objectAtIndex:1] substringFromIndex:11];
        
        model.businessTime = [beginTime stringByAppendingFormat:@"-%@", endTime];
       
        
        if ([beginTime isEqualToString:@"00:00:00"] && [endTime isEqualToString:@"23:59:59"]) {
          model.projectDescription = [NSString stringWithFormat:@"开放时间：全天%@", model.projectDescription];
        }
        else{
             model.projectDescription = [NSString stringWithFormat:@"开放时间：当地时间%@%@", model.businessTime, model.projectDescription];
        }
    }

    
    
    return model;
    
}

@end
