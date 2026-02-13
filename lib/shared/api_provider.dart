import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:io';

import 'package:ksp/page/auth/login.dart';
import 'package:ksp/shared/facebook_firebase.dart';
import 'package:ksp/shared/google.dart';
import 'package:ksp/shared/line.dart';

const versionName = '3.1.9';
const versionNumber = 319;

// flutter build apk --build-name=2.9.3 --build-number=26
// const server = 'http://122.155.223.63/td-ksp-api/';
const server = 'https://ksp.we-builds.com/ksp-api/';
const serverUpload = 'https://ksp.we-builds.com/ksp-document/upload';
const serverLineNoti = 'https://notify-api.line.me/api/notify';
const serverOTP = 'https://portal-otp.smsmkt.com/api/';

const registerApi = '${server}m/register/';
const newsApi = '${server}m/news/';
const newsCmsApi = '${server}news/';
const videoClipsApi = '${server}m/videoClips/';
const newsGalleryApi = '${server}m/news/gallery/read';
const conferenceGalleryApi = '${server}m/conference/gallery/read';
const teachersDayGalleryApi = '${server}m/teachersDay/gallery/read';
const pollApi = '${server}m/poll/';
const poiApi = '${server}m/poi/';
const poiGalleryApi = '${server}m/poi/gallery/read';
const faqApi = '${server}m/faq/';
const conferenceApi = '${server}m/conference/';
const teachersDayApi = '${server}m/teachersDay/';
const knowledgeApi = '${server}m/knowledge/';
const ethicsApi = '${server}m/ethics/';
const cooperativeApi = '${server}m/cooperativeForm/';
const contactApi = '${server}m/contact/';
const bannerApi = '${server}m/banner/';
const bannerGalleryApi = '${server}m/banner/gallery/read';
const privilegeApi = "${server}m/privilege/";
const menuApi = "${server}m/menu/";
const menuV2Api = "${server}m/v2/menu/";
const aboutUsApi = "${server}m/aboutus/";
const welfareApi = '${server}m/welfare/';
const welfareGalleryApi = '${server}m/welfare/gallery/read';
const eventCalendarApi = '${server}m/eventCalendar/';
const eventCalendarCategoryApi = '${server}m/eventCalendar/category/';
const eventCalendarCommentApi = '${server}m/eventCalendar/comment/';
const eventCalendarGalleryApi = '${server}m/eventCalendar/gallery/read';
const pollGalleryApi = '${server}m/poll/gallery/read';
const reporterApi = '${server}m/v2/reporter/';
const reporterGalleryApi = '${server}m/Reporter/gallery/';
const fundApi = '${server}m/fund/';
const fundGalleryApi = '${server}m/fund/gallery/read';
const warningApi = '${server}m/warning/';
const warningGalleryApi = '${server}m/warning/gallery/read';
const privilegeGalleryApi = '${server}m/privilege/gallery/read';
// const privilegeSpecialReadApi =
//     'http://122.155.223.63/td-we-mart-api/m/privilege/ksp/read';
const privilegeSpecialReadApi = 'm/privilege/read';
// const privilegeSpecialCategoryReadApi =
//     'http://122.155.223.63/td-we-mart-api/m/privilege/category/read';
const privilegeSpecialCategoryReadApi = 'm/privilege/category/read';

const comingSoonApi = '${server}m/comingsoon/read';
const comingSoonGalleryApi = '${server}m/comingsoon/gallery/read';
const organizationApi = '${server}Organization/read';

const questionApi = '${server}m/question/';
const answerApi = '${server}m/answer/';

//banner
const mainBannerApi = '${server}m/Banner/main/';
const contactBannerApi = '${server}m/Banner/contact/';
const reporterBannerApi = '${server}m/Banner/reporter/';

