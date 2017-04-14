//
//  ViewController.m
//  Social
//
//  Created by Duong Tuan Dat on 10/19/15.
//  Copyright © 2015 Duong Tuan Dat. All rights reserved.
//

#import "ViewController.h"
#import <REFrostedViewController.h>
#import "CommonF.h"
#import "Common.h"
#import <GoogleMaps/GoogleMaps.h>
#import "UserInfoVC.h"
#import "UserData.h"
#import "MarkerTableViewCell.h"
#import "UserDataManager.h"
#import "LibraryAPI.h"
#import <SVProgressHUD/SVProgressHUD.h>


@import GoogleMaps;
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface ViewController () <CLLocationManagerDelegate,UIPickerViewDelegate,UITextFieldDelegate,GMSMapViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    BOOL didFindBlood;
    UIButton *btnDone;
    UIView *inputAccView;
    float zoom;
    GMSCameraPosition *camera;
    GMSMarker         *_locationMarker;
    GMSMarker *_secondMarker;
    UserData *userdata;
    NSArray *imageData;
    NSArray *titleData;
    NSArray *detailData;
    NSArray *bloodTypeData;
    NSArray *radiusData;
    NSMutableArray *userArray;
    UIPickerView *bloodTypePickerView;
    UIPickerView *radiusPickerView;
    GMSMapView *mapView_;
    BOOL firstLocationUpdate_;
    double conDis;
    NSMutableArray *arrayMarker;
    NSMutableArray *arrayNearMarker;
}
@property (weak, nonatomic) IBOutlet UIView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableMarker;
@property (weak, nonatomic) IBOutlet UITextField *bloodType;
@property (weak, nonatomic) IBOutlet UITextField *radius;
@property (nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSString *selectedBloodType;

@end

@implementation ViewController




#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createInputAccessoryView];
    didFindBlood = FALSE;
    // Now add the view as an input accessory view to the selected textfield.
    [_radius setInputAccessoryView:inputAccView];
    [_bloodType setInputAccessoryView:inputAccView];
    [_tableMarker registerNib:[UINib nibWithNibName:@"MarkerTableViewCell" bundle:nil] forCellReuseIdentifier:@"MarkerTableViewCell"];
    [self.view viewWithTag:69].hidden = YES;
//    NSArray *data;
    zoom = 14;
    arrayMarker = [[NSMutableArray alloc]init];
    arrayNearMarker = [[NSMutableArray alloc]init];
    conDis = 0.011438 * pow(2, 11);
    userdata = [[UserData alloc]init];
    RLMResults *_results = [UserData allObjects];
    userdata = _results.firstObject;
    bloodTypePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 150)];
    radiusPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
    bloodTypePickerView.delegate = self;
    [self getCurrentLocation];
    bloodTypePickerView.showsSelectionIndicator = YES;
    radiusPickerView.delegate = self;
    radiusPickerView.showsSelectionIndicator = YES;
    bloodTypePickerView.hidden = NO;
    radiusPickerView.hidden = NO;
    _bloodType.inputView = bloodTypePickerView;
    _radius.inputView = radiusPickerView;
    camera = [GMSCameraPosition cameraWithLatitude:_locationMarker.position.latitude
                                                            longitude:_locationMarker.position.longitude
                                                                 zoom:zoom];
    mapView_ = [GMSMapView mapWithFrame:self.view.frame camera:camera];
    mapView_.settings.compassButton = YES;
    mapView_.settings.myLocationButton = NO;
    mapView_.settings.indoorPicker = NO;
    mapView_.delegate = self;
    // Listen to the myLocation property of GMSMapView.
    [mapView_ addObserver:self
               forKeyPath:@"myLocation"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    // Ask for My Location data after the map has already been added to the UI.
    [self.mapView addSubview:mapView_];
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"Please enable location services");
        return;
    }
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        NSLog(@"Please authorize location services");
        return;
    }
    if ([userdata.address isEqual: @"Vietnam"]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Thông báo"
                                                                       message:@"Bạn hãy vào phần cập nhật thông tin điền chính xác địa chỉ của mình để Regen hoạt động hiệu quả nhất!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    // Creates a marker in the center of the map.
    [CommonF chageColorPlaceHolder:_bloodType withColor:[UIColor whiteColor]];
    [CommonF chageColorPlaceHolder:_radius withColor:[UIColor whiteColor]];
    dispatch_async(dispatch_get_main_queue(), ^{
        mapView_.myLocationEnabled = YES;
    });
    [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(upDateLocationOfUserFindBlood) userInfo:nil repeats:YES];

    self.selectedBloodType = STR_SEARCH_ALL;
}

