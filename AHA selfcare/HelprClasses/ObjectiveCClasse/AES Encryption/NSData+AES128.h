//
//  NSData+AES256.h
//  HealthCareTesting
//
//  Created by SivA on 21/05/14.
//  Copyright (c) 2014 Hubbl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES128)

- (NSData *)AES128EncryptWithKey:(NSString *)key iv:(NSString *)initialization_vector;
- (NSData *)AES128DecryptWithKey:(NSString *)key iv:(NSString *)initialization_vector;
- (NSString *)hexadecimalString;
- (NSData *)decryptCipher:(NSData *)dataIn
                  iv:(NSData *)iv
                 key:(NSData *)symmetricKey
               error:(NSError **)error;

- (NSString *)base64Encoding;

@end
