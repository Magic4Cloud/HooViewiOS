
//
//  main.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "AppDelegate.h"

 void sigpipe(int s)
{
    EVLog(@"sigpipe --- on main");
}

int main(int argc, char * argv[])
{
    @autoreleasepool
    {
        signal(SIGPIPE, sigpipe);
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}

