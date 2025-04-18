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

  late AnimationController animationController;

  @override
  void initState() {
    expanded = false;
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
      floatingActionButton: InkWell(
        child: Image.asset('assets/images/icon_floatphone.png', height: 70),
        onTap: () {
          launchUrl(Uri.parse('tel://023049899'));
        },
      ),
      body: PopScope(
        // onWillPop: confirmExit,
        canPop: false,
        onPopInvokedWithResult: (didPop, result) => confirmExit(),
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overScroll) {
            return true;
          },
          child: _buildBackground(),
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
          SizedBox(height: 10),
          _buildRotation(),
          SizedBox(height: 20),
          _buildListMenu(),
          SizedBox(height: 20.0),
          BuildPrivilege(
            title: 'สิทธิประโยชน์สำหรับสมาชิก',
            model: _futureOtherbenfit,
            onError: () {},
          ),
          SizedBox(height: 20),
          _buildContact(),
          SizedBox(height: 100.0 + MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  _buildHeader() {
    return Container(
      height: 520,
      decoration: BoxDecoration(
        image: DecorationImage(
          image:
              isKspCategory != ""
                  ? AssetImage("assets/background/new_bgactive.png")
                  : AssetImage("assets/background/new_bgnoactive.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          headerV2(
            context,
            isCenter: false,
            notiCount: notiCount,
            callBackClickButtonCalendar: () => _read(),
          ),
          SizedBox(height: 15),
          _buildProfile(),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              InkWell(
                onTap: () {
                  postTrackClick("สถาบันผลิตครูที่คุรุสภารับรอง");
                  launchUrl(
                    Uri.parse('https://www.ksp.or.th/ksp2018/cert-stdksp/'),
                  );
                },
                child: Container(
                  // padding: EdgeInsets.symmetric(horizontal: 5),
                  width: (MediaQuery.of(context).size.width / 100) * 50,
                  height: (MediaQuery.of(context).size.height / 100) * 12,
                  child: ClipRRect(
                    child: Image.asset(
                      "assets/top_menu1.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  postTrackClick("สถาบันผลิตครูที่คุรุสภารับรอง");
                  launchUrl(
                    Uri.parse('https://www.ksp.or.th/ksp2018/cert-stdksp/'),
                  );
                },
                child: Container(
                  // padding: EdgeInsets.symmetric(horizontal: 5),
                  width: (MediaQuery.of(context).size.width / 100) * 50,
                  height: (MediaQuery.of(context).size.height / 100) * 12,
                  child: ClipRRect(
                    child: Image.asset(
                      "assets/top_menu2.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          _buildListBottomMenu(),
        ],
      ),
    );
  }

  _buildListBottomMenu() {
    return Container(
      height: 180,
      width: double.infinity,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          SizedBox(width: 10),
          InkWell(
            onTap: () {
              postTrackClick("KSP Self-service");
              // launchInWebViewWithJavaScript
              launchUrl(
                Uri.parse('https://www.ksp.or.th/ksp2018/ksp-selfservice/'),
              );
            },
            child: Container(
              height: 180,
              width: (MediaQuery.of(context).size.width / 100) * 45,
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bot_menu1.png"),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Image.asset(
                      'assets/images/bot_icon1.png',
                      width: 60,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'KSP Service',
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 15),
          Column(
            children: [
              _buildBottomMenu(
                title: 'ขั้้นตอนการใช้งาน',
                title2: 'E - Service',
                bgimage: 'assets/images/bot_menu2.png',
                image: 'assets/images/bot_icon2.png',
                onTap: () {
                  postTrackClick("ขั้นตอนการใช้งาน E-Service");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => BuildListEService(
                            title: 'ขั้นตอนการใช้งาน E-Service',
                          ),
                    ),
                  );
                },
              ),
              SizedBox(height: 10),
              _buildBottomMenu(
                title: 'KSP School',
                title2: '',
                bgimage: 'assets/images/bot_menu3.png',
                image: 'assets/images/bot_icon3.png',
                onTap: () {
                  postTrackClick("KSP School");
                  launchUrl(
                    Uri.parse('https://www.ksp.or.th/ksp2018/ksp-school/'),
                  );
                },
              ),
            ],
          ),
          SizedBox(width: 5),
          Column(
            children: [
              _buildBottomMenu(
                title: 'KSP Bundit',
                title2: '',
                bgimage: 'assets/images/bot_menu4.png',
                image: 'assets/images/bot_icon4.png',
                onTap: () {
                  postTrackClick("KSP Bundit");
                  launchUrl(
                    Uri.parse('https://www.ksp.or.th/ksp2018/uni-bundit/'),
                  );
                },
              ),
              SizedBox(height: 10),
              _buildBottomMenu(
                title: 'ตรวจสอบข้อมูล',
                title2: 'ใบอนุญาต',
                bgimage: 'assets/images/bot_menu5.png',
                image: 'assets/images/bot_icon5.png',
                onTap: () {
                  postTrackClick("ข้อมูลใบอนุญาต");
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
              ),
            ],
          ),
          SizedBox(width: 5),
          Column(
            children: [
              _buildBottomMenu(
                title: 'ค้นหาผู้ได้รับ',
                title2: 'รางวัลคุรุสภา',
                bgimage: 'assets/images/bot_menu6.png',
                image: 'assets/images/bot_icon6.png',
                onTap: () {
                  postTrackClick("ค้นหาผู้ได้รับรางวัลคุรุสภา");
                  launchUrl(
                    Uri.parse('https://www.ksp.or.th/service/check_reward.php'),
                  );
                },
              ),
              SizedBox(height: 10),
              _buildBottomMenu(
                title: 'สถาบันผลิตครูที่',
                title2: 'คุรุสภารับรอง',
                bgimage: 'assets/images/bot_menu7.png',
                image: 'assets/images/bot_icon7.png',
                onTap: () {
                  postTrackClick("สถาบันผลิตครูที่คุรุสภารับรอง");
                  launchUrl(
                    Uri.parse('https://www.ksp.or.th/ksp2018/cert-stdksp/'),
                  );
                },
              ),
            ],
          ),
          SizedBox(width: 5),
          Column(
            children: [
              _buildBottomMenu(
                title: 'บริการอื่นๆ',
                title2: '',
                bgimage: 'assets/images/bot_menu8.png',
                image: 'assets/images/bot_icon8.png',
                onTap: () {
                  postTrackClick("บริการอื่นๆ");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              BuildListOtherService(title: 'บริการอื่นๆ'),
                    ),
                  );
                },
              ),
              SizedBox(height: 10),
            ],
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }

  _buildBottomMenu({
    String title = '',
    String title2 = '',
    String image = '',
    String bgimage = '',
    required Function onTap,
  }) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 85,
        width: (MediaQuery.of(context).size.width / 100) * 45,
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(bgimage), fit: BoxFit.fill),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Image.asset(image, width: 55),
            ),
            title2 != ''
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        title2,
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )
                : Container(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                ),
          ],
        ),
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
          child:
              size == 'l'
                  ? Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    padding: EdgeInsets.all(2),
                    width: (MediaQuery.of(context).size.width),
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
                      borderRadius: BorderRadius.circular(5.0),
                      child: Image.network(model['imageUrl'], fit: BoxFit.fill),
                    ),
                  )
                  : size == 'm'
                  ? Container(
                    // margin: EdgeInsets.symmetric(horizontal: 10),
                    width: (MediaQuery.of(context).size.width / 100) * 55,
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
                      borderRadius: BorderRadius.circular(5.0),
                      child: Image.network(model['imageUrl'], fit: BoxFit.fill),
                    ),
                  )
                  : Container(
                    // margin: EdgeInsets.symmetric(horizontal: 10),
                    width: (MediaQuery.of(context).size.width / 100) * 35,
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
                      borderRadius: BorderRadius.circular(5.0),
                      child: Image.network(model['imageUrl'], fit: BoxFit.fill),
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

  _buildProfile() {
    return Profile(
      model: _futureProfile,
      nav: () {
        postTrackClick("โปรโฟล์");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => UserInformationPage(
                  // userData: userData,
                ),
          ),
        ).then((value) => _read());
      },
    );
  }

  _buildRotation() {
    return CarouselBannerDotStack(
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
            MaterialPageRoute(builder: (context) => ConferenceGroupYearPage()),
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
