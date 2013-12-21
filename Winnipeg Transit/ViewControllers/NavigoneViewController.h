//
//  NavigoneViewController.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12/20/2013.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniversalViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "MSTopBar.h"

@interface NavigoneViewController : UniversalViewController {
    int statusBarAdjustment;
    
    GMSMapView *mainMap;
    
    MSTopBar *topBar;
    
    CLLocationManager *locationManager;
}


@end
