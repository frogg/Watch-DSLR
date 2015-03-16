//
//  PTPString.m
//  Watch DSLR
//
//  Created by Frederik Riedel on 16.03.15.
//  Copyright (c) 2015 Frederik Riedel. All rights reserved.
//

#import "PTPString.h"

@implementation PTPString

-(id) initWithRawHexString:(NSString *) rawHexString {
    self = [super init];
    
    if(self) {
        self.length = [self hexToDec:[rawHexString substringWithRange:NSMakeRange(0, 2)]];
        self.hexString = [rawHexString substringWithRange:NSMakeRange(2, self.length*2*2)]; //zwei hex zeichen pro byte und zwei byte pro string char
    }
    
    return self;
}


-(NSString *) unicodeString {
    return [[NSString alloc] initWithData:[self dataFromHexString:self.hexString] encoding:NSUTF8StringEncoding];
}

-(int) hexToDec:(NSString *) hex {
    unsigned int outVal;
    NSScanner* scanner = [NSScanner scannerWithString:hex];
    [scanner scanHexInt:&outVal];
    
    return outVal;
}

- (NSData *)dataFromHexString:(NSString *) string {
    const char *chars = [string UTF8String];
    int i = 0, len = string.length;
    
    NSMutableData *data = [NSMutableData dataWithCapacity:len / 2];
    char byteChars[3] = {'\0','\0','\0'};
    unsigned long wholeByte;
    
    while (i < len) {
        byteChars[0] = chars[i++];
        byteChars[1] = chars[i++];
        wholeByte = strtoul(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    
    return data;
}

@end
