import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart' show Html;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ksp/shared/api_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ksp/widget/carousel.dart';
import 'package:ksp/widget/extension.dart';
import 'package:ksp/widget/gallery_view.dart';
import 'package:ksp/widget/link_url.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

// ignore: must_be_immutable
class Content extends StatefulWidget {
  Content({
    Key? key,
    required this.code,
    required this.url,
    this.model,
    required this.urlGallery,
    required this.urlRotation,
    required this.pathShare,
  }) : super(key: key);

  final String code;
  final String url;
  final dynamic model;
  final String urlGallery;
  final String urlRotation;
  final String pathShare;

  @override
  _Content createState() => _Content();
}

class _Content extends State<Content> {
  Future<dynamic> _futureModel = Future.value(null);
  Future<dynamic> _futureRotation = Future.value(null);
  final storage = FlutterSecureStorage();

  String _urlShared = '';
  List urlImage = [];
  List<ImageProvider> urlImageProvider = [];

  @override
  void initState() {
    initFunc();
    sharedApi();

    readGallery();
    super.initState();
  }

  initFunc() async {
    _futureModel = postDio(widget.url, {
      'skip': 0,
      'limit': 1,
      'code': widget.code,
    });
    _futureRotation = postDio(widget.urlRotation, {'limit': 10});
  }

