//
//  SPKWebClient.m
//  Spark IOS
//
//  Copyright (c) 2013 Spark Devices. All rights reserved.
//

#import "SPKWebClient.h"
#import "AFJSONRequestOperation.h"
#import "NSData+HexString.h"
#import "NSString+HexData.h"


@interface SPKWebClient ()

@property (nonatomic, strong) SOLOUser *user;
@property (nonatomic, strong) dispatch_queue_t webQueue;

@end

@implementation SPKWebClient

- (id)initWithUser:(SOLOUser *)user
{
    if (self = [super initWithBaseURL:[NSURL URLWithString:@"http://54.149.44.33:8080"]]) {
        _user = user;
        _webQueue = dispatch_queue_create("webQueue", DISPATCH_QUEUE_CONCURRENT);

        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        
        
        [self setDefaultHeader:@"Accept" value:@"text/json"];
        [self setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            NSNotification *notification;
            if (status == AFNetworkReachabilityStatusNotReachable) {
                notification = [NSNotification notificationWithName:kSPKWebClientReachabilityChange object:nil userInfo:@{ @"wifi": @(NO) }];
            } else if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
                notification = [NSNotification notificationWithName:kSPKWebClientReachabilityChange object:nil userInfo:@{ @"wifi": @(YES) }];
            }
            if (notification) {
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }
        }];
    }
    return self;
}

- (void)cores:(void (^)(NSArray *))cores failure:(void (^)(void))failure
{
    
    
    NSDictionary *params = @{ @"access_token": self.user.token };
    
    

    [self callMethod:@"GET" path:@"v1/devices" parameters:params notifyAuthenticationFailure:YES success:^(NSInteger statusCode, id JSON) {
        if (cores) {
            NSMutableArray *coresList = [NSMutableArray array];
            for (NSDictionary *coreDict in JSON) {
                SPKCore *c  = [[SPKCore alloc] init];
                // DDLogVerbose(@"coreDict: %@", coreDict);
                c.name = [coreDict objectForKey:@"name"];
                if (!c.name || c.name == Nil || c.name == nil || (NSNull *)c.name == [NSNull null]) {
                    c.name = @"no-name-core";
                }
                c.coreId = [(NSString *)coreDict[@"id"] dataFromHex];
                //c.connected = [coreDict[@"connected"] boolValue];
                c.connected = TRUE;
                //c.color = UIColorFromRGB([coreDict[@"color"] intValue]);
                c.color = UIColorFromRGB(0xFFFFFF);
                c.intensity = [coreDict[@"intensity"] intValue];
                c.sensorStatus = [(NSString *)coreDict[@"sensorStatus"] dataFromHex];
                c.UVReading = [coreDict[@"UVReading"] intValue];
                c.lightReading = [coreDict[@"lightReading"] intValue];
                c.tempLed = [coreDict[@"tempLed"] intValue];
                c.tempLocal = [coreDict[@"tempLocal"] intValue];
                //c.groupName = [coreDict objectForKey:@"groupName"];
                c.groupName = @"noGroup";
                
                c.state = SPKCoreStateReady;
                [coresList addObject:c];
            }
            cores(coresList);
        }
    } failure:^(NSInteger statusCode, NSDictionary *dict) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kSPKWebClientAuthenticationError object:nil];
    }];
}

- (void)singleCore:(NSData *)coreId task:(NSString *)description success:(void (^)(SPKCore *))core failure:(void (^)(void))failure
{
    
    
    NSDictionary *params = @{ @"access_token": self.user.token };
    
    
    [self callMethod:@"GET" path:[NSString stringWithFormat:@"v1/devices/%@/get%@", [coreId hexString],description] parameters:params notifyAuthenticationFailure:YES success:^(NSInteger statusCode, id JSON) {
        if (core) {
            SPKCore *c  = [[SPKCore alloc] init];
            for (NSDictionary *coreDict in JSON) {
                
                // DDLogVerbose(@"coreDict: %@", coreDict);
                c.name = [coreDict objectForKey:@"name"];
                if (!c.name || c.name == Nil || c.name == nil || (NSNull *)c.name == [NSNull null]) {
                    c.name = @"no-name-core";
                }
                
                c.connected = [coreDict[@"connected"] boolValue];
                
                if ([description isEqualToString:@"Light"]) {
                    c.color = UIColorFromRGB([coreDict[@"color"] intValue]);
                    c.intensity = [coreDict[@"intensity"] intValue];
                    
                    c.UVReading = [coreDict[@"UVReading"] intValue];
                    c.lightReading = [coreDict[@"lightReading"] intValue];
                    c.tempLed = [coreDict[@"tempLed"] intValue];
                    c.tempLocal = [coreDict[@"tempLocal"] intValue];
                }
                else if ([description isEqualToString:@"SensorSettings"]){
                c.sensorStatus = [(NSString *)coreDict[@"sensorStatus"] dataFromHex];
                c.lightThreshold = [coreDict[@"lightThreshold"] intValue];
                c.UVThreshold = [coreDict[@"UVThreshold"] intValue];
                c.motionTime = [coreDict[@"motionTime"] intValue];
                c.tempHigh = [coreDict[@"tempHigh"] intValue];
                c.tempLedHigh = [coreDict[@"tempLedHigh"] intValue];
                    c.tempLow = [coreDict[@"tempLow"] intValue];
                }
                
            }
            core(c);
        }
    } failure:^(NSInteger statusCode, NSDictionary *dict) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kSPKWebClientAuthenticationError object:nil];
    }];
}