//rotation
const rotationApi = '${server}rotation/';
const mainRotationApi = '${server}m/Rotation/main/';
const rotationGalleryApi = '${server}m/rotation/gallery/read';
const rotationWarningApi = '${server}m/rotation/warning/read';
const rotationWelfareApi = '${server}m/rotation/welfare/read';
const rotationNewsApi = '${server}m/rotation/news/read';
const rotationPoiApi = '${server}m/rotation/poi/read';
const rotationPrivilegeApi = '${server}m/rotation/privilege/read';
const rotationNotificationApi = '${server}m/rotation/notification/read';
const rotationEvantCalendarApi = '${server}m/rotation/event/read';
const rotationReporterApi = '${server}m/rotation/reporter/read';
const rotationConferenceApi = '${server}m/rotation/conference/read';
const rotationTeachersDayApi = '${server}m/rotation/teachersDay/read';

//mainPopup
const mainPopupHomeApi = '${server}m/MainPopup/';
const forceAdsApi = '${server}m/ForceAds/';

// comment
const newsCommentApi = '${server}m/news/comment/';
const welfareCommentApi = '${server}m/welfare/comment/';
const poiCommentApi = '${server}m/poi/comment/';
const fundCommentApi = '${server}m/fund/comment/';
const warningCommentApi = '${server}m/warning/comment/';
const conferenceCommentApi = '${server}m/conference/comment/';
const teachersDayCommentApi = '${server}m/teachersDay/comment/';

//category
const conferenceCategoryApi = '${server}m/conference/category/';
const knowledgeCategoryApi = '${server}m/knowledge/category/';
const ethicsCategoryApi = '${server}m/ethics/category/';
const cooperativeCategoryApi = '${server}m/cooperativeForm/category/';
const newsCategoryApi = '${server}m/news/category/';
const privilegeCategoryApi = '${server}m/privilege/category/';
const contactCategoryApi = '${server}m/contact/category/';
const welfareCategoryApi = '${server}m/welfare/category/';
const fundCategoryApi = '${server}m/fund/category/';
const pollCategoryApi = '${server}m/poll/category/';
const poiCategoryApi = '${server}m/poi/category/';
const reporterCategoryApi = '${server}m/reporter/category/';
const warningCategoryApi = '${server}m/warning/category/';
const teachersDayCategoryApi = '${server}m/teachersDay/category/';

const splashApi = '${server}m/splash/read';
const versionReadApi = '${server}m/v2/version/read';

Future<dynamic> postCategory(String url, dynamic criteria) async {
  final storage = FlutterSecureStorage();
  var value = await storage.read(key: 'dataUserLoginKSP') ?? "";
  var dataUser = json.decode(value);
  List<dynamic> dataOrganization = [];
  dataOrganization =
      dataUser['countUnit'] != '' ? json.decode(dataUser['countUnit']) : [];

  var body = json.encode({
    "permission": "all",
    "skip": criteria['skip'] ?? 0,
    "limit": criteria['limit'] ?? 1,
    "code": criteria['code'] ?? '',
    "reference": criteria['reference'] ?? '',
    "description":
        criteria['description'] ?? '',
    "category": criteria['category'] ?? '',
    "keySearch": criteria['keySearch'] ?? '',
    "username": criteria['username'] ?? '',
    "isHighlight":
        criteria['isHighlight'] ?? false,
    "language": criteria['language'] ?? 'th',
    "organization": dataOrganization,
  });

  var response = await http.post(
    Uri.parse(url),
    body: body,
    headers: {"Accept": "application/json", "Content-Type": "application/json"},
  );

  var data = json.decode(response.body);

  List<dynamic> list = [
    {'code': "", 'title': 'ทั้งหมด'},
  ];
  list = [...list, ...data['objectData']];

  return Future.value(list);
}

