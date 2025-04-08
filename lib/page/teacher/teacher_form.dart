import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ksp/shared/api_provider.dart';
import 'package:ksp/widget/header.dart';

// ignore: must_be_immutable
class TeacherForm extends StatefulWidget {
  TeacherForm({Key? key, this.profileCode, required this.title})
    : super(key: key);
  final dynamic profileCode;
  final String title;
  @override
  _TeacherForm createState() => _TeacherForm();
}

class _TeacherForm extends State<TeacherForm> {
  Future<dynamic> _futureModel = Future.value(null);

  late String code;
  double fontSizedetiel = 15;

  @override
  void initState() {
    super.initState();
    _futureModel = postDio('${server}m/employee/read', {
      'code': widget.profileCode,
    });
  }

  void goBack() async {
    Navigator.pop(context, true);
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
        backgroundColor: Colors.white,
        appBar: header(context, goBack, title: widget.title),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overScroll) {
            return false;
          },
          child: FutureBuilder<dynamic>(
            future: _futureModel,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                return myContent(snapshot.data);
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  myContent(dynamic model) {
    final license = listLicense(model);
    final teach = listTeach(model);
    final allow = listAllow(model);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: (MediaQuery.of(context).size.height / 100) * 20,
            width: double.maxFinite,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: ExactAssetImage("assets/images/back_employee.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: ClipRRect(
              // make sure we apply clip it properly
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.grey.withOpacity(0.1),
                  child: Text(
                    "ข้อมูลใบอนุญาต",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.all(
                  (MediaQuery.of(context).size.width / 100) * 2,
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  "สถานะการขึ้นทะเบียนใบอนุญาตประกอบวิชาชีพ",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      left: (MediaQuery.of(context).size.width / 100) * 2,
                    ),
                    width: (MediaQuery.of(context).size.width / 100) * 45,
                    child: new Text(
                      'รหัสประจำตัวประชาชน :',
                      style: TextStyle(
                        fontSize: fontSizedetiel,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF707070),
                      ),
                    ),
                  ),
                  Text(
                    model['title'] == '' || model['title'] == '@'
                        ? 'ไม่พบข้อมูล'
                        : model['kurusapa_n'],
                    style: TextStyle(
                      fontSize: fontSizedetiel,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF000000),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      left: (MediaQuery.of(context).size.width / 100) * 2,
                    ),
                    width: (MediaQuery.of(context).size.width / 100) * 45,
                    child: new Text(
                      'คำนำหน้า :',
                      style: TextStyle(
                        fontSize: fontSizedetiel,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF707070),
                      ),
                    ),
                  ),
                  Text(
                    model['title'] == '' ? 'ไม่พบข้อมูล' : '${model['title']}',
                    style: TextStyle(
                      fontSize: fontSizedetiel,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF000000),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      left: (MediaQuery.of(context).size.width / 100) * 2,
                    ),
                    width: (MediaQuery.of(context).size.width / 100) * 45,
                    child: new Text(
                      'ชื่อ :',
                      style: TextStyle(
                        fontSize: fontSizedetiel,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF707070),
                      ),
                    ),
                  ),
                  Text(
                    model['fitstname'] == ''
                        ? 'ไม่พบข้อมูล'
                        : '${model['fitstname']}',
                    style: TextStyle(
                      fontSize: fontSizedetiel,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF000000),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      left: (MediaQuery.of(context).size.width / 100) * 2,
                    ),
                    width: (MediaQuery.of(context).size.width / 100) * 45,
                    child: new Text(
                      'นามสกุล :',
                      style: TextStyle(
                        fontSize: fontSizedetiel,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF707070),
                      ),
                    ),
                  ),
                  Text(
                    model['lastname'] == ''
                        ? 'ไม่พบข้อมูล'
                        : '${model['lastname']}',
                    style: TextStyle(
                      fontSize: fontSizedetiel,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF000000),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(
                  (MediaQuery.of(context).size.width / 100) * 2,
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  "ข้อมูลใบอนุญาตทั้งหมด",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Column(children: license.toList()),
              Container(
                padding: EdgeInsets.all(
                  (MediaQuery.of(context).size.width / 100) * 2,
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  "ข้อมูลใบปฏิบัติการสอนทั้งหมด",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Column(children: teach.toList()),
              Container(
                padding: EdgeInsets.all(
                  (MediaQuery.of(context).size.width / 100) * 2,
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  "ข้อมูลหนังสืออนุญาตให้ประกอบวิชาชีพทางการศึกษาโดยไม่มีใบอนุญาต ประกอบวิชาชีพทั้งหมด",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Column(children: allow.toList()),
            ],
          ),
        ],
      ),
    );
  }

  listLicense(dynamic model) {
    final license = [];
    if (model['license'].length > 0) {
      for (var i = 0; i < model['license'].length; i++) {
        license.add(
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: (MediaQuery.of(context).size.width / 100) * 5,
                ),
                width: (MediaQuery.of(context).size.width / 100) * 45,
                child: new Text(
                  'เลขที่อนุญาต :',
                  style: TextStyle(
                    fontSize: fontSizedetiel,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF707070),
                  ),
                ),
              ),
              Text(
                '${model['license'][i]['id']}',
                style: TextStyle(
                  fontSize: fontSizedetiel,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w500,
                  color: i == 0 ? Color(0xFFFF7514) : Color(0xFF000000),
                ),
              ),
              //  Container(
              //   alignment: Alignment.center,
              //   padding: i == 0 ?  EdgeInsets.only(top: 2, bottom: 2, right: 5, left: 5) : EdgeInsets.all(0),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(40),
              //     color: i == 0 ? Color(0xFFFF7514) : Colors.transparent,
              //   ),
              //   child: Text(
              //     '${model['license'][i]['id']}',
              //     style: TextStyle(
              //       fontSize: fontSizedetiel,
              //       fontFamily: 'Kanit',
              //       fontWeight: FontWeight.w500,
              //       color: Color(0xFF000000),
              //     ),
              //   ),
              // ),
            ],
          ),
        );
        license.add(
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: (MediaQuery.of(context).size.width / 100) * 5,
                ),
                width: (MediaQuery.of(context).size.width / 100) * 45,
                child: new Text(
                  'วันที่อนุญาติ :',
                  style: TextStyle(
                    fontSize: fontSizedetiel,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF707070),
                  ),
                ),
              ),
              Text(
                '${model['license'][i]['valid']}',
                style: TextStyle(
                  fontSize: fontSizedetiel,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w500,
                  color: i == 0 ? Color(0xFFFF7514) : Color(0xFF000000),
                  // color: Color(0xFF000000),
                ),
              ),
            ],
          ),
        );
        license.add(
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: (MediaQuery.of(context).size.width / 100) * 5,
                ),
                width: (MediaQuery.of(context).size.width / 100) * 45,
                child: new Text(
                  'วันหมดอายุ :',
                  style: TextStyle(
                    fontSize: fontSizedetiel,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF707070),
                  ),
                ),
              ),
              Text(
                '${model['license'][i]['expire']}',
                style: TextStyle(
                  fontSize: fontSizedetiel,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w500,
                  // color: Color(0xFF000000),
                  color: i == 0 ? Color(0xFFFF7514) : Color(0xFF000000),
                ),
              ),
            ],
          ),
        );
        license.add(
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: (MediaQuery.of(context).size.width / 100) * 5,
                ),
                width: (MediaQuery.of(context).size.width / 100) * 45,
                child: new Text(
                  'รหัสประเภทวิชาชีพ :',
                  style: TextStyle(
                    fontSize: fontSizedetiel,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF707070),
                  ),
                ),
              ),
              Text(
                '${model['license'][i]['edutype_id']}',
                style: TextStyle(
                  fontSize: fontSizedetiel,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w500,
                  // color: Color(0xFF000000),
                  color: i == 0 ? Color(0xFFFF7514) : Color(0xFF000000),
                ),
              ),
            ],
          ),
        );
        license.add(
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: (MediaQuery.of(context).size.width / 100) * 5,
                ),
                width: (MediaQuery.of(context).size.width / 100) * 45,
                child: new Text(
                  'ประเภทวิชาชีพ :',
                  style: TextStyle(
                    fontSize: fontSizedetiel,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF707070),
                  ),
                ),
              ),
              Text(
                '${model['license'][i]['edutype']}',
                style: TextStyle(
                  fontSize: fontSizedetiel,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w500,
                  // color: Color(0xFF000000),
                  color: i == 0 ? Color(0xFFFF7514) : Color(0xFF000000),
                ),
              ),
            ],
          ),
        );
        license.add(
          Container(
            alignment: Alignment.center,
            width: (MediaQuery.of(context).size.width / 100) * 80,
            padding: EdgeInsets.only(top: 15),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFE2E2E2), width: 2.0),
              ),
            ),
          ),
        );
        license.add(SizedBox(height: 15));
      }
    } else {
      license.add(
        Container(
          padding: EdgeInsets.only(bottom: 15),
          alignment: Alignment.center,
          child: Text(
            "ไม่พบข้อมูล",
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }
    return license;
  }

  listTeach(dynamic model) {
    final teach = [];
    if (model['teach'].length > 0) {
      for (var i = 0; i < model['license'].length; i++) {
        teach.add(
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: (MediaQuery.of(context).size.width / 100) * 5,
                ),
                width: (MediaQuery.of(context).size.width / 100) * 45,
                child: new Text(
                  'เลขที่อนุญาต :',
                  style: TextStyle(
                    fontSize: fontSizedetiel,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF707070),
                  ),
                ),
              ),
              Text(
                '${model['license'][i]['id']}',
                style: TextStyle(
                  fontSize: fontSizedetiel,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF000000),
                ),
              ),
            ],
          ),
        );
        teach.add(
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: (MediaQuery.of(context).size.width / 100) * 5,
                ),
                width: (MediaQuery.of(context).size.width / 100) * 45,
                child: new Text(
                  'วันที่อนุญาติ :',
                  style: TextStyle(
                    fontSize: fontSizedetiel,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF707070),
                  ),
                ),
              ),
              Text(
                '${model['license'][i]['valid']}',
                style: TextStyle(
                  fontSize: fontSizedetiel,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF000000),
                ),
              ),
            ],
          ),
        );
        teach.add(
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: (MediaQuery.of(context).size.width / 100) * 5,
                ),
                width: (MediaQuery.of(context).size.width / 100) * 45,
                child: new Text(
                  'วันหมดอายุ :',
                  style: TextStyle(
                    fontSize: fontSizedetiel,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF707070),
                  ),
                ),
              ),
              Text(
                '${model['license'][i]['expire']}',
                style: TextStyle(
                  fontSize: fontSizedetiel,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF000000),
                ),
              ),
            ],
          ),
        );
        teach.add(
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: (MediaQuery.of(context).size.width / 100) * 5,
                ),
                width: (MediaQuery.of(context).size.width / 100) * 45,
                child: new Text(
                  'รหัสประเภทวิชาชีพ :',
                  style: TextStyle(
                    fontSize: fontSizedetiel,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF707070),
                  ),
                ),
              ),
              Text(
                '${model['license'][i]['edutype_id']}',
                style: TextStyle(
                  fontSize: fontSizedetiel,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF000000),
                ),
              ),
            ],
          ),
        );
        teach.add(
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: (MediaQuery.of(context).size.width / 100) * 5,
                ),
                width: (MediaQuery.of(context).size.width / 100) * 45,
                child: new Text(
                  'ประเภทวิชาชีพ :',
                  style: TextStyle(
                    fontSize: fontSizedetiel,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF707070),
                  ),
                ),
              ),
              Text(
                '${model['license'][i]['edutype']}',
                style: TextStyle(
                  fontSize: fontSizedetiel,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF000000),
                ),
              ),
            ],
          ),
        );
        teach.add(
          Container(
            alignment: Alignment.center,
            width: (MediaQuery.of(context).size.width / 100) * 80,
            padding: EdgeInsets.only(top: 15),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFE2E2E2), width: 2.0),
              ),
            ),
          ),
        );
        teach.add(SizedBox(height: 15));
      }
    } else {
      teach.add(
        Container(
          padding: EdgeInsets.only(bottom: 15),
          alignment: Alignment.center,
          child: Text(
            "ไม่พบข้อมูล",
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }
    return teach;
  }

  listAllow(dynamic model) {
    final allow = [];
    if (model['allow'].length > 0) {
      for (var i = 0; i < model['license'].length; i++) {
        allow.add(
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: (MediaQuery.of(context).size.width / 100) * 5,
                ),
                width: (MediaQuery.of(context).size.width / 100) * 45,
                child: new Text(
                  'เลขที่อนุญาต :',
                  style: TextStyle(
                    fontSize: fontSizedetiel,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF707070),
                  ),
                ),
              ),
              Text(
                '${model['license'][i]['id']}',
                style: TextStyle(
                  fontSize: fontSizedetiel,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF000000),
                ),
              ),
            ],
          ),
        );
        allow.add(
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: (MediaQuery.of(context).size.width / 100) * 5,
                ),
                width: (MediaQuery.of(context).size.width / 100) * 45,
                child: new Text(
                  'วันที่อนุญาติ :',
                  style: TextStyle(
                    fontSize: fontSizedetiel,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF707070),
                  ),
                ),
              ),
              Text(
                '${model['license'][i]['valid']}',
                style: TextStyle(
                  fontSize: fontSizedetiel,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF000000),
                ),
              ),
            ],
          ),
        );
        allow.add(
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: (MediaQuery.of(context).size.width / 100) * 5,
                ),
                width: (MediaQuery.of(context).size.width / 100) * 45,
                child: new Text(
                  'วันหมดอายุ :',
                  style: TextStyle(
                    fontSize: fontSizedetiel,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF707070),
                  ),
                ),
              ),
              Text(
                '${model['license'][i]['expire']}',
                style: TextStyle(
                  fontSize: fontSizedetiel,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF000000),
                ),
              ),
            ],
          ),
        );
        allow.add(
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: (MediaQuery.of(context).size.width / 100) * 5,
                ),
                width: (MediaQuery.of(context).size.width / 100) * 45,
                child: new Text(
                  'รหัสประเภทวิชาชีพ :',
                  style: TextStyle(
                    fontSize: fontSizedetiel,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF707070),
                  ),
                ),
              ),
              Text(
                '${model['license'][i]['edutype_id']}',
                style: TextStyle(
                  fontSize: fontSizedetiel,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF000000),
                ),
              ),
            ],
          ),
        );
        allow.add(
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: (MediaQuery.of(context).size.width / 100) * 5,
                ),
                width: (MediaQuery.of(context).size.width / 100) * 45,
                child: new Text(
                  'ประเภทวิชาชีพ :',
                  style: TextStyle(
                    fontSize: fontSizedetiel,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF707070),
                  ),
                ),
              ),
              Text(
                '${model['license'][i]['edutype']}',
                style: TextStyle(
                  fontSize: fontSizedetiel,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF000000),
                ),
              ),
            ],
          ),
        );
        allow.add(
          Container(
            alignment: Alignment.center,
            width: (MediaQuery.of(context).size.width / 100) * 80,
            padding: EdgeInsets.only(top: 15),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFE2E2E2), width: 2.0),
              ),
            ),
          ),
        );
        allow.add(SizedBox(height: 15));
      }
    } else {
      allow.add(
        Container(
          padding: EdgeInsets.only(bottom: 15),
          alignment: Alignment.center,
          child: Text(
            "ไม่พบข้อมูล",
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }
    return allow;
  }
}
