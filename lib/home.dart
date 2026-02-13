import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badge/flutter_app_badge.dart';
import 'package:ksp/page/about_us/about_us_form.dart';
import 'package:ksp/page/conference/conference_group_year.dart';
import 'package:ksp/page/contact/contact_list_category.dart';
import 'package:ksp/page/enfranchise/enfrancise_main.dart';
import 'package:ksp/page/ethics/ethics_list.dart';
import 'package:ksp/page/event_calendar/event_calendar_main.dart';
import 'package:ksp/page/knowledge/knowledge_list.dart';
import 'package:ksp/page/main_popup/dialog_main_popup.dart';
import 'package:ksp/page/news/news_list.dart';
import 'package:ksp/page/notification/notification_list.dart';
import 'package:ksp/page/other/build_e_service.dart';
import 'package:ksp/page/other/build_other_service.dart';
import 'package:ksp/page/other/other_menu.dart';
import 'package:ksp/page/poi/poi_list.dart';
import 'package:ksp/page/poll/poll_list.dart';
import 'package:ksp/page/privilege/build_privilege.dart';
import 'package:ksp/page/privilege/privilege_main.dart';
import 'package:ksp/page/profile/profile.dart';
import 'package:ksp/page/profile/user_information.dart';
import 'package:ksp/page/reporter/reporter_list_category.dart';
import 'package:ksp/page/teacher/teacher_form.dart';
import 'package:ksp/page/teachers_day/teachers_day_list.dart';
import 'package:ksp/page/video/video_clips.dart';
import 'package:ksp/page/privilege/privilege_special_list.dart';
import 'package:ksp/page/question_and_answer/question_list.dart';
import 'package:ksp/service_all.dart';
import 'package:ksp/policy.dart';
import 'package:ksp/shared/notification_service.dart';
import 'package:ksp/widget/carousel.dart';
import 'package:ksp/widget/dialog.dart';
import 'package:ksp/widget/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ksp/widget/link_url.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ksp/shared/api_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final Completer<GoogleMapController> _mapController = Completer();

  void launchURLMap(String lat, String lng) async {
    String homeLat = lat;
    String homeLng = lng;

    final String googleMapslocationUrl =
        "https://www.google.com/maps/search/?api=1&query=" +
        homeLat +
        ',' +
        homeLng;

    final String encodedURl = Uri.encodeFull(googleMapslocationUrl);

    launchUrl(Uri.parse(encodedURl), mode: LaunchMode.externalApplication);
  }

  final storage = FlutterSecureStorage();
  String profileCode = "";
  late DateTime currentBackPressTime;
  Future<dynamic> _futureProfile = Future.value(null);
  Future<dynamic> _futureMenu = Future.value(null);
  Future<dynamic> _futureRotation = Future.value(null);
  Future<dynamic> _futureAboutUs = Future.value(null);
  Future<dynamic> _futureMainPopUp = Future.value(null);
  Future<dynamic> _futureNoti = Future.value(null);
  Future<dynamic> _futureOtherbenfit = Future.value(null);

  bool hiddenMainPopUp = false;

  bool expanded = false;

  dynamic _isNewsCount = false;
  dynamic _isEventCount = false;
  dynamic _isPollCount = false;
  dynamic _isPrivilegeCount = false;

  dynamic _profile;
  dynamic _aboutUs;

  String isKspCategory = "";

  int add_badger = 0;
  int notiCount = 0;

  double lat = 0.0;
  double lng = 0.0;
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );
  int _selectedIndex = 0;

  late AnimationController animationController;

  @override
  void initState() {
    expanded = false;
    currentBackPressTime = DateTime.now().subtract(Duration(days: 1));
    _read();
    super.initState();
    NotificationService.instance.start(context);
    animationController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton:
          _selectedIndex == 0
              ? InkWell(
                child: Image.asset(
                  'assets/images/icon_floatphone.png',
                  height: 70,
                ),
                onTap: () {
                  launchUrl(Uri.parse('tel://023049899'));
                },
              )
              : null,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(29),
            topRight: Radius.circular(29),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(29),
            topRight: Radius.circular(29),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber[900],
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
              if (index == 0) {
                _read();
              } else if (index == 1) {
                postTrackClick("ปฏิทินกิจกรรม");
              } else if (index == 2) {
                postTrackClick("แจ้งเตือน");
              } else if (index == 3) {
                postTrackClick("โปรโฟล์");
              }
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'หน้าแรก'),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_outlined),
                label: 'ปฏิทินกิจกรรม',
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    Icon(Icons.notifications),
                    if (notiCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                        ),
                      ),
                  ],
                ),
                label: 'แจ้งเตือน',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'โปรไฟล์',
              ),
            ],
          ),
        ),
      ),
      body: PopScope(
        // onWillPop: confirmExit,
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (_selectedIndex != 0) {
            setState(() {
              _selectedIndex = 0;
            });
          } else {
            confirmExit();
          }
        },
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overScroll) {
                return true;
              },
              child: _buildBackground(),
            ),
            EventCalendarMain(title: 'ปฏิทินกิจกรรม'),
            NotificationList(title: 'แจ้งเตือน'),
            UserInformationPage(),
          ],
        ),
      ),
    );
  }

  confirmExit() {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      toastFail(
        context,
        text: 'กดอีกครั้งเพื่อออก',
        color: Colors.black,
        fontColor: Colors.white,
      );
      // return Future.value(false);
    } else {
      SystemNavigator.pop();
      // return Future.value(true);
    }
  }

  _buildBackground() {
    return Container(
      decoration: BoxDecoration(),
      child: _buildNotificationListener(),
    );
  }

  _buildNotificationListener() {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overScroll) {
        // ไม่จำเป็นต้องใช้ disallowGlow() อีกต่อไป
        return true;
      },
      child: Stack(children: [Positioned.fill(child: _buildListBody())]),
    );
  }

  _buildListBody() {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
      header: WaterDropHeader(
        complete: Container(child: Text('')),
        completeDuration: Duration(milliseconds: 0),
      ),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: ListView(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: [
          _buildHeader(),
          SizedBox(height: 16),
          _buildBanner(),
          SizedBox(height: 16),
          _buildServiceSection(),
          SizedBox(height: 16),
          _buildListMenu(),
          SizedBox(height: 20.0),
          BuildPrivilege(
            title: 'สิทธิประโยชน์สำหรับสมาชิก',
            model: _futureOtherbenfit,
            onError: () {},
          ),
          SizedBox(height: 20),
          _buildContact(),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  _buildHeader() {
    return FutureBuilder<dynamic>(
      future: _futureProfile,
      builder: (context, snapshot) {
        var profile = snapshot.data;
        var imageUrl = profile != null ? (profile['imageUrl'] ?? '') : '';
        var prefix = profile != null ? (profile['prefixTh'] ?? '') : '';
        var firstName =
            profile != null
                ? (profile['firstName'] ?? 'ยินดีต้อนรับ')
                : 'ยินดีต้อนรับ';
        var lastName = profile != null ? (profile['lastName'] ?? '') : '';
        var position =
            profile != null
                ? (profile['iskspCategory'] ?? 'สมาชิกคุรุสภา')
                : 'บุคคลทั่วไป';

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFF9800), Color(0xFFE65100)],
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 50,
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      backgroundImage:
                          (imageUrl != null && imageUrl != '')
                              ? NetworkImage(imageUrl)
                              : null,
                      child:
                          (imageUrl == null || imageUrl == '')
                              ? Icon(Icons.person, size: 30, color: Colors.grey)
                              : null,
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$prefix $firstName $lastName",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Kanit',
                            ),
                          ),
                          Text(
                            "$position",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Kanit',
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => TeacherForm(
                                  title: 'ข้อมูลใบอนุญาต',
                                  profileCode: profileCode,
                                ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: const [
                            Icon(Icons.badge_outlined, color: Colors.black87),
                            Text(
                              "ตรวจสอบใบอนุญาต",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Kanit',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 30,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _buildBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CarouselBannerDotStack(
          model: _futureRotation,
          onTap: (
            String path,
            String action,
            dynamic model,
            String code,
            String urlGallery,
          ) async {
            postTrackClick("แบนเนอร์");
            if (action == 'out') {
              if (!await launchUrl(
                Uri.parse(path),
                mode: LaunchMode.externalApplication,
              )) {
                throw 'Could not launch $path';
              }
            } else if (action == 'in') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => CarouselForm(
                        code: code,
                        model: model,
                        url: '${mainRotationApi}read',
                        urlGallery: bannerGalleryApi,
                      ),
                ),
              );
            } else if (action == 'conRef') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConferenceGroupYearPage(),
                ),
              );
            } else if (action.toLowerCase() == 'teachersdayref') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TeachersDayList(title: 'วันครู'),
                ),
              );
            } else if (action.toUpperCase() == 'P') {
              postDio('${server}m/Rotation/innserlog', model);
              _callReadPolicyPrivilegeAtoZ(code);
            }
          },
        ),
      ),
    );
  }

  Widget _buildServiceSection() {
    final List<Map<String, dynamic>> services = [
      {
        'title': 'KSP Service',
        'img': 'http://ksp.we-builds.com/ksp-document/images/menu/menu_service.png',
        'onTap': () {
          postTrackClick("KSP Self-service");
          launchUrl(
            Uri.parse('https://www.ksp.or.th/ksp2018/ksp-selfservice/'),
          );
        },
      },
      {
        'title': 'KSP School',
        'img': 'http://ksp.we-builds.com/ksp-document/images/menu/menu_school.png',
        'onTap': () {
          postTrackClick("KSP School");
          launchUrl(Uri.parse('https://www.ksp.or.th/ksp2018/ksp-school/'));
        },
      },
      {
        'title': 'KSP Bundit',
        'img': 'http://ksp.we-builds.com/ksp-document/images/menu/menu_bandit.png',
        'onTap': () {
          postTrackClick("KSP Bundit");
          launchUrl(Uri.parse('https://www.ksp.or.th/ksp2018/uni-bundit/'));
        },
      },
      {
        'title': 'ค้นหาผู้ได้รับ\nรางวัลคุรุสภา',
        'img': 'http://ksp.we-builds.com/ksp-document/images/menu/menu_reward.png',
        'onTap': () {
          postTrackClick("ค้นหาผู้ได้รับรางวัลคุรุสภา");
          launchUrl(
            Uri.parse('https://www.ksp.or.th/service/check_reward.php'),
          );
        },
      },
      {
        'title': 'สถาบันผลิตครูที่\nคุรุสภารับรอง',
        'img': 'http://ksp.we-builds.com/ksp-document/images/menu/menu_tt.png',
        'onTap': () {
          postTrackClick("สถาบันผลิตครูที่คุรุสภารับรอง");
          launchUrl(Uri.parse('https://www.ksp.or.th/ksp2018/cert-stdksp/'));
        },
      },
      {
        'title': 'สิทธิพิเศษ',
        'img': 'http://ksp.we-builds.com/ksp-document/images/menu/menu_privileges.png',
        'onTap': () {
          postTrackClick("สิทธิพิเศษ");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PrivilegeSpecialList(title: 'สิทธิพิเศษ'),
            ),
          );
        },
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "บริการ",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Kanit',
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ServiceAllPage(
                            profileCode: profileCode,
                            futureAboutUs: _futureAboutUs,
                          ),
                    ),
                  );
                },
                child: Text(
                  "ดูทั้งหมด >",
                  style: TextStyle(color: Colors.grey, fontFamily: 'Kanit'),
                ),
              ),
            ],
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(top: 10),
            itemCount: services.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.85,
            ),
            itemBuilder: (context, index) {
              return _buildServiceCard(
                services[index]['title'],
                services[index]['img'],
                onTap: services[index]['onTap'],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(String title, String imageUrl, {Function? onTap}) {
    return InkWell(
      onTap: () {
        if (onTap != null) onTap();
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              imageUrl,
              fit: BoxFit.fill,
              width: double.infinity,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: 35,
              color: const Color(0xFFF57F20),
              alignment: Alignment.center,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Kanit',
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildListMenu() {
    return FutureBuilder<dynamic>(
      future: _futureMenu,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: ClampingScrollPhysics(),
            children: [
              _buildButtonMenu(snapshot.data[0], 'l'),
              SizedBox(height: 10),
              _buildButtonMenu(snapshot.data[1], 'l'),
              SizedBox(height: 10),
              _buildButtonMenu(snapshot.data[5], 'l'),
              SizedBox(height: 10),
              _buildButtonMenu(snapshot.data[7], 'l'),
              SizedBox(height: 10),
              _buildButtonMenu(snapshot.data[2], 'l'),
              SizedBox(height: 10),
              _buildButtonMenu(snapshot.data[3], 'l'),
              SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(width: 10),
                  _buildButtonMenu(snapshot.data[6], 'm'),
                  SizedBox(width: 15),
                  _buildButtonMenu(snapshot.data[4], 's'),
                  SizedBox(width: 10),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(width: 10),
                  _buildButtonMenu(snapshot.data[10], 's'),
                  SizedBox(width: 15),
                  _buildButtonMenu(snapshot.data[11], 'm'),
                  SizedBox(width: 10),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(width: 10),
                  _buildButtonMenu(snapshot.data[9], 'm'),
                  SizedBox(width: 15),
                  _buildButtonMenu(snapshot.data[8], 's'),
                  SizedBox(width: 10),
                ],
              ),
            ],
          );
        } else {
          return Container(height: 500);
        }
      },
    );
  }

  _buildButtonMenu(dynamic model, String size) {
    double width;
    double rightPos = 0;
    double topPos = 0;
    double imageWidth;

    if (size == 'l') {
      width = MediaQuery.of(context).size.width;
      rightPos = 12;
      topPos = 2;
      imageWidth = width - 24;
    } else if (size == 'm') {
      width = (MediaQuery.of(context).size.width / 100) * 55;
      rightPos = 0;
      topPos = 0;
      imageWidth = width;
    } else {
      width = (MediaQuery.of(context).size.width / 100) * 35;
      rightPos = 0;
      topPos = 0;
      imageWidth = width;
    }

    return Stack(
      children: <Widget>[
        InkWell(
          onTap: () {
            switch (model['code']) {
              case 'NEWS':
                postTrackClick("ข่าวประชาสัมพันธ์");
                storage.write(
                  key: 'isBadgerNews',
                  value: '0', //_newsCount.toString(),
                );
                setState(() {
                  _isNewsCount = false;
                  // _addBadger();
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewsList(title: 'ข่าวประชาสัมพันธ์'),
                  ),
                ).then((value) => _read());
                break;
              case 'KNOWLEDGE':
                postTrackClick("สารคุรุสภา");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => KnowledgeList(title: 'สารคุรุสภา'),
                  ),
                );
                break;
              case 'VIDEO_CLIPS':
                postTrackClick("คลิปคุรุสภา");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoClipsPage(title: 'คลิปคุรุสภา'),
                  ),
                );
                break;
              case 'Q_A':
                postTrackClick("ถาม - ตอบ");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => BuildQuestionList(
                          // isSchool: _futureCheck['isSchool'],
                          menuModel: {'title': 'ถาม - ตอบ'},
                        ),
                  ),
                );
                break;
              case 'OTHERBENFITS':
                postTrackClick("สิทธิประโยชน์");
                storage.write(
                  key: 'isBadgerPrivilege',
                  value: '0', //_isPrivilegeCount.toString(),
                );
                setState(() {
                  _isPrivilegeCount = false;
                  // _addBadger();
                });
                _callReadPolicyPrivilege('สิทธิประโยชน์');
                break;
              case 'PRIVILEGE':
                postTrackClick("สิทธิพิเศษ");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => PrivilegeSpecialList(title: 'สิทธิพิเศษ'),
                  ),
                );
                break;
              case 'CONTACT':
                postTrackClick("เบอร์ติดต่อเร่งด่วน");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            ContactListCategory(title: 'เบอร์ติดต่อเร่งด่วน'),
                  ),
                );
                break;
              case 'ABOUT_US':
                postTrackClick("เกี่ยวกับเรา");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => AboutUsForm(
                          model: _futureAboutUs,
                          title: 'เกี่ยวกับเรา',
                        ),
                  ),
                );
                break;
              case 'EVENT':
                postTrackClick("ปฏิทินกิจกรรม");
                storage.write(
                  key: 'isBadgerEvent',
                  value: '0', //_eventCount.toString(),
                );
                setState(() {
                  _isEventCount = false;
                  // _addBadger();
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => EventCalendarMain(title: 'ปฏิทินกิจกรรม'),
                  ),
                ).then((value) => _read());
                break;
              case 'REPORTER':
                postTrackClick("รับเรื่องร้องเรียน");
                storage.write(key: 'eventCount', value: 1.toString());
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            ReporterListCategory(title: 'รับเรื่องร้องเรียน'),
                  ),
                ).then((value) => _read());
                break;
              case 'RELATE_AGENCY':
                postTrackClick("หน่วยงานที่เกี่ยวข้อง");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            OtherMenuPage(title: 'หน่วยงานที่เกี่ยวข้อง'),
                  ),
                );
                break;
              case 'POI':
                postTrackClick("จุดน่าสนใจ");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PoiList(title: 'จุดน่าสนใจ'),
                  ),
                ).then((value) => _read());
                break;
              case 'POLL':
                postTrackClick("แบบสอบถาม");
                storage.write(
                  key: 'isBadgerPoll',
                  value: '0', //_pollCount.toString(),
                );
                setState(() {
                  _isPollCount = false;
                  // _addBadger();
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PollList(title: 'แบบสอบถาม'),
                  ),
                );
                break;
              case 'ETHICS':
                postTrackClick("จรรยาบรรณวิชาชีพ");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EthicsList(title: 'จรรยาบรรณวิชาชีพ'),
                  ),
                );
                break;
              default:
            }
          },
          child: Container(
            margin: size == 'l' ? EdgeInsets.symmetric(horizontal: 10) : null,
            padding: size == 'l' ? EdgeInsets.all(2) : null,
            width: width,
            height: (MediaQuery.of(context).size.height / 100) * 15,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  spreadRadius: 0,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                  color: Color(0xFFAFA9A9),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.network(model['imageUrl'], fit: BoxFit.fill),
            ),
          ),
        ),
        Positioned(
          top: topPos,
          right: rightPos,
          child: Container(
            width: imageWidth / 1.6,
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
            decoration: BoxDecoration(
              color: Color(0xFFF57F20),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                topRight: Radius.circular(15),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              model['title'] ?? '',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Positioned(
          top: 5,
          right: 10,
          child:
              (model['code'] == "NEWS" && _isNewsCount) ||
                      (model['code'] == "EVENT" && _isEventCount) ||
                      (model['code'] == "POLL" && _isPollCount) ||
                      (model['code'] == "OTHERBENFITS" && _isPrivilegeCount)
                  ? Container(
                    alignment: Alignment.center,
                    width: 30,
                    // height: 90.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.red,
                    ),
                    child: Text(
                      'N',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
                  : Container(),
        ),
      ],
    );
  }

  _buildContact() {
    if (_aboutUs == null) return Container();
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            'ติดต่อเรา',
            style: TextStyle(
              color: Color(0xFF000000),
              fontWeight: FontWeight.w500,
              fontSize: 15,
              fontFamily: 'Kanit',
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: InkWell(
            onTap: () {
              postTrackClick("ติดต่อเรา");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => AboutUsForm(
                        model: _futureAboutUs,
                        title: 'ติดต่อเรา',
                      ),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buttonContact(
                  imageUrl: 'assets/logo/icons/icon_facebook.png',
                  onTap: () {
                    launchUrl(Uri.parse('${_aboutUs['facebook']}'));
                  },
                ),
                _buttonContact(
                  imageUrl: 'assets/logo/icons/icon_youtube.png',
                  onTap: () {
                    launchUrl(Uri.parse('${_aboutUs['youtube']}'));
                  },
                ),
                _buttonContact(
                  imageUrl: 'assets/logo/icons/icon_instragram.png',
                  onTap: () {
                    launchUrl(Uri.parse('${_aboutUs['instagram']}'));
                  },
                ),
                _buttonContact(
                  imageUrl: 'assets/logo/icons/icon_line.png',
                  onTap: () {
                    launchURL('${_aboutUs['lineOfficial']}');
                  },
                ),
                _buttonContact(
                  imageUrl: 'assets/logo/icons/icon_phone.png',
                  onTap: () {
                    launchUrl(Uri.parse('tel://' + '${_aboutUs['telephone']}'));
                  },
                ),
                _buttonContact(
                  imageUrl: 'assets/logo/icons/icon_email.png',
                  onTap: () {
                    launchURL('mailto:' + '${_aboutUs['email']}');
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20.0),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            height: (MediaQuery.of(context).size.height / 100) * 25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 6,
                  offset: Offset(0, 3),
                  color: Color(0xFFAFA9A9),
                ),
              ],
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Container(
                    // padding: EdgeInsets.symmetric(horizontal: 10),
                    height: (MediaQuery.of(context).size.height / 100) * 15,
                    width: double.infinity,
                    child: googleMap(lat, lng),
                  ),
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        'สำนักงานเลขาคุรุสภา',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          fontFamily: 'Kanit',
                        ),
                      ),
                    ),
                    MaterialButton(
                      minWidth: (MediaQuery.of(context).size.width / 100) * 15,
                      onPressed: () {
                        launchURLMap(lat.toString(), lng.toString());
                      },
                      child: Container(
                        height: 35,
                        width: 75,
                        child: Image.asset(
                          'assets/logo/icons/icon_navigate.png',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _read() async {
    //read profile
    _callReadPolicy();
    profileCode = await storage.read(key: 'profileCode9') ?? "";
    if (profileCode != '') {
      setState(() {
        _futureProfile = postDio(profileReadApi, {"code": profileCode});
        // _futureOrganizationImage = postDio(organizationImageReadApi, {
        //   "code": profileCode,
        // });
        // _futureVerify = postDio(organizationImageReadApi, {
        //   "code": profileCode,
        // });
      });
    } else {
      logout(context);
    }

    _futureMenu = postDio('${menuV2Api}readV2', {'limit': 100});
    // _futureBanner = postDio('${mainBannerApi}read', {'limit': 10});
    _futureRotation = postDio('${mainRotationApi}read', {'limit': 10});
    _futureMainPopUp = postDio('${mainPopupHomeApi}read', {'limit': 10});
    _futureAboutUs = postDio('${aboutUsApi}read', {});
    // _futureEventCalendar = postDio('${eventCalendarApi}read', {'limit': 10});
    // _futureContact = postDio('${contactApi}read', {'limit': 10});
    // _futureNews = postDio('${newsApi}read', {'limit': 10});
    // _futureConference = postDio('${conferenceApi}read', {'limit': 10});
    // _futureKnowledge = postDio('${knowledgeApi}read', {'limit': 10});
    // _futureEthics = postDio('${ethicsApi}read', {'limit': 10});
    // _futureVideoClips = postDio('${videoClipsApi}read', {'limit': 10});
    _futureOtherbenfit = postDio('${privilegeApi}read', {
      'skip': 0,
      'limit': 10,
      'category': '',
    });

    _profile = await _futureProfile;

    print('iskspCategory ${_profile['iskspCategory']}');
    debugPrint('location ----> ');

    isKspCategory = _profile['iskspCategory'] ?? '';
    _aboutUs = await _futureAboutUs;
    lat = double.parse(_aboutUs['latitude'] != '' ? _aboutUs['latitude'] : 0.0);
    lng = double.parse(
      _aboutUs['longitude'] != '' ? _aboutUs['longitude'] : 0.0,
    );
    //get api Count
    // _newsCount = await postDio(newsApi + 'count', {});
    // _eventCount = await postDio(eventCalendarApi + 'count', {});
    // _pollCount = await postDio(pollApi + 'count', {});
    // //get storage
    // int storageNewsCount =
    //     int.parse(await storage.read(key: 'newsCount') ?? '0');
    // int storageEventCount =
    //     int.parse(await storage.read(key: 'eventCount') ?? '0');
    // int storagePollCount =
    //     int.parse(await storage.read(key: 'pollCount') ?? '0');

    // _isNewsCount = _newsCount > storageNewsCount ? true : false;
    // _isEventCount = _eventCount > storageEventCount ? true : false;
    // _isPollCount = _pollCount > storagePollCount ? true : false;

    // _addBadger();
    _readNoti();

    _buildMainPopUp();
    _callReadPolicy();
  }

  _readNoti() async {
    var _profile = await _futureProfile;
    if (_profile != null) {
      dynamic _username = _profile["username"];
      dynamic _category = _profile["category"];
      _futureNoti = postDio(notificationApi + 'count', {
        "username": _username,
        "category": _category,
      });
      var _norti = await _futureNoti;
      setState(() {
        notiCount = _norti['total'];
        _isNewsCount = (_norti['newsPage'] ?? 0) > 0 ? true : false;
        _isPrivilegeCount = (_norti['privilegePage'] ?? 0) > 0 ? true : false;
        _isEventCount = (_norti['eventPage'] ?? 0) > 0 ? true : false;
        _isPollCount = (_norti['pollPage'] ?? 0) > 0 ? true : false;
      });
      FlutterAppBadge.count(notiCount);
    } else {
      FlutterAppBadge.count(0);
    }
  }

  _buildMainPopUp() async {
    var result = await post('${mainPopupHomeApi}read', {'limit': 100});

    if (result.length > 0) {
      var valueStorage = await storage.read(key: 'mainPopupDDPM');
      var dataValue;
      if (valueStorage != null) {
        dataValue = json.decode(valueStorage);
      } else {
        dataValue = null;
      }

      var now = DateTime.now();
      DateTime date = DateTime(now.year, now.month, now.day);

      if (dataValue != null) {
        var index = dataValue.indexWhere(
          (c) =>
              // c['username'] == userData.username &&
              c['date'].toString() ==
                  DateFormat("ddMMyyyy").format(date).toString() &&
              c['boolean'] == "true",
        );

        if (index == -1) {
          setState(() {
            hiddenMainPopUp = false;
          });
          return showDialog(
            barrierDismissible: false, // close outside
            context: context,
            builder: (_) {
              return WillPopScope(
                onWillPop: () {
                  return Future.value(false);
                },
                child: MainPopupDialog(
                  model: _futureMainPopUp,
                  type: 'mainPopup',
                  url: '${mainPopupHomeApi}read',
                  urlGallery: '',
                  username: '',
                ),
              );
            },
          );
        } else {
          setState(() {
            hiddenMainPopUp = true;
          });
        }
      } else {
        setState(() {
          hiddenMainPopUp = false;
        });
        return showDialog(
          barrierDismissible: false, // close outside
          context: context,
          builder: (_) {
            return WillPopScope(
              onWillPop: () {
                return Future.value(false);
              },
              child: MainPopupDialog(
                model: _futureMainPopUp,
                type: 'mainPopup',
                url: '${mainPopupHomeApi}read',
                urlGallery: '',
                username: '',
              ),
            );
          },
        );
      }
    }
  }

  Future<Null> _callReadPolicy() async {
    var policy = await postDio(server + "m/policy/read", {
      "category": "application",
      "skip": 0,
      "limit": 10,
    });

    // print(policy);

    if (policy.length > 0) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder:
              (context) => PolicyPage(
                category: 'application',
                navTo: () {
                  // Navigator.pop(context);
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => HomePage()),
                    (Route<dynamic> route) => false,
                  );
                },
              ),
        ),
        (Route<dynamic> route) => false,
      );
    }
    // else
    //   _buildMainPopUp();
  }

  Future<Null> _callReadPolicyPrivilege(String title) async {
    var policy = await postDio(server + "m/policy/read", {
      "category": "marketing",
      "skip": 0,
      "limit": 10,
    });

    if (policy.length > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          // ignore: missing_required_param
          // builder: (context) => PolicyIdentityVerificationPage(),
          builder:
              (context) => PolicyPage(
                category: 'marketing',
                navTo: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrivilegeMain(title: title),
                    ),
                  );
                },
              ),
        ),
      );

      // if (!isPolicyFasle) {
      //   logout(context);
      //   _onRefresh();
      // }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PrivilegeMain(title: title)),
      );
    }
  }

  void _onRefresh() async {
    _read();

    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
    // _refreshController.loadComplete();
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  googleMap(double lat, double lng) {
    return GoogleMap(
      myLocationEnabled: true,
      compassEnabled: true,
      tiltGesturesEnabled: false,
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(target: LatLng(lat, lng), zoom: 16),
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
        Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
      },
      onMapCreated: (GoogleMapController controller) {
        _mapController.complete(controller);
      },
      markers: <Marker>{
        Marker(
          markerId: MarkerId('1'),
          position: LatLng(lat, lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      },
    );
  }

  Future<Null> _callReadPolicyPrivilegeAtoZ(code) async {
    var policy = await postDio(server + "m/policy/readAtoZ", {
      "reference": "AtoZ",
    });
    if (policy.length <= 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          // ignore: missing_required_param
          // builder: (context) => PolicyIdentityVerificationPage(),
          builder:
              (context) => PolicyPage(
                category: 'AtoZ',
                navTo: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EnfranchiseMain(reference: code),
                    ),
                  );
                },
              ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EnfranchiseMain(reference: code),
        ),
      );
    }
  }
}

_buttonContact({String imageUrl = '', required Function onTap}) {
  return InkWell(
    onTap: () {
      onTap();
    },
    child: Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            spreadRadius: 0,
            blurRadius: 7,
            offset: Offset(0, 3),
            color: Color(0xFFAFA9A9).withOpacity(0.5),
          ),
        ],
      ),
      child: Image.asset(imageUrl),
    ),
  );
}
