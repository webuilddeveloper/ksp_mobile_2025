import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as dtpicker;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:ksp/page/profile/organization.dart';
import 'package:ksp/shared/api_provider.dart';
import 'package:ksp/widget/dialog.dart';
import 'package:ksp/widget/header.dart';
import 'package:ksp/widget/text_field.dart';

class IdentityVerificationPage extends StatefulWidget {
  IdentityVerificationPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _IdentityVerificationPageState createState() =>
      _IdentityVerificationPageState();
}

class _IdentityVerificationPageState extends State<IdentityVerificationPage> {
  final storage = FlutterSecureStorage();

  late String _imageUrl;
  late String status;

  final _formKey = GlobalKey<FormState>();

  // Option 2

  late String _selectedSex = '';

  List<dynamic> _itemProvince = [];
  late String _selectedProvince = '';

  List<dynamic> _itemDistrict = [];
  late String _selectedDistrict = '';

  List<dynamic> _itemSubDistrict = [];
  late String _selectedSubDistrict = '';

  List<dynamic> _itemPostalCode = [];
  late String _selectedPostalCode = '';

  final txtEmail = TextEditingController();
  final txtPassword = TextEditingController();
  final txtConPassword = TextEditingController();
  final txtPrefixName = TextEditingController();
  final txtFirstName = TextEditingController();
  final txtLastName = TextEditingController();
  final txtPhone = TextEditingController();
  final txtUsername = TextEditingController();
  final txtIdCard = TextEditingController();
  final txtLineID = TextEditingController();
  final txtOfficerCode = TextEditingController();
  final txtAddress = TextEditingController();
  final txtMoo = TextEditingController();
  final txtSoi = TextEditingController();
  final txtRoad = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TextEditingController txtDate = TextEditingController();

  Future<dynamic> futureModel = Future.value(null);

  ScrollController scrollController = ScrollController();
  ScrollController scrollController1 = ScrollController();

  int _selectedDay = 0;
  int _selectedMonth = 0;
  int _selectedYear = 0;
  int year = 0;
  int month = 0;
  int day = 0;

  bool openOrganization = false;
  late String _selectedLv0;
  late String _selectedTitleLv0;
  late String _selectedLv1;
  late String _selectedTitleLv1;
  late String _selectedLv2;
  late String _selectedTitleLv2;
  late String _selectedLv3;
  late String _selectedTitleLv3;
  late String _selectedLv4;
  late String _selectedTitleLv4;
  late String _selectedLv5;
  late String _selectedTitleLv5;
  int totalLv = 0;

  List<dynamic> dataCountUnit = [];

  List<dynamic> dataPolicy = [];

  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  FocusNode f3 = FocusNode();
  FocusNode f4 = FocusNode();
  FocusNode f5 = FocusNode();
  FocusNode f6 = FocusNode();
  FocusNode f7 = FocusNode();
  FocusNode f8 = FocusNode();
  FocusNode f9 = FocusNode();
  FocusNode f10 = FocusNode();

  final k1 = GlobalKey();
  final k2 = GlobalKey();
  final k3 = GlobalKey();
  final k4 = GlobalKey();
  final k5 = GlobalKey();
  final k6 = GlobalKey();
  final k7 = GlobalKey();
  final k8 = GlobalKey();
  final k9 = GlobalKey();
  final k10 = GlobalKey();

