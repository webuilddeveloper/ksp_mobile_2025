import 'dart:async';
import 'dart:io';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:ksp/home.dart';
import 'package:ksp/page/auth/forgot_password.dart';
import 'package:ksp/page/auth/register.dart';
import 'package:ksp/shared/api_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ksp/shared/apple_firebase.dart';
import 'package:ksp/shared/google.dart';
import 'package:ksp/shared/line.dart';
import 'package:ksp/widget/text_field.dart';
import 'package:url_launcher/url_launcher.dart';

DateTime now = new DateTime.now();
void main() {
  runApp(LoginPage());
}

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final storage = new FlutterSecureStorage();

  String _username = "";
  String _password = "";
  String _category = "";

  final txtUsername = TextEditingController();
  final txtPassword = TextEditingController();

  @override
  void initState() {
    setState(() {
      _username = "";
      _password = "";
      _category = "";
    });
    super.initState();
  }

  @override
  void dispose() {
    txtUsername.dispose();
    txtPassword.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBackground();
  }

  _buildBackground() {
    return Container(
      
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        image: DecorationImage(
          image: AssetImage("assets/background_login.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: _buildScaffold(),
    );
  }

  _buildScaffold() {
    return GestureDetector(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          child: ListView(
            padding: EdgeInsets.only(top: 70, left: 20, right: 20, bottom: 30),
            children: [
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
                margin: EdgeInsets.only(top: 20),
                // color: Color(0xFF023047),
                color: Color(0xFFFFFFFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 10,
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _widgetText(title: 'เข้าสู่ระบบ', fontSize: 24),
                      SizedBox(height: 20.0),
                      labelTextField(
                        'ชื่อผู้ใช้งาน',
                        Icon(
                          Icons.person,
                          color: Color(0xFF023047),
                          size: 20.00,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      textField(
                        txtUsername,
                        null,
                        'ชื่อผู้ใช้งาน',
                        'ชื่อผู้ใช้งาน',
                        true,
                        false,
                      ),
                      SizedBox(height: 15.0),
                      labelTextField(
                        'รหัสผ่าน',
                        Icon(Icons.lock, color: Color(0xFF023047), size: 20.00),
                      ),
                      SizedBox(height: 5.0),
                      textField(
                        txtPassword,
                        null,
                        'รหัสผ่าน',
                        'รหัสผ่าน',
                        true,
                        true,
                      ),
                      SizedBox(height: 30.0),
                      _buildLoginButton(),
                      SizedBox(height: 5.0),
                      _buildRegister(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Divider(
                      color: Color(0xFF037F8C),
                      height: 10,
                      thickness: 2,
                    ),
                  ),
                  Text(
                    '  หรือลงทะเบียนผ่าน  ',
                    style: TextStyle(
                      fontSize: 14.00,
                      fontFamily: 'Kanit',
                      color: Color(0xFF037F8C),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Color(0xFF037F8C),
                      height: 10,
                      thickness: 2,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (Platform.isIOS)
                    InkWell(
                      onTap: () async {
                        var obj = await signInWithApple();

                        var model = {
                          "username":
                              obj.user?.email != null
                                  ? obj.user!.email
                                  : obj.user?.uid,
                          "email":
                              obj.user?.email != null ? obj.user!.email : '',
                          "imageUrl": '',
                          "firstName":
                              obj.user?.email != null
                                  ? obj.user!.email
                                  : 'โปรดระบุชื่อ',
                          "lastName": '',
                          "appleID": obj.user?.uid,
                        };

                        Dio dio = new Dio();
                        var response = await dio.post(
                          '${server}m/v2/register/apple/login',
                          data: model,
                        );

                        // print(
                        //     '----- code ----- ${response.data['objectData']['code']}');

                        createStorageApp(
                          model: response.data['objectData'],
                          category: 'apple',
                        );

                        if (obj.user != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        }
                      },
                      child: Image.asset(
                        'assets/logo/socials/apple.png',
                        height: 40,
                        width: 40,
                      ),
                    ),
                  SizedBox(width: 5),
                  InkWell(
                    onTap: () => _buildLoginFacebook(),
                    child: Image.asset(
                      'assets/facebook_circle.png',
                      height: 40,
                      width: 40,
                    ),
                  ),
                  SizedBox(width: 5),
                  InkWell(
                    onTap: () => _buildLoginGoogle(),
                    child: Image.asset(
                      'assets/google_circle.png',
                      height: 40,
                      width: 40,
                    ),
                  ),
                  SizedBox(width: 5),
                  InkWell(
                    onTap: () async {
                      var obj = await loginLine();

                      final idToken = obj.accessToken.idToken;
                      final userEmail =
                          (idToken != null)
                              ? idToken['email'] != ""
                                  ? idToken['email']
                                  : ''
                              : '';

                      if (obj.userProfile != null) {
                        var model = {
                          "username":
                              (userEmail != '' && userEmail != null)
                                  ? userEmail
                                  : obj.userProfile?.userId,
                          "email": userEmail,
                          "imageUrl":
                              (obj.userProfile?.pictureUrl != '' &&
                                      obj.userProfile?.pictureUrl != null)
                                  ? obj.userProfile!.pictureUrl
                                  : '',
                          "firstName": obj.userProfile?.displayName,
                          "lastName": '',
                          "lineID": obj.userProfile?.userId,
                        };

                        Dio dio = new Dio();
                        var response = await dio.post(
                          '${server}m/v2/register/line/login',
                          data: model,
                        );

                        await storage.write(
                          key: 'categorySocial',
                          value: 'Line',
                        );

                        await storage.write(
                          key: 'imageUrlSocial',
                          value:
                              (obj.userProfile?.pictureUrl != '' &&
                                      obj.userProfile?.pictureUrl != null)
                                  ? obj.userProfile!.pictureUrl
                                  : '',
                        );

                        createStorageApp(
                          model: response.data['objectData'],
                          category: 'line',
                        );
                        if (obj.userProfile != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        }
                      }
                    },
                    child: Image.asset(
                      'assets/line_circle.png',
                      height: 40,
                      width: 40,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height > 640 ? 15.0 : 0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'หากผ่านหน้าจอนี้ไป แสดงว่าคุณยอมรับ',
                    style: TextStyle(
                      fontSize: 13.00,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF707070),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      launchUrl(Uri.parse('https://policy.we-builds.com/ksp/'));
                    },
                    child: Text(
                      'นโยบายความเป็นส่วนตัว',
                      style: TextStyle(
                        fontSize: 13.00,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF0000FF),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildRegister() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
            );
          },
          child: Text(
            "ลืมรหัสผ่าน",
            style: TextStyle(
              fontSize: 12.00,
              fontFamily: 'Kanit',
              color: Color(0xFF037F8C),
            ),
          ),
        ),
        Text(
          '|',
          style: TextStyle(
            fontSize: 15.00,
            fontFamily: 'Kanit',
            color: Color(0xFF037F8C),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (BuildContext context) => new RegisterPage(
                      username: "",
                      password: "",
                      facebookID: "",
                      appleID: "",
                      googleID: "",
                      lineID: "",
                      email: "",
                      imageUrl: "",
                      category: "guest",
                      prefixName: "",
                      firstName: "",
                      lastName: "",
                    ),
              ),
            );
          },
          child: Text(
            "สมัครสมาชิก",
            style: TextStyle(
              fontSize: 12.00,
              fontFamily: 'Kanit',
              color: Color(0xFF037F8C),
            ),
          ),
        ),
      ],
    );
  }

  _buildLoginFacebook() async {
    final LoginResult result =
        await FacebookAuth.instance
            .login(); // by default we request the email and the public profile
    // or FacebookAuth.i.login()
    if (result.status == LoginStatus.success) {
      // you are logged
      final AccessToken? accessToken = result.accessToken;

      if (accessToken != null) {
        // user is logged
        print(accessToken.toString());
        final userData = await FacebookAuth.i.getUserData();
        print(userData['email'].toString());
        try {
          var model = {
            "username": userData['email'].toString(),
            "email": userData['email'].toString(),
            "imageUrl": userData['picture']['data']['url'].toString(),
            "firstName": userData['name'].toString(),
            "lastName": '',
            "facebookID": userData['id'].toString(),
          };

          Dio dio = new Dio();
          var response = await dio.post(
            '${server}m/v2/register/facebook/login',
            data: model,
          );

          await storage.write(key: 'categorySocial', value: 'Facebook');

          await storage.write(
            key: 'imageUrlSocial',
            value:
                userData['picture']['data']['url'].toString() != ""
                    ? userData['picture']['data']['url'].toString()
                    : '',
          );

          createStorageApp(
            model: response.data['objectData'],
            category: 'facebook',
          );

          if (response.data['objectData'] != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          }

          // setState(() => _loadingSubmit = false);
        } catch (e) {
          // setState(() => _loadingSubmit = false);
        }
      }
    } else {
      print(result.status);
      print(result.message);
    }
  }

  _buildLoginGoogle() async {
    var obj = await signInWithGoogle();
    // print('----- Login Google ----- ' + obj.toString());
    if (obj.user != null) {
      var model = {
        "username": obj.user?.email,
        "email": obj.user?.email,
        "imageUrl": obj.user?.photoURL != null ? obj.user!.photoURL : '',
        "firstName": obj.user?.displayName,
        "lastName": '',
        "googleID": obj.user?.uid,
      };

      Dio dio = new Dio();
      var response = await dio.post(
        '${server}m/v2/register/google/login',
        data: model,
      );

      await storage.write(key: 'categorySocial', value: 'Google');

      await storage.write(
        key: 'imageUrlSocial',
        value: obj.user?.photoURL != null ? obj.user!.photoURL : '',
      );

      createStorageApp(model: response.data['objectData'], category: 'google');

      if (obj.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    }
  }

  _buildLoginButton() {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      color: Color(0xFF023047),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        height: 40,
        onPressed: () {
          loginWithGuest();
        },
        child: new Text(
          'เข้าสู่ระบบ',
          style: new TextStyle(
            fontSize: 18.0,
            color: Colors.white,
            fontWeight: FontWeight.normal,
            fontFamily: 'Kanit',
          ),
        ),
      ),
    );
  }

  _widgetText({required String title, double fontSize = 18}) {
    return Text(
      title,
      style: TextStyle(
        fontSize: fontSize,
        fontFamily: 'Kanit',
        fontWeight: FontWeight.bold,
        color: Color(0xFF023047),
      ),
    );
  }

  //login username / password
  Future<dynamic> login() async {
    if ((_username == '') && _category == 'guest') {
      return showDialog(
        barrierDismissible: false,
        context: context,
        builder:
            (BuildContext context) => new CupertinoAlertDialog(
              title: new Text(
                'กรุณากรอกชื่อผู้ใช้',
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
                      color: Color(0xFF000070),
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
    } else if ((_password == '') && _category == 'guest') {
      return showDialog(
        barrierDismissible: false,
        context: context,
        builder:
            (BuildContext context) => new CupertinoAlertDialog(
              title: new Text(
                'กรุณากรอกรหัสผ่าน',
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
                      color: Color(0xFF000070),
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
    } else {
      Dio dio = new Dio();
      var response = await dio.post(
        '${server}m/register/login',
        data: {
          'username': _username.toString(),
          'password': _password.toString(),
        },
      );
      print('----- response ----- ${response.toString()}');

      if (response.data['status'] == 'S') {
        FocusScope.of(context).unfocus();
        new TextEditingController().clear();
        createStorageApp(model: response.data['objectData'], category: 'guest');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder:
              (BuildContext context) => new CupertinoAlertDialog(
                title: new Text(
                  'ชื่อผู้ใช้งาน/รหัสผ่าน ไม่ถูกต้อง',
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
                        color: Color(0xFF000070),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      new TextEditingController().clear();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
        );
      }
    }
  }

  //login guest
  void loginWithGuest() async {
    setState(() {
      _category = 'guest';
      _username = txtUsername.text;
      _password = txtPassword.text;
    });
    login();
  }
}