Future<dynamic> post(String url, dynamic criteria) async {
  final storage = FlutterSecureStorage();
  var value = await storage.read(key: 'dataUserLoginKSP') ?? "";
  var dataUser = json.decode(value);
  List<dynamic> dataOrganization = [];
  dataOrganization =
      dataUser['countUnit'] != '' ? json.decode(dataUser['countUnit']) : [];

  var body = json.encode({
    "permission": "all",
    "skip": criteria['skip'] ?? 0,
    "limit": criteria['limit'] ?? 1,
    "code": criteria['code'] ?? '',
    "reference": criteria['reference'] ?? '',
    "description":
        criteria['description'] ?? '',
    "category": criteria['category'] ?? '',
    "keySearch": criteria['keySearch'] ?? '',
    "username": criteria['username'] ?? '',
    "firstName": criteria['firstName'] ?? '',
    "lastName": criteria['lastName'] ?? '',
    "title": criteria['title'] ?? '',
    "answer": criteria['answer'] ?? '',
    "isHighlight":
        criteria['isHighlight'] ?? false,
    "createBy": criteria['createBy'] ?? '',
    "isPublic": criteria['isPublic'] ?? false,
    "language": criteria['language'] ?? 'th',
    "organization": dataOrganization,
  });

  var response = await http.post(
    Uri.parse(url),
    body: body,
    headers: {"Accept": "application/json", "Content-Type": "application/json"},
  );

  var data = json.decode(response.body);
  return Future.value(data['objectData']);
}

Future<dynamic> postAny(String url, dynamic criteria) async {
  final storage = FlutterSecureStorage();
  final profileCode = await storage.read(key: 'profileCode9');
  var body = json.encode({
    "permission": "all",
    "skip": criteria['skip'] ?? 0,
    "limit": criteria['limit'] ?? 1,
    "code": criteria['code'] ?? '',
    "category": criteria['category'] ?? '',
    "username": criteria['username'] ?? '',
    "password": criteria['password'] ?? '',
    "createBy": criteria['createBy'] ?? '',
    "profileCode": profileCode,
    "imageUrlCreateBy":
        criteria['imageUrlCreateBy'] ?? '',
    "reference": criteria['reference'] ?? '',
    "description":
        criteria['description'] ?? '',
  });
  var response = await http.post(
    Uri.parse(url),
    body: body,
    headers: {"Accept": "application/json", "Content-Type": "application/json"},
  );

  var data = json.decode(response.body);

  return Future.value(data['status']);
}

Future<dynamic> postAnyObj(String url, dynamic criteria) async {
  var body = json.encode({
    "permission": "all",
    "skip": criteria['skip'] ?? 0,
    "limit": criteria['limit'] ?? 1,
    "code": criteria['code'] ?? '',
    "createBy": criteria['createBy'] ?? '',
    "imageUrlCreateBy":
        criteria['imageUrlCreateBy'] ?? '',
    "reference": criteria['reference'] ?? '',
    "description":
        criteria['description'] ?? '',
  });

  var response = await http.post(
    Uri.parse(url),
    body: body,
    headers: {"Accept": "application/json", "Content-Type": "application/json"},
  );

  var data = json.decode(response.body);

  return Future.value(data);
}

Future<dynamic> postLogin(String url, dynamic criteria) async {
  var body = json.encode({
    "category": criteria['category'] ?? '',
    "password": criteria['password'] ?? '',
    "username": criteria['username'] ?? '',
    "email": criteria['email'] ?? '',
  });

  var response = await http.post(
    Uri.parse(url),
    body: body,
    headers: {"Accept": "application/json", "Content-Type": "application/json"},
  );

  var data = json.decode(response.body);

  return Future.value(data['objectData']);
}

Future<dynamic> postObjectData(String url, dynamic criteria) async {
  var body = json.encode(criteria);

  var response = await http.post(
    Uri.parse(server + url),
    body: body,
    headers: {"Accept": "application/json", "Content-Type": "application/json"},
  );

  // print('-----response.statusCode-----${response.statusCode}');
  if (response.statusCode == 200) {
    // print('-----response.body-----${response.body}');
    var data = json.decode(response.body);
    return {
      "status": data['status'],
      "message": data['message'],
      "objectData": data['objectData'],
    };
    // Future.value(data['objectData']);
  } else {
    return {"status": "F"};
  }
}

Future<dynamic> postObjectData2(String url, dynamic criteria) async {
  var body = json.encode(criteria);

  var response = await http.post(
    Uri.parse(url),
    body: body,
    headers: {"Accept": "application/json", "Content-Type": "application/json"},
  );

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    return {
      "status": data['status'],
      "message": data['message'],
      "objectData": data['objectData'],
    };
    // Future.value(data['objectData']);
  } else {
    return {"status": "F"};
  }
}

