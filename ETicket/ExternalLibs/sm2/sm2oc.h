//
//  sm2oc.h
//  TestSM
//
//  Created by chunjian wang on 2018/8/16.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//


# include <openssl/bn.h>
# include <openssl/ec.h>
# include <openssl/evp.h>
# include <openssl/rand.h>
# include <openssl/engine.h>
# include <openssl/sm2.h>

int sm2Sign(const unsigned char *key, int keyLen, const unsigned char *src, int srcLen, unsigned char *sign, int *signLen);
int sm4dec( unsigned char *srcKey ,int len, unsigned char *outKey);
