import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ksp/shared/api_provider.dart';
import 'package:ksp/widget/dialog.dart';
import 'package:ksp/widget/extension.dart';

// ignore: must_be_immutable
class Comment extends StatefulWidget {
  Comment({
    Key? key,
    required this.code,
    required this.url,
    required this.model,
    required this.limit,
  }) : super(key: key);

  final String code;
  final String url;
  Future<dynamic> model;
  final int limit;

  @override
  _Comment createState() => _Comment();
}

class _Comment extends State<Comment> {
  final txtDescription = TextEditingController();
  late FlutterSecureStorage storage;
  String username = '';
  String imageUrlCreateBy = '';
  bool hideDialog = true;
  String profileCode = '';

  // Future<dynamic> _futureModel;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtDescription.dispose();
    super.dispose();
  }

  @override
  void initState() {
    storage = FlutterSecureStorage();

    getUser();
    super.initState();
  }

  setDelayShowDialog() {
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        hideDialog = true;
        // Here you can write your code for open new view
      });
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: CupertinoAlertDialog(
              title: new Text(
                'ขอบคุณสำหรับความคิดเห็น',
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
                    "ยกเลิก",
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Kanit',
                      color: Theme.of(context).primaryColorDark,
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
    });
  }

  getUser() async {
    var profile = await storage.read(key: 'profileCode9') ?? "";
    var value = await storage.read(key: 'dataUserLoginKSP') ?? "";
    var data = json.decode(value);

    setState(() {
      profileCode = profile;
      imageUrlCreateBy = data['imageUrl'];
      username = data['firstName'] + ' ' + data['lastName'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 15, left: 15, right: 15),
          alignment: Alignment.centerLeft,
          child: Text(
            'แสดงความคิดเห็น',
            style: TextStyle(fontSize: 15, fontFamily: 'Kanit'),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 15, left: 15, right: 15),
          child: TextField(
            controller: txtDescription,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            maxLength: 100,
            style: TextStyle(fontSize: 13, fontFamily: 'Kanit'),
            // decoration: new InputDecoration(hintText: "Enter Something", contentPadding: const EdgeInsets.all(20.0)),
            decoration: InputDecoration(
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black.withAlpha(50),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                gapPadding: 1,
              ),
              hintText: 'แสดงความคิดเห็น',
              contentPadding: const EdgeInsets.all(10.0),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          alignment: Alignment.centerRight,
          // color: Colors.red,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor, // กำหนดสีพื้นหลังของปุ่ม
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              splashFactory: NoSplash.splashFactory, // ลบ splash effect
              // ถ้าคุณต้องการให้ปุ่มแสดงสีเมื่อไม่สามารถใช้งานได้ คุณสามารถใช้ `onSurface` ได้
              // onSurface: Colors.transparent, // กำหนดสีพื้นหลังเมื่อปุ่มไม่สามารถใช้งานได้ (ไม่จำเป็นต้องใช้ในกรณีนี้)
            ),
            child: Text(
              'ส่ง',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'Kanit',
              ),
            ),
            onPressed: () {
              sendComment();
            },
          ),
        ),
        FutureBuilder<dynamic>(
          // future: widget.model,
          future: widget.model,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return myComment(
                snapshot.data,
              ); 
            } else {
              return CommentLoading();
            }
          },
        ),
      ],
    );
  }

  myComment(dynamic model) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true, // 1st add
        physics: ClampingScrollPhysics(), // 2nd
        // scrollDirection: Axis.horizontal,
        itemCount: model.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Container(
              padding: EdgeInsets.all(
                '${model[index]['imageUrlCreateBy']}' != '' ? 0.0 : 5.0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17.5),
                color: Colors.black12,
              ),
              width: 35.0,
              height: 35.0,
              child:
                  '${model[index]['imageUrlCreateBy']}' != ''
                      ? CircleAvatar(
                        backgroundImage:
                            model[index]['imageUrlCreateBy'] != null
                                ? NetworkImage(
                                  '${model[index]['imageUrlCreateBy']}',
                                )
                                : null,
                      )
                      : Image.asset(
                        'assets/images/user_not_found.png',
                        color: Theme.of(context).colorScheme.secondary,
                      ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        top: 5,
                        bottom: 5,
                        left: 15,
                        right: 15,
                      ),
                      margin: EdgeInsets.only(
                        left: 1,
                        right: 15,
                        top: 5,
                        bottom: 1,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(10),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withAlpha(50)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${model[index]['createBy']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              fontFamily: 'Kanit',
                            ),
                          ),
                          Text(
                            '${model[index]['description']}',
                            style: TextStyle(fontSize: 13, fontFamily: 'Kanit'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    dateStringToDate(model[index]['createDate']),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.black.withAlpha(80),
                      fontFamily: 'Kanit',
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  sendComment() async {
    if (txtDescription.text != '') {
      postAny('${widget.url}create', {
            'createBy': username,
            'imageUrlCreateBy': imageUrlCreateBy,
            'reference': widget.code,
            'description': txtDescription.text,
            'profileCode': profileCode,
          })
          .then((response) {
            if (response == 'S') {
              txtDescription.text = '';

              unfocus(context);

              setState(() {
                widget.model = post('${widget.url}read', {
                  'skip': 0,
                  'limit': widget.limit,
                  'code': widget.code,
                });
              });
              // helloWorld();
              toastFail(context, text: 'ขอบคุณสำหรับความคิดเห็น', duration: 4);
            } else {
              return showDialog(
                context: context,
                builder: (BuildContext context) {
                  return WillPopScope(
                    onWillPop: () {
                      return Future.value(false);
                    },
                    child: CupertinoAlertDialog(
                      title: new Text(
                        'ไม่สามารถแสดงความคิดเห็นได้',
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
                              color: Theme.of(context).primaryColor,
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
          })
          .catchError((onError) {
            return showDialog(
              context: context,
              builder: (BuildContext context) {
                return WillPopScope(
                  onWillPop: () {
                    return Future.value(false);
                  },
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
                            color: Theme.of(context).primaryColorDark,
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
          });
    }
  }
}


class CommentLoading extends StatefulWidget {
  // CardLoading({Key key, this.title}) : super(key: key);

  // final String title;

  @override
  _CommentLoading createState() => _CommentLoading();
}

class _CommentLoading extends State<CommentLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Animatable<Color?> background = TweenSequence<Color?>([
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: Colors.black.withAlpha(20),
        end: Colors.black.withAlpha(50),
      ),
    ),
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: Colors.black.withAlpha(50),
        end: Colors.black.withAlpha(20),
      ),
    ),
  ]);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true, // 1st add
        physics: ClampingScrollPhysics(), // 2nd
        // scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Container(
                padding: EdgeInsets.all(5),
                alignment: Alignment.topLeft,
                height: 50,
                // decoration: BoxDecoration(
                //   borderRadius: new BorderRadius.circular(50),
                //   color: background.evaluate(
                //     AlwaysStoppedAnimation(_controller.value),
                //   ),
                // ),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      // padding: EdgeInsets.only(
                      //     top: 5, bottom: 5, left: 15, right: 15),
                      width: index == 0 ? 150 : index == 1 ? 250 : 200,
                      margin: EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Container(
                          
                            height: 40,
                        
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
