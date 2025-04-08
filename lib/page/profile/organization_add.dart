import 'dart:async';
import 'package:ksp/widget/dialog.dart';
import 'package:flutter/material.dart';
import 'package:ksp/shared/api_provider.dart';
import 'package:ksp/widget/header.dart';

class OrganizationAddPage extends StatefulWidget {
  @override
  _OrganizationAddPageState createState() => _OrganizationAddPageState();
}

class _OrganizationAddPageState extends State<OrganizationAddPage> {
  Future<dynamic> futureLv0 = Future.value(null);
  Future<dynamic> futureLv1 = Future.value(null);
  Future<dynamic> futureLv2 = Future.value(null);
  Future<dynamic> futureLv3 = Future.value(null);
  Future<dynamic> futureLv4 = Future.value(null);

  String lv0 = '';
  String lv1 = '';
  String lv2 = '';
  String lv3 = '';
  String lv4 = '';

  @override
  void initState() {
    _callRead();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildScaffold();
  }

  _callRead() {
    futureLv0 = postDio('${server}organization/category/read', {
      'category': 'lv0',
    });
  }

  _buildScaffold() {
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
        appBar: header(context, goBack, title: 'หน่วยงานที่รับข้อมูล'),
        body: _buildListView(),
      ),
    );
  }

  _buildListView() {
    return ListView(
      // shrinkWrap: true, // use it
      children: [
        SizedBox(height: 20),
        _buildLv0(),
        SizedBox(height: 12),
        SizedBox(height: 12),
        Container(
          margin: EdgeInsets.only(top: 50, bottom: 50),
          padding: EdgeInsets.only(left: 50, right: 50),
          child: ElevatedButton(
            child: Text('บันทึกข้อมูล'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFF7514), // สีพื้นหลังของปุ่ม
              foregroundColor: Colors.white, // สีของข้อความในปุ่ม
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: BorderSide(color: Color(0xFFFF7514)), // สีขอบ
              ),
            ),
            onPressed: () {
              _callSave();
            },
          ),
        ),
      ],
    );
  }

  _buildLv0() {
    return FutureBuilder<dynamic>(
      future: futureLv0,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true, // use it
            physics: ClampingScrollPhysics(),
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    lv1 = '';
                    lv2 = '';
                    lv3 = '';
                    lv4 = '';
                    lv0 =
                        lv0 == snapshot.data[index]['code']
                            ? ""
                            : snapshot.data[index]['code'];

                    futureLv1 = Future.value([]);
                    futureLv2 = Future.value([]);
                    futureLv3 = Future.value([]);
                    futureLv4 = Future.value([]);

                    if (lv0 != '') {
                      futureLv1 = postDio(
                        '${server}organization/category/read',
                        {'category': 'lv1', 'lv0': lv0},
                      );
                    }
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(left: 50, right: 50, bottom: 5),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color:
                        lv0 == snapshot.data[index]['code']
                            ? Color(0xFFFF7514)
                            : Colors.white,
                    border: Border.all(color: Color(0xFFFF7514)),
                  ),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${snapshot.data[index]['title']}',
                            style: TextStyle(
                              color:
                                  lv0 == snapshot.data[index]['code']
                                      ? Colors.white
                                      : Colors.black,
                            ),
                          ),
                        ),
                        if (lv0 == snapshot.data[index]['code'])
                          Icon(Icons.check, color: Color(0xFFFFFFFF)),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Container(
              color: Colors.white,
              child: dialogFail(context, reloadApp: true),
            ),
          );
        } else {
          return Center(child: Text('Loading....'));
        }
      },
    );
  }

  _callSave() async {
    if (lv0 == '') {
      dialog(
        context,
        title: 'ไม่สามารถบันทึกข้อมูลได้',
        description: 'กรุณาเลือกหน่วยงาน \nอย่างน้อย 1 รายการ',
      );
    } else {
      await postDio('${server}m/v2/register/organization/create', {
        'lv0': lv0,
        'lv1': lv1,
        'lv2': lv2,
        'lv3': lv3,
        'lv4': lv4,
      });

      Navigator.pop(context, true);
    }
  }

  void goBack() async {
    Navigator.pop(context, false);
  }
}