-(void)viewWillAppear:(BOOL)animated{
    didFindBlood = FALSE;
}

-(void)viewDidLayoutSubviews {
    
}


- (void)upDateLocationOfUserFindBlood{
    if (didFindBlood) {
        [arrayMarker removeAllObjects];
        [LibraryAPI requestToUpdateUserFindBloodWithUserId:userdata.userId location:_locationManager.location.coordinate radius:[_radius.text substringToIndex:[_radius.text length] - 2] callBack:^(BOOL success, id result, id message) {
            if (success) {
                for (NSDictionary *var in result) {
                    UserData* Data = [[UserData alloc] init];
                    [Data assignValueFromDictionary:var];
                    [arrayMarker addObject:[self prepareLocationMarkerwithUserData:Data]];
                }
            }
        }];

    }
}


- (void) getCurrentLocation {
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 5.0f;

    
    if(IS_OS_8_OR_LATER){
        NSUInteger code = [CLLocationManager authorizationStatus];
        if (code == kCLAuthorizationStatusNotDetermined && ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
            // choose one request according to your business.
            if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
                [self.locationManager requestAlwaysAuthorization];
            } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                [self.locationManager  requestWhenInUseAuthorization];
            } else {
                NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
            }
        }
    }
    [self.locationManager startUpdatingLocation];
}
- (void)dealloc {
    [mapView_ removeObserver:self
                  forKeyPath:@"myLocation"
                     context:NULL];
}

#pragma mark - Functions
-(void)showMenu
{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}


- (double) calculateDistanceBetween:(GMSMarker*)marker1 and: (GMSMarker*)marker2{
    
    double x = marker1.position.latitude, y = marker1.position.longitude, z = marker2.position.latitude,
    t = marker2.position.longitude;
    
    return (double)sqrt((x - z)*(x - z) + (y - t)*(y - t));
}

- (BOOL) isFarEnoughWithDistance:(double)distance andZoomLevel:(double)zoomLevel {
    NSLog(@"ddf : %f", conDis/(pow(2, zoomLevel)));
    if (distance < conDis/(pow(2, zoomLevel))) {
        return YES;
    }
    else return NO;
    
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(void) chageColorPlaceHolder:(UITextField*)text withColor:(UIColor*)color{
    text.attributedPlaceholder = [[NSAttributedString alloc]initWithString:text.placeholder attributes:@{NSForegroundColorAttributeName: color} ];
}

#pragma mark - GMSMapViewDelegate
-(void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position{
    zoom = position.zoom;
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    [self.view viewWithTag:69].hidden = YES;
    [arrayNearMarker removeAllObjects];
    for (int i=0; i<arrayMarker.count; i++) {
        if ([self isFarEnoughWithDistance:[self calculateDistanceBetween:marker and:arrayMarker[i]] andZoomLevel:zoom]) {
            [arrayNearMarker addObject:arrayMarker[i]];
        }
        
    }
    if (arrayNearMarker.count>1) {
        [_tableMarker reloadData];
        [self.view viewWithTag:69].hidden = NO;
        return YES;
    }
    else{
        [mapView_ setSelectedMarker:marker];
        [arrayNearMarker removeAllObjects];
        return YES;
    }

}



- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    InfoWindow *view =  [[[NSBundle mainBundle] loadNibNamed:@"InfoWindow" owner:self options:nil] objectAtIndex:0];
    view.imgProfilePicture.layer.cornerRadius = view.imgProfilePicture.frame.size.width / 2;;
    view.imgProfilePicture.clipsToBounds = YES;
    
    UserData *data = (UserData *)marker.userData;
    view.lblBloodType.text = data.bloodType;
    if ([data.name isKindOfClass:[NSNull class]]) {
        view.lblName.text = data.email;
    }
    else view.lblName.text = data.name;
    view.lblPhone.text = data.phone;
    if (data.photoData != nil) {
        view.imgProfilePicture.image = [CommonF stringToUIImage:data.photoData];

    }
    
    return view;
}

-(void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture{
    mapView_.selectedMarker = nil;
    [self.view viewWithTag:69].hidden = YES;
    [arrayNearMarker removeAllObjects];
}

-(void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker{
    UserInfoVC *secondViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"UserInfoVC"];
    UserData *data = (UserData *)marker.userData;
    secondViewController.userData = data ;
    secondViewController.lblName.text = data.name;
    [self.navigationController pushViewController:secondViewController animated:YES];
}
#pragma mark - KVO updates

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        NSLog(@"Please authorize location services");
        return;
    }
    
    NSLog(@"CLLocationManager error: %@", error.localizedFailureReason);
    return;
}
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
//    CLLocation *location = [locations lastObject];
//    
//    if (_locationMarker == nil) {
//        _locationMarker = [[GMSMarker alloc] init];
//        _locationMarker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
//        NSArray *frames = @[[UIImage imageNamed:@"MyLocationMarker"]];
//        
//        _locationMarker.icon = [UIImage animatedImageWithImages:frames duration:0.8];
//        _locationMarker.groundAnchor = CGPointMake(0.5f, 0.97f); // Taking into account walker's shadow
//        _locationMarker.map = mapView_;
//        //Quan ly marker
//        //_locationMarker.userData = ();
//    } else {
//        [CATransaction begin];
//        [CATransaction setAnimationDuration:2.0];
//        _locationMarker.position = location.coordinate;
//        [CATransaction commit];
//    }
//}


