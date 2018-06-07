//
//  sha256.c
//  Advertising
//
//  Created by hht on 2018/5/28.
//  Copyright © 2018年 hht. All rights reserved.
//

#include "sha256.h"

#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>



#define SHA_LONG unsigned int

#define SHA_LBLOCK    16
#define SHA_CBLOCK    (SHA_LBLOCK*4)    /* SHA treats input data as a
* contiguous array of 32 bit
* wide big-endian values. */
#define SHA_LAST_BLOCK  (SHA_CBLOCK-8)
#define SHA_DIGEST_LENGTH 20

typedef struct SHAstate_st
{
    SHA_LONG h0,h1,h2,h3,h4;
    SHA_LONG Nl,Nh;
    SHA_LONG data[SHA_LBLOCK];
    unsigned int num;
} SHA_CTX;


#define SHA256_CBLOCK    (SHA_LBLOCK*4)    /* SHA-256 treats input data as a
* contiguous array of 32 bit
* wide big-endian values. */
#define SHA224_DIGEST_LENGTH    28
#define SHA256_DIGEST_LENGTH    32

typedef unsigned char        u8;
typedef unsigned short        u16;
typedef signed char            s8;
typedef signed short        s16;
typedef unsigned char        boolean;
typedef unsigned long        u32;
typedef signed long            s32;
//typedef unsigned __int64   ulong64;   /* 64-bit unsigned integer type */
typedef unsigned long long   ulong64;   /* 64-bit unsigned integer type */

#define jtoh32(x) (((x & 0xff000000) >> 24) | ((x & 0x00ff0000) >> 8) | \
((x & 0x0000ff00) << 8) | ((x & 0x000000ff) << 24) )
#define htoj32(x) (((x & 0x000000ff) << 24) | ((x & 0x0000ff00) << 8) | \
((x & 0x00ff0000) >> 8) | ((x & 0xff000000) >> 24) )


typedef struct sha256_ctx
{
    ulong64 length;
    u32 state[8];
    u32 curlen;
    u8 buf[64];
} SHA256_CTX;

#define RORc(x, n) (((x) >> (n)) | ((x) << (32 - (n))))
/* Various logical functions */
//#define Ch(x,y,z)       (z ^ (x & (y ^ z)))
//#define Maj(x,y,z)      (((x | y) & z) | (x & y))
#define S(x, n)         RORc((x),(n))
#define R(x, n)         (((x)&0xFFFFFFFFUL)>>(n))
#define Sigma00(x)       (S(x, 2) ^ S(x, 13) ^ S(x, 22))
#define Sigma10(x)       (S(x, 6) ^ S(x, 11) ^ S(x, 25))
#define Gamma0(x)       (S(x, 7) ^ S(x, 18) ^ R(x, 3))
#define Gamma1(x)       (S(x, 17) ^ S(x, 19) ^ R(x, 10))

#define Ch(x, y, z) ((z) ^ ((x) & ((y) ^ (z))))
#define Maj(x, y, z) (((x) & ((y) | (z))) | ((y) & (z)))
#define SILC_GET32_MSB(l, cp)                           \
do {                                                    \
(l) = ((u32)(u8)(cp)[0]) << 24          \
| ((u32)(u8)(cp)[1] << 16)            \
| ((u32)(u8)(cp)[2] << 8)             \
| ((u32)(u8)(cp)[3]);                 \
}while(0)

#define SILC_PUT32_MSB(l, cp)                   \
do {                                            \
(cp)[0] = (u8)((l) >> 24);             \
(cp)[1] = (u8)((l) >> 16);             \
(cp)[2] = (u8)((l) >> 8);              \
(cp)[3] = (u8)(l);                     \
} while(0)

#define SILC_PUT64_MSB(l, cp)                                   \
do {                                                            \
SILC_PUT32_MSB((u32)((ulong64)(l) >> 32), (cp));    \
SILC_PUT32_MSB((u32)(l), (cp) + 4);                    \
}while(0)

#define MIN(x,y) ((x)<(y)?(x):(y))

u8 gAPIBuffer[1024];

#define  gsha256crx   ((SHA256_CTX*)((u8*)((u8*)&gAPIBuffer) + 0x80))

