//
//  openssl_wrapper.m
//  ThirdDemoApp
//
//  Created by Xu Hanjie on 11-1-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "openssl_wrapper.h"
#import <MF_Base64Additions.h>
#import "rsa.h"
#include "pem.h"
#include "md5.h"
#include "bio.h"
#include "sha.h"
#include <string.h>


int rsa_sign_with_private_key_pem(char *message, int message_length
                                  , unsigned char *signature, unsigned int *signature_length
                                  , char *private_key_file_path, BOOL rsa2) {
    unsigned char shabuf[(rsa2?(SHA256_DIGEST_LENGTH):(SHA_DIGEST_LENGTH))];
    if (rsa2) {
        SHA256((unsigned char *)message, message_length, shabuf);
    } else {
        SHA1((unsigned char *)message, message_length, shabuf);
    }
    
    int success = 0;
    BIO *bio_private = NULL;
    RSA *rsa_private = NULL;
    bio_private = BIO_new(BIO_s_file());
    BIO_read_filename(bio_private, private_key_file_path);
    rsa_private = PEM_read_bio_RSAPrivateKey(bio_private, NULL, NULL, "");
    if (rsa_private != nil) {
        if (1 == RSA_check_key(rsa_private)) {
            int rsa_sign_valid = RSA_sign((rsa2?(NID_sha256):(NID_sha1))
                                          , shabuf, (rsa2?(SHA256_DIGEST_LENGTH):(SHA_DIGEST_LENGTH))
                                          , signature, signature_length
                                          , rsa_private);
            if (1 == rsa_sign_valid) {
                success = 1;
            }
        }
        BIO_free_all(bio_private);
    }
    else {
        NSLog(@"rsa_private read error : private key is NULL");
    }
    
    return success;
}
