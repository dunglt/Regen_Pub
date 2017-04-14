//
//  MapRegisterViewController.h
//  Social
//
//  Created by Pham Nghi on 11/25/15.
//  Copyright © 2015 Duong Tuan Dat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "signupViewController.h"
#import "MVPlaceSearchTextField.h"
@import GoogleMaps;

@protocol MapRegisterDelegate <NSObject>

-(void)didFindAddress:(NSString*)address andLocation:(CLLocationCoordinate2D)location;
-(void)didFindAddressWithPlace:(GMSPlace *)place;

@end

@interface MapRegisterViewController : UIViewController

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (strong, atomic) NSString* address;
@property CLLocationCoordinate2D location;
@property (strong, nonatomic) GMSPlace *placeSelected;
@property (nonatomic,assign) id <MapRegisterDelegate> myDelegate;
- (IBAction)btnConfirm:(id)sender;
@property (weak, nonatomic) IBOutlet MVPlaceSearchTextField *txtSearch;



@end