void  sha256_transform(u32 *state, unsigned char *buf)
{
    u32 S[8], W[64], t0, t1;
    int i;
    
    /* copy state into S */
    for (i = 0; i < 8; i++) {
        S[i] = state[i];
    }
    
    /* copy the state into 512-bits into W[0..15] */
    for (i = 0; i < 16; i++)
        SILC_GET32_MSB(W[i], buf + (4 * i));
    
    /* fill W[16..63] */
    for (i = 16; i < 64; i++) {
        W[i] = Gamma1(W[i - 2]) + W[i - 7] + Gamma0(W[i - 15]) + W[i - 16];
    }
    
    /* Compress */
#define RND(a,b,c,d,e,f,g,h,i,ki)               \
t0 = h + Sigma10(e) + Ch(e, f, g) + ki + W[i]; \
t1 = Sigma00(a) + Maj(a, b, c);                \
d += t0;                                      \
h  = t0 + t1;
    
    RND(S[0],S[1],S[2],S[3],S[4],S[5],S[6],S[7],0,0x428a2f98);
    RND(S[7],S[0],S[1],S[2],S[3],S[4],S[5],S[6],1,0x71374491);
    RND(S[6],S[7],S[0],S[1],S[2],S[3],S[4],S[5],2,0xb5c0fbcf);
    RND(S[5],S[6],S[7],S[0],S[1],S[2],S[3],S[4],3,0xe9b5dba5);
    RND(S[4],S[5],S[6],S[7],S[0],S[1],S[2],S[3],4,0x3956c25b);
    RND(S[3],S[4],S[5],S[6],S[7],S[0],S[1],S[2],5,0x59f111f1);
    RND(S[2],S[3],S[4],S[5],S[6],S[7],S[0],S[1],6,0x923f82a4);
    RND(S[1],S[2],S[3],S[4],S[5],S[6],S[7],S[0],7,0xab1c5ed5);
    RND(S[0],S[1],S[2],S[3],S[4],S[5],S[6],S[7],8,0xd807aa98);
    RND(S[7],S[0],S[1],S[2],S[3],S[4],S[5],S[6],9,0x12835b01);
    RND(S[6],S[7],S[0],S[1],S[2],S[3],S[4],S[5],10,0x243185be);
    RND(S[5],S[6],S[7],S[0],S[1],S[2],S[3],S[4],11,0x550c7dc3);
    RND(S[4],S[5],S[6],S[7],S[0],S[1],S[2],S[3],12,0x72be5d74);
    RND(S[3],S[4],S[5],S[6],S[7],S[0],S[1],S[2],13,0x80deb1fe);
    RND(S[2],S[3],S[4],S[5],S[6],S[7],S[0],S[1],14,0x9bdc06a7);
    RND(S[1],S[2],S[3],S[4],S[5],S[6],S[7],S[0],15,0xc19bf174);
    RND(S[0],S[1],S[2],S[3],S[4],S[5],S[6],S[7],16,0xe49b69c1);
    RND(S[7],S[0],S[1],S[2],S[3],S[4],S[5],S[6],17,0xefbe4786);
    RND(S[6],S[7],S[0],S[1],S[2],S[3],S[4],S[5],18,0x0fc19dc6);
    RND(S[5],S[6],S[7],S[0],S[1],S[2],S[3],S[4],19,0x240ca1cc);
    RND(S[4],S[5],S[6],S[7],S[0],S[1],S[2],S[3],20,0x2de92c6f);
    RND(S[3],S[4],S[5],S[6],S[7],S[0],S[1],S[2],21,0x4a7484aa);
    RND(S[2],S[3],S[4],S[5],S[6],S[7],S[0],S[1],22,0x5cb0a9dc);
    RND(S[1],S[2],S[3],S[4],S[5],S[6],S[7],S[0],23,0x76f988da);
    RND(S[0],S[1],S[2],S[3],S[4],S[5],S[6],S[7],24,0x983e5152);
    RND(S[7],S[0],S[1],S[2],S[3],S[4],S[5],S[6],25,0xa831c66d);
    RND(S[6],S[7],S[0],S[1],S[2],S[3],S[4],S[5],26,0xb00327c8);
    RND(S[5],S[6],S[7],S[0],S[1],S[2],S[3],S[4],27,0xbf597fc7);
    RND(S[4],S[5],S[6],S[7],S[0],S[1],S[2],S[3],28,0xc6e00bf3);
    RND(S[3],S[4],S[5],S[6],S[7],S[0],S[1],S[2],29,0xd5a79147);
    RND(S[2],S[3],S[4],S[5],S[6],S[7],S[0],S[1],30,0x06ca6351);
    RND(S[1],S[2],S[3],S[4],S[5],S[6],S[7],S[0],31,0x14292967);
    RND(S[0],S[1],S[2],S[3],S[4],S[5],S[6],S[7],32,0x27b70a85);
    RND(S[7],S[0],S[1],S[2],S[3],S[4],S[5],S[6],33,0x2e1b2138);
    RND(S[6],S[7],S[0],S[1],S[2],S[3],S[4],S[5],34,0x4d2c6dfc);
    RND(S[5],S[6],S[7],S[0],S[1],S[2],S[3],S[4],35,0x53380d13);
    RND(S[4],S[5],S[6],S[7],S[0],S[1],S[2],S[3],36,0x650a7354);
    RND(S[3],S[4],S[5],S[6],S[7],S[0],S[1],S[2],37,0x766a0abb);
    RND(S[2],S[3],S[4],S[5],S[6],S[7],S[0],S[1],38,0x81c2c92e);
    RND(S[1],S[2],S[3],S[4],S[5],S[6],S[7],S[0],39,0x92722c85);
    RND(S[0],S[1],S[2],S[3],S[4],S[5],S[6],S[7],40,0xa2bfe8a1);
    RND(S[7],S[0],S[1],S[2],S[3],S[4],S[5],S[6],41,0xa81a664b);
    RND(S[6],S[7],S[0],S[1],S[2],S[3],S[4],S[5],42,0xc24b8b70);
    RND(S[5],S[6],S[7],S[0],S[1],S[2],S[3],S[4],43,0xc76c51a3);
    RND(S[4],S[5],S[6],S[7],S[0],S[1],S[2],S[3],44,0xd192e819);
    RND(S[3],S[4],S[5],S[6],S[7],S[0],S[1],S[2],45,0xd6990624);
    RND(S[2],S[3],S[4],S[5],S[6],S[7],S[0],S[1],46,0xf40e3585);
    RND(S[1],S[2],S[3],S[4],S[5],S[6],S[7],S[0],47,0x106aa070);
    RND(S[0],S[1],S[2],S[3],S[4],S[5],S[6],S[7],48,0x19a4c116);
    RND(S[7],S[0],S[1],S[2],S[3],S[4],S[5],S[6],49,0x1e376c08);
    RND(S[6],S[7],S[0],S[1],S[2],S[3],S[4],S[5],50,0x2748774c);
    RND(S[5],S[6],S[7],S[0],S[1],S[2],S[3],S[4],51,0x34b0bcb5);
    RND(S[4],S[5],S[6],S[7],S[0],S[1],S[2],S[3],52,0x391c0cb3);
    RND(S[3],S[4],S[5],S[6],S[7],S[0],S[1],S[2],53,0x4ed8aa4a);
    RND(S[2],S[3],S[4],S[5],S[6],S[7],S[0],S[1],54,0x5b9cca4f);
    RND(S[1],S[2],S[3],S[4],S[5],S[6],S[7],S[0],55,0x682e6ff3);
    RND(S[0],S[1],S[2],S[3],S[4],S[5],S[6],S[7],56,0x748f82ee);
    RND(S[7],S[0],S[1],S[2],S[3],S[4],S[5],S[6],57,0x78a5636f);
    RND(S[6],S[7],S[0],S[1],S[2],S[3],S[4],S[5],58,0x84c87814);
    RND(S[5],S[6],S[7],S[0],S[1],S[2],S[3],S[4],59,0x8cc70208);
    RND(S[4],S[5],S[6],S[7],S[0],S[1],S[2],S[3],60,0x90befffa);
    RND(S[3],S[4],S[5],S[6],S[7],S[0],S[1],S[2],61,0xa4506ceb);
    RND(S[2],S[3],S[4],S[5],S[6],S[7],S[0],S[1],62,0xbef9a3f7);
    RND(S[1],S[2],S[3],S[4],S[5],S[6],S[7],S[0],63,0xc67178f2);
    
#undef RND
    
    /* feedback */
    for (i = 0; i < 8; i++) {
        state[i] = state[i] + S[i];
    }
}

