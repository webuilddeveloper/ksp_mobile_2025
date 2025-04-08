import 'package:flutter/material.dart';

labelTextField(String label, Icon icon) {
  return Row(
    children: <Widget>[
      icon,
      Text(
        ' ' + label,
        style: TextStyle(
          fontSize: 15.000,
          fontFamily: 'Kanit',
          // color: Colors.white,
          color: Color(0xFF023047),
        ),
      ),
    ],
  );
}

textField(
  TextEditingController model,
  TextEditingController? modelMatch,
  String hintText,
  String validator,
  bool enabled,
  bool isPassword,
) {
  return SizedBox(
    height: 45.0,
    child: TextField(
      // keyboardType: TextInputType.number,
      obscureText: isPassword,
      controller: model,
      enabled: enabled,
      style: TextStyle(
        color: Color(0xFFF58A33),
        fontWeight: FontWeight.normal,
        fontFamily: 'Kanit',
        fontSize: 15.00,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xFFFDF2E8),
        contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}

labelTextFormFieldRequired(String labelReequired, String label, Key? key) {
  return Padding(
    key: key,
    padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
    child: Row(
      children: [
        Text(
          labelReequired,
          style: TextStyle(
            fontSize: 15.000,
            fontFamily: 'Kanit',
            color: Color(0xFFFF0000),
          ),
        ),
        Text(label, style: TextStyle(fontSize: 15.000, fontFamily: 'Kanit')),
      ],
    ),
  );
}

textFormFieldProfile(
  TextEditingController model,
  String? modelMatch,
  String hintText,
  String validator,
  bool enabled,
  bool isPassword,
  bool isEmail,
  FocusNode? focus,
) {
  return TextFormField(
    focusNode: focus,
    obscureText: isPassword,
    style: TextStyle(
      color: enabled ? Color(0xFF000070) : Color(0xFFFFFFFF),
      fontWeight: FontWeight.normal,
      fontFamily: 'Kanit',
      fontSize: 15.00,
    ),
    decoration: InputDecoration(
      filled: true,
      fillColor: enabled ? Color(0xFFC5DAFC) : Color(0xFF707070),
      contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
      hintText: hintText,
      // focusedBorder: UnderlineInputBorder(
      //   borderSide: BorderSide(color: Colors.amber, width: 0.5),
      // ),
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
        return 'กรุณากรอก ' + validator + '.';
      }
      // if (isPassword && model != modelMatch && modelMatch != null) {
      //   return 'กรุณากรอกรหัสผ่านให้ตรงกัน.';
      // }

      if (isPassword) {
        // String pattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).{6,}$';
        // RegExp regex = new RegExp(pattern);
        // if (!regex.hasMatch(model)) {
        if (model.length < 6) {
          return 'กรุณากรอกรูปแบบรหัสผ่านให้ถูกต้อง.';
        }
      }
      if (isEmail) {
        String pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = RegExp(pattern);
        if (!regex.hasMatch(model)) {
          return 'กรุณากรอกรูปแบบอีเมลให้ถูกต้อง.';
        }
      }
      return null;
    },
    controller: model,
    enabled: enabled,
  );
}

labelRegisterRequired(String labelReequired, String label, Key key) {
  return Padding(
    key: key,
    padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
    child: Row(
      children: [
        Text(
          labelReequired,
          style: TextStyle(
            fontSize: 15.000,
            fontFamily: 'Kanit',
            color: Color(0xFFFF0000),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 15.000,
            fontFamily: 'Kanit',
            color: Color(0xFFFFFFFF),
          ),
        ),
      ],
    ),
  );
}

textFormFieldRequired(
  TextEditingController model,
  String? modelMatch,
  String hintText,
  String validator,
  bool enabled,
  bool isPassword,
  bool isEmail,
  FocusNode focus,
) {
  return TextFormField(
    focusNode: focus,
    obscureText: isPassword,
    style: TextStyle(
      color: enabled ? Color(0xFFF58A33) : Color(0xFFFFFFFF),
      fontWeight: FontWeight.normal,
      fontFamily: 'Kanit',
      fontSize: 15.00,
    ),
    decoration: InputDecoration(
      filled: true,
      fillColor: enabled ? Color(0xFFFFFFFF) : Color(0xFF707070),
      contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
      hintText: hintText,
      // focusedBorder: UnderlineInputBorder(
      //   borderSide: BorderSide(color: Colors.amber, width: 0.5),
      // ),
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
        return 'กรุณากรอก ' + validator + '.';
      }
      // if (isPassword && model != modelMatch && modelMatch != null) {
      //   return 'กรุณากรอกรหัสผ่านให้ตรงกัน.';
      // }

      if (isPassword) {
        // String pattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).{6,}$';
        // RegExp regex = new RegExp(pattern);
        // if (!regex.hasMatch(model)) {
        if (model.length < 6) {
          return 'กรุณากรอกรูปแบบรหัสผ่านให้ถูกต้อง.';
        }
      }

      if (isEmail) {
        String pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = RegExp(pattern);
        if (!regex.hasMatch(model)) {
          return 'กรุณากรอกรูปแบบอีเมลให้ถูกต้อง.';
        }
      }
      return null;
    },
    controller: model,
    enabled: enabled,
  );
}