- (void)login:(void (^)(NSString *))success failure:(void (^)(NSString *))failure
{
    NSDictionary *params = @{
                             @"grant_type": @"password",
                             @"username": self.user.userId,
                             @"password": self.user.password,
                             };

    [self setAuthorizationHeaderWithUsername:SPK_CLIENT_USERNAME password:SPK_CLIENT_PASSWORD];
    [self callMethod:@"POST" path:@"oauth/token" parameters:params notifyAuthenticationFailure:NO success:^(NSInteger statusCode, id JSON) {
        [self clearAuthorizationHeader];
        success(JSON[@"access_token"]);
    } failure:^(NSInteger statusCode, NSDictionary *dict) {
        failure([dict[@"errors"] componentsJoinedByString:@" "]);
    }];
}

- (void)register:(void (^)(NSString *))success failure:(void (^)(NSString *))failure
{
    NSDictionary *params = @{
                             @"username": self.user.userId,
                             @"password": self.user.password,
                             };
    
    DDLogVerbose(@"%@ %@", self.user.userId, self.user.password);

    [self callMethod:@"POST" path:@"v1/users" parameters:params notifyAuthenticationFailure:YES success:^(NSInteger statusCode, id JSON) {
        [self login:success failure:failure];
    } failure:^(NSInteger statusCode, NSDictionary *dict) {
        failure([dict[@"errors"] componentsJoinedByString:@" "]);
    }];
}

- (void)attach:(NSData *)coreId success:(void (^)(NSData *))success offline:(void (^)(void))offline alreadyClaimed:(void (^)(void))alreadyClaimed failure:(void (^)(NSString *message))failure
{
    NSDictionary *params = @{
                             @"access_token": self.user.token,
                             @"id": [coreId hexString],
                             };

    [self callMethod:@"POST" path:@"v1/devices" parameters:params notifyAuthenticationFailure:YES success:^(NSInteger statusCode, id JSON) {
        NSString *coreIdString = JSON[@"id"];
        success([coreIdString dataFromHex]);
    } failure:^(NSInteger statusCode, NSDictionary *dict) {
        if (statusCode == 404) {
            offline();
        } else if (statusCode == 403) {
            alreadyClaimed();
        } else {
            failure([NSString stringWithFormat:@"Unknown Error: %u", statusCode]);
        }
    }];
}

- (void)signal:(NSData *)coreId on:(BOOL)on
{
    NSDictionary *params = @{
                             @"access_token": self.user.token,
                             @"signal": @(on)
                             };
    [self callMethod:@"PUT" path:[NSString stringWithFormat:@"v1/devices/%@", [coreId hexString]] parameters:params notifyAuthenticationFailure:YES success:^(NSInteger statusCode, id JSON) {
        // do nothing
    } failure:^(NSInteger statusCode, id JSON) {
        DDLogWarn(@"Problem signalling core");
    }];
}

- (void)name:(NSData *)coreId label:(NSString *)label success:(void (^)(void))success failure:(void (^)(void))failure
{
    NSDictionary *params = @{
                             @"access_token": self.user.token,
                             @"name": label
                             };
    [self callMethod:@"PUT" path:[NSString stringWithFormat:@"v1/devices/%@", [coreId hexString]] parameters:params notifyAuthenticationFailure:YES success:^(NSInteger statusCode, id JSON) {
        success();
    } failure:^(NSInteger statusCode, id JSON) {
        failure();
    }];
}

- (void)flashTinker:(NSData *)coreId success:(void (^)(void))success failure:(void (^)(void))failure
{
    NSDictionary *params = @{
                             @"access_token": self.user.token,
                             @"app": @"tinker"
                             };
    [self callMethod:@"PUT" path:[NSString stringWithFormat:@"v1/devices/%@", [coreId hexString]] parameters:params notifyAuthenticationFailure:YES success:^(NSInteger statusCode, id JSON) {
        success();
    } failure:^(NSInteger statusCode, id JSON) {
        failure();
    }];
}

// set LED status

