//
//  gzstream.h
//  Objective-Zip
//
//  Created by  on 11-8-19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#ifndef Objective_Zip_gzstream_h
#define Objective_Zip_gzstream_h

#include "zlib.h"

#ifdef __cplusplus
extern "C" {
#endif
    

#define  Z_HEADER_SIZE 12
/* Compress data */
int zcompress(Bytef *data, uLong ndata, 
              Bytef *zdata, uLong *nzdata);
/* Uncompress data */
int zdecompress(Bytef *zdata, uLong nzdata,
                Bytef *data, uLong *ndata);
/* gzip Compress data */
int gzcompress(Bytef *data, uLong ndata, 
               Bytef *zdata, uLong *nzdata);
/* gzip Uncompress data */
int gzdecompress(Bytef *zdata, uLong nzdata,
                 Bytef *data, uLong *ndata);
/* http gzip Uncompress data */
int httpgzdecompress(Bytef *zdata, uLong nzdata,
                     Bytef *data, uLong *ndata);
    
int gzip_compress(const unsigned char *source, unsigned long sourcelen, unsigned char** target, unsigned long *targetlen);
int gzip_decompress(const unsigned char *source, unsigned long sourcelen, unsigned char **target, unsigned long *targetlen);    
#ifdef __cplusplus
}
#endif
#endif
