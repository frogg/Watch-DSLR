//
//  ViewController.h
//  Watch DSLR
//
//  Created by Frederik Riedel on 14.03.15.
//  Copyright (c) 2015 Frederik Riedel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDAsyncSocket.h"
#import "Camera.h"



@interface ViewController : UIViewController <GCDAsyncSocketDelegate,CameraDelegate> {
    GCDAsyncSocket *commandsocket;
    GCDAsyncSocket *eventsocket;
    Camera *camera;
}




@end

