import 'package:flutter/material.dart';
import 'package:ksp/page/notification/notification_list.dart';
import 'package:ksp/shared/api_provider.dart';
import 'package:badges/badges.dart' as badges;

header(
  BuildContext context,
  Function functionGoBack, {
  String title = '',
  bool isButtonRight = false,
  Function? rightButton,
  String menu = '',
}) {
  return AppBar(
    centerTitle: true,
    flexibleSpace: Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
    ),
    backgroundColor: Colors.white,
    elevation: 0.0,
    titleSpacing: 5,
    automaticallyImplyLeading: false,
    title: Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        fontFamily: 'Kanit',
        color: Colors.black,
      ),
    ),
    leading: Center(
      child: InkWell(
        onTap: () => functionGoBack(),
        child: Container(
          width: 40,
          height: 40,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(0x4FFAB67F),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Image.asset(
            "assets/images/arrow_left.png",
            color: Color(0xFFE76800),
          ),
        ),
      ),
    ),
    actions: <Widget>[
      isButtonRight == true
          ? menu == 'notification'
              ? Container(
                child: Container(
                  child: Container(
                    width: 42.0,
                    height: 42.0,
                    margin: EdgeInsets.only(top: 6.0, right: 10.0, bottom: 6.0),
                    padding: EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap:
                          () => rightButton == null ? () => {} : rightButton(),
                      child: Image.asset('assets/images/task_list.png'),
                    ),
                  ),
                ),
              )
              : Container(
                child: Container(
                  child: Container(
                    width: 42.0,
                    height: 42.0,
                    margin: EdgeInsets.only(top: 6.0, right: 10.0, bottom: 6.0),
                    padding: EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap:
                          () => rightButton == null ? () => {} : rightButton(),
                      child: Image.asset('assets/logo/icons/Group344.png'),
                    ),
                  ),
                ),
              )
          : Container(),
    ],
  );
}

headerV2(
  BuildContext context, {
  bool isCenter = false,
  int notiCount = 0,
  required Function callBackClickButtonCalendar,
}) {
  return AppBar(
    backgroundColor: Colors.transparent,
    centerTitle: isCenter,
    elevation: 0.0,
    flexibleSpace: Container(),
    title: Row(
      // mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [Image.asset('assets/logo3.png', height: 30)],
    ),
    actions: [
      Container(
        // width: 40.0,
        // height: 20.0,
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.circular(10),
          color: Color(0xFFFFFFFF),
          // color: Colors.red,
        ),
        margin: EdgeInsets.only(top: 10.0, right: 10.0, bottom: 10.0),
        padding: EdgeInsets.all(8.0),
        child: InkWell(
          onTap:
              () => {
                postTrackClick("แจ้งเตือน"),
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationList(title: 'แจ้งเตือน'),
                  ),
                ).then((value) => callBackClickButtonCalendar()),
              },
          child: badges.Badge(
            // padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
            showBadge: notiCount > 0 ? true : false,
            position: badges.BadgePosition.topEnd(),
            badgeContent: Text(
              notiCount.toString(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: Image.asset(
              'assets/logo/icons/Group103.png',
              color: Color(0xFFF5661F),
            ),
          ),
        ),
      ),
    ],
  );
}

