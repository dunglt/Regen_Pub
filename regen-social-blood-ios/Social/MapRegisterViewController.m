//
//  MapRegisterViewController.m
//  Social
//
//  Created by Pham Nghi on 11/25/15.
//  Copyright © 2015 Duong Tuan Dat. All rights reserved.
//

#import "MapRegisterViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "CommonF.h"


@interface MapRegisterViewController ()<UISearchBarDelegate,UITextFieldDelegate,PlaceSearchTextFieldDelegate>

@end

@implementation MapRegisterViewController
{
    BOOL isPressReturn;
    GMSMapView *mapView_;
    BOOL firstLocationUpdate_;
    UISearchController *searchController;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isPressReturn = NO;
    
    _txtSearch.placeSearchDelegate                 = self;
    _txtSearch.strApiKey                           = @"AIzaSyBnryhNxhWN3ycH7EGJffIzal2q0mK_JM0";
    _txtSearch.superViewOfList                     = self.view;  // View, on which Autocompletion list should be appeared.
    _txtSearch.autoCompleteShouldHideOnSelection   = YES;
    _txtSearch.maximumNumberOfAutoCompleteRows     = 5;
    
    
    if (self.placeSelected) {
        GMSCameraPosition* camera = [GMSCameraPosition cameraWithLatitude:self.placeSelected.coordinate.latitude
                                                                longitude:self.placeSelected.coordinate.longitude
                                                                     zoom:16];
        [self.mapView setCamera:camera];
        
    } else {
        _mapView.settings.compassButton = YES;
        [_mapView addObserver:self
                   forKeyPath:@"myLocation"
                      options:NSKeyValueObservingOptionNew
                      context:NULL];
        //_mapView = [GMSMapView mapWithFrame:_mapView.frame camera:camera];
        // Listen to the myLocation property of GMSMapView.
        
        // Ask for My Location data after the map has already been added to the UI.
        dispatch_async(dispatch_get_main_queue(), ^{
            _mapView.myLocationEnabled = YES;
        });
    }
    
    

    
}
-(void)viewDidLayoutSubviews {
    //[self.view addSubview:_mapView];
}

- (void)dealloc {
    [_mapView removeObserver:self
                  forKeyPath:@"myLocation"
                     context:NULL];
}
-(void)viewDidAppear:(BOOL)animated{
    
    //Optional Properties
    _txtSearch.autoCompleteRegularFontName =  @"HelveticaNeue-Bold";
    _txtSearch.autoCompleteBoldFontName = @"HelveticaNeue";
    _txtSearch.autoCompleteTableCornerRadius=0.0;
    _txtSearch.autoCompleteRowHeight=35;
    _txtSearch.autoCompleteTableCellTextColor=[UIColor colorWithWhite:0.131 alpha:1.000];
    _txtSearch.autoCompleteFontSize=14;
    _txtSearch.autoCompleteTableBorderWidth=1.0;
    _txtSearch.showTextFieldDropShadowWhenAutoCompleteTableIsOpen=YES;
    _txtSearch.autoCompleteShouldHideOnSelection=YES;
    _txtSearch.autoCompleteShouldHideClosingKeyboard=YES;
    _txtSearch.autoCompleteShouldSelectOnExactMatchAutomatically = YES;
    _txtSearch.autoCompleteTableFrame = CGRectMake((self.view.frame.size.width-_txtSearch.frame.size.width)*0.5, _txtSearch.frame.size.height, _txtSearch.frame.size.width, 200.0);
}

-(void)placeSearch:(MVPlaceSearchTextField*)textField ResponseForSelectedPlace:(GMSPlace*)responseDict{
    [self.view endEditing:YES];
    NSLog(@"SELECTED ADDRESS :%@",responseDict);
    _location = responseDict.coordinate;
    self.placeSelected = responseDict;
    _mapView.camera = [GMSCameraPosition cameraWithTarget:responseDict.coordinate
                                                     zoom:16];
}
-(void)placeSearchWillShowResult:(MVPlaceSearchTextField*)textField{
    
}
-(void)placeSearchWillHideResult:(MVPlaceSearchTextField*)textField{
    
}
-(void)placeSearch:(MVPlaceSearchTextField*)textField ResultCell:(UITableViewCell*)cell withPlaceObject:(PlaceObject*)placeObject atIndex:(NSInteger)index{
    if(index%2==0){
        cell.contentView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    }else{
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
}

#pragma mark - KVO updates

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (!firstLocationUpdate_) {
        // If the first location update has not yet been recieved, then jump to that
        // location.
        firstLocationUpdate_ = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        _mapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                         zoom:14];
        [self.txtSearch becomeFirstResponder];
        
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Place search Textfield Delegates



#pragma mark - Searchbar Delegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
        });
        
    });
    [self.view endEditing:YES];
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)btnConfirm:(id)sender {
    if (self.myDelegate && [self.myDelegate respondsToSelector:@selector(didFindAddress:andLocation:)] && self.placeSelected) {
        [self.myDelegate didFindAddress:_txtSearch.text andLocation:_location];
    }
    
    if (self.myDelegate && [self.myDelegate respondsToSelector:@selector(didFindAddressWithPlace:)] && self.placeSelected) {
        [self.myDelegate didFindAddressWithPlace:self.placeSelected];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
