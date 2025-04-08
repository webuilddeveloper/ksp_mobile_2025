import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ksp/shared/api_provider.dart';
import 'package:ksp/widget/dialog.dart';
import 'package:ksp/widget/header.dart';

class SettingNotificationPage extends StatefulWidget {
  @override
  _SettingNotificationPageState createState() =>
      _SettingNotificationPageState();
}

class _SettingNotificationPageState extends State<SettingNotificationPage> {
  final storage = FlutterSecureStorage();

  late String _username;

  Future<dynamic> futureModel = Future.value(null);

  ScrollController scrollController = ScrollController();

  bool isSwitchedEventPage = false;
  bool isSwitchedContactPage = false;
  bool isSwitchedKnowledgePage = false;
  bool isSwitchedMainPage = false;
  bool isSwitchedNewsPage = false;
  bool isSwitchedPoiPage = false;
  bool isSwitchedPollPage = false;
  bool isSwitchedPrivilegePage = false;
  bool isSwitchedReporterPage = false;
  bool isSwitchedWelfarePage = false;
  bool isSwitchedCooperativeFormPage = false;
  bool isSwitchedWarningPage = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    futureModel = readNotification();
    super.initState();
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
      child: FutureBuilder<dynamic>(
        future: futureModel,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Container(
                color: Colors.white,
                child: dialogFail(context),
              ),
            );
          } else {
            return Scaffold(
              appBar: header(context, goBack, title: 'ตั้งค่าการแจ้งเตือน'),
              backgroundColor: Colors.white,
              body: Container(
                child: ListView(
                  controller: scrollController,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  // padding: EdgeInsets.only(top: 10),
                  children: <Widget>[
                    Column(
                      // alignment: Alignment.topCenter,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topCenter,
                          margin: EdgeInsets.symmetric(
                            horizontal: 5.0,
                            // vertical: 10.0,
                          ),
                          child: contentCard(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<dynamic> readNotification() async {
    var value = await storage.read(key: 'dataUserLoginKSP') ??"";
    var user = json.decode(value);
    if (user['code'] != '') {
      setState(() {
        _username = user['username'] ?? '';
      });
    }
    final result = await postObjectData('m/register/notification/read', {
      'username': _username,
    });

    if (result['status'] == 'S') {
      await storage.write(
        key: 'dataNotificationDDPM',
        value: jsonEncode(result['objectData']),
      );

      setState(() {
        isSwitchedEventPage = result['objectData']['eventPage'];
        isSwitchedContactPage = result['objectData']['contactPage'];
        isSwitchedKnowledgePage = result['objectData']['knowledgePage'];
        isSwitchedMainPage = result['objectData']['mainPage'];
        isSwitchedNewsPage = result['objectData']['newsPage'];
        isSwitchedPoiPage = result['objectData']['poiPage'];
        isSwitchedPollPage = result['objectData']['pollPage'];
        isSwitchedPrivilegePage = result['objectData']['privilegePage'];
        isSwitchedReporterPage = result['objectData']['reporterPage'];
        isSwitchedWelfarePage = result['objectData']['welfarePage'];
        isSwitchedCooperativeFormPage =
            result['objectData']['cooperativeFormPage'];
        // isSwitchedWarningPage = result['objectData']['warningPage'];
      });
    }
  }

  Future<dynamic> updateNotication() async {
    var value = await storage.read(key: 'dataNotificationDDPM') ??"";
    var data = json.decode(value);
    data['eventPage'] = isSwitchedEventPage;
    data['contactPage'] = isSwitchedContactPage;
    data['knowledgePage'] = isSwitchedKnowledgePage;
    data['mainPage'] = isSwitchedMainPage;
    data['newsPage'] = isSwitchedNewsPage;
    data['poiPage'] = isSwitchedPoiPage;
    data['pollPage'] = isSwitchedPollPage;
    data['privilegePage'] = isSwitchedPrivilegePage;
    data['reporterPage'] = isSwitchedReporterPage;
    data['welfarePage'] = isSwitchedWelfarePage;
    data['cooperativeFormPage'] = isSwitchedCooperativeFormPage;
    data['warningPage'] = isSwitchedWarningPage;

    final result = await postObjectData('m/Register/notification/update', data);

    if (result['status'] == 'S') {
      await storage.write(
        key: 'dataNotificationDDPM',
        value: jsonEncode(result['objectData']),
      );

      setState(() {
        isSwitchedEventPage = result['objectData']['eventPage:'] ?? '';
        isSwitchedContactPage = result['objectData']['contactPage:'] ?? '';
        isSwitchedKnowledgePage = result['objectData']['knowledgePage:'] ?? '';
        isSwitchedMainPage = result['objectData']['mainPage'] ?? '';
        isSwitchedNewsPage = result['objectData']['newsPage'] ?? '';
        isSwitchedPoiPage = result['objectData']['poiPage'] ?? '';
        isSwitchedPollPage = result['objectData']['pollPage'] ?? '';
        isSwitchedPrivilegePage = result['objectData']['privilegePage'] ?? '';
        isSwitchedReporterPage = result['objectData']['reporterPage'] ?? '';
        isSwitchedWelfarePage = result['objectData']['welfarePage'] ?? '';
        isSwitchedCooperativeFormPage =
            result['objectData']['cooperativeFormPage'] ?? '';
      });
    }
  }

  void goBack() async {
    // Navigator.of(context).pushAndRemoveUntil(
    //   MaterialPageRoute(
    //     builder: (context) => UserInformationPage(),
    //   ),
    //   (Route<dynamic> route) => false,
    // );
    Navigator.pop(context, false);
    // // Navigator.of(context).push(
    // //   MaterialPageRoute(
    // //     builder: (context) => UserInformationPage(),
    // //   ),
    // // );
  }

  card() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Padding(padding: EdgeInsets.all(10), child: contentCard()),
    );
  }

  contentCard() {
    return Column(
      // shrinkWrap: true,
      // physics: ClampingScrollPhysics(),
      children: [
        Padding(
          padding: EdgeInsets.all(5),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: _buildText('ระบบแจ้งเตือน'),
              ),
              Expanded(
                child: Switch(
                  value: isSwitchedMainPage,
                  onChanged: (value) {
                    setState(() {
                      isSwitchedMainPage = value;
                      isSwitchedNewsPage = value;
                      isSwitchedEventPage = value;
                      isSwitchedKnowledgePage = value;
                      isSwitchedPrivilegePage = value;
                      isSwitchedPoiPage = value;
                    });
                    updateNotication();
                  },
                  activeTrackColor: Color(0xFFFEE9E8),
                  activeColor: Theme.of(context).colorScheme.secondary,
                ),
              )
            ],
          ),
        ),
        _buildLine(),
        Padding(
          padding: EdgeInsets.all(5),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: _buildText('ข่าวประชาสัมพันธ์'),
              ),
              Expanded(
                child: Switch(
                  value: isSwitchedNewsPage,
                  onChanged: (value) {
                    setState(() {
                      isSwitchedNewsPage = value;
                    });
                    updateNotication();
                  },
                  activeTrackColor: Color(0xFFFEE9E8),
                  activeColor: Theme.of(context).colorScheme.secondary,
                ),
              )
            ],
          ),
        ),
        _buildLine(),
        Padding(
          padding: EdgeInsets.all(5),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: _buildText('ปฏิทินกิจกรรม'),
              ),
              Expanded(
                child: Switch(
                  value: isSwitchedEventPage,
                  onChanged: (value) {
                    setState(() {
                      isSwitchedEventPage = value;
                    });
                    updateNotication();
                  },
                  activeTrackColor: Color(0xFFFEE9E8),
                  activeColor: Theme.of(context).colorScheme.secondary,
                ),
              )
            ],
          ),
        ),
        _buildLine(),
        // Padding(
        //   padding: EdgeInsets.all(5),
        //   child: Row(
        //     children: [
        //       Expanded(
        //         flex: 5,
        //         child: _buildText('เบอร์ติดต่อเร่งด่วน'),
        //       ),
        //       Expanded(
        //         child: Switch(
        //           value: isSwitchedContactPage,
        //           onChanged: (value) {
        //             print(value);
        //             setState(() {
        //               isSwitchedContactPage = value;
        //             });
        //             updateNotication();
        //           },
        //           activeTrackColor: Color(0xFFFEE9E8),
        //           activeColor: Theme.of(context).colorScheme.secondary,
        //         ),
        //       )
        //     ],
        //   ),
        // ),
        // _buildLine(),
        Padding(
          padding: EdgeInsets.all(5),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: _buildText('สารคุรุสภา'),
              ),
              Expanded(
                child: Switch(
                  value: isSwitchedKnowledgePage,
                  onChanged: (value) {
                    setState(() {
                      isSwitchedKnowledgePage = value;
                    });
                    updateNotication();
                  },
                  activeTrackColor: Color(0xFFFEE9E8),
                  activeColor: Theme.of(context).colorScheme.secondary,
                ),
              )
            ],
          ),
        ),
        _buildLine(),
        Padding(
          padding: EdgeInsets.all(5),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: _buildText('สิทธิประโยชน์'),
              ),
              Expanded(
                child: Switch(
                  value: isSwitchedPrivilegePage,
                  onChanged: (value) {
                    setState(() {
                      isSwitchedPrivilegePage = value;
                    });
                    updateNotication();
                  },
                  activeTrackColor: Color(0xFFFEE9E8),
                  activeColor: Theme.of(context).colorScheme.secondary,
                ),
              )
            ],
          ),
        ),
        _buildLine(),
        Padding(
          padding: EdgeInsets.all(5),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: _buildText('จุดน่าสนใจ'),
              ),
              Expanded(
                child: Switch(
                  value: isSwitchedPoiPage,
                  onChanged: (value) {
                    setState(() {
                      isSwitchedPoiPage = value;
                    });
                    updateNotication();
                  },
                  activeTrackColor: Color(0xFFFEE9E8),
                  activeColor: Theme.of(context).colorScheme.secondary,
                ),
              )
            ],
          ),
        ),
        _buildLine(),
      ],
    );
  }

  _buildText(param) {
    return Text(
      param,
      style: TextStyle(
        fontSize: 13.0,
        //color: Theme.of(context).accentColor,
        fontWeight: FontWeight.normal,
        fontFamily: 'Kanit',
      ),
    );
  }

  _buildLine() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE2E2E2),
            width: 1.0,
          ),
        ),
      ),
    );
  }

  rowContentButton(String urlImage, String title) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          Container(
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Image.asset(
                urlImage,
                height: 5.0,
                width: 5.0,
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              //color: Theme.of(context).accentColor,
            ),
            width: 30.0,
            height: 40.0,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.733,
            margin: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13.0,
                //color: Theme.of(context).accentColor,
                fontWeight: FontWeight.normal,
                fontFamily: 'Kanit',
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: Image.asset(
              "assets/logo/icons/Group6232.png",
              height: 20.0,
              width: 20.0,
            ),
          ),
        ],
      ),
    );
  }
}
