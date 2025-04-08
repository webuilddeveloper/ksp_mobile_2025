import 'package:flutter/material.dart';

inputCus(
    {required BuildContext context,
    TextEditingController? controller,
    String? value,
    bool checkText = false,
    required Function callback,
    String title = '',
    String hintText = '',
    bool enabled = true,
    required Function validator,
    bool isShowPattern = false,
    bool isShowIcon = false,
    bool isPassword = false,
    TextInputType? textInputType,
    required Function onChanged}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (title != '')
        Container(
          margin: EdgeInsets.only(top: 15.0),
          child: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontFamily: 'Kanit',
              fontSize: 14.0,
            ),
          ),
        ),
      TextFormField(
        keyboardType: textInputType,
        enabled: enabled,
        obscureText: isPassword ? checkText : false,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.normal,
          fontFamily: 'Kanit',
          fontSize: 14.0,
        ),
        decoration: InputDecoration(
          suffixIcon: isShowIcon
              ? IconButton(
                  icon: Icon(
                    checkText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    callback();
                  },
                )
              : null,
          // filled: true,
          fillColor: Colors.transparent,
          contentPadding: EdgeInsets.only(left: 5.0, right: 5.0, top: 15.0),
          hintText: hintText,
          errorStyle: TextStyle(
            fontWeight: FontWeight.normal,
            fontFamily: 'Kanit',
            fontSize: 10.0,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        validator: (model) {
          return validator(model);
        },
        onChanged: (value) => onChanged(value),
        initialValue: value,
        controller: controller,
        // enabled: true,
      ),
      isShowPattern
          ? Text(
              '(รหัสผ่านต้องมีตัวอักษร A-Z, a-z และ 0-9 ความยาวขั้นต่ำ 6 ตัวอักษร)',
              style: TextStyle(
                fontSize: 10.00,
                fontFamily: 'Kanit',
                color: Color(0xFFFF0000),
              ),
            )
          : Container(),
    ],
  );
}