- (void)setLED:(SPKCore *)core task:(NSString *)description success:(void (^)(NSUInteger value))success failure:(void (^)(NSString *err))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{ @"access_token": self.user.token }];
    NSMutableString *path = [NSMutableString stringWithFormat:@"v1/devices/%@/set%@", [core.coreId hexString],description];
    
    NSLog(@"set LED...");
    
    //set color
    if ([description containsString:@"Light"]) {
        const CGFloat *components=CGColorGetComponents(core.color.CGColor);
        
        params[@"color"]=[NSString stringWithFormat:@"R,%.2f,G,%.2f,B,%.2f,I,%d",components[0],components[1],components[2],core.intensity];
    }
    
    
    //set sensor settings
    if ([description containsString:@"SensorSettings"]) {
        params[@"lightThreshold"]=[NSString stringWithFormat:@"%d", core.lightThreshold];
        params[@"UVThreshold"]=[NSString stringWithFormat:@"%d", core.UVThreshold];
        params[@"tempLow"]=[NSString stringWithFormat:@"%d", core.tempLow];
        params[@"tempHigh"]=[NSString stringWithFormat:@"%d", core.tempHigh];
        params[@"tempLedHigh"]=[NSString stringWithFormat:@"%d", core.tempLedHigh];
        params[@"motionTime"]=[NSString stringWithFormat:@"%d", core.motionTime];
        params[@"sensorStatus"]=[[NSString alloc] initWithData:core.sensorStatus encoding:NSUTF16StringEncoding];
    
    
    }
    
    
    
    [self callMethod:@"POST" path:path parameters:params notifyAuthenticationFailure:YES success:^(NSInteger statusCode, id JSON) {
        NSString *errorMessage = JSON[@"error"];
        if (!errorMessage && JSON[@"return_value"] != [NSNull null]) {
            
            success([JSON[@"return_value"] unsignedIntegerValue]);
        } else {
            failure(errorMessage);
        }
    } failure:^(NSInteger statusCode, id JSON) {
        failure([NSString stringWithFormat:@"Unknown error: %d", statusCode]);
    }];
    
}



#pragma mark - Private Methods

// All API calls go through this method to consolidate authentication and error cases
- (void)callMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters notifyAuthenticationFailure:(BOOL)notifyAuthenticationFailure success:(void (^)(NSInteger, id))success failure:(void (^)(NSInteger, id))failure
{
    NSURLRequest *request = [self requestWithMethod:method path:path parameters:parameters];
    
    NSLog(@"%@ %@", path, parameters);
    
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request
                                                                      success:^(AFHTTPRequestOperation *operation, id JSON) {
                                               
                                               NSLog(@"%@ %@", operation, JSON);
                                                                          if ([operation.response statusCode] >= 200 && [operation.response statusCode] <= 299) {
                                                                              success([operation.response statusCode], JSON);
                                                                          } else if ([operation.response statusCode] == 400 && notifyAuthenticationFailure) {
                                                                              [[NSNotificationCenter defaultCenter] postNotificationName:kSPKWebClientAuthenticationError object:nil];
                                                                          } else {
                                                                              failure([operation.response statusCode], JSON);
                                                                          }
                                                                      }
                                                                      failure:^(AFHTTPRequestOperation *operation, NSError *e) {

                                                                          
                                                                          //DDLogVerbose(@"%@ %@ %@ %@", operation, operation.response, [e localizedDescription], e);
                                                                          if ([operation.response statusCode] == 400) {
                                                                              if (notifyAuthenticationFailure) {
                                                                                  
                                                                                  [[NSNotificationCenter defaultCenter] postNotificationName:kSPKWebClientAuthenticationError object:nil];
                                                                              } else {
                                                                                  failure([operation.response statusCode], @{});
                                                                              }
                                                                          } else if ([operation.response statusCode] > 400 && [operation.response statusCode] <= 499) {
                                                                              DDLogError(@"failure: %@", [e localizedDescription]);
                                                                              failure([operation.response statusCode], @{});
                                                                          } else {
                                                                              NSLog(@"error: %@", [e localizedDescription]);
                                                                              [[NSNotificationCenter defaultCenter] postNotificationName:kSPKWebClientConnectionError object:self];
                                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                                  NSString *title;
                                                                                  NSString *msg;
                                                                                  if ([operation.response statusCode]) {
                                                                                      title = @"Internal error";
                                                                                      msg = @"An error was reported by the Spark Cloud. Please try again later. If the issue is not resolved, please visit www.spark.io/support for help.";
                                                                                  } else {
                                                                                      title = @"No connection";
                                                                                      msg = @"There was a problem communicating with Spark. Please check your internet connection.";
                                                                                  }
                                                                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                                                                  [alert show];
                                                                              });
                                                                          }
                                                                      }];
    operation.successCallbackQueue = self.webQueue;
    operation.failureCallbackQueue = self.webQueue;
    [self enqueueHTTPRequestOperation:operation];
}

@end
