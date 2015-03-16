//
//  Camera.h
//  Watch DSLR
//
//  Created by Frederik Riedel on 15.03.15.
//  Copyright (c) 2015 Frederik Riedel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
#import "Packet.h"

@protocol CameraDelegate <NSObject>

-(void) connected;

@end


@interface Camera : NSObject {
    GCDAsyncSocket *commandsocket;
    GCDAsyncSocket *eventsocket;
}

@property(nonatomic,strong) id<CameraDelegate> delegate;

-(void) capture;
-(void) startLiveView;

@end
