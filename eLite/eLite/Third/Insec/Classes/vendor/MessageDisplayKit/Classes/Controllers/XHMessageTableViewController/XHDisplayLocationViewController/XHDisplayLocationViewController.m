//
//  XHDisplayLocationViewController.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-6.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHDisplayLocationViewController.h"
#import "XHAnnotation.h"
#import <CoreLocation/CoreLocation.h>
@interface XHDisplayLocationViewController () <MKMapViewDelegate,CLLocationManagerDelegate>
{
    CLLocationManager  *locationManager;
    CLLocationCoordinate2D centerCoordinate;
    XHAnnotation *myRegionAnnotation;
}
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) NSArray *placemarkArray;
@end

@implementation XHDisplayLocationViewController

- (MKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
        [_mapView setShowsUserLocation:YES];
        _mapView.delegate = self;
    }
    return _mapView;
}

- (void)loadLocations {
    
    CLLocationCoordinate2D coord = [self.message.location coordinate];
      NSLog(@"self.message.location==%f     %f",coord.latitude,coord.longitude);
    CLRegion *newRegion = [[CLRegion alloc] initCircularRegionWithCenter:coord
                                                                  radius:10.0
                                                              identifier:[NSString stringWithFormat:@"%f, %f", coord.latitude, coord.longitude]];
    
    // Create an annotation to show where the region is located on the map.
    XHAnnotation *myRegionAnnotation = [[XHAnnotation alloc] initWithCLRegion:newRegion title:@"消息的位置" subtitle:self.message.geolocations];
    
    myRegionAnnotation.coordinate = coord;
    myRegionAnnotation.radius = newRegion.radius;
    [self.mapView addAnnotation:myRegionAnnotation];

    //放大到标注的位置
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 150, 150);
    [self.mapView setRegion:region animated:YES];
}
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    CLLocationCoordinate2D coord = [userLocation coordinate];
    NSLog(@"经度:%f,纬度:%f",coord.latitude,coord.longitude);
    //放大到标注的位置
    [self.mapView removeAnnotation:myRegionAnnotation];
    CLRegion *newRegion = [[CLRegion alloc] initCircularRegionWithCenter:userLocation.coordinate
                                                                  radius:10.0
                                                              identifier:[NSString stringWithFormat:@"%f, %f", userLocation.coordinate.latitude, userLocation.coordinate.longitude]];
    
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 150, 150);
    [self.mapView setRegion:region animated:YES];
//    myRegionAnnotation = [[XHAnnotation alloc] initWithCLRegion:newRegion title:@"我的位置" subtitle:self.message.geolocations];
//    CLLocationCoordinate2D coor = userLocation.coordinate;
//    coor.longitude+=0.00042;
//    coor.latitude-=0.0001;
//    userLocation.coordinate = coor;
//    myRegionAnnotation.coordinate = coor;
//    myRegionAnnotation.radius = newRegion.radius;
//    [self.mapView addAnnotation:myRegionAnnotation];
}


//// 代理方法实现
//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
////    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
//    //放大到标注的位置
//    [self.mapView removeAnnotation:myRegionAnnotation];
//    CLRegion *newRegion = [[CLRegion alloc] initCircularRegionWithCenter:newLocation.coordinate
//                                                                  radius:10.0
//                                                              identifier:[NSString stringWithFormat:@"%f, %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude]];
//    
//   
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 150, 150);
//    [self.mapView setRegion:region animated:YES];
//    
//    // Create an annotation to show where the region is located on the map.
//    NSLog(@"------%@",newLocation);
//    myRegionAnnotation = [[XHAnnotation alloc] initWithCLRegion:newRegion title:@"我的位置" subtitle:self.message.geolocations];
////    31.85440250,+117.20197096
////    117.214458,31.858354
//    CLLocationCoordinate2D coor = newRegion.center;
//    coor.longitude+=0.0020;
//    coor.latitude+=0.013012;
//    myRegionAnnotation.coordinate = coor;
//    myRegionAnnotation.radius = newRegion.radius;
//    [self.mapView addAnnotation:myRegionAnnotation];
//
//}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [manager stopUpdatingLocation];
}
-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    centerCoordinate = mapView.region.center;
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:centerCoordinate.latitude longitude:centerCoordinate.longitude];
    NSLog(@"loc===%@",loc);
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    typeof(self) __weak weakSelf = self;
    [geocoder reverseGeocodeLocation:loc completionHandler:
     ^(NSArray* placemarks, NSError* error) {
          weakSelf.placemarkArray =placemarks;

     }];
}
#pragma mark - Life cycle
//31.85456965,+117.20214860
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isLocationMessage) {
            [self loadLocations];
    }
    else
    {
        locationManager = [[CLLocationManager alloc]init];
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = 5.0;
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
            [locationManager requestWhenInUseAuthorization];//使用程序其间允许访问位置数据（iOS8定位需要）
        }
        locationManager.delegate = self;
        [locationManager startUpdatingLocation];
        UIButton *button  =[UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"发送" forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, 40, 30);
        [button addTarget:self action:@selector(sendLocation) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        UIImageView *certerIcon = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-8, [UIScreen mainScreen].bounds.size.height/2+30, 16, 33)];
        certerIcon.image = [UIImage imageNamed:@"anjuke_icon_itis_position.png"];
        [self.view addSubview:certerIcon];
    }
}
- (void)sendLocation
{
     CLLocation *loc = [[CLLocation alloc] initWithLatitude:centerCoordinate.latitude longitude:centerCoordinate.longitude];
    NSLog(@"self.placemarkArray===%@",loc);
    if (self.GetGeolocationsCompledBlock) {
        self.GetGeolocationsCompledBlock(self.placemarkArray,loc);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedStringFromTable(@"Location", @"MessageDisplayKitString", @"地理位置");
    
    [self.view addSubview:self.mapView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.mapView = nil;
}

@end
