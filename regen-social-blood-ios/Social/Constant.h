//
//  Constant.h
//  Social
//
//  Created by Duong Tuan Dat on 10/21/15.
//  Copyright © 2015 Duong Tuan Dat. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

#define GoogleMapAPI @"AIzaSyBnryhNxhWN3ycH7EGJffIzal2q0mK_JM0"
#define CIcon @[@"Email.png",@"Password1.png",@"PasswordAgain.png",@"Name-100.png",@"Calendar 9-100.png",@"Phone-100.png",@"Home-100.png"]
#define API_URL @"http://203.162.13.103:6868/RegenService.asmx/"
#define URL_LOGIN [NSString stringWithFormat:@"%@%@",API_URL,@"LogIn"]
#define URL_REGISTER [NSString stringWithFormat:@"%@%@",API_URL,@"Register"]
#define URL_SETTING [NSString stringWithFormat:@"%@%@",API_URL,@"UpdateUserInfo"]
#define URL_UPDATE_STATUS [NSString stringWithFormat:@"%@%@",API_URL,@"UpdateStatusBloodDonation"]
#define URL_FIND_AROUND [NSString stringWithFormat:@"%@%@",API_URL,@"FindAllDonorAround"]
#define URL_UPDATE_USER_FIND_BLOOD [NSString stringWithFormat:@"%@%@",API_URL,@"UpdateLocationUserFindBlood"]
#define URL_CHECK_EMAIL [NSString stringWithFormat:@"%@%@",API_URL,@"CheckEmail"]
#define URL_CHECK_PHONE [NSString stringWithFormat:@"%@%@",API_URL,@"CheckPhone"]
#define URL_SEND_PASSWORD_TO_EMAIL [NSString stringWithFormat:@"%@%@",API_URL,@"sendPasswordtoEmail"]
#define URL_UPLOAD_IMAGE [NSString stringWithFormat:@"%@%@",API_URL,@"UploadImage"]
#define URL_ADD_DEVICE_TOKEN [NSString stringWithFormat:@"%@%@",API_URL,@"pushDeviceTokenOsType"]
#define URL_PUSH_NUMBER_BADGE [NSString stringWithFormat:@"%@%@",API_URL,@"pushNumberBadge"]
#define URL_PUSH_NOTIFICATION [NSString stringWithFormat:@"%@%@",API_URL,@"PushNotificationAll"]
#define URL_GET_USER_INFO [NSString stringWithFormat:@"%@%@",API_URL,@"getInfoUser"]
#define URL_GET_NEWS_FEED [NSString stringWithFormat:@"%@%@",API_URL,@"getNewsFeed"]
#define URL_IMAGE_DEFAULT @"http://27.118.16.203:6868/Image/e4748f1f-a2bb-460e-adad-d5465dc8d4c0.jpg"
#define NAME_ARRAY @[@"Phạm Hữu Nghị",@"Dương Tuấn Đạt",@"Phạm Thanh Sơn",@"Nguyễn Lê Hoàng",@"Vũ Hải Trường",@"Lê Quang Huy",@"Duy Huy",@"Vũ Trung Đức",@"Lương Thế Dũng",@"Bùi Đức Chung",@"Đỗ Việt Anh",@"Vương Bá Nghi",@"Nguyễn Trần Lịch",@"Nguyễn Viết Mạnh",@"Nguyễn Danh Tú",@"Nguyễn Văn Trịnh",@"Triệu Quốc Đạt",@"Tô Quang Năng",@"Đoàn Văn Khải",@"Phạm Văn An"]
#define BLOOD_TYPE @[@"Chưa xác định",@"O+",@"O-",@"A+",@"A-",@"B+",@"B-",@"AB+",@"AB-"]
#define STR_SEARCH_ALL @"Tất cả"
#define RADIUS @[@"1km",@"5km",@"10km",@"20km",@"50km",@"100km",@"200km",@"500km"]
#endif /* Constant_h */