labelRegisterPasswordOldNew(
  String labelReequired,
  String lable,
  bool showSubtitle,
  Key key,
) {
  return Padding(
    key: key,
    padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
    child: Row(
      children: <Widget>[
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Text(
                    labelReequired,
                    style: TextStyle(
                      fontSize: 15.000,
                      fontFamily: 'Kanit',
                      color: Color(0xFFFF0000),
                    ),
                  ),
                  Text(
                    lable,
                    style: TextStyle(
                      fontSize: 15.000,
                      fontFamily: 'Kanit',
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ],
              ),
              if (showSubtitle)
                Text(
                  '(รหัสผ่านต้องมีตัวอักษร A-Z, a-z และ 0-9 ความยาวขั้นต่ำ 6 ตัวอักษร',
                  style: TextStyle(
                    fontSize: 10.00,
                    fontFamily: 'Kanit',
                    color: Color(0xFFFF0000),
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

textFormField(
  TextEditingController model,
  String? modelMatch,
  String hintText,
  String validator,
  bool enabled,
  bool isPassword,
  bool isEmail,
  FocusNode focus,
) {
  return TextFormField(
    focusNode: focus,
    obscureText: isPassword,
    style: TextStyle(
      color: enabled ? Color(0xFFF58A33) : Color(0xFFFFFFFF),
      fontWeight: FontWeight.normal,
      fontFamily: 'Kanit',
      fontSize: 15.00,
    ),
    decoration: InputDecoration(
      filled: true,
      fillColor: enabled ? Color(0xFFFFFFFF) : Color(0xFF707070),
      contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
      hintText: hintText,
      // focusedBorder: UnderlineInputBorder(
      //   borderSide: BorderSide(color: Colors.amber, width: 0.5),
      // ),
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
      // if (model.isEmpty) {
      //   return 'กรุณากรอก ' + validator + '.';
      // }
      // if (isPassword && model != modelMatch && modelMatch != null) {
      //   return 'กรุณากรอกรหัสผ่านให้ตรงกัน.';
      // }

      if (isPassword) {
        // String pattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).{6,}$';
        // RegExp regex = new RegExp(pattern);
        // if (!regex.hasMatch(model)) {
        if (model.length < 6) {
          return 'กรุณากรอกรูปแบบรหัสผ่านให้ถูกต้อง.';
        }
        // }
      }

      if (isEmail) {
        String pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = RegExp(pattern);
        if (!regex.hasMatch(model)) {
          return 'กรุณากรอกรูปแบบอีเมลให้ถูกต้อง.';
        }
      }
      return null;
    },
    controller: model,
    enabled: enabled,
  );
}

labelRegister(String label) {
  return Padding(
    padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
    child: Text(
      label,
      style: TextStyle(
        fontSize: 15.000,
        fontFamily: 'Kanit',
        color: Color(0xFFFFFFFF),
      ),
    ),
  );
}

textFormPhoneField(
  TextEditingController model,
  String hintText,
  String validator,
  bool enabled,
  bool isPhone,
  FocusNode? focus,
) {
  return TextFormField(
    focusNode: focus,
    keyboardType: TextInputType.number,
    style: TextStyle(
      color: enabled ? Color(0xFF000070) : Color(0xFFFFFFFF),
      fontWeight: FontWeight.normal,
      fontFamily: 'Kanit',
      fontSize: 15.00,
    ),
    decoration: InputDecoration(
      filled: true,
      fillColor: enabled ? Color(0xFFC5DAFC) : Color(0xFF707070),
      contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
      hintText: hintText,
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
        return 'กรุณากรอก' + validator + '.';
      }
      if (isPhone) {
        String pattern = r'(^(?:[+0]9)?[0-9]{9,10}$)';
        RegExp regex = RegExp(pattern);
        if (!regex.hasMatch(model)) {
          return 'กรุณากรอกรูปแบบเบอร์ติดต่อให้ถูกต้อง.';
        }
      }
      return null;
    },
    controller: model,
    enabled: enabled,
  );
}

textFormIdCardField(
  TextEditingController model,
  String hintText,
  String validator,
  bool enabled,
  FocusNode focus,
) {
  return TextFormField(
    focusNode: focus,
    keyboardType: TextInputType.number,
    style: TextStyle(
      color: enabled ? Color(0xFF000070) : Color(0xFFFFFFFF),
      fontWeight: FontWeight.normal,
      fontFamily: 'Kanit',
      fontSize: 15.00,
    ),
    decoration: InputDecoration(
      filled: true,
      fillColor: enabled ? Color(0xFFC5DAFC) : Color(0xFF707070),
      contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
      hintText: hintText,
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
        return 'กรุณากรอก' + validator + '.';
      }

      String pattern = r'(^[0-9]\d{12}$)';
      RegExp regex = RegExp(pattern);

      if (regex.hasMatch(model)) {
        if (model.length != 13) {
          return 'กรุณากรอกรูปแบบเลขบัตรประชาชนให้ถูกต้อง';
        } else {
          var sum = 0.0;
          for (var i = 0; i < 12; i++) {
            sum += double.parse(model[i]) * (13 - i);
          }
          if ((11 - (sum % 11)) % 10 != double.parse(model[12])) {
            return 'กรุณากรอกเลขบัตรประชาชนให้ถูกต้อง';
          } else {
            return null;
          }
        }
      } else {
        return 'กรุณากรอกรูปแบบเลขบัตรประชาชนให้ถูกต้อง';
      }
    },
    controller: model,
    enabled: enabled,
  );
}

labelTextFormFieldProfile(String label) {
  return Padding(
    padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
    child: Text(
      label,
      style: TextStyle(
        fontSize: 15.000,
        fontFamily: 'Kanit',
        // color: Color(0xFF1B6CA8),
      ),
    ),
  );
}

textFormFieldNoValidator(
  TextEditingController model,
  String hintText,
  bool enabled,
  bool isEmail,
) {
  return TextFormField(
    style: TextStyle(
      color: enabled ? Color(0xFF000070) : Color(0xFFFFFFFF),
      fontWeight: FontWeight.normal,
      fontFamily: 'Kanit',
      fontSize: 15.00,
    ),
    decoration: InputDecoration(
      filled: true,
      fillColor: enabled ? Color(0xFFC5DAFC) : Color(0xFF707070),
      contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
      hintText: hintText,
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
      if (isEmail && model != "") {
        String pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = RegExp(pattern);
        if (!regex.hasMatch(model)) {
          return 'กรุณากรอกรูปแบบอีเมลให้ถูกต้อง.';
        }
      }
      return null;
    },
    controller: model,
    enabled: enabled,
  );
}