void sha256_init(SHA256_CTX* md)
{
    memset((u8*)&md->length,0,sizeof(struct sha256_ctx));
    
    md->length = 0;
    md->curlen = 0;
    md->state[0] = 0x6A09E667UL;
    md->state[1] = 0xBB67AE85UL;
    md->state[2] = 0x3C6EF372UL;
    md->state[3] = 0xA54FF53AUL;
    md->state[4] = 0x510E527FUL;
    md->state[5] = 0x9B05688CUL;
    md->state[6] = 0x1F83D9ABUL;
    md->state[7] = 0x5BE0CD19UL;
    return;
}

void SHA256Update(unsigned char* inbuf, unsigned int inlen)
{
    unsigned long n;
    u32 block_size = sizeof(gsha256crx->buf);
    
    if (gsha256crx->curlen > block_size)
        return;
    while (inlen > 0) {
        if (gsha256crx->curlen == 0 && inlen >= block_size) {
            memcpy(gsha256crx->buf + gsha256crx->curlen, inbuf, (u16)block_size);
            sha256_transform(gsha256crx->state, (unsigned char *)gsha256crx->buf);
            gsha256crx->length += block_size * 8;
            inbuf += block_size;
            inlen -= block_size;
        }else{
            n = MIN(inlen, (block_size - gsha256crx->curlen));
            memcpy(gsha256crx->buf + gsha256crx->curlen, inbuf,(u16)n);
            gsha256crx->curlen += n;
            inbuf += n;
            inlen -= n;
            if (gsha256crx->curlen == block_size){
                sha256_transform(gsha256crx->state, gsha256crx->buf);
                gsha256crx->length += block_size * 8;
                gsha256crx->curlen = 0;
            }
        }
    }
    return;
}
void SHA256Final(u8 * outdata, u16 outlen)
{
    if (gsha256crx->curlen >= sizeof(gsha256crx->buf))
        return;
    
    /* increase the length of the message */
    gsha256crx->length += gsha256crx->curlen * 8;
    
    /* append the '1' bit */
    gsha256crx->buf[gsha256crx->curlen++] = (unsigned char)0x80;
    
    /* if the length is currently above 56 bytes we append zeros
     * then compress.  Then we can fall back to padding zeros and length
     * encoding like normal.
     */
    if (gsha256crx->curlen > 56) {
        while (gsha256crx->curlen < 64) {
            gsha256crx->buf[gsha256crx->curlen++] = (unsigned char)0;
        }
        sha256_transform(gsha256crx->state, gsha256crx->buf);
        gsha256crx->curlen = 0;
    }
    
    /* pad upto 56 bytes of zeroes */
    while (gsha256crx->curlen < 56) {
        gsha256crx->buf[gsha256crx->curlen++] = (unsigned char)0;
    }
    
    /* store length */
    SILC_PUT64_MSB(gsha256crx->length, gsha256crx->buf + 56);
    sha256_transform(gsha256crx->state, gsha256crx->buf);
    
    /* copy output */
    //    for (i = 0; i < 8; i += 2){
    //        SILC_PUT32_MSB(gsha256crx->state[i], &gsha256crx->state[i]);
    //        SILC_PUT32_MSB(gsha256crx->state[i + 1], &gsha256crx->state[i + 1]);
    //    }
    
    gsha256crx->state[0] = htoj32(gsha256crx->state[0]);
    gsha256crx->state[1] = htoj32(gsha256crx->state[1]);
    gsha256crx->state[2] = htoj32(gsha256crx->state[2]);
    gsha256crx->state[3] = htoj32(gsha256crx->state[3]);
    gsha256crx->state[4] = htoj32(gsha256crx->state[4]);
    gsha256crx->state[5] = htoj32(gsha256crx->state[5]);
    gsha256crx->state[6] = htoj32(gsha256crx->state[6]);
    gsha256crx->state[7] = htoj32(gsha256crx->state[7]);
    
    
    memcpy(outdata, (u8*)&gsha256crx->state[0] ,outlen);
    
    return;
}

