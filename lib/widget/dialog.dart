import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ksp/shared/api_provider.dart';
import 'package:ksp/splash.dart';
import 'package:fluttertoast/fluttertoast.dart';

dialog(BuildContext context,
    {required String title,
    required String description,
    bool isYesNo = false,
    String btnOk = 'ตกลง',
    String btnCancel = 'ยกเลิก',
    Function? callBack}) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: new Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Kanit',
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          content: Text(
            description,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Kanit',
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          actions: [
            Container(
              color: Color(0xFFFF7514),
              child: CupertinoDialogAction(
                isDefaultAction: true,
                child: new Text(
                  btnOk,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Kanit',
                    color: Color(0xFFFFFFFF),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                onPressed: () {
                  if (isYesNo) {
                    Navigator.pop(context, false);
                    callBack;
                  } else {
                    Navigator.pop(context, false);
                  }
                },
              ),
            ),
            if (isYesNo)
              Container(
                color: Color(0xFF707070),
                child: CupertinoDialogAction(
                  isDefaultAction: true,
                  child: new Text(
                    btnCancel,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Kanit',
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
              ),
          ],
        );
      });
}

dialogVersion(
  BuildContext context, {
  required String title,
  required String description,
  bool isYesNo = false,
  required Function callBack,
}) {
  return CupertinoAlertDialog(
    title: new Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontFamily: 'Kanit',
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
    ),
    content: Column(
      children: [
        Text(
          description,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Kanit',
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'เวอร์ชั่นปัจจุบัน $versionName',
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'Kanit',
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    ),
    actions: [
      Container(
        color: Color(0xFFFF7514),
        child: CupertinoDialogAction(
          isDefaultAction: true,
          child: new Text(
            "อัพเดท",
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Kanit',
              color: Color(0xFFFFFFFF),
              fontWeight: FontWeight.normal,
            ),
          ),
          onPressed: () {
            if (isYesNo) {
              callBack(true);
              // Navigator.pop(context, false);
            } else {
              callBack(true);
              // Navigator.pop(context, false);
            }
          },
        ),
      ),
      if (isYesNo)
        Container(
          color: Color(0xFF707070),
          child: CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text(
              "ภายหลัง",
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Kanit',
                color: Color(0xFFFFFFFF),
                fontWeight: FontWeight.normal,
              ),
            ),
            onPressed: () {
              callBack(false);
              Navigator.pop(context, false);
            },
          ),
        ),
    ],
  );
}

dialogFail(BuildContext context, {bool reloadApp = false}) {
  return WillPopScope(
    onWillPop: () {
      return Future.value(reloadApp);
    },
    child: Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.white,
      child: CupertinoAlertDialog(
        title: new Text(
          'การเชื่อมต่อมีปัญหากรุณาลองใหม่อีกครั้ง',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Kanit',
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        content: Text(" "),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text(
              "ตกลง",
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Kanit',
                color: Color(0xFFFF7514),
                fontWeight: FontWeight.normal,
              ),
            ),
            onPressed: () {
              reloadApp
                  ? Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => SplashPage()),
                    (Route<dynamic> route) => false,
                  )
                  : Navigator.pop(context, false);
            },
          ),
        ],
      ),
    ),
  );
}

toastFail(
  BuildContext context, {
  String text = 'การเชื่อมต่อผิดพลาด',
  Color color = Colors.grey,
  Color fontColor = Colors.white,
  int duration = 3,
}) {
  return Fluttertoast.showToast(
    msg: text, // ข้อความที่จะแสดง
    toastLength:
        duration == 0
            ? Toast.LENGTH_SHORT
            : Toast.LENGTH_LONG, // ระยะเวลาในการแสดง Toast
    gravity: ToastGravity.BOTTOM, // ตำแหน่งการแสดง Toast
    backgroundColor: color, // สีพื้นหลัง
    textColor: fontColor, // สีของข้อความ
    fontSize: 16.0, // ขนาดตัวอักษร
  );
}