Future<dynamic> postConfigShare() async {
  var body = json.encode({});

  var response = await http.post(
    Uri.parse('${server}configulation/shared/read'),
    body: body,
    headers: {"Accept": "application/json", "Content-Type": "application/json"},
  );
  if (response.statusCode == 200) {
    // print('---------- success ----------');
    // print('---------- response ----------' + response?.body.toString());

    var data = json.decode(response.body);

    return {
      // Future.value(data['objectData']);
      "status": data['status'],
      "message": data['message'],
      "objectData": data['objectData'],
    };
  } else {
    return {"status": "F"};
  }
}

//upload with dio
Future<String> uploadImage(XFile file) async {
  Dio dio = Dio();

  String fileName = file.path.split('/').last;
  FormData formData = FormData.fromMap({
    "ImageCaption": "flutter",
    "Image": await MultipartFile.fromFile(file.path, filename: fileName),
  });

  var response = await dio.post(serverUpload, data: formData);

  return response.data['imageUrl'];
}

//upload with http
upload(File file) async {
  var uri = Uri.parse(serverUpload);
  var request =
      http.MultipartRequest('POST', uri)
        ..fields['ImageCaption'] = 'flutter2'
        ..files.add(
          await http.MultipartFile.fromPath(
            'Image',
            file.path,
            contentType: MediaType('application', 'x-tar'),
          ),
        );
  var response = await request.send();
  if (response.statusCode == 200) {
    return response;
  }
}

createStorageApp({dynamic model, String? category}) {
  final storage = FlutterSecureStorage();

  storage.write(key: 'profileCategory', value: category ?? "");

  storage.write(key: 'profileCode9', value: model['code']);

  storage.write(key: 'profileImageUrl', value: model['imageUrl']);

  storage.write(key: 'profileFirstName', value: model['firstName']);

  storage.write(key: 'profileUserName', value: model['userName']);

  storage.write(key: 'profileLastName', value: model['lastName']);

  storage.write(key: 'dataUserLoginKSP', value: jsonEncode(model));
}

logout(BuildContext context) async {
  final storage = FlutterSecureStorage();
  var profileCategory = await storage.read(key: 'profileCategory');
  storage.deleteAll();
  if (profileCategory != '' && profileCategory != null) {
    switch (profileCategory) {
      case 'facebook':
        logoutFacebook();
        break;
      case 'google':
        logoutGoogle();
        break;
      case 'line':
        logoutLine();
        break;
      default:
    }
  }

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => LoginPage()),
    (Route<dynamic> route) => false,
  );

  // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginPage()), (Route<dynamic> route) => false);
}

Future<dynamic> postDio(String url, dynamic criteria) async {
  // print(url);
  // print(criteria);
  final storage = FlutterSecureStorage();
  final profileCode = await storage.read(key: 'profileCode9');

  if (profileCode != '' && profileCode != null) {
    criteria = {'profileCode': profileCode, ...criteria};
  }

  Dio dio = Dio();
  var response = await dio.post(url, data: criteria);
  // print(response.data.toString());
  // print(response.data['objectData'].toString());
  return Future.value(response.data['objectData']);
}

Future<dynamic> postDioMessage(String url, dynamic criteria) async {
  final storage = FlutterSecureStorage();
  final profileCode = await storage.read(key: 'profileCode9');
  if (profileCode != '' && profileCode != null) {
    criteria = {'profileCode': profileCode, ...criteria};
  }
  Dio dio = Dio();
  var response = await dio.post(url, data: criteria);
  return Future.value(response.data['objectData']);
}

Future<dynamic> postLineNoti() async {
  Dio dio = Dio();
  dio.options.contentType = Headers.formUrlEncodedContentType;
  dio.options.headers["Authorization"] =
      "Bearer " + "1RwnPOBFU0sN0LNBNWxkNpSOmpNjjKeVaFzwmg1c5zl";
  var formData = FormData.fromMap({'message': "Ksp ระบบขัดข้อง"});
  var response = await dio.post(serverLineNoti, data: formData);
  return Future.value(response.data['message']);
}

