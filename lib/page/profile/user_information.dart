import 'package:ksp/page/profile/change_password.dart';
import 'package:ksp/page/profile/edit_user_information.dart';
import 'package:ksp/page/profile/identity_verification.dart';
import 'package:ksp/page/profile/organization.dart';
import 'package:ksp/page/profile/policy.dart';
import 'package:ksp/page/profile/setting_notification.dart';
import 'package:ksp/shared/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ksp/widget/header.dart';
import 'package:ksp/widget/link_url.dart';

class UserInformationPage extends StatefulWidget {
  @override
  _UserInformationPageState createState() => _UserInformationPageState();
}

class _UserInformationPageState extends State<UserInformationPage> {
  final storage = FlutterSecureStorage();
  Future<dynamic> _futureProfile = Future.value(null);
  Future<dynamic> _futureLine = Future.value(null);
  late DateTime currentBackPressTime;
  String profileCategory = '';

  @override
  void initState() {
    _futureLine = postDio('${server}configulation/read', {
      'title': 'lineContact',
    });
    _read();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Note: Sensitivity is integer used when you don't want to mess up vertical drag
        if (details.delta.dx > 10) {
          // Right Swipe
          Navigator.pop(context);
        } else if (details.delta.dx < -0) {
          //Left Swipe
        }
      },
      child: Scaffold(
        appBar: header(context, _goBack, title: 'โปรไฟล์'),
        backgroundColor: Color(0XFFFACBA4),
        body: FutureBuilder<dynamic>(
          future: _futureProfile,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //   return Center(child: Text('Please wait its loading...'));
            // } else {
            // }
            if (snapshot.hasData) {
              return _buildScreen(snapshot.data);
            } else if (snapshot.hasError) {
              return _buildScreen({'imageUrl': ''});
            } else {
              return _buildScreen({'imageUrl': ''});
            }
          },
        ),
      ),
    );
  }

  _buildScreen(dynamic model) {
    return Container(
      height: double.infinity,
      color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
      child: ListView(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: <Widget>[
          Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(
                          'assets/background/backgroundUserInfo.png',
                        ),
                      ),
                    ),
                    height: 150.0,
                  ),
                  Container(
                    height: 150.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(
                          'assets/background/backgroundUserInfoColor.png',
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(
                        model['imageUrl'] != null && model['imageUrl'] != ''
                            ? 0.0
                            : 5.0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(45),
                        color: Colors.white70,
                      ),
                      height: 90,
                      width: 90,
                      margin: EdgeInsets.only(top: 30.0),
                      child:
                          model['imageUrl'] != null && model['imageUrl'] != ''
                              ? CircleAvatar(
                                backgroundColor: Colors.black,
                                backgroundImage:
                                    model['imageUrl'] != null &&
                                            model['imageUrl'] != ''
                                        ? NetworkImage(model['imageUrl'])
                                        : null,
                              )
                              : Container(
                                padding: EdgeInsets.all(10.0),
                                child: Image.asset(
                                  'assets/images/user_not_found.png',
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
              Container(color: Colors.white, child: _buildContentCard()),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.only(top: 10.0),
                color: Colors.white,
                child: ButtonTheme(
                  child: TextButton(
                    onPressed: () async {
                      postTrackClick("ออกจากระบบ");
                      logout(context);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(10.0),
                      foregroundColor: Color(0xFFFC4137), // กำหนดสีของ text และ icon
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.power_settings_new, color: Colors.red),
                        Text(
                          " ออกจากระบบ",
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Color(0xFFFC4137),
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Kanit',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(right: 5),
                child: Text(
                  versionName,
                  style: TextStyle(
                    // fontSize: 9.0,
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Kanit',
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _read() async {
    //read profile
    profileCategory = await storage.read(key: 'profileCategory') ?? "";
    var profileCode = await storage.read(key: 'profileCode9');
    if (profileCode != '' && profileCode != null) {
      setState(() {
        _futureProfile = postDio(profileReadApi, {"code": profileCode});
      });
    }
  }

  _goBack() async {
    Navigator.pop(context);
  }

  _buildContentCard() {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      padding: const EdgeInsets.all(10.0),
      // padding: EdgeInsets.only(top: 65.0),
      children: <Widget>[
        _buildButton(
          title: 'บัญชีผู้ใช้งาน',
          image: 'assets/logo/icons/Group105.png',
          onPressed:
              () => {
                postTrackClick("โปรไฟล์/บัญชีผู้ใช้งาน"),
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditUserInformationPage(),
                  ),
                ),
              },
        ),
        _buildButton(
          title: 'ตั้งค่าการแจ้งเตือน',
          image: 'assets/logo/icons/Group103.png',
          onPressed:
              () => {
                postTrackClick("โปรไฟล์/ตั้งค่าการแจ้งเตือน"),
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingNotificationPage(),
                  ),
                ),
              },
        ),
        // _buildButton(
        //   title: 'เปลี่ยนภาษา',
        //   image: 'assets/logo/icons/noun_Globe.png',
        //   onPressed: () => Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => ConnectSSOPage(goHome: false),
        //     ),
        //   ),
        // ),
        // _buildButton(
        //   title: 'การเชื่อมต่อ',
        //   image: 'assets/logo/icons/Group109.png',
        //   onPressed: () => Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => ConnectSocialPage(),
        //     ),
        //   ),
        // ),
        if (profileCategory == '' || profileCategory == 'guest')
          _buildButton(
            title: 'เปลี่ยนรหัสผ่าน',
            image: 'assets/logo/icons/Group221.png',
            onPressed:
                () => {
                  postTrackClick("โปรไฟล์/เปลี่ยนรหัสผ่าน"),
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangePasswordPage(),
                    ),
                  ),
                },
          ),
        ButtonTheme(child: _getdata()),
        _buildButton(
          title: 'หน่วยงานที่รับข้อมูล',
          image: 'assets/icon_user_information_organization.png',
          onPressed:
              () => {
                postTrackClick("โปรไฟล์/หน่วยงานที่รับข้อมูล"),
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrganizationPage()),
                ),
              },
        ),
        _buildButton(
          title: 'นโยบาย',
          image: 'assets/logo/icons/2985813.png',
          onPressed:
              () => {
                postTrackClick("โปรไฟล์/นโยบาย"),
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePolicyPage()),
                ),
              },
        ),
        FutureBuilder<dynamic>(
          future: _futureLine,
          builder: (BuildContext context, AsyncSnapshot<dynamic> dataLine) {
            if (dataLine.hasData) {
              return _buildButton(
                title: 'ติดต่อเรา',
                image: 'assets/logo/icons/2985813.png',
                onPressed: () => launchURL('${dataLine.data['description']}'),
              );
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }

  _buildButton({required String image, required String title, required Function onPressed}) {
    return TextButton(
      child: Container(
        padding: EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFE2E2E2), width: 1.0),
          ),
        ),
        alignment: Alignment.bottomLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(7.0),
              child: Image.asset(
                image,
                height: 5.0,
                width: 5.0,
                color: Colors.white,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17.5),
                color: Color(0xFFF5561F),
              ),
              width: 30.0,
              height: 30.0,
            ),
            Expanded(
              child: Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Color(0xFFF5561F),
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Kanit',
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomLeft,
              child: Image.asset(
                "assets/logo/icons/right.png",
                height: 20.0,
                width: 20.0,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
      onPressed: () => onPressed(),
    );
  }

  _getdata() {
    return FutureBuilder<dynamic>(
      future: _futureProfile,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return _buildButton(
            title:
                snapshot.data['idcard'] != ""
                    ? "ข้อมูลสมาชิก"
                    : "ลงทะเบียนข้อมูลสมาชิก",
            image: 'assets/logo/icons/2985813.png',
            onPressed:
                () => {
                  postTrackClick(
                    "โปรไฟล์/${snapshot.data['idcard'] != "" ? "ข้อมูลสมาชิก" : "ลงทะเบียนข้อมูลสมาชิก"}",
                  ),
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => IdentityVerificationPage(
                            title:
                                snapshot.data['idcard'] != ""
                                    ? "ข้อมูลสมาชิก"
                                    : "ลงทะเบียนข้อมูลสมาชิก",
                          ),
                    ),
                  ),
                },
          );
        } else if (snapshot.hasError) {
          return Container();
        } else {
          return Center(child: Container());
        }
      },
    );
  }
}