#pragma mark 十六进制转Ascii
unsigned char Hex_to_Hascii(unsigned char hex)
{
    unsigned char m;
    m=hex>>4;
    if(m<0x0a) m+=0x30;
    else m+=0x37;
    return(m);
}
unsigned char Hex_to_Lascii(unsigned char hex)
{
    unsigned char m;
    m=hex&0x0f;
    if(m<0x0a) m+=0x30;
    else m+=0x37;
    return(m);
    }
#pragma mark Ascii转十六进制
unsigned char Ascii_to_Hex(unsigned char highbit,unsigned char lowbit)
{
    unsigned char hexbyte;
    if((highbit>0x2f)&&(highbit<0x3a))
        highbit-=0x30;
    else
        {
         highbit-=0x37;
          if(highbit>0x0f)
             highbit-=0x20;
            }
    if((lowbit>0x2f)&&(lowbit<0x3a))
        lowbit-=0x30;
    else
        {
        lowbit-=0x37;
        if(lowbit>0x0f)
            lowbit-=0x20;
            }
    hexbyte=(highbit<<4)|lowbit;
    return(hexbyte);
}
void CSHA256CalDlg(){
    
    char *m_vCardNO = "1000751510000002";
    //88FE6BD222EEE800E4AC94B0C846D3E0CBCE9BE28728FF15A4C0BD76653AC0B6
    unsigned char instr[256] , outstr[256] ;
    long inlen , i ;
    
    if(strlen(m_vCardNO) != 16)
    {
        printf("用户卡号输入错误！");
        return ;
    }
    memcpy(outstr , m_vCardNO , 16);
    for(i=0;i<8;i++)
        instr[i] = Ascii_to_Hex(outstr[2*i],outstr[2*i+1]);
    
    inlen = 8 ;

    sha256_init(gsha256crx);
    SHA256Update(instr, 8);
    SHA256Final(outstr, 32);
    
    for(i=0;i<4;i++)
    {
        instr[2*i]  = Hex_to_Hascii(outstr[i]);
        instr[2*i+1] = Hex_to_Lascii(outstr[i]);
    }
    instr[8] = 0x00 ;
    
    printf("instr===%s\n", instr);
    printf("outstr===%s\n", outstr);
    //    card_number.SetWindowText((CString)instr) ;
    
}