  @override
  void initState() {
    // readStorage();
    getUser();
    // getProvince();
    scrollController = ScrollController();
    scrollController1 = ScrollController();
    var now = DateTime.now();
    setState(() {
      year = now.year;
      month = now.month;
      day = now.day;
      _selectedYear = now.year;
      _selectedMonth = now.month;
      _selectedDay = now.day;
    });
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtEmail.dispose();
    txtPassword.dispose();
    txtConPassword.dispose();
    txtFirstName.dispose();
    txtLastName.dispose();
    txtPhone.dispose();
    txtDate.dispose();
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
        appBar: header(context, goBack, title: widget.title),
        backgroundColor: Color(0xFFFFFFFF),
        body: Container(
          child: ListView(
            controller: scrollController,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: [
              Container(
                color: Colors.white,
                child: FutureBuilder<dynamic>(
                  future: futureModel,
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<dynamic> snapshot,
                  ) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Container(
                          color: Colors.white,
                          child: dialogFail(context),
                        ),
                      );
                    } else {
                      return _buildContentCard();
                      // return Container(
                      //   child: (Text('data')),
                      // );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> getPolicy() async {
    final result = await postDio("m/policy/read", {"category": "application"});
    // if (result['status'] == 'S') {
    if (result['objectData'].length > 0) {
      for (var i in result['objectData']) {
        result['objectData'][i].isActive = "";
        result['objectData'][i].agree = false;
        result['objectData'][i].noAgree = false;
      }
      setState(() {
        dataPolicy = result['objectData'];
      });
    }
    // }
  }

  Future<dynamic> getProvince() async {
    final result = await postObjectData("route/province/read", {});
    if (result['status'] == 'S') {
      setState(() {
        _itemProvince = result['objectData'];
      });
    }
  }

  Future<dynamic> getDistrict() async {
    final result = await postObjectData("route/district/read", {
      'province': _selectedProvince,
    });
    if (result['status'] == 'S') {
      setState(() {
        _itemDistrict = result['objectData'];
      });
    }
  }

  Future<dynamic> getSubDistrict() async {
    final result = await postObjectData("route/tambon/read", {
      'province': _selectedProvince,
      'district': _selectedDistrict,
    });
    if (result['status'] == 'S') {
      setState(() {
        _itemSubDistrict = result['objectData'];
      });
    }
  }

  Future<dynamic> getPostalCode() async {
    final result = await postObjectData("route/postcode/read", {
      'tambon': _selectedSubDistrict,
    });
    if (result['status'] == 'S') {
      setState(() {
        _itemPostalCode = result['objectData'];
      });
    }
  }

  bool isValidDate(String input) {
    try {
      final date = DateTime.parse(input);
      final originalFormatString = toOriginalFormatString(date);
      return input == originalFormatString;
    } catch (e) {
      return false;
    }
  }

  String toOriginalFormatString(DateTime dateTime) {
    final y = dateTime.year.toString().padLeft(4, '0');
    final m = dateTime.month.toString().padLeft(2, '0');
    final d = dateTime.day.toString().padLeft(2, '0');
    return "$y$m$d";
  }

  Future<dynamic> getUser() async {
    var profileCode = await storage.read(key: 'profileCode9');

    if (profileCode != '') {
      // print('-----$profileCode-----');
      final result = await postObjectData("m/Register/read", {
        'code': profileCode,
      });
      // print('-----${result.toString()}-----');
      if (result['status'] == 'S') {
        // await storage.write(
        //   key: 'dataUserLoginKSP',
        //   value: jsonEncode(result['objectData'][0]),
        // );

        if (result['objectData'][0]['birthDay'] != '') {
          if (isValidDate(result['objectData'][0]['birthDay'])) {
            var date = result['objectData'][0]['birthDay'];
            var year = date.substring(0, 4);
            var month = date.substring(4, 6);
            var day = date.substring(6, 8);
            DateTime todayDate = DateTime.parse(year + '-' + month + '-' + day);
            setState(() {
              _selectedYear = todayDate.year;
              _selectedMonth = todayDate.month;
              _selectedDay = todayDate.day;
              txtDate.text = DateFormat("dd-MM-yyyy").format(todayDate);
            });
          }
        }
        setState(() {
          // _username = result['objectData'][0]['username'] ?? '';
          dataCountUnit =
              result['objectData'][0]['countUnit'] != null
                  ? json.decode(result['objectData'][0]['countUnit'])
                  : [];
          _imageUrl = result['objectData'][0]['imageUrl'] ?? '';
          txtFirstName.text = result['objectData'][0]['firstName'] ?? '';
          txtLastName.text = result['objectData'][0]['lastName'] ?? '';
          txtEmail.text = result['objectData'][0]['email'] ?? '';
          txtPhone.text = result['objectData'][0]['phone'] ?? '';
          // _code = result['objectData'][0]['code'] ?? '';
          txtPhone.text = result['objectData'][0]['phone'] ?? '';
          txtUsername.text = result['objectData'][0]['username'] ?? '';
          txtIdCard.text = result['objectData'][0]['idcard'] ?? '';
          txtLineID.text = result['objectData'][0]['lineID'] ?? '';
          txtOfficerCode.text = result['objectData'][0]['officerCode'] ?? '';
          txtAddress.text = result['objectData'][0]['address'] ?? '';
          txtMoo.text = result['objectData'][0]['moo'] ?? '';
          txtSoi.text = result['objectData'][0]['soi'] ?? '';
          txtRoad.text = result['objectData'][0]['road'] ?? '';
          txtPrefixName.text = result['objectData'][0]['prefixName'] ?? '';

          _selectedProvince = result['objectData'][0]['provinceCode'] ?? '';
          _selectedDistrict = result['objectData'][0]['amphoeCode'] ?? '';
          _selectedSubDistrict = result['objectData'][0]['tambonCode'] ?? '';
          _selectedPostalCode = result['objectData'][0]['postnoCode'] ?? '';
          _selectedSex = result['objectData'][0]['sex'] ?? '';
          status = result['objectData'][0]['status'];
        });
      }
      if (_selectedProvince != '') {
        getPolicy();
        getProvince();
        getDistrict();
        getSubDistrict();
        setState(() {
          futureModel = getPostalCode();
        });
      } else {
        getPolicy();
        setState(() {
          futureModel = getProvince();
        });
      }
    }
  }

  Future<dynamic> submitAddOrganization() async {
    if (dataCountUnit.length > 0) {
      var index = dataCountUnit.indexWhere(
        (c) =>
            c['lv0'] == _selectedLv0 &&
            c['lv1'] == _selectedLv1 &&
            c['lv2'] == _selectedLv2 &&
            c['lv3'] == _selectedLv3 &&
            c['lv4'] == _selectedLv4 &&
            c['lv5'] == _selectedLv5,
      );
      if (index == -1) {
        dataCountUnit.add({
          "lv0": _selectedLv0,
          "titleLv0": _selectedTitleLv0,
          "lv1": _selectedLv1,
          "titleLv1": _selectedTitleLv1,
          "lv2": _selectedLv2,
          "titleLv2": _selectedTitleLv2,
          "lv3": _selectedLv3,
          "titleLv3": _selectedTitleLv3,
          "lv4": _selectedLv4,
          "titleLv4": _selectedTitleLv4,
          "lv5": _selectedLv5,
          "titleLv5": _selectedTitleLv5,
          "status": "V",
        });

        this.setState(() {
          dataCountUnit = dataCountUnit;
          _selectedLv0 = "";
          _selectedTitleLv0 = "";
          _selectedLv1 = "";
          _selectedTitleLv1 = "";
          _selectedLv2 = "";
          _selectedTitleLv2 = "";
          _selectedLv3 = "";
          _selectedTitleLv3 = "";
          _selectedLv4 = "";
          _selectedTitleLv4 = "";
          _selectedLv5 = "";
          _selectedTitleLv5 = "";
          openOrganization = false;
          totalLv = 0;
        });
      } else {
        return showDialog(
          context: context,
          builder:
              (BuildContext context) => CupertinoAlertDialog(
                title: Text(
                  'ข้อมูลซ้ำ กรุณาเลือกใหม่',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Kanit',
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                content: Text(''),
                actions: [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text(
                      "ตกลง",
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Kanit',
                        color: Color(0xFF9A1120),
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
      }
    } else {
      dataCountUnit.add({
        "lv0": _selectedLv0,
        "titleLv0": _selectedTitleLv0,
        "lv1": _selectedLv1,
        "titleLv1": _selectedTitleLv1,
        "lv2": _selectedLv2,
        "titleLv2": _selectedTitleLv2,
        "lv3": _selectedLv3,
        "titleLv3": _selectedTitleLv3,
        "lv4": _selectedLv4,
        "titleLv4": _selectedTitleLv4,
        "lv5": _selectedLv5,
        "titleLv5": _selectedTitleLv5,
        "status": "V",
      });

      this.setState(() {
        dataCountUnit = dataCountUnit;
        _selectedLv0 = "";
        _selectedTitleLv0 = "";
        _selectedLv1 = "";
        _selectedTitleLv1 = "";
        _selectedLv2 = "";
        _selectedTitleLv2 = "";
        _selectedLv3 = "";
        _selectedTitleLv3 = "";
        _selectedLv4 = "";
        _selectedTitleLv4 = "";
        _selectedLv5 = "";
        _selectedTitleLv5 = "";
        openOrganization = false;
        totalLv = 0;
      });
    }
  }

  Future<dynamic> submitUpdateUser() async {
    var codeLv0 = "";
    var codeLv1 = "";
    var codeLv2 = "";
    var codeLv3 = "";
    var codeLv4 = "";
    var codeLv5 = "";

    // var dataRow = dataCountUnit;
    for (var i in dataCountUnit) {
      if (codeLv0 != "") {
        codeLv0 = codeLv0 + "," + i['lv0'];
      } else {
        codeLv0 = i['lv0'];
      }

      if (codeLv1 != "") {
        codeLv1 = codeLv1 + "," + i['lv1'];
      } else {
        codeLv1 = i['lv1'];
      }

      if (codeLv2 != "") {
        codeLv2 = codeLv2 + "," + i['lv2'];
      } else {
        codeLv2 = i['lv2'];
      }

      if (codeLv3 != "") {
        codeLv3 = codeLv3 + "," + i['lv3'];
      } else {
        codeLv3 = i['lv3'];
      }

      if (codeLv4 != "") {
        codeLv4 = codeLv4 + "," + i['lv4'];
      } else {
        codeLv4 = i['lv4'];
      }
      if (codeLv5 != "") {
        codeLv5 = codeLv4 + "," + i['lv4'];
      } else {
        codeLv5 = i['lv4'];
      }
    }

    // var index = dataCountUnit.indexWhere((c) => c['status'] != "A");

    dynamic user = {};
    var profileCode = await storage.read(key: 'profileCode9');
    if (profileCode != '' && profileCode != null) user['code'] = profileCode;
    user['imageUrl'] = _imageUrl;
    // user['prefixName'] = _selectedPrefixName;
    user['prefixName'] = txtPrefixName.text;
    user['firstName'] = txtFirstName.text;
    user['lastName'] = txtLastName.text;
    user['birthDay'] = DateFormat(
      "yyyyMMdd",
    ).format(DateTime(_selectedYear, _selectedMonth, _selectedDay));
    user['phone'] = txtPhone.text;
    user['email'] = txtEmail.text;
    user['sex'] = _selectedSex;
    user['soi'] = txtSoi.text;
    user['address'] = txtAddress.text;
    user['moo'] = txtMoo.text;
    user['road'] = txtRoad.text;
    user['tambonCode'] = _selectedSubDistrict;
    user['tambon'] = '';
    user['amphoeCode'] = _selectedDistrict;
    user['amphoe'] = '';
    user['provinceCode'] = _selectedProvince;
    user['province'] = '';
    user['postnoCode'] = _selectedPostalCode;
    user['postno'] = '';
    user['idcard'] = txtIdCard.text;
    user['countUnit'] = json.encode(dataCountUnit);
    user['lv0'] = codeLv0;
    user['lv1'] = codeLv1;
    user['lv2'] = codeLv2;
    user['lv3'] = codeLv3;
    user['lv4'] = codeLv4;
    user['status'] = status;
    user['updateBy'] = '';

    // final result = await postDio('${server}m/v2/Register/verify/update', user);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => OrganizationPage()),
    );
  }

  readStorage() async {
    var value = await storage.read(key: 'dataUserLoginKSP') ?? "";
    var user = json.decode(value);

    if (user['code'] != '') {
      setState(() {
        _imageUrl = user['imageUrl'] ?? '';
        txtFirstName.text = user['firstName'] ?? '';
        txtLastName.text = user['lastName'] ?? '';
        txtEmail.text = user['email'] ?? '';
        txtPhone.text = user['phone'] ?? '';
        txtPrefixName.text = user['prefixName'] ?? '';
        // _selectedPrefixName = user['prefixName'];
        // _code = user['code'];
      });

      if (user['birthDay'] != '') {
        var date = user['birthDay'];
        var year = date.substring(0, 4);
        var month = date.substring(4, 6);
        var day = date.substring(6, 8);
        DateTime todayDate = DateTime.parse(year + '-' + month + '-' + day);
        // DateTime todayDate = DateTime.parse(user['birthDay']);

        setState(() {
          _selectedYear = todayDate.year;
          _selectedMonth = todayDate.month;
          _selectedDay = todayDate.day;
          txtDate.text = DateFormat("dd-MM-yyyy").format(todayDate);
        });
      }
      // getUser();
    }
  }

  card() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 5,
      child: Padding(padding: EdgeInsets.all(15), child: _buildContentCard()),
    );
  }

  dialogOpenPickerDate() {
    dtpicker.DatePicker.showDatePicker(
      context,
      theme: dtpicker.DatePickerTheme(
        containerHeight: 210.0,
        itemStyle: TextStyle(
          fontSize: 16.0,
          color: Color(0xFF9A1120),
          fontWeight: FontWeight.normal,
          fontFamily: 'Kanit',
        ),
        doneStyle: TextStyle(
          fontSize: 16.0,
          color: Color(0xFF9A1120),
          fontWeight: FontWeight.normal,
          fontFamily: 'Kanit',
        ),
        cancelStyle: TextStyle(
          fontSize: 16.0,
          color: Color(0xFF9A1120),
          fontWeight: FontWeight.normal,
          fontFamily: 'Kanit',
        ),
      ),
      showTitleActions: true,
      minTime: DateTime(1800, 1, 1),
      maxTime: DateTime(year, month, day),
      onConfirm: (date) {
        setState(() {
          _selectedYear = date.year;
          _selectedMonth = date.month;
          _selectedDay = date.day;
          txtDate.value = TextEditingValue(
            text: DateFormat("dd-MM-yyyy").format(date),
          );
        });
      },
      currentTime: DateTime(_selectedYear, _selectedMonth, _selectedDay),
      locale: dtpicker.LocaleType.th,
    );
  }

  _buildContentCard() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          controller: scrollController1,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 5.0)),
            Text(
              'ข้อมูลสมาชิก',
              style: TextStyle(
                fontSize: 18.00,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w500,
                // color: Color(0xFFBC0611),
              ),
            ),
            labelTextFormFieldRequired('* ', 'คำนำหน้า', k1),
            textFormFieldProfile(
              txtPrefixName,
              null,
              'คำนำหน้า',
              'คำนำหน้า',
              true,
              false,
              false,
              f1,
            ),
            labelTextFormFieldRequired('* ', 'ชื่อ', k2),
            textFormFieldProfile(
              txtFirstName,
              null,
              'ชื่อ',
              'ชื่อ',
              true,
              false,
              false,
              f2,
            ),
            labelTextFormFieldRequired('* ', 'นามสกุล', k3),
            textFormFieldProfile(
              txtLastName,
              null,
              'นามสกุล',
              'นามสกุล',
              true,
              false,
              false,
              f3,
            ),
            labelTextFormFieldProfile('วันเดือนปีเกิด'),
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                TextEditingController().clear();
                dialogOpenPickerDate();
              },
              child: AbsorbPointer(
                child: TextFormField(
                  controller: txtDate,
                  style: TextStyle(
                    color: Color(0xFF000070),
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Kanit',
                    fontSize: 15.0,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFC5DAFC),
                    contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                    hintText: "วันเดือนปีเกิด",
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
                ),
              ),
            ),
            labelTextFormFieldRequired('* ', 'เบอร์โทรศัพท์ (10 หลัก)', k5),
            textFormPhoneField(
              txtPhone,
              'เบอร์โทรศัพท์ (10 หลัก)',
              'เบอร์โทรศัพท์ (10 หลัก)',
              true,
              false,
              f5,
            ),
            labelTextFormFieldRequired('* ', 'รหัสประจำตัวประชาชน', k6),
            textFormIdCardField(
              txtIdCard,
              'รหัสประจำตัวประชาชน',
              'รหัสประจำตัวประชาชน',
              true,
              f6,
            ),
            labelTextFormFieldRequired('* ', 'จังหวัด', k7),
            Container(
              width: 5000.0,
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
              decoration: BoxDecoration(
                color: Color(0xFFC5DAFC),
                borderRadius: BorderRadius.circular(10),
              ),
              child:
                  (_selectedProvince != '')
                      ? DropdownButtonFormField(
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Kanit',
                            fontSize: 10.0,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        validator:
                            (value) =>
                                value == '' || value == null
                                    ? 'กรุณาเลือกจังหวัด'
                                    : null,
                        hint: Text(
                          'จังหวัด',
                          style: TextStyle(
                            fontSize: 15.00,
                            fontFamily: 'Kanit',
                          ),
                        ),
                        value: _selectedProvince,
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          TextEditingController().clear();
                        },
                        onChanged: (newValue) {
                          setState(() {
                            _selectedDistrict = "";
                            _itemDistrict = [];
                            _selectedSubDistrict = "";
                            _itemSubDistrict = [];
                            _selectedPostalCode = "";
                            _itemPostalCode = [];
                            _selectedProvince = (newValue ?? "").toString();
                          });
                          getDistrict();
                        },
                        items:
                            _itemProvince.map((item) {
                              return DropdownMenuItem(
                                value: item['code'],
                                child: Text(
                                  item['title'],
                                  style: TextStyle(
                                    fontSize: 15.00,
                                    fontFamily: 'Kanit',
                                    color: Color(0xFF000070),
                                  ),
                                ),
                              );
                            }).toList(),
                      )
                      : DropdownButtonFormField(
                        focusNode: f7,
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Kanit',
                            fontSize: 10.0,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        validator:
                            (value) =>
                                value == '' || value == null
                                    ? 'กรุณาเลือกจังหวัด'
                                    : null,
                        hint: Text(
                          'จังหวัด',
                          style: TextStyle(
                            fontSize: 15.00,
                            fontFamily: 'Kanit',
                          ),
                        ),
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          TextEditingController().clear();
                        },
                        onChanged: (newValue) {
                          setState(() {
                            _selectedDistrict = "";
                            _itemDistrict = [];
                            _selectedSubDistrict = "";
                            _itemSubDistrict = [];
                            _selectedPostalCode = "";
                            _itemPostalCode = [];
                            _selectedProvince = (newValue ?? "").toString();
                          });
                          getDistrict();
                        },
                        items:
                            _itemProvince.map((item) {
                              return DropdownMenuItem(
                                value: item['code'],
                                child: Text(
                                  item['title'],
                                  style: TextStyle(
                                    fontSize: 15.00,
                                    fontFamily: 'Kanit',
                                    color: Color(0xFF000070),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
            ),
            labelTextFormFieldRequired('* ', 'อำเภอ', k8),
            Container(
              width: 5000.0,
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
              decoration: BoxDecoration(
                color: Color(0xFFC5DAFC),
                borderRadius: BorderRadius.circular(10),
              ),
              child:
                  (_selectedDistrict != '')
                      ? DropdownButtonFormField(
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Kanit',
                            fontSize: 10.0,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        validator:
                            (value) =>
                                value == '' || value == null
                                    ? 'กรุณาเลือกอำเภอ'
                                    : null,
                        hint: Text(
                          'อำเภอ',
                          style: TextStyle(
                            fontSize: 15.00,
                            fontFamily: 'Kanit',
                          ),
                        ),
                        value: _selectedDistrict,
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          TextEditingController().clear();
                        },
                        onChanged: (newValue) {
                          setState(() {
                            _selectedSubDistrict = "";
                            _itemSubDistrict = [];
                            _selectedPostalCode = "";
                            _itemPostalCode = [];
                            _selectedDistrict = (newValue ?? "").toString();
                            getSubDistrict();
                          });
                        },
                        items:
                            _itemDistrict.map((item) {
                              return DropdownMenuItem(
                                value: item['code'],
                                child: Text(
                                  item['title'],
                                  style: TextStyle(
                                    fontSize: 15.00,
                                    fontFamily: 'Kanit',
                                    color: Color(0xFF000070),
                                  ),
                                ),
                              );
                            }).toList(),
                      )
                      : DropdownButtonFormField(
                        focusNode: f8,
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Kanit',
                            fontSize: 10.0,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        validator:
                            (value) =>
                                value == '' || value == null
                                    ? 'กรุณาเลือกอำเภอ'
                                    : null,
                        hint: Text(
                          'อำเภอ',
                          style: TextStyle(
                            fontSize: 15.00,
                            fontFamily: 'Kanit',
                          ),
                        ),
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          TextEditingController().clear();
                        },
                        onChanged: (newValue) {
                          setState(() {
                            _selectedSubDistrict = "";
                            _itemSubDistrict = [];
                            _selectedPostalCode = "";
                            _itemPostalCode = [];
                            _selectedDistrict = (newValue ?? "").toString();
                            getSubDistrict();
                          });
                        },
                        items:
                            _itemDistrict.map((item) {
                              return DropdownMenuItem(
                                value: item['code'],
                                child: Text(
                                  item['title'],
                                  style: TextStyle(
                                    fontSize: 15.00,
                                    fontFamily: 'Kanit',
                                    color: Color(0xFF000070),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
            ),
            labelTextFormFieldRequired('* ', 'ตำบล', k9),
            Container(
              width: 5000.0,
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
              decoration: BoxDecoration(
                color: Color(0xFFC5DAFC),
                borderRadius: BorderRadius.circular(10),
              ),
              child:
                  (_selectedSubDistrict != '')
                      ? DropdownButtonFormField(
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Kanit',
                            fontSize: 10.0,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        validator:
                            (value) =>
                                value == '' || value == null
                                    ? 'กรุณาเลือกตำบล'
                                    : null,
                        hint: Text(
                          'ตำบล',
                          style: TextStyle(
                            fontSize: 15.00,
                            fontFamily: 'Kanit',
                          ),
                        ),
                        value: _selectedSubDistrict,
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          TextEditingController().clear();
                        },
                        onChanged: (newValue) {
                          setState(() {
                            _selectedPostalCode = "";
                            _itemPostalCode = [];
                            _selectedSubDistrict = (newValue ?? "").toString();
                            getPostalCode();
                          });
                        },
                        items:
                            _itemSubDistrict.map((item) {
                              return DropdownMenuItem(
                                value: item['code'],
                                child: Text(
                                  item['title'],
                                  style: TextStyle(
                                    fontSize: 15.00,
                                    fontFamily: 'Kanit',
                                    color: Color(0xFF000070),
                                  ),
                                ),
                              );
                            }).toList(),
                      )
                      : DropdownButtonFormField(
                        focusNode: f9,
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Kanit',
                            fontSize: 10.0,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        validator:
                            (value) =>
                                value == '' || value == null
                                    ? 'กรุณาเลือกตำบล'
                                    : null,
                        hint: Text(
                          'ตำบล',
                          style: TextStyle(
                            fontSize: 15.00,
                            fontFamily: 'Kanit',
                          ),
                        ),
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          TextEditingController().clear();
                        },
                        onChanged: (newValue) {
                          setState(() {
                            _selectedPostalCode = "";
                            _itemPostalCode = [];
                            _selectedSubDistrict = (newValue ?? "").toString();
                            getPostalCode();
                          });
                        },
                        items:
                            _itemSubDistrict.map((item) {
                              return DropdownMenuItem(
                                value: item['code'],
                                child: Text(
                                  item['title'],
                                  style: TextStyle(
                                    fontSize: 15.00,
                                    fontFamily: 'Kanit',
                                    color: Color(0xFF000070),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
            ),
            labelTextFormFieldRequired('* ', 'รหัสไปรษณีย์', k10),
            Container(
              width: 5000.0,
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
              decoration: BoxDecoration(
                color: Color(0xFFC5DAFC),
                borderRadius: BorderRadius.circular(10),
              ),
              child:
                  (_selectedPostalCode != '')
                      ? DropdownButtonFormField(
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Kanit',
                            fontSize: 10.0,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        validator:
                            (value) =>
                                value == '' || value == null
                                    ? 'กรุณาเลือกรหัสไปรษณีย์'
                                    : null,
                        hint: Text(
                          'รหัสไปรษณีย์',
                          style: TextStyle(
                            fontSize: 15.00,
                            fontFamily: 'Kanit',
                          ),
                        ),
                        value: _selectedPostalCode,
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          TextEditingController().clear();
                        },
                        onChanged: (newValue) {
                          setState(() {
                            _selectedPostalCode = (newValue ?? "").toString();
                          });
                        },
                        items:
                            _itemPostalCode.map((item) {
                              return DropdownMenuItem(
                                value: item['code'],
                                child: Text(
                                  item['postCode'],
                                  style: TextStyle(
                                    fontSize: 15.00,
                                    fontFamily: 'Kanit',
                                    color: Color(0xFF000070),
                                  ),
                                ),
                              );
                            }).toList(),
                      )
                      : DropdownButtonFormField(
                        focusNode: f10,
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Kanit',
                            fontSize: 10.0,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        validator:
                            (value) =>
                                value == '' || value == null
                                    ? 'กรุณาเลือกรหัสไปรษณีย์'
                                    : null,
                        hint: Text(
                          'รหัสไปรษณีย์',
                          style: TextStyle(
                            fontSize: 15.00,
                            fontFamily: 'Kanit',
                          ),
                        ),
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          TextEditingController().clear();
                        },
                        onChanged: (newValue) {
                          setState(() {
                            _selectedPostalCode = (newValue ?? "").toString();
                          });
                        },
                        items:
                            _itemPostalCode.map((item) {
                              return DropdownMenuItem(
                                value: item['code'],
                                child: Text(
                                  item['postCode'],
                                  style: TextStyle(
                                    fontSize: 15.00,
                                    fontFamily: 'Kanit',
                                    color: Color(0xFF000070),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
            ),

            labelTextFormFieldProfile('ที่อยู่ปัจจุบัน'),
            textFormFieldNoValidator(
              txtAddress,
              'ที่อยู่ปัจจุบัน',
              true,
              false,
            ),
            labelTextFormFieldProfile('หมู่ที่'),
            textFormFieldNoValidator(txtMoo, 'หมู่ที่', true, false),
            labelTextFormFieldProfile('ซอย'),
            textFormFieldNoValidator(txtSoi, 'ซอย', true, false),
            labelTextFormFieldProfile('ถนน'),
            textFormFieldNoValidator(txtRoad, 'ถนน', true, false),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            _buildButtonSave(),
          ],
        ),
      ),
    );
  }

  _buildButtonSave() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(10.0),
          color: Color(0xFFFF7514),
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            height: 40,
            onPressed: () {
              final form = _formKey.currentState;
              if (form != null && form.validate()) {
                form.save();
                submitUpdateUser();
              } else {
                f1.unfocus();
                f2.unfocus();
                f3.unfocus();
                f4.unfocus();
                f5.unfocus();
                f6.unfocus();
                f7.unfocus();
                f8.unfocus();

                String pattern = r'(^[0-9]\d{12}$)';
                RegExp regex = RegExp(pattern);

                var isIdcard = false;
                if (regex.hasMatch(txtIdCard.text)) {
                  if (txtIdCard.text.length != 13) {
                    isIdcard = true;
                  } else {
                    var sum = 0.0;
                    for (var i = 0; i < 12; i++) {
                      sum += double.parse(txtIdCard.text[i]) * (13 - i);
                    }
                    if ((11 - (sum % 11)) % 10 !=
                        double.parse(txtIdCard.text[12])) {
                      isIdcard = true;
                    }
                  }
                } else {
                  isIdcard = true;
                }

                if (txtPrefixName.text == '') {
                  RenderObject? renderObject =
                      k1.currentContext?.findRenderObject();
                  if (renderObject != null) {
                    scrollController.position.ensureVisible(renderObject);
                  }
                  FocusScope.of(context).requestFocus(f1);
                } else if (txtFirstName.text == '') {
                  RenderObject? renderObject =
                      k2.currentContext?.findRenderObject();
                  if (renderObject != null) {
                    scrollController.position.ensureVisible(renderObject);
                  }
                  FocusScope.of(context).requestFocus(f2);
                } else if (txtLastName.text == '') {
                  RenderObject? renderObject =
                      k3.currentContext?.findRenderObject();
                  if (renderObject != null) {
                    scrollController.position.ensureVisible(renderObject);
                  }
                  FocusScope.of(context).requestFocus(f3);
                } else if (txtPhone.text == '') {
                  RenderObject? renderObject =
                      k5.currentContext?.findRenderObject();
                  if (renderObject != null) {
                    scrollController.position.ensureVisible(renderObject);
                  }
                  FocusScope.of(context).requestFocus(f5);
                } else if (isIdcard) {
                  RenderObject? renderObject =
                      k6.currentContext?.findRenderObject();
                  if (renderObject != null) {
                    scrollController.position.ensureVisible(renderObject);
                  }
                  FocusScope.of(context).requestFocus(f6);
                } else if (_selectedProvince == '') {
                  RenderObject? renderObject =
                      k7.currentContext?.findRenderObject();
                  if (renderObject != null) {
                    scrollController.position.ensureVisible(renderObject);
                  }
                  FocusScope.of(context).requestFocus(f7);
                } else if (_selectedDistrict == '') {
                  RenderObject? renderObject =
                      k8.currentContext?.findRenderObject();
                  if (renderObject != null) {
                    scrollController.position.ensureVisible(renderObject);
                  }
                  FocusScope.of(context).requestFocus(f8);
                } else if (_selectedSubDistrict == '') {
                  RenderObject? renderObject =
                      k9.currentContext?.findRenderObject();
                  if (renderObject != null) {
                    scrollController.position.ensureVisible(renderObject);
                  }
                  FocusScope.of(context).requestFocus(f9);
                } else if (_selectedPostalCode == '') {
                  RenderObject? renderObject =
                      k10.currentContext?.findRenderObject();
                  if (renderObject != null) {
                    scrollController.position.ensureVisible(renderObject);
                  }
                  FocusScope.of(context).requestFocus(f10);
                }
              }
            },
            child: Text(
              'บันทึกข้อมูล',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontFamily: 'Kanit',
              ),
            ),
          ),
        ),
      ),
    );
  }

  dropdownMenuItemHaveData(
    String _selected,
    List<dynamic> _item,
    String title,
  ) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        errorStyle: TextStyle(
          fontWeight: FontWeight.normal,
          fontFamily: 'Kanit',
          fontSize: 10.0,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      validator: (value) => value == null ? 'กรุณาเลือก' + title : null,
      hint: Text(title, style: TextStyle(fontSize: 15.00, fontFamily: 'Kanit')),
      value: _selected,
      onChanged: (newValue) {
        setState(() {
          _selected = (newValue ?? "").toString();
        });
      },
      items:
          _item.map((item) {
            return DropdownMenuItem(
              value: item['code'],
              child: Text(
                item['title'],
                style: TextStyle(
                  fontSize: 15.00,
                  fontFamily: 'Kanit',
                  color: Color(0xFF9A1120),
                ),
              ),
            );
          }).toList(),
    );
  }

  dropdownMenuItemNoHaveData(
    String _selected,
    List<dynamic> _item,
    String title,
  ) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        errorStyle: TextStyle(
          fontWeight: FontWeight.normal,
          fontFamily: 'Kanit',
          fontSize: 10.0,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      validator:
          (value) => value == '' || value == null ? 'กรุณาเลือก' + title : null,
      hint: Text(title, style: TextStyle(fontSize: 15.00, fontFamily: 'Kanit')),
      // value: _selected,
      onChanged: (newValue) {
        setState(() {
          _selected = (newValue ?? "").toString();
        });
      },
      items:
          _item.map((item) {
            return DropdownMenuItem(
              value: item['code'],
              child: Text(
                item['title'],
                style: TextStyle(
                  fontSize: 15.00,
                  fontFamily: 'Kanit',
                  color: Color(0xFF9A1120),
                ),
              ),
            );
          }).toList(),
    );
  }

  rowContentButton(String urlImage, String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Color(0xFF0B5C9E),
            ),
            width: 30.0,
            height: 30.0,
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Image.asset(urlImage, height: 5.0, width: 5.0),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.63,
            margin: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12.0,
                color: Color(0xFF9A1120),
                fontWeight: FontWeight.normal,
                fontFamily: 'Kanit',
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: Image.asset(
              "assets/icons/Group6232.png",
              height: 20.0,
              width: 20.0,
            ),
          ),
        ],
      ),
    );
  }

  void goBack() async {
    Navigator.pop(context, false);
  }
}
