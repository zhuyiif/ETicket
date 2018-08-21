//
//  sm2oc.m
//  TestSM
//
//  Created by chunjian wang on 2018/8/16.
//  Copyright © 2018年 chunjian wang. All rights reserved.
//

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#import "sm2oc.h"
#include "string.h"
# include <openssl/bn.h>
# include <openssl/ec.h>
# include <openssl/evp.h>
# include <openssl/rand.h>
# include <openssl/engine.h>
# include <openssl/sm2.h>
# include "pkcs12.h"
# include "sm2_lcl.h"
# include "sm4.h"


EC_KEY *mk_eckey(int nid, const unsigned char *key, int keylen) {
    int ok = 0;
    EC_KEY *k = NULL;
    BIGNUM *priv = NULL;
    EC_POINT *pub = NULL;
    const EC_GROUP *grp;
    k = EC_KEY_new_by_curve_name(nid);
    if (!k)
        goto err;
    if (!(priv = BN_bin2bn(key, keylen, NULL)))
        goto err;
    if (!EC_KEY_set_private_key(k, priv))
        goto err;
    grp = EC_KEY_get0_group(k);
    pub = EC_POINT_new(grp);
    if (!pub)
        goto err;
    if (!EC_POINT_mul(grp, pub, priv, NULL, NULL, NULL))
        goto err;
    if (!EC_KEY_set_public_key(k, pub))
        goto err;
    ok = 1;
err:
    BN_clear_free(priv);
    EC_POINT_free(pub);
    if (ok)
        return k;
    EC_KEY_free(k);
    return NULL;
}


int sm2Sign(const unsigned char *key, int keyLen, const unsigned char *src, int srcLen, unsigned char *sign, int *signLen) {
    const EVP_MD *id_md = EVP_sm3();
    const EVP_MD *msg_md = EVP_sm3();
    
    int type = NID_sm2p256v1;
    unsigned char dgst[EVP_MAX_MD_SIZE];
    size_t dgstlen = 32;
    const char *id = "1234567812345678";
    
    ECDSA_SIG *sm2sig = NULL;
    unsigned char sig[256] = {0x0};
    unsigned int siglen = 0;
    
    const BIGNUM *sig_r;
    const BIGNUM *sig_s;
    const unsigned char *p;
    
    
    EC_KEY *ec_key = mk_eckey(NID_sm2p256v1, key, keyLen);
    
    SM2_compute_message_digest(id_md, msg_md, src, srcLen, id,
                               strlen(id), dgst, &dgstlen, ec_key);
    
    siglen = sizeof(sig);
    int sret = SM2_sign(type, dgst, dgstlen, sig, &siglen, ec_key);
    if (!sret) {
        fprintf(stderr, "error: %s %d\n", __FUNCTION__, __LINE__);
        return -1;
    }
    
    p = sig;
    sm2sig = d2i_ECDSA_SIG(NULL, &p, siglen);
    
    ECDSA_SIG_get0(sm2sig, &sig_r, &sig_s);
    
    siglen = BN_bn2bin(sig_r, sign);
    *signLen = siglen;
    siglen = BN_bn2bin(sig_s, sign + siglen);
    *signLen += siglen;
    
    return 0;
}

int sm4dec(unsigned char *srcKey ,int len, unsigned char *outKey) {
    unsigned char key[16] = {0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33,
        0x33};
    sm4_context ctx;
    sm4_setkey_dec(&ctx, key);
    sm4_crypt_ecb(&ctx, 0, len, srcKey, outKey);
    return 0;
}



