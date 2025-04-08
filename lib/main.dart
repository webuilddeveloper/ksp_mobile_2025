import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ksp/version.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) =>
              true; // ยอมรับทุกใบรับรอง
  }
}

Future<void> main() async {
  // ตั้งค่าภาษาเป็นไทย
  Intl.defaultLocale = 'th';
  initializeDateFormatting();

  // เรียกให้ Flutter พร้อมใช้งาน
  WidgetsFlutterBinding.ensureInitialized();

  // เริ่มต้น Firebase
  await Firebase.initializeApp();

  // รอให้ LineSDK ตั้งค่าเสร็จเรียบร้อย
  await LineSDK.instance.setup('1655423616').then((_) {
    print('LineSDK Prepared');
  });

  HttpOverrides.global = MyHttpOverrides();

  // เริ่มใช้งานแอป
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _portraitModeOnly();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFFF58A33),
        ).copyWith(
          secondary: Color(
            0xFFF58A33,
          ), // กำหนด secondary เป็นสีเดียวกับ seedColor
        ),
        primaryColor: Color(0xFFF5661F),
        primaryColorDark: Color(0xFF9A1120),
        fontFamily: 'Kanit',
      ),
      home: VersionPage(),
    );
  }

  void _portraitModeOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
