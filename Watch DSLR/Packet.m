//
//  Packet.m
//  Watch DSLR
//
//  Created by Frederik Riedel on 15.03.15.
//  Copyright (c) 2015 Frederik Riedel. All rights reserved.
//

#import "Packet.h"

@implementation Packet

static NSString *sessionID;
static int transactionID;

-(id) initWithData:(NSData *) data {
    self = [super init];
    
    if(self) {
        NSString *hexString = [self hexadecimalStringFromData:data];
        NSString *typeString = [hexString substringWithRange:NSMakeRange(8, 8)];
        self.type = [self littleEndianHexToDec:typeString];
        
        
        self.message = [hexString substringWithRange:NSMakeRange(16, [hexString length] -16)];
        
        if(self.type == Init_Command_Ack) {
            self.sessionID = [self.message substringWithRange:NSMakeRange(0, 8)];
            sessionID=self.sessionID;
        }
        if(self.type == Pong) {
            NSLog(@"Pong");
        } else {
            NSLog(@"Created Packet from type %u, with payload: %@",self.type,self.message);
        }
        
        self.transactionID=transactionID++;
    }
    
    return self;
}


-(NSString *) transactionIDString {
    return [self swapEndian:[self decToHex:self.transactionID]];
}

-(NSString *) hexString {
    NSString *typeString = [self decToLittleEndianHex:self.type];
        
    
    NSString *string = [NSString stringWithFormat:@"%@%@",typeString,self.message];
    
    return [self stringWithPTPLengthPrefix:string];
}


-(NSData *) data {
    return [self dataFromHexString:[self hexString]];
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


-(NSString *) stringWithPTPLengthPrefix:(NSString *) string {
    int length = (int)([string length] + 8) / 2; //add 8 for the prefix which we will add
    
    NSString *bigEndianLengthString = [self decToHex:length];
    
    bigEndianLengthString = [self makeLength:8 byAddingLeadingZeroesToString:bigEndianLengthString];
    
    return [NSString stringWithFormat:@"%@%@",[self swapEndian:bigEndianLengthString],string];
}

-(NSString *) makeLength:(int) length byAddingLeadingZeroesToString:(NSString *) string {
    while ([string length]<length) {
        string = [NSString stringWithFormat:@"0%@",string];
    }
    
    return string;
}

-(NSString *) decToLittleEndianHex:(int) dec {
    NSString *bigEndian = [self decToHex:dec];
    bigEndian = [self makeLength:8 byAddingLeadingZeroesToString:bigEndian];
    return [self swapEndian:bigEndian];
}

-(int) littleEndianHexToDec:(NSString *) hex {
    NSString *bigEndian = [self swapEndian:hex];
    return [self hexToDec:bigEndian];
}

-(NSString *) decToHex:(int) dec {
    return [NSString stringWithFormat:@"%02x", dec];
}


-(int) hexToDec:(NSString *) hex {
    unsigned int outVal;
    NSScanner* scanner = [NSScanner scannerWithString:hex];
    [scanner scanHexInt:&outVal];
    
    return outVal;
}


-(NSString *) swapEndian:(NSString *) endianString {
    NSString *swappedEndianString = @"";
    
    for(int i=0; i<[endianString length]; i+=2) {
        swappedEndianString = [NSString stringWithFormat:@"%@%@",[endianString substringWithRange:NSMakeRange(i, 2)],swappedEndianString];
    }
    return swappedEndianString;
}



- (NSString *)hexadecimalStringFromData:(NSData *) data {
    /* Returns hexadecimal string of NSData. Empty string if data is empty.   */
    
    const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
    
    if (!dataBuffer)
        return [NSString string];
    
    NSUInteger          dataLength  = [data length];
    
    
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    
    
    for (int i = 0; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    
    return [NSString stringWithString:hexString];
}

+(NSString *) sessionID {
    return sessionID;
}

@end
