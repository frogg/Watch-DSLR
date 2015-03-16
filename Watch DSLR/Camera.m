//
//  Camera.m
//  Watch DSLR
//
//  Created by Frederik Riedel on 15.03.15.
//  Copyright (c) 2015 Frederik Riedel. All rights reserved.
//

#import "Camera.h"

@implementation Camera
@synthesize delegate;
-(id) init {
    self=[super init];
    
    if(self) {
        NSError *error = nil;
        
        
        commandsocket = [[GCDAsyncSocket alloc] init];
        commandsocket.delegate=self;
        commandsocket.delegateQueue=dispatch_get_main_queue();
        
        
        
        if(![commandsocket connectToHost:@"192.168.1.1" onPort:15740 error:&error]) {
            NSLog(@"%@",error.description);
        }
        
        
        eventsocket = [[GCDAsyncSocket alloc] init];
        eventsocket.delegate=self;
        eventsocket.delegateQueue=dispatch_get_main_queue();
        
        
        [NSTimer scheduledTimerWithTimeInterval:2.5f target:self selector:@selector(sendPing) userInfo:nil repeats:YES];
    }
    
    return self;
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    Packet *packet = [[Packet alloc] initWithData:data];
    
    if(packet.type == Init_Command_Ack) {
        //Command Socket Initialized and ready for transfer data, now initialize the event socket
        
        NSError *error;
        if(![eventsocket connectToHost:@"192.168.1.1" onPort:15740 error:&error]) {
            NSLog(@"%@",error.description);
        }
        
        [self sendEventInitWithSessionID:packet.sessionID];
        
    }
    
    if(packet.type == Init_Event_Ack) {
        [self completeConnection];
        
    }
    
    if(packet.type==7 && [packet.message isEqualToString:@"012000000000"]) {
        [delegate connected];
    }
    
    if(packet.type==9) {
        [sock readDataWithTimeout:-1 tag:tag];
    }
}


-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    NSLog(@"write string");
}

-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    
    if(sock==commandsocket) {
        NSLog(@"command socket connected");
        [self sendCommandInit];
    }
    
    if(sock == eventsocket) {
        NSLog(@"event socket connected");
    }
    
}

-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSLog(@"Socket did disconnect");
}

-(void) socketDidCloseReadStream:(GCDAsyncSocket *)sock {
    NSLog(@"did close read stream");
}


-(void) sendCommandInit {
    Packet *initPacket = [[Packet alloc] init];
    initPacket.type = Init_Command_Request;
    initPacket.message = @"000000000000000000000000000000000c7000740070002e006a0073002000640065006d006f00000001000000";
    
    
    [commandsocket writeData:[initPacket data] withTimeout:-1 tag:0];
    [commandsocket readDataWithTimeout:-1 tag:0];
}

-(void) sendEventInitWithSessionID:(NSString *) sessionID {
    Packet *eventInitPacket = [[Packet alloc] init];
    eventInitPacket.type = Init_Event_Request;
    eventInitPacket.message = sessionID;
    
    [eventsocket writeData:[eventInitPacket data] withTimeout:-1 tag:2];
    [eventsocket readDataWithTimeout:-1 tag:2];
}

-(void) sendPing {
    Packet *pingPacket = [Packet new];
    pingPacket.type=13;
    
    
    [eventsocket writeData:[pingPacket data] withTimeout:-1 tag:2];
    [eventsocket readDataWithTimeout:-1 tag:2];
}

-(void) completeConnection {
    Packet *cmdRequest = [Packet new];
    cmdRequest.type=Cmd_Request;
    cmdRequest.message=[NSString stringWithFormat:@"01000000021000000000%@",[Packet sessionID]];
    
    [commandsocket writeData:[cmdRequest data] withTimeout:-1 tag:4];
    [commandsocket readDataWithTimeout:-1 tag:4];
    
}

-(void) capture {
    Packet *cmdRequest = [Packet new];
    cmdRequest.type=Cmd_Request;
    cmdRequest.message=@"010000000e10010000000000000000000000";
    
    [commandsocket writeData:[cmdRequest data] withTimeout:-1 tag:3];
    [commandsocket readDataWithTimeout:-1 tag:3];
    
    //[self getThumb];
    
    //[self startLiveView];
    
}


-(void) getThumb {
    Packet *cmdRequest = [Packet new];
    cmdRequest.type=Cmd_Request;
    cmdRequest.message=@"010000000a10020000000000000000000000";
    
    [commandsocket writeData:[cmdRequest data] withTimeout:-1 tag:3];
    [commandsocket readDataWithTimeout:-1 tag:3];
    
}


-(void) startLiveView {
    Packet *cmdRequest = [Packet new];
    cmdRequest.type=Cmd_Request;
    cmdRequest.message=@"01000000011001000000000000000000000000000000";
    
    [commandsocket writeData:[cmdRequest data] withTimeout:-1 tag:3];
    [commandsocket readDataWithTimeout:-1 tag:3];
}







@end
