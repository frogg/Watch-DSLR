//
//  PTPArray.m
//  Watch DSLR
//
//  Created by Frederik Riedel on 16.03.15.
//  Copyright (c) 2015 Frederik Riedel. All rights reserved.
//

#import "PTPArray.h"

@implementation PTPArray

+(void) arrayInHexString:(NSString *) hexString {
    int size = [self hexToDec:[hexString substringWithRange:NSMakeRange(0, 8)]]; // erste 4 bits geben anzahl der elemente in array an
    
    
}


+(int) hexToDec:(NSString *) hex {
    unsigned int outVal;
    NSScanner* scanner = [NSScanner scannerWithString:hex];
    [scanner scanHexInt:&outVal];
    
    return outVal;
}

@end
