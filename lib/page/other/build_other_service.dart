import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ksp/widget/header.dart';
import 'package:ksp/widget/link_url.dart';

class BuildListOtherService extends StatefulWidget {
  BuildListOtherService({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _BuildListOtherService createState() => _BuildListOtherService();
}

class _BuildListOtherService extends State<BuildListOtherService> {
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
              _buildMenu('สถานะการจัดส่งใบอนุญาต',
                  'https://www.ksp.or.th/service/check_rc.php'),
              SizedBox(height: 10),
              _buildMenu('ข้อมูลการชำระเงิน',
                  'https://www.ksp.or.th/service/check_payment.php'),
              SizedBox(height: 10),
              _buildMenu(
                  'ข้อมูลการขอคืนเงิน', 'http://refund.ksp.or.th/search.php'),
            ],
          ),
        ),
      ),
    );
  }

  _buildMenu(String title, String url) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            launchURL(url);
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
                                width: MediaQuery.of(context).size.width * 0.63,
                                padding: EdgeInsets.all(5),
                                // color: Colors.red,
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                    fontFamily: 'Kanit',
                                    color: Color.fromRGBO(0, 0, 0, 0.6),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
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