- (GMSMarker *) prepareLocationMarkerwithUserData:(UserData*)userData{
    GMSMarker *marker;
    marker = [[GMSMarker alloc]init];
    marker.userData = userData;
    NSString *statusString = nil;
    if (userData.status==1) {
        statusString = @"bordered";
    } else
        statusString = @"filled";

    if ([userData.bloodType isEqualToString:BLOOD_TYPE[0]]) {
        marker.icon = [UIImage imageNamed:@"Unknown_bordered_marker"];
    } else {
        marker.icon = [UIImage imageNamed:[NSString stringWithFormat:@"%@_bordered_marker", userData.bloodType]];
    }

//    NSLog(@"image name: %@",[NSString stringWithFormat:@"%@_bordered_marker", userData.bloodType]);
    marker.position = CLLocationCoordinate2DMake(userData.latitude, userData.longitude);
    marker.map = mapView_;
    return marker;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (!firstLocationUpdate_) {
        // If the first location update has not yet been recieved, then jump to that
        // location.
        [self getCurrentLocation];
        firstLocationUpdate_ = YES;
        CLLocation* location = [change objectForKey:NSKeyValueChangeNewKey];
        mapView_.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                         zoom:14];
    }
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (pickerView == bloodTypePickerView) {
        return [BLOOD_TYPE count];
    }
    else return [RADIUS count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString * title = nil;
    if (pickerView == bloodTypePickerView) {
        if (row == 0) {
            title = STR_SEARCH_ALL;
        } else {
            title = [BLOOD_TYPE objectAtIndex:row];
        }

    } else
        title = [RADIUS objectAtIndex:row];
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == bloodTypePickerView) {
        if (row == 0) {
            _bloodType.text = STR_SEARCH_ALL;
        } else {
            _bloodType.text = [BLOOD_TYPE objectAtIndex:row];
        }

        self.selectedBloodType = _bloodType.text;
    }
    else
        _radius.text = [RADIUS objectAtIndex:row];

}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayNearMarker.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MarkerTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MarkerTableViewCell"];
    GMSMarker *marker = arrayNearMarker[indexPath.row];
    UserData *data = (UserData *)marker.userData;
    if (data.photoData != nil) {
        cell.imgAvatar.image = [CommonF stringToUIImage:data.photoData];
        
    }
    cell.imgAvatar .layer.cornerRadius = cell.imgAvatar.frame.size.height/2;
    cell.imgAvatar.clipsToBounds = YES;
    if ([data.name isKindOfClass:[NSNull class]]) {
        cell.lblName.text = data.email;
    }
    else cell.lblName.text = data.name;
    cell.lblBloodType.text = data.bloodType;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UserInfoVC *secondViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"UserInfoVC"];
    GMSMarker *marker = arrayNearMarker[indexPath.row];
    UserData *data = (UserData *)marker.userData;
    secondViewController.userData = data;
    [self.navigationController pushViewController:secondViewController animated:YES];
    [self.view viewWithTag:69].hidden = YES;

}


