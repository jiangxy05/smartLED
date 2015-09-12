//
//  SPKWebClient.h
//  Spark IOS
//
//  Copyright (c) 2013 Spark Devices. All rights reserved.
//

#import "AFHTTPClient.h"
#import "SOLOUser.h"
#import "SPKCore.h"


#define kSPKWebClientAuthenticationError    @"SPKWebClientAuthenticationError"
#define kSPKWebClientConnectionError        @"SPKWebClientConnectionError"
#define kSPKWebClientReachabilityChange     @"kSPKWebClientReachabilityChange"

@interface SPKWebClient : AFHTTPClient

- (id)initWithUser:(SOLOUser *)user;

- (void)login:(void (^)(NSString *))authToken failure:(void (^)(NSString *))message;
- (void)register:(void (^)(NSString *))success failure:(void (^)(NSString *))failure;
- (void)attach:(NSData *)coreId success:(void (^)(NSData *))success offline:(void (^)(void))offline alreadyClaimed:(void (^)(void))alreadyClaimed failure:(void (^)(NSString *message))failure;
- (void)cores:(void (^)(NSArray *))cores failure:(void (^)(void))failure;
- (void)signal:(NSData *)coreId on:(BOOL)on;
- (void)name:(NSData *)coreId label:(NSString *)label success:(void (^)(void))success failure:(void (^)(void))failure;
- (void)flashTinker:(NSData *)coreId success:(void (^)(void))success failure:(void (^)(void))failure;
- (void)setLED:(SPKCore *)core task:(NSString *)description success:(void (^)(NSUInteger value))success failure:(void (^)(NSString *err))failure;
- (void)singleCore:(NSData *)coreId task:(NSString *)description success:(void (^)(SPKCore *))core failure:(void (^)(void))failure;


@end
