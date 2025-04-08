import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Profile extends StatefulWidget {
  Profile({Key? key, required this.model, required this.nav})
    : super(key: key);

  final Future<dynamic> model;
  final Function nav;

  @override
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {
  final storage = new FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: widget.model,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return _buildCard(model: snapshot.data);
        } else if (snapshot.hasError) {
          return _buildCard(
            model: {
              'imageUrl': '',
              'firstName': 'การเชื่อมต่อขัดข้อง',
              'lastName': '',
              'isksp': false,
            },
          );
        } else {
          return Container();
          // return _buildCard(model: {
          //   'imageUrl': '',
          //   'firstName': '',
          //   'lastName': '',
          //   'isksp': false
          // });
        }
      },
    );
  }

  _buildCard({dynamic model}) {
    return Container(
      padding: EdgeInsets.all(15.0),
      alignment: Alignment.center,
      // decoration: BoxDecoration(
      //   // color: Theme.of(context).accentColor,
      //   // border: Border.all(color: Colors.white),
      //   borderRadius: BorderRadius.circular(15),
      //   image: model["isksp"]
      //       ? DecorationImage(
      //           image: AssetImage("assets/ksp_bgactive.png"),
      //           fit: BoxFit.cover,
      //         )
      //       : DecorationImage(
      //           image: AssetImage("assets/ksp_bginactive.png"),
      //           fit: BoxFit.cover,
      //         ),

      // ),
      // height: 145,
      // ),
      child: InkWell(
        onTap: () => widget.nav(),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(
                          '${model['imageUrl']}' != '' ? 0.0 : 5.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.black12,
                        ),
                        height: 50,
                        width: 50,
                        child: GestureDetector(
                          onTap: () => widget.nav(),
                          child:
                              model['imageUrl'] != '' &&
                                      model['imageUrl'] != null
                                  ? CircleAvatar(
                                    backgroundColor: Colors.black,
                                    backgroundImage:
                                        model['imageUrl'] != null
                                            ? NetworkImage(model['imageUrl'])
                                            : null,
                                  )
                                  : Container(
                                    padding: EdgeInsets.all(10.0),
                                    child: Image.asset(
                                      'assets/images/user_not_found.png',
                                      color:
                                          Theme.of(context).primaryColorLight,
                                    ),
                                  ),
                        ),
                      ),
                      model["iskspCategory"] != "" &&
                              model["iskspCategory"] != null
                          ? Expanded(
                            child: GestureDetector(
                              onTap: () => widget.nav(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: 375 * 3 / 100,
                                      right: 375 * 1 / 100,
                                    ),
                                    child: Text(
                                      '${model['firstName']} ${model['lastName']}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'Kanit',
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: 375 * 3 / 100,
                                      right: 375 * 1 / 100,
                                    ),
                                    child: Text(
                                      model["iskspCategory"],
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'Kanit',
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          : Expanded(
                            child: GestureDetector(
                              onTap: () => widget.nav(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: 375 * 3 / 100,
                                      right: 375 * 1 / 100,
                                    ),
                                    child: Text(
                                      "บุคคลทั่วไป",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'Kanit',
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: 375 * 3 / 100,
                                      right: 375 * 1 / 100,
                                    ),
                                    child: Text(
                                      '${model['firstName']} ${model['lastName']}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'Kanit',
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => widget.nav(),
                  child: Container(
                    width: 110.0,
                    // height: 20.0,
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.circular(10),
                      color: Color(0xFFFFFFFF),
                    ),
                    margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        model["iskspCategory"] != "" &&
                                model["iskspCategory"] != null
                            ? Image.asset(
                              'assets/icon_qr.png',
                              width: 16,
                              height: 16,
                            )
                            : Image.asset(
                              'assets/loading.png',
                              width: 16,
                              height: 16,
                            ),
                        SizedBox(width: 5),
                        model["iskspCategory"] != "" &&
                                model["iskspCategory"] != null
                            ? Text(
                              'การ์ดของฉัน',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12.0,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Kanit',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                            : Text(
                              'รอยืนยันตัวตน',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12.0,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Kanit',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