#pragma mark - IB Outlet Action
- (IBAction)btnMyLocation:(id)sender {
    [self getCurrentLocation];
    GMSCameraUpdate *move = [GMSCameraUpdate setTarget:_locationManager.location.coordinate zoom:camera.zoom];
    [mapView_ animateWithCameraUpdate:move];
    NSLog(@"d = %f",[self calculateDistanceBetween:_secondMarker and:_locationMarker]);

}

- (IBAction)menuBtn:(id)sender {
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == _bloodType) {
        _bloodType.text = self.selectedBloodType;
    }
    else
        _radius.text = @"1km";
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (![_radius.text isEqual:@""]&&![_bloodType.text isEqual:@""]) {
        int i;
        for (i=0; i<BLOOD_TYPE.count; i++) {
            if([BLOOD_TYPE[i] isEqual:_bloodType.text] || [self.selectedBloodType isEqualToString:STR_SEARCH_ALL])
                break;
        }
        [mapView_ clear];
        [arrayMarker removeAllObjects];
        [SVProgressHUD show];
        [LibraryAPI requestToFindAllDonorAroundWithUserId:userdata.userId location:_locationManager.location.coordinate radius:[_radius.text substringToIndex:[_radius.text length] - 2] bloodTypeID:i callBack:^(BOOL success, id result, id message) {
            if (success) {
                [SVProgressHUD dismiss];
                if ([NSArray arrayWithObject:result].count == 0) {
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Thông báo"
                                                                                   message:@"Không tìm thấy!"
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action) {}];
                    
                    [alert addAction:defaultAction];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                for (NSDictionary *var in result) {
                    UserData* Data = [[UserData alloc] init];
                    [Data assignValueFromDictionary:var];
                    [arrayMarker addObject:[self prepareLocationMarkerwithUserData:Data]];
                    didFindBlood = YES;
                        }
                if (arrayMarker.count != 0) {
                    GMSCoordinateBounds *bounds;
                    bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:_locationManager.location.coordinate
                                                                  coordinate:_locationManager.location.coordinate];
                    bounds = [bounds includingCoordinate:_locationManager.location.coordinate];
                    for (GMSMarker *marker in arrayMarker) {
                        
                        bounds = [bounds includingCoordinate:marker.position];
                        
                    }
                    GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds
                                                             withPadding:50.0f];
                    [mapView_ moveCamera:update];
                }
                else{
                    GMSCameraUpdate *move = [GMSCameraUpdate setTarget:_locationManager.location.coordinate zoom:14];
                [mapView_ animateWithCameraUpdate:move];
                }
                           }

        }];
        
    }
}
-(void)createInputAccessoryView{
    
    
    inputAccView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 310.0, 40.0)];
    
    // Set the view’s background color. We’ ll set it here to gray. Use any color you want.
    [inputAccView setBackgroundColor:[UIColor lightGrayColor]];
    
    // We can play a little with transparency as well using the Alpha property. Normally
    // you can leave it unchanged.
    [inputAccView setAlpha: 0.8];
    
    btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDone setFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-70, 0.0f, 80.0f, 40.0f)];
    [btnDone setTitle:@"Done" forState:UIControlStateNormal];
    [btnDone setBackgroundColor:[UIColor clearColor]];
    [btnDone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnDone addTarget:self action:@selector(doneTyping) forControlEvents:UIControlEventTouchUpInside];
    [inputAccView addSubview:btnDone];
    
    
}
-(void)doneTyping{
    // When the "done" button is tapped, the keyboard should go away.
    // That simply means that we just have to resign our first responder.
    [_bloodType resignFirstResponder];
    [_radius resignFirstResponder];
}

@end

