import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ksp/shared/api_provider.dart';
import 'package:ksp/widget/header.dart';
import 'package:ksp/widget/text_field.dart';
import 'package:url_launcher/url_launcher.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  final String username;
  final String password;
  final String facebookID;
  final String appleID;
  final String googleID;
  final String lineID;
  final String email;
  final String imageUrl;
  final String category;
  final String prefixName;
  final String firstName;
  final String lastName;
  final bool isShowStep1 = true;
  final bool isShowStep2 = false;

  RegisterPage({
    Key? key,
    required this.username,
    required this.password,
    required this.facebookID,
    required this.appleID,
    required this.googleID,
    required this.lineID,
    required this.email,
    required this.imageUrl,
    required this.category,
    required this.prefixName,
    required this.firstName,
    required this.lastName,
  }) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final storage = new FlutterSecureStorage();

  bool _isShowStep1 = true;
  bool _isShowStep2 = false;
  bool _checkedValue = false;
  List<dynamic> _dataPolicy = [];

  final _formKey = GlobalKey<FormState>();

  final txtUsername = TextEditingController();
  final txtPassword = TextEditingController();
  final txtConPassword = TextEditingController();
  final txtFirstName = TextEditingController();
  final txtLastName = TextEditingController();
  final txtPhone = TextEditingController();
  final txtEmail = TextEditingController();
  final txtPrefixName = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TextEditingController txtDate = TextEditingController();

  Future<dynamic> _futureModel = Future.value(null);

  ScrollController scrollController = new ScrollController();

  int year = 0;
  int month = 0;
  int day = 0;

  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  FocusNode f3 = FocusNode();
  FocusNode f4 = FocusNode();

  final k1 = new GlobalKey();
  final k2 = new GlobalKey();
  final k3 = new GlobalKey();
  final k4 = new GlobalKey();

  @override
  void initState() {
    _callRead();

    var now = new DateTime.now();
    setState(() {
      year = now.year;
      month = now.month;
      day = now.day;
    });

    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtUsername.dispose();
    txtPassword.dispose();
    txtConPassword.dispose();
    txtFirstName.dispose();
    txtLastName.dispose();
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
        appBar: header(context, goBack, title: 'สมัครสมาชิก'),
        // backgroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        body: FutureBuilder<dynamic>(
          future: _futureModel,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return ListView(
                controller: scrollController,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                padding: const EdgeInsets.all(15.0),
                children: [
                  // myWizard(),
                  // card(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.asset(
                          "assets/logo_login.png",
                          fit: BoxFit.contain,
                          height: 80.0,
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                  SizedBox(height: 20),

                  Card(
                    color: Color(0xFF023047),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: formContentStep2(),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Container();
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  _callRead() {
    _futureModel = postDio('${server}m/policy/read', {
      'username': widget.username,
      'category': 'register',
    });
  }

  Future<Null> checkValueStep1() async {
    if (_checkedValue) {
      setState(() {
        _isShowStep1 = false;
        _isShowStep2 = true;
        scrollController.jumpTo(scrollController.position.minScrollExtent);
      });
    } else {
      return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: new Text(
              'กรุณาติ้ก ยอมรับข้อตกลงเงื่อนไข',
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
                    color: Color(0xFF1B6CA8),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<dynamic> submitRegister() async {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!(regex.hasMatch(txtEmail.text))) {
      return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: CupertinoAlertDialog(
              title: new Text(
                'รูปแบบอีเมลไม่ถูกต้อง',
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
                      color: Color(0xFF1B6CA8),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    final result = await postDio('m/Register/create', {
      'username': txtUsername.text,
      'password': txtPassword.text,
      'facebookID': "",
      'appleID': "",
      'googleID': "",
      'lineID': "",
      'email': txtEmail.text,
      'imageUrl': "",
      'category': "guest",
      'prefixName': txtPrefixName.text,
      'firstName': txtFirstName.text,
      'lastName': txtLastName.text,
      'phone': txtPhone.text,
      'birthDay': "",
      // 'birthDay': DateFormat("yyyyMMdd").format(
      //   DateTime(
      //     _selectedYear,
      //     _selectedMonth,
      //     _selectedDay,
      //   ),
      // ),
      'status': "N",
      'platform': Platform.operatingSystem.toString(),
      'countUnit': "[]",
    });

    if (result["status"] == 'S') {
      return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: CupertinoAlertDialog(
              title: new Text(
                'ลงทะเบียนเรียบร้อยแล้ว',
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
                      color: Color(0xFF1B6CA8),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onPressed: () {
                    goBack();
                    // Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
    } else {
      return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: CupertinoAlertDialog(
              title: new Text(
                result["message"],
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
                      color: Color(0xFF1B6CA8),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }

  myWizard() {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: [
        Container(
          padding: EdgeInsets.only(
            top: 0.0,
            left: 30.0,
            right: 30.0,
            bottom: 0.0,
          ),
          child: Column(
            children: <Widget>[
              new Row(
                children: [
                  new Column(
                    children: <Widget>[
                      new Container(
                        width: 50.0,
                        height: 50.0,
                        padding: EdgeInsets.all(5),
                        alignment: Alignment.center,
                        child: Text(
                          '1',
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                            fontSize: 20.0,
                            color: _isShowStep1 ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Kanit',
                          ),
                        ),
                        decoration: new BoxDecoration(
                          color:
                              _isShowStep1
                                  ? Color(0xFFFFC324)
                                  : Color(0xFFFFFFFF),
                          borderRadius: new BorderRadius.all(
                            new Radius.circular(25.0),
                          ),
                          border: new Border.all(
                            color: Color(0xFFFFC324),
                            width: 2.0,
                          ),
                        ),
                      ),
                      Text(
                        'ข้อตกลง',
                        style: new TextStyle(
                          fontSize: 10.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w100,
                          fontFamily: 'Kanit',
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        height: 2.0,
                        color: Color(0xFFFFC324),
                      ),
                    ),
                  ),
                  new Column(
                    children: <Widget>[
                      new Container(
                        width: 50.0,
                        height: 50.0,
                        padding: EdgeInsets.all(5),
                        alignment: Alignment.center,
                        child: Text(
                          '2',
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                            fontSize: 20.0,
                            color: _isShowStep2 ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Kanit',
                          ),
                        ),
                        decoration: new BoxDecoration(
                          color:
                              _isShowStep2
                                  ? Color(0xFFFFC324)
                                  : Color(0xFFFFFFFF),
                          borderRadius: new BorderRadius.all(
                            new Radius.circular(25.0),
                          ),
                          border: new Border.all(
                            color: Color(0xFFFFC324),
                            width: 2.0,
                          ),
                        ),
                      ),
                      Text(
                        'ข้อมูลส่วนตัว',
                        style: new TextStyle(
                          fontSize: 10.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w100,
                          fontFamily: 'Kanit',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  card() {
    return Card(
      color: Colors.white,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(15.0),
      // ),
      // elevation: 5,
      child: Padding(padding: EdgeInsets.all(0), child: formContentStep2()),
      // child: _isShowStep1 ? formContentStep1() : formContentStep2()),
    );
  }

  formContentStep1() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (var item in _dataPolicy)
          Html(
            data: item['description'].toString(),
            onLinkTap:
                (url, attributes, element) => launchUrl(Uri.parse(url ?? "")),
            // onLinkTap: (String? url, RenderContext context,
            //     Map<String, String> attributes,Element element) {
            //   launch(url);
            //   //open URL in webview, or launch URL in browser, or any other logic here
            // },
          ),
        new Container(
          alignment: Alignment.center,
          child: CheckboxListTile(
            activeColor: Color(0xFF1B6CA8),
            title: Text(
              "ฉันยอมรับข้อตกลงในการบริการ",
              style: new TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.normal,
                fontFamily: 'Kanit',
              ),
            ),
            value: _checkedValue,
            onChanged: (newValue) {
              setState(() {
                _checkedValue = newValue ?? false;
              });
            },
            controlAffinity:
                ListTileControlAffinity.leading, //  <-- leading Checkbox
          ),
        ),
        Container(
          alignment: Alignment.topRight,
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFFC324), // สีพื้นหลัง
              foregroundColor: Colors.white, // สีข้อความ
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: Color(0xFFFFC324)), // ขอบของปุ่ม
              ),
            ),
            onPressed: () {
              checkValueStep1();
            },
            child: Text(
              "ถัดไป >",
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontFamily: 'Kanit',
              ),
            ),
          ),
        ),
      ],
    );
  }

  formContentStep2() {
    return (Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'สมัครสมาชิก',
            style: TextStyle(
              fontSize: 18.00,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w500,
              color: Color(0xFFFFFFFF),
            ),
          ),

          labelRegisterRequired('* ', 'ชื่อผู้ใช้งาน', k1),
          textFormFieldRequired(
            txtUsername,
            null,
            'ชื่อผู้ใช้งาน',
            'ชื่อผู้ใช้งาน',
            true,
            false,
            false,
            f1,
          ),
          // labelTextFormField('* รหัสผ่าน'),
          labelRegisterPasswordOldNew('* ', 'รหัสผ่าน', true, k2),
          textFormField(
            txtPassword,
            null,
            'รหัสผ่าน',
            'รหัสผ่าน',
            true,
            true,
            false,
            f2,
          ),
          labelRegisterRequired('* ', 'ยืนยันรหัสผ่าน', k3),
          TextFormField(
            focusNode: f3,
            obscureText: true,
            style: TextStyle(
              color: Color(0xFFF58A33),
              // fontWeight: FontWeight.normal,
              fontFamily: 'Kanit',
              // fontSize: 15.00,
            ),
            decoration: InputDecoration(
              hintText: 'ยืนยันรหัสผ่าน',
              filled: true,
              fillColor: Color(0xFFFFFFFF),
              contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
              errorStyle: TextStyle(
                fontWeight: FontWeight.normal,
                fontFamily: 'Kanit',
                fontSize: 10.0,
              ),
            ),
            validator: (model) {
              model = model ?? "";
              if (model.isEmpty) {
                return 'กรุณากรอกข้อมูล. $model';
              }

              if (model != txtPassword.text) {
                return 'กรุณากรอกรหัสผ่านให้ตรงกัน.';
              }
              return null;
            },
            controller: txtConPassword,
            enabled: true,
          ),

          SizedBox(height: 15.0),
          Text(
            'ข้อมูลส่วนตัว',
            style: TextStyle(
              fontSize: 18.00,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w500,
              color: Color(0xFFFFFFFF),
            ),
          ),
          SizedBox(height: 5.0),
          labelRegisterRequired('* ', 'อีเมล', k4),
          textFormField(
            txtEmail,
            null,
            'อีเมล',
            'อีเมล',
            true,
            false,
            true,
            f4,
          ),

          labelRegister('ชื่อ'),
          textFormField(
            txtFirstName,
            null,
            'ชื่อ',
            'ชื่อ',
            true,
            false,
            false,
            FocusNode(),
          ),
          labelRegister('นามสกุล'),
          textFormField(
            txtLastName,
            null,
            'นามสกุล',
            'นามสกุล',
            true,
            false,
            false,
            FocusNode(),
          ),

          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              margin: EdgeInsets.only(top: 15.0, bottom: 10.0),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(5.0),
                color: Color(0xFFF58A33),
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width,
                  height: 40,
                  onPressed: () {
                    final form = _formKey.currentState;
                    if (form != null && form.validate()) {
                      form.save();
                      submitRegister();
                    } else {
                      f1.unfocus();
                      f2.unfocus();
                      f3.unfocus();
                      f4.unfocus();

                      if (txtUsername.text == '') {
                        RenderObject? renderObject =
                            k1.currentContext?.findRenderObject();
                        if (renderObject != null)
                          scrollController.position.ensureVisible(renderObject);
                        FocusScope.of(context).requestFocus(f1);
                      } else if (txtPassword.text.length < 6) {
                        RenderObject? renderObject =
                            k2.currentContext?.findRenderObject();
                        if (renderObject != null)
                          scrollController.position.ensureVisible(renderObject);
                        FocusScope.of(context).requestFocus(f2);
                      } else if (txtConPassword.text != txtPassword.text) {
                        RenderObject? renderObject =
                            k3.currentContext?.findRenderObject();
                        if (renderObject != null)
                          scrollController.position.ensureVisible(renderObject);
                        FocusScope.of(context).requestFocus(f3);
                      } else if (txtEmail.text == '') {
                        RenderObject? renderObject =
                            k4.currentContext?.findRenderObject();
                        if (renderObject != null)
                          scrollController.position.ensureVisible(renderObject);
                        FocusScope.of(context).requestFocus(f4);
                      }
                    }
                  },
                  child: new Text(
                    'สมัครสมาชิก',
                    style: new TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Kanit',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  void goBack() async {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }
}
