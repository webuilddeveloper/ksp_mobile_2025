import 'dart:ui';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:ksp/shared/api_provider.dart';
import 'package:ksp/widget/blank.dart';
import 'package:ksp/widget/button.dart';
import 'package:ksp/widget/carousel.dart';
import 'package:ksp/widget/extension.dart';
import 'package:ksp/widget/gallery_view.dart';
import 'package:ksp/widget/link_url.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivilegeForm extends StatefulWidget {
  PrivilegeForm({Key? key, required this.code, this.model}) : super(key: key);
  final String code;
  final dynamic model;

  @override
  _PrivilegeDetailPageState createState() =>
      _PrivilegeDetailPageState(code: code);
}

class _PrivilegeDetailPageState extends State<PrivilegeForm> {
  _PrivilegeDetailPageState({required this.code});
  final storage = new FlutterSecureStorage();
  String profileCode = "";
  Future<dynamic> _futureModel = Future.value(null);
  Future<dynamic> _futureRotation = Future.value(null);
  // String _urlShared = '';
  String code;
  List urlImage = [];
  List<ImageProvider> urlImageProvider = [];

  @override
  void initState() {
    super.initState();
    readGallery();
    _futureModel = postDio('${privilegeApi}read', {
      'skip': 0,
      'limit': 1,
      'code': widget.code,
    });
    _futureRotation = postDio(rotationPrivilegeApi, {'limit': 10});
  }

  Future<dynamic> readGallery() async {
    profileCode = await storage.read(key: 'profileCode9') ?? "";
    final result = await postDio(privilegeGalleryApi, {'code': widget.code});

    // if (result['status'] == 'S') {
    List data = [];
    List<ImageProvider> dataPro = [];

    for (var item in result) {
      data.add(item['imageUrl']);
      if (item['imageUrl'] != null) {
        dataPro.add(NetworkImage(item['imageUrl']));
      }
    }
    setState(() {
      urlImage = data;
      urlImageProvider = dataPro;
    });
    // }
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.transparent,
    // ));

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
        backgroundColor: Colors.white,
        body: FutureBuilder<dynamic>(
          future: _futureModel, // function where you call your api
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            // AsyncSnapshot<Your object type>

            if (snapshot.hasData) {
              return myContent(snapshot.data[0]);
            } else {
              if (widget.model != null) {
                return myContent(widget.model);
              } else {
                return BlankLoading();
              }
            }
          },
        ),
      ),
    );
  }

  myContent(dynamic model) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    List image = ['${model['imageUrl']}'];
    List<ImageProvider> imagePro = [];
    if (model['imageUrl'] != null) {
      imagePro.add(NetworkImage(model['imageUrl']));
    }
    // return Container();
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView(
        shrinkWrap: true,
        children: [
          Stack(
            children: [
              Container(
                child: ListView(
                  shrinkWrap: true, // 1st add
                  physics: ClampingScrollPhysics(), // 2nd
                  children: [
                    Container(
                      // width: 500.0,
                      color: Color(0xFFFFFFF),
                      child: GalleryView(
                        imageUrl: [...image, ...urlImage],
                        imageProvider: [...imagePro, ...urlImageProvider],
                      ),
                    ),
                    Container(
                      // color: Colors.green,
                      padding: EdgeInsets.only(right: 10.0, left: 10.0),
                      margin: EdgeInsets.only(right: 50.0, top: 10.0),
                      child: Text(
                        '${model['title']}',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10, left: 10),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    model['imageUrlCreateBy'] != null
                                        ? NetworkImage(
                                          model['imageUrlCreateBy'],
                                        )
                                        : null,
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      model['createBy'],
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Kanit',
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          dateStringToDate(
                                                model['createDate'],
                                              ) +
                                              ' | ',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontFamily: 'Kanit',
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        Text(
                                          'เข้าชม ' +
                                              '${model['view']}' +
                                              ' ครั้ง',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontFamily: 'Kanit',
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(height: 10),
                    Container(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: Html(
                        data: model['description'],
                        onLinkTap:
                            (url, attributes, element) =>
                                launchUrl(Uri.parse(url ?? "")),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    model['linkUrl'] != '' && model['textButton'] != ''
                        ? Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 80.0),
                          child: Material(
                            elevation: 5.0,
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(color: Color(0xFFFF7514)),
                              ),
                              child: MaterialButton(
                                minWidth: MediaQuery.of(context).size.width,
                                onPressed: () {
                                  if (model['isPostHeader']) {
                                    var path = model['linkUrl'];
                                    if (profileCode != '') {
                                      var splitCheck =
                                          path.split('').reversed.join();
                                      if (splitCheck[0] != "/") {
                                        path = path + "/";
                                      }
                                      var codeReplae =
                                          "P" +
                                          profileCode.replaceAll('-', '') +
                                          model['code'].replaceAll('-', '');
                                      launchInWebViewWithJavaScript(
                                        '$path$codeReplae',
                                      );
                                      // launchURL(path);
                                    }
                                  } else
                                    launchURL(model['linkUrl']);
                                },
                                child: Text(
                                  model['textButton'],
                                  style: TextStyle(
                                    color: Color(0xFFFF7514),
                                    fontFamily: 'Kanit',
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        : Container(),
                    SizedBox(height: 20.0),
                    _buildRotation(),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                top: statusBarHeight + 5,
                child: Container(child: buttonCloseBack(context)),
              ),
            ],
            // overflow: Overflow.clip,
          ),
        ],
      ),
    );
  }

  _buildRotation() {
    return Container(
      // padding: EdgeInsets.only(left: 15, right: 15, top: 5),
      child: CarouselRotation(
        model: _futureRotation,
        nav: (String path, String action, dynamic model, String code) {
          if (action == 'out') {
            launchInWebViewWithJavaScript(path);
            // launchURL(path);
          } else if (action == 'in') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => CarouselForm(
                      code: code,
                      model: model,
                      url: mainBannerApi,
                      urlGallery: bannerGalleryApi,
                    ),
              ),
            );
          }
        },
      ),
    );
  }
}
