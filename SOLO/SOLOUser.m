//
//  SOLOUser.m
//  SOLO
//
//  Created by Lei Zheng on 2/12/15.
//  Copyright (c) 2015 smallfish. All rights reserved.
//

#import "SOLOUser.h"

#import "KeychainItemWrapper.h"

#define KEYCHAIN_SERVICE            @"SOLO"
#define KEYCHAIN_IDENTIFIER         @"Account Information"

@interface SOLOUser ()

@property (nonatomic, strong) KeychainItemWrapper *keychainWrapper;

@end


@implementation SOLOUser

- (id)init
{
    if (self = [super init]) {
        _keychainWrapper = [[KeychainItemWrapper alloc] initWithAccount:KEYCHAIN_IDENTIFIER service:KEYCHAIN_SERVICE accessGroup:nil];
        _userId = [self.keychainWrapper objectForKey:(__bridge id)(kSecAttrGeneric)];
        _token = [self.keychainWrapper objectForKey:(__bridge id)(kSecValueData)];
    }
    
    return self;
}

- (BOOL)found
{
    return (self.userId != nil) && ([self.userId length]) && (self.token != nil) && ([self.token length]);
}

- (void)store
{
    [self.keychainWrapper setObject:self.userId forKey:(__bridge id)(kSecAttrGeneric)];
    [self.keychainWrapper setObject:self.token forKey:(__bridge id)(kSecValueData)];
}

// Reset the values in the keychain item, or create a new item if it doesn't already exist
- (void)clear
{
    [self.keychainWrapper resetKeychainItem];
    self.keychainWrapper = [[KeychainItemWrapper alloc] initWithAccount:KEYCHAIN_IDENTIFIER service:KEYCHAIN_SERVICE accessGroup:nil];
    self.userId = nil;
    self.password = nil;
    self.token = nil;
}

@end
