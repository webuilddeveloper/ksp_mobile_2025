import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ksp/widget/header.dart';
import 'package:ksp/widget/link_url.dart';

class BuildListEService extends StatefulWidget {
  BuildListEService({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _BuildListEService createState() => _BuildListEService();
}

class _BuildListEService extends State<BuildListEService> {
  bool hideSearch = true;
  final txtDescription = TextEditingController();
  String keySearch = '';
  String category = '';

  final storage = new FlutterSecureStorage();
  // final ScrollController _controller = ScrollController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
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
          child: ListView(
            children: [
              SizedBox(height: 15),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'วีดิโอสอนการใช้งาน',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    // color: Color(0XFF9A1120),
                  ),
                ),
              ),
              SizedBox(height: 10),
              _buildMenu('1. วิธีการสมัคร KSP Self-service',
                  'https://www.youtube.com/watch?v=y4RW8lfnFcU', 'web'),
              SizedBox(height: 10),
              _buildMenu(
                  '2. วิธีการขึ้นทะเบียนใบอนุญาตประกอบวิชาชีพครู KSP Self-service',
                  'https://www.youtube.com/watch?v=-bP8kPBiY7s',
                  'web'),
              SizedBox(height: 10),
              _buildMenu('3. วิธีการขอใบแทนใบอนุญาต KSP Self-service ',
                  'https://www.youtube.com/watch?v=f89QfSjDdLc', 'web'),
              SizedBox(height: 10),
              _buildMenu(
                  '4. วิธีการขอเปลี่ยนแปลงข้อมูลทางทะเบียน KSP Self-service',
                  'https://www.youtube.com/watch?v=xENK3FxTvDU',
                  'web'),
              SizedBox(height: 10),
              _buildMenu('วิธีการขอหนังสือรับรองทางทะเบียน KSP Self-service',
                  'https://www.youtube.com/watch?v=clZ-8BVq5XQ', 'web'),
              SizedBox(height: 15),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'คู่มือการใช้งาน',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    // color: Color(0XFF9A1120),
                  ),
                ),
              ),
              SizedBox(height: 10),
              _buildMenu(
                  '1. ขั้นตอนการขอขึ้นทะเบียนใบอนุญาตประกอบวิชาชีพ',
                  'https://www.ksp.or.th/ksp2018/wp-content/uploads/2021/05/ขั้นตอนการขอขึ้นทะเบียนใบอนุญาตประกอบวิชาชีพ.pdf',
                  'pdf'),
              SizedBox(height: 10),
              _buildMenu(
                  '2. ขั้นตอนการขอต่อใบอนุญาตประกอบวิชาชีพ',
                  'https://www.ksp.or.th/ksp2018/wp-content/uploads/2021/05/ขั้นตอนการขอต่อใบอนุญาตประกอบวิชาชีพ.pdf',
                  'pdf'),
              SizedBox(height: 10),
              _buildMenu(
                  '3. ขั้นตอนการขอใบแทนใบอนุญาต',
                  'https://www.ksp.or.th/ksp2018/wp-content/uploads/2021/05/ขั้นตอนการขอใบแทนใบอนุญาต.pdf',
                  'pdf'),
              SizedBox(height: 10),
              _buildMenu(
                  '4. วิธีการกรอกข้อมูลในระบบ KSP  Self-service',
                  'https://www.ksp.or.th/ksp2018/wp-content/uploads/2021/05/วิธีการกรอกข้อมูลในระบบ-ksp-selfservice.pdf',
                  'pdf'),
              SizedBox(height: 10),
              _buildMenu(
                  '5. การตรวจสอบข้อมูล',
                  'https://www.ksp.or.th/ksp2018/wp-content/uploads/2021/05/การตรวจสอบข้อมูล.pdf',
                  'pdf'),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  _buildMenu(String title, String url, String type) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            type == 'web'
                ? launchInWebViewWithJavaScript(url)
                : launchURL(url);
                // : Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => PdfViewerPage(
                //         path: url,
                //       ),
                //     ),
                //   );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  // color: Color.fromRGBO(0, 0, 2, 1),
                ),
                margin: EdgeInsets.only(bottom: 5.0),
                child: Column(
                  children: [
                    Container(
                      height: 80.0,
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.circular(5.0),
                        color: Color(0xFFFFFFFF),
                      ),
                      padding: EdgeInsets.all(5.0),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.80,
                                padding: EdgeInsets.all(5),
                                // color: Colors.red,
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                    fontFamily: 'Kanit',
                                    color: Color.fromRGBO(0, 0, 0, 0.6),
                                  ),
                                  // maxLines: 2,
                                  // overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            // color: Colors.yellow,
                            child: Icon(
                              Icons.keyboard_arrow_right,
                              color: Color.fromRGBO(0, 0, 0, 0.5),
                              size: 40.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