headerCalendar(
  BuildContext context, {
  String title = '',
  bool isShowLogo = true,
  bool isCenter = false,
  bool isShowButtonCalendar = false,
  bool isButtonCalendar = false,
  bool isShowButtonPoi = false,
  bool isButtonPoi = false,
  bool isNoti = false,
  int notiCount = 0,
  required Function callBackClickButtonCalendar,
}) {
  return AppBar(
    backgroundColor: Color(0xFFF58A33),
    centerTitle: isCenter,
    elevation: 0.0,
    flexibleSpace: Container(),
    leading: IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: Colors.white, // เปลี่ยนสีลูกศรที่นี่
      ),
      onPressed: () {
        Navigator.of(context).pop(); // ใช้สำหรับการย้อนกลับ
      },
    ),
    title:
        isCenter
            ? isShowButtonCalendar || isShowButtonPoi
                ? Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 18,
                    color: Colors.white,
                  ),
                )
                : Column(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'KSP',
                        fontSize: 28,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'BY Khurusapha',
                      style: TextStyle(
                        fontFamily: 'KSP',
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
            : Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (isShowLogo) Image.asset('assets/logo2.png', height: 30),
                SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily:
                        isShowButtonCalendar || isShowButtonPoi
                            ? 'Kanit'
                            : 'Kanit',
                    fontSize: isShowButtonCalendar || isShowButtonPoi ? 18 : 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
    actions: [
      if (isShowButtonCalendar)
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.only(right: 10, top: 12, bottom: 12),
          width: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: InkWell(
            onTap: () => callBackClickButtonCalendar(),
            child:
                isButtonCalendar
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.list,
                          color: Theme.of(context).primaryColor,
                          size: 15,
                        ),
                        Text(
                          'รายการ',
                          style: TextStyle(
                            fontSize: 9,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icon_header_calendar_1.png',
                          color: Theme.of(context).primaryColor,
                        ),
                        Text(
                          'ปฏิทิน',
                          style: TextStyle(
                            fontSize: 9,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        // widgetText(
                        //     title: 'ปฏิทิน', fontSize: 9, color: 0xFF1B6CA8),
                      ],
                    ),
          ),
        ),
      if (isShowButtonPoi)
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(right: 10.0),
          margin: EdgeInsets.only(right: 10, top: 12, bottom: 12),
          width: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: InkWell(
            onTap: () => callBackClickButtonCalendar(),
            child:
                isButtonPoi
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.list,
                          color: Theme.of(context).primaryColor,
                          size: 15,
                        ),
                        Text(
                          'รายการ',
                          style: TextStyle(
                            fontSize: 9,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Theme.of(context).primaryColor,
                          size: 20,
                        ),
                        // Image.asset('assets/icon_header_calendar_1.png'),
                        Text(
                          'แผนที่',
                          style: TextStyle(
                            fontSize: 9,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        // widgetText(
                        //     title: 'ปฏิทิน', fontSize: 9, color: 0xFF1B6CA8),
                      ],
                    ),
          ),
        ),
      if (isNoti)
        Container(
          width: 40.0,
          // height: 20.0,
          decoration: BoxDecoration(
            borderRadius: new BorderRadius.circular(15),
            color: Color(0xFFFACBA4),
          ),
          margin: EdgeInsets.only(top: 10.0, right: 10.0, bottom: 10.0),
          padding: EdgeInsets.all(8.0),
          child: InkWell(
            onTap:
                () => {
                  postTrackClick("แจ้งเตือน"),
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => NotificationList(title: 'แจ้งเตือน'),
                    ),
                  ).then((value) => callBackClickButtonCalendar),
                },
            child: badges.Badge(
              // padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
              showBadge: notiCount > 0 ? true : false,
              position: badges.BadgePosition.topStart(),
              badgeContent: Text(
                notiCount.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Image.asset(
                'assets/logo/icons/Group103.png',
                color: Colors.white,
              ),
            ),
          ),
        ),
    ],
  );
}

headerNoti(
  BuildContext context,
  Function functionGoBack, {
  String title = '',
  bool isButtonRight = false,
  required Function rightButton,
  String menu = '',
  required int notiCount,
}) {
  return AppBar(
    centerTitle: false,
    flexibleSpace: Container(),
    backgroundColor: Colors.white,
    elevation: 0.0,
    titleSpacing: 5,
    automaticallyImplyLeading: false,
    title: Row(
      children: [
        InkWell(
          onTap: () => functionGoBack(),
          child: Container(
            child: Image.asset(
              "assets/images/arrow_left.png",
              color: Color(0xFFFF9300),
              width: 35,
              height: 50,
            ),
          ),
        ),
        // SizedBox(width: 15),
        Text(
          title,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: 'Kanit',
            color: Color(0xFF707070),
          ),
        ),
        SizedBox(width: 15),
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.red,
          ),
          height: 30,
          width: 30,
          child: Text(
            notiCount.toString(),
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,
              fontFamily: 'Kanit',
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
    // leading: InkWell(
    //   onTap: () => functionGoBack(),
    //   child: Container(
    //     child: Image.asset(
    //       "assets/images/arrow_left.png",
    //       color: Color(0xFFFF9300),
    //       width: 20,
    //       height: 20,
    //     ),
    //   ),
    // ),
    actions: <Widget>[
      isButtonRight == true
          ? menu == 'notification'
              ? Container(
                child: Container(
                  child: Container(
                    width: 45.0,
                    height: 45.0,
                    margin: EdgeInsets.only(top: 6.0, right: 10.0, bottom: 6.0),
                    padding: EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () => rightButton(),
                      child: Image.asset(
                        'assets/noti_list.png',
                        color: Color(0xFFFF9300),
                      ),
                    ),
                  ),
                ),
              )
              : Container(
                child: Container(
                  child: Container(
                    width: 24.0,
                    height: 24.0,
                    margin: EdgeInsets.only(top: 6.0, right: 10.0, bottom: 6.0),
                    padding: EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () => rightButton(),
                      child: Image.asset('assets/logo/icons/Group344.png'),
                    ),
                  ),
                ),
              )
          : Container(),
    ],
  );
}
