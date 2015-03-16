//
//  Packet.h
//  Watch DSLR
//
//  Created by Frederik Riedel on 15.03.15.
//  Copyright (c) 2015 Frederik Riedel. All rights reserved.
//

#import <Foundation/Foundation.h>

static int const Init_Command_Request = 1;
static int const Init_Command_Ack = 2;
static int const Init_Event_Request = 3;
static int const Init_Event_Ack = 4;

static int const Cmd_Request = 6;

static int const Ping = 13;
static int const Pong = 14;



@interface Packet : NSObject

@property(nonatomic) int type;
@property(nonatomic,retain) NSString *message;
@property(nonatomic,retain) NSString *sessionID;
@property(nonatomic) int transactionID;


-(id) initWithData:(NSData *) data;
-(NSString *) hexString;
-(NSData *) data;
-(NSData *) dataTemp;
-(NSData *) capture;
-(NSString *) transactionIDString;
+(NSString *) sessionID;

@end