Future<dynamic> postDioCategory(String url, dynamic criteria) async {
  final storage = FlutterSecureStorage();
  // var platform = Platform.operatingSystem.toString();
  final profileCode = await storage.read(key: 'profileCode9');

  if (profileCode != '' && profileCode != null) {
    criteria = {'profileCode': profileCode, ...criteria};
  }

  Dio dio = Dio();
  var response = await dio.post(url, data: criteria);

  List<dynamic> list = [
    {'code': "", 'title': 'ทั้งหมด'},
  ];
  list = [...list, ...response.data['objectData']];

  return Future.value(list);
}

Future<dynamic> postDioCategoryWeMart(String url, dynamic criteria) async {
  // print(url);
  // print(criteria);
  final storage = FlutterSecureStorage();
  // var platform = Platform.operatingSystem.toString();
  final profileCode = await storage.read(key: 'profileCode9');

  if (profileCode != '' && profileCode != null) {
    criteria = {'profileCode': profileCode, ...criteria};
  }

  Dio dio = Dio();
  var response = await dio.post(url, data: criteria);
  var data = response.data['objectData'];

  List<dynamic> list = [
    {'code': "", 'title': 'ทั้งหมด'},
  ];

  list = [...data, ...list];
  return Future.value(list);
}

Future<dynamic> postDioCategoryWeMartNoAll(String url, dynamic criteria) async {
  // print(url);
  // print(criteria);
  final storage = FlutterSecureStorage();
  // var platform = Platform.operatingSystem.toString();
  final profileCode = await storage.read(key: 'profileCode9');

  if (profileCode != '' && profileCode != null) {
    criteria = {'profileCode': profileCode, ...criteria};
  }

  Dio dio = Dio();
  var response = await dio.post(url, data: criteria);
  var data = response.data['objectData'];

  List<dynamic> list = [
    // {'code': "", 'title': 'ทั้งหมด'}
  ];

  list = [...data];
  return Future.value(list);
}

Future<dynamic> postOTPSend(String url, dynamic criteria) async {
  //https://portal-otp.smsmkt.com/api/otp-send
  //https://portal-otp.smsmkt.com/api/otp-validate
  Dio dio = Dio();
  dio.options.contentType = Headers.formUrlEncodedContentType;
  dio.options.headers["api_key"] = "db88c29e14b65c9db353c9385f6e5f28";
  dio.options.headers["secret_key"] = "XpM2EfFk7DKcyJzt";
  var response = await dio.post(serverOTP + url, data: criteria);
  // print('----------- -----------  ${response.data['result']}');
  return Future.value(response.data['result']);
}

Future<void> postTrackClick(String button) async {
  final storage = FlutterSecureStorage();
  final profileCode = await storage.read(key: 'profileCode9');
  var value = await storage.read(key: 'dataUserLoginKSP') ?? "";
  var data = json.decode(value);

  dynamic criteria = {
    'button': button,
    'username': data['username'] != '' ? data['username'] ?? '' : '',
    'firstname': data['firstname'] != '' ? data['firstname'] ?? '' : '',
    'lastname': data['lastname'] != '' ? data['lastname'] ?? '' : '',
    'profileCode':
        data['code'] != '' ? data['code'] ?? profileCode : profileCode,
    'createBy': data['username'] != '' ? data['username'] ?? '' : '',
  };
  // print('-----dio uri-----' + server + "trackClick/create");
  // print('-----dio criteria-----' + criteria.toString());
  Dio dio = Dio();
  dio.post("${server}trackClick/create", data: criteria);
}



const splashReadApi = '${server}m/splash/read';
const newsReadApi = '${server}m/news/read';
const profileReadApi = '${server}m/v2/register/read';
const organizationImageReadApi = '${server}m/v2/organization/image/read';
const notificationApi = '${server}m/v2/notification/';