  Future<dynamic> readGallery() async {
    final result = await postDio(widget.urlGallery, {'code': widget.code});

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

  Future<dynamic> sharedApi() async {
    print('----- sharedApi -----');
    await postConfigShare().then(
      (result) => {
        if (result['status'] == 'S')
          {
            setState(() {
              _urlShared = result['objectData']['description'];
            }),
          },
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _futureModel, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>
        if (snapshot.hasData) {
          // setState(() {
          //   urlImage = [snapshot.data[0].imageUrl];
          // });
          return myContent(
            snapshot.data[0],
          ); //   return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return myContent(widget.model);
          // return myContent(widget.model);
        }
      },
    );
  }

  myContent(dynamic model) {
    List image = ['${model['imageUrl']}'];
    List<ImageProvider> imagePro = [];
    if (model['imageUrl'] != null) {
      imagePro = [NetworkImage(model['imageUrl'])];
    }
    return ListView(
      shrinkWrap: true, // 1st add
      physics: ClampingScrollPhysics(), // 2nd
      children: [
        if (model['imageUrl'] != '' && model['imageUrl'] != null)
          Container(
            // width: 500.0,
            // color: Color(0xFFFFFFF),
            color: Colors.white,
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
                  Container(
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(model['imageUrlCreateBy']),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${model['createBy']}',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w300,
                          ),
                          maxLines: 3,
                        ),
                        Row(
                          children: [
                            Text(
                              model['createDate'] != null
                                  ? dateStringToDate(model['createDate']) +
                                      ' | '
                                  : '',
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Text(
                              'เข้าชม ' + '${model['view']}' + ' ครั้ง',
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
                  Container(
                    width: MediaQuery.of(context).size.width * 0.24,
                    child: Container(
                      width: 100.0,
                      height: 35.0,
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.all(0.0),
                          tapTargetSize:
                              MaterialTapTargetSize
                                  .shrinkWrap, // ปรับขนาดของปุ่ม
                        ),
                        onPressed: () {
                          final RenderBox box =
                              context.findRenderObject() as RenderBox;
                          Share.share(
                            '$_urlShared${widget.pathShare}${model['code']} ${model['title']}',
                            subject: '${model['title']}',
                            sharePositionOrigin:
                                box.localToGlobal(Offset.zero) & box.size,
                          );
                        },
                        child: Image.asset('assets/images/share.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(height: 10),
        Padding(
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: Html(
            data: model['description'],
            onLinkTap:
                (url, attributes, element) => launchUrl(Uri.parse(url ?? "")),
          ),
        ),
        Container(height: 10),
        model['linkUrl'] != '' && model['textButton'] != ''
            ? linkButton(model)
            : Container(),
        Container(height: 10),
        model['fileUrl'] != '' ? fileUrl(model) : Container(),
        SizedBox(height: 10),
        if (widget.urlRotation != '') _buildRotation(),
      ],
    );
  }

  linkButton(dynamic model) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 45.0,
      padding: EdgeInsets.symmetric(horizontal: 80.0),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(color: Theme.of(context).colorScheme.secondary),
          ),
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            onPressed: () {
              launchURL('${model['linkUrl']}');
            },
            child: Text(
              '${model['textButton']}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontFamily: 'Kanit',
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ),
      ),
    );
  }

  fileUrl(dynamic model) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {
          launchURL('${model['fileUrl']}');
        },
        child: Text(
          'เปิดเอกสารแนบ',
          style: TextStyle(
            fontFamily: 'Kanit',
            fontSize: 14.0,
            color: Theme.of(context).colorScheme.secondary,
            decoration: TextDecoration.underline,
          ),
        ),
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

// ignore: must_be_immutable
class ContentCarousel extends StatefulWidget {
  ContentCarousel({
    Key? key,
    required this.code,
    required this.url,
    this.model,
    required this.urlGallery,
  }) : super(key: key);

  final String code;
  final String url;
  final dynamic model;
  final String urlGallery;

  @override
  _ContentCarousel createState() => _ContentCarousel();
}

class _ContentCarousel extends State<ContentCarousel> {
  late Future<dynamic> _futureModel;

  // String _urlShared = '';
  List urlImage = [];
  List<ImageProvider> urlImageProvider = [];

  @override
  void initState() {
    super.initState();
    _futureModel = post(widget.url, {
      'skip': 0,
      'limit': 1,
      'code': widget.code,
    });
    readGallery();
    // sharedApi();
  }

  Future<dynamic> readGallery() async {
    final result = await postObjectData(widget.urlGallery, {
      'code': widget.code,
    });

    if (result['status'] == 'S') {
      List data = [];
      List<ImageProvider> dataPro = [];

      for (var item in result['objectData']) {
        data.add(item['imageUrl']);

        dataPro.add(NetworkImage(item['imageUrl']));
      }
      setState(() {
        urlImage = data;
        urlImageProvider = dataPro;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _futureModel, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>
        if (snapshot.hasData) {
          // setState(() {
          //   urlImage = [snapshot.data[0].imageUrl];
          // });
          return myContent(
            snapshot.data[0],
          ); //   return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return myContent(widget.model);
          // return myContent(widget.model);
        }
      },
    );
  }

  myContent(dynamic model) {
    List image = [model['imageUrl']];
    List<ImageProvider> imagePro = [NetworkImage(model['imageUrl'])];
    return ListView(
      shrinkWrap: true, // 1st add
      physics: ClampingScrollPhysics(), // 2nd
      children: [
        Container(
          // color: Colors.green,
          padding: EdgeInsets.only(right: 10.0, left: 10.0),
          margin: EdgeInsets.only(right: 50.0, top: 10.0),
          child: Text(
            '${model['title']}',
            style: TextStyle(fontSize: 20, fontFamily: 'Kanit'),
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
                    backgroundImage: NetworkImage(
                      '${model['imageUrlCreateBy']}',
                    ),
                    // child: Image.network(
                    //     '${snapshot.data[0]['imageUrlCreateBy']}'),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${model['createBy']}',
                          style: TextStyle(fontSize: 15, fontFamily: 'Kanit'),
                        ),
                        Row(
                          children: [
                            Text(
                              dateStringToDate(model['createDate']),
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'Kanit',
                              ),
                            ),
                            // Text(
                            //   ' | ' + 'เข้าชม ' + '${model['view']}' + ' ครั้ง',
                            //   style: TextStyle(
                            //     fontSize: 10,
                            //     fontFamily: 'Kanit',
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Container(
            //   width: 74.0,
            //   height: 31.0,
            //   decoration: BoxDecoration(
            //       image: DecorationImage(
            //     image: AssetImage('assets/images/share.png'),
            //   )),
            //   alignment: Alignment.centerRight,
            //   child: FlatButton(
            //     padding: EdgeInsets.all(0.0),
            //     onPressed: () {
            //       final RenderBox box = context.findRenderObject();
            //       Share.share(
            //         _urlShared +
            //             'content/news/' +
            //             '${model['code']}' +
            //             '${model['title']}',
            //         subject: '${model['title']}',
            //         sharePositionOrigin:
            //             box.localToGlobal(Offset.zero) & box.size,
            //       );
            //     },
            //   ),
            // )
          ],
        ),
        Container(
          // width: 500.0,
          color: Color(0x0fffffff),
          child: GalleryView(
            imageUrl: [...image, ...urlImage],
            imageProvider: [...imagePro, ...urlImageProvider],
          ),
        ),
        Container(height: 10),
        // Image.network('${model['imageUrl']}'),
        // Container(
        //   height: 20,
        // ),
        Padding(
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: Html(
            data: model['description'],
            onLinkTap:
                (url, attributes, element) => launchUrl(Uri.parse(url ?? "")),
            // onLinkTap: (String url, RenderContext context,
            //     Map<String, String> attributes, element) {
            //   launch(url);
            //   //open URL in webview, or launch URL in browser, or any other logic here
            // },
          ),
        ),
      ],
    );
  }
}

class ContentEventCalendar extends StatefulWidget {
  ContentEventCalendar({
    Key? key,
    required this.code,
    required this.url,
    this.model,
    required this.urlGallery,
    required this.urlRotation,
    required this.pathShare,
  }) : super(key: key);

  final String code;
  final String url;
  final dynamic model;
  final String urlGallery;
  final String urlRotation;
  final String pathShare;

  @override
  _ContentEventCalendar createState() => _ContentEventCalendar();
}

class _ContentEventCalendar extends State<ContentEventCalendar> {
  Future<dynamic> _futureModel = Future.value(null);
  Future<dynamic> _futureRotation = Future.value(null);
  final storage = FlutterSecureStorage();

  String _urlShared = '';
  List urlImage = [];
  List<ImageProvider> urlImageProvider = [];

  @override
  void initState() {
    super.initState();
    initFunc();
    sharedApi();

    readGallery();
  }

  initFunc() async {
    _futureModel = postDio(widget.url, {
      'skip': 0,
      'limit': 1,
      'code': widget.code,
    });
    _futureRotation = postDio(widget.urlRotation, {'limit': 10});
  }

  Future<dynamic> readGallery() async {
    final result = await postDio(widget.urlGallery, {'code': widget.code});

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

  Future<dynamic> sharedApi() async {
    await postConfigShare().then(
      (result) => {
        if (result['status'] == 'S')
          {
            setState(() {
              _urlShared = result['objectData']['description'];
            }),
          },
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _futureModel, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return myContent(snapshot.data[0]);
        } else {
          return myContent(widget.model);
        }
      },
    );
  }

  myContent(dynamic model) {
    List image = ['${model['imageUrl']}'];

    List<ImageProvider> imagePro = [];
    if (model['imageUrl'] != null) {
      imagePro.add(NetworkImage(model['imageUrl']));
    }
    return ListView(
      shrinkWrap: true, // 1st add
      physics: ClampingScrollPhysics(), // 2nd
      children: [
        Container(
          // width: 500.0,
          // color: Color(0xFFFFFFF),
          color: Colors.white,
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
                  Container(
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(model['imageUrlCreateBy']),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${model['createBy']}',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w300,
                          ),
                          maxLines: 3,
                        ),
                        Row(
                          children: [
                            Text(
                              model['createDate'] != null
                                  ? dateStringToDate(model['createDate']) +
                                      ' | '
                                  : '',
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Text(
                              'เข้าชม ' + '${model['view']}' + ' ครั้ง',
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          // margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
                          child: Text(
                            (model['dateStart'] != '' &&
                                        model['dateStart'] != 'Invalid date') &&
                                    (model['dateEnd'] != '' &&
                                        model['dateEnd'] != 'Invalid date')
                                ? 'วันที่จัดกิจกรรม: ' +
                                    dateStringToDate(model['dateStart']) +
                                    " - " +
                                    dateStringToDate(model['dateEnd'])
                                : 'วันที่จัดกิจกรรม: -',
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontFamily: 'Kanit',
                              fontSize: 10,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.24,
                    child: Container(
                      width: 100.0,
                      height: 35.0,
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.all(
                            0.0,
                          ), // กำหนด padding ตามที่ต้องการ
                          backgroundColor:
                              Colors
                                  .transparent, // ใช้สีที่โปร่งใสเพื่อไม่ให้มีสีพื้นหลัง
                        ),
                        onPressed: () {
                          final RenderBox box =
                              context.findRenderObject() as RenderBox;
                          Share.share(
                            '$_urlShared${widget.pathShare}${model['code']} ${model['title']}',
                            subject: '${model['title']}',
                            sharePositionOrigin:
                                box.localToGlobal(Offset.zero) & box.size,
                          );
                        },
                        child: Image.asset('assets/images/share.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(height: 10),
        Padding(
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: Html(
            data: model['description'],
            onLinkTap:
                (url, attributes, element) => launchUrl(Uri.parse(url ?? "")),
          ),
        ),
        Container(height: 10),
        model['linkUrl'] != '' && model['textButton'] != ''
            ? linkButton(model)
            : Container(),
        Container(height: 10),
        model['fileUrl'] != '' ? fileUrl(model) : Container(),
        SizedBox(height: 10),
        if (widget.urlRotation != '') _buildRotation(),
      ],
    );
  }

  linkButton(dynamic model) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 45.0,
      padding: EdgeInsets.symmetric(horizontal: 80.0),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(color: Color(0xFF99722F)),
          ),
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            onPressed: () {
              launchURL('${model['linkUrl']}');
            },
            child: Text(
              '${model['textButton']}',
              style: TextStyle(color: Color(0xFF99722F), fontFamily: 'Kanit'),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ),
      ),
    );
  }

  fileUrl(dynamic model) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {
          launchURL('${model['fileUrl']}');
        },
        child: Text(
          'เปิดเอกสารแนบ',
          style: TextStyle(
            fontFamily: 'Kanit',
            fontSize: 14.0,
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
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

class ContentWithOutShare extends StatefulWidget {
  ContentWithOutShare({
    Key? key,
    required this.code,
    this.model,
    required this.urlGallery,
    this.urlRotation = '',
  }) : super(key: key);

  final String code;
  final dynamic model;
  final String urlGallery;
  final String urlRotation;

  @override
  _ContentWithOutShare createState() => _ContentWithOutShare();
}

class _ContentWithOutShare extends State<ContentWithOutShare> {
  Future<dynamic> _futureRotation = Future.value(null);
  final storage = FlutterSecureStorage();

  List urlImage = [];
  List<ImageProvider> urlImageProvider = [];

  @override
  void initState() {
    super.initState();
    initFunc();

    readGallery();
  }

  initFunc() async {
    _futureRotation = postDio(widget.urlRotation, {'limit': 10});
  }

  Future<dynamic> readGallery() async {
    final result = await postDio(widget.urlGallery, {'code': widget.code});

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
    return myContentWithOutShare(widget.model);
  }

  myContentWithOutShare(dynamic model) {
    List image = ['${model['imageUrl']}'];
    List<ImageProvider> imagePro = [];
    if (model['imageUrl'] != null) {
      imagePro.add(NetworkImage(model['imageUrl']));
    }
    return ListView(
      shrinkWrap: true, // 1st add
      physics: ClampingScrollPhysics(), // 2nd
      children: [
        Container(
          // width: 500.0,
          // color: Color(0xFFFFFFF),
          color: Colors.white,
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
                  Container(
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(model['imageUrlCreateBy']),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${model['createBy']}',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w300,
                          ),
                          maxLines: 3,
                        ),
                        Row(
                          children: [
                            Text(
                              model['createDate'] != null
                                  ? dateStringToDate(model['createDate'])
                                  // + ' | '
                                  : '',
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            // Text(
                            //   'เข้าชม ' + '${model['view']}' + ' ครั้ง',
                            //   style: TextStyle(
                            //     fontSize: 10,
                            //     fontFamily: 'Kanit',
                            //     fontWeight: FontWeight.w300,
                            //   ),
                            // ),
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
        Padding(
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: Html(
            data: model['description'],
            onLinkTap:
                (url, attributes, element) => launchUrl(Uri.parse(url ?? "")),
          ),
        ),
        Container(height: 10),
        model['linkUrl'] != '' ? linkButton(model) : Container(),
        Container(height: 10),
        model['fileUrl'] != '' ? fileUrl(model) : Container(),
        SizedBox(height: 10),
        if (widget.urlRotation != '') _buildRotation(),
      ],
    );
  }

  linkButton(dynamic model) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 45.0,
      padding: EdgeInsets.symmetric(horizontal: 80.0),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(color: Color(0xFF1B6CA8)),
          ),
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            onPressed: () {
              launchURL('${model['linkUrl']}');
            },
            child: Text(
              '${model['textButton']}',
              style: TextStyle(color: Color(0xFF1B6CA8), fontFamily: 'Kanit'),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ),
      ),
    );
  }

  fileUrl(dynamic model) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {
          launchURL('${model['fileUrl']}');
        },
        child: Text(
          'เปิดเอกสารแนบ',
          style: TextStyle(
            fontFamily: 'Kanit',
            fontSize: 14.0,
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
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

// ignore: must_be_immutable
class ContentPoi extends StatefulWidget {
  ContentPoi({
    Key? key,
    required this.code,
    required this.url,
    this.model,
    required this.urlGallery,
    required this.pathShare,
    this.urlRotation = '',
  }) : super(key: key);

  final String code;
  final String url;
  final dynamic model;
  final String urlGallery;
  final String pathShare;
  final String urlRotation;

  @override
  _ContentPoi createState() => _ContentPoi();
}

class _ContentPoi extends State<ContentPoi> {
  Future<dynamic> _futureModel = Future.value(null);
  Future<dynamic> _futureRotation = Future.value(null);

  String _urlShared = '';
  List urlImage = [];
  List<ImageProvider> urlImageProvider = [];

  final Completer<GoogleMapController> _mapController = Completer();
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    initFunc();
    readGallery();
    sharedApi();
  }

  initFunc() async {
    _futureModel = postDio('${widget.url}read', {
      'skip': 0,
      'limit': 1,
      'code': widget.code,
    });
    _futureRotation = postDio(widget.urlRotation, {'limit': 10});
  }

  Future<dynamic> readGallery() async {
    final result = await postDio(widget.urlGallery, {'code': widget.code});

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

  Future<dynamic> sharedApi() async {
    await postConfigShare().then(
      (result) => {
        if (result['status'] == 'S')
          {
            setState(() {
              _urlShared = result['objectData']['description'];
            }),
          },
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _futureModel, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>
        if (snapshot.hasData) {
          return myContentPoi(snapshot.data[0]);
        } else {
          return myContentPoi(widget.model);
        }
      },
    );
  }

  myContentPoi(dynamic model) {
    List image = ['${model['imageUrl']}'];
    List<ImageProvider> imagePro = [];
    if (model['imageUrl'] != null) {
      imagePro.add(NetworkImage(model['imageUrl']));
    }
    return ListView(
      shrinkWrap: true, // 1st add
      physics: ClampingScrollPhysics(), // 2nd
      children: [
        Container(
          // width: 500.0,
          color: Color(0x0fffffff),
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
                            ? NetworkImage(model['imageUrlCreateBy'])
                            : null,
                    // child: Image.network(
                    //     '${snapshot.data[0]['imageUrlCreateBy']}'),
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
                              dateStringToDate(model['createDate']) + ' | ',
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Text(
                              'เข้าชม ' + '${model['view']}' + ' ครั้ง',
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
            Container(
              width: 74.0,
              height: 31.0,

              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent, // สีพื้นหลัง
                  foregroundColor: Colors.black, // สีข้อความ
                  padding: EdgeInsets.all(0.0),
                  shadowColor: Colors.transparent, // ปิดเงา
                ),
                onPressed: () {
                  final RenderBox box = context.findRenderObject() as RenderBox;
                  Share.share(
                    '$_urlShared${widget.pathShare}${model['code']} ${model['title']}',
                    subject: '${model['title']}',
                    sharePositionOrigin:
                        box.localToGlobal(Offset.zero) & box.size,
                  );
                },
                child: Image.asset('assets/images/share.png'),
              ),
            ),
          ],
        ),
        Container(height: 10),
        Padding(
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: Html(
            data: model['description'],
            onLinkTap:
                (url, attributes, element) => launchUrl(Uri.parse(url ?? "")),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: Text(
            'ที่ตั้ง',
            style: TextStyle(fontSize: 15, fontFamily: 'Kanit'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: Text(
            model['address'] != '' ? model['address'] : '-',
            style: TextStyle(fontSize: 10, fontFamily: 'Kanit'),
          ),
        ),
        SizedBox(height: 10),
        if (widget.urlRotation != '') _buildRotation(),
        SizedBox(height: 10),
        Container(
          height: 400,
          width: double.infinity,
          child: googleMap(
            model['latitude'] != ''
                ? double.parse(model['latitude'])
                : 13.8462512,
            model['longitude'] != ''
                ? double.parse(model['longitude'])
                : 100.5234803,
          ),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(15),
          color: Colors.transparent,
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: Color(0xFFF58A33)),
              ),
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                onPressed: () {
                  _launchURLMap(
                    model['latitude'] ?? '',
                    model['longitude'] ?? '',
                  );
                },
                child: Text(
                  'ตำแหน่ง Google Map',
                  style: TextStyle(
                    color: Color(0xFFF58A33),
                    fontFamily: 'Kanit',
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  googleMap(double lat, double lng) {
    return GoogleMap(
      myLocationEnabled: true,
      compassEnabled: true,
      tiltGesturesEnabled: false,
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(target: LatLng(lat, lng), zoom: 16),
      gestureRecognizers:
          <Factory<OneSequenceGestureRecognizer>>{
            Factory<OneSequenceGestureRecognizer>(
              () => EagerGestureRecognizer(),
            ),
          },
      onMapCreated: (GoogleMapController controller) {
        _mapController.complete(controller);
      },
      // onTap: _handleTap,
      markers:
          <Marker>{
            Marker(
              markerId: MarkerId('1'),
              position: LatLng(lat, lng),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed,
              ),
            ),
          },
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

  void _launchURLMap(String lat, String lng) async {
    String homeLat = lat;
    String homeLng = lng;

    final String googleMapslocationUrl =
        "https://www.google.com/maps/search/?api=1&query=$homeLat,$homeLng";

    final String encodedURl = Uri.encodeFull(googleMapslocationUrl);

    launchUrl(Uri.parse(encodedURl), mode: LaunchMode.externalApplication);
  }
}
