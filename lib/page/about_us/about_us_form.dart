import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ksp/widget/header.dart';
import 'package:ksp/widget/link_url.dart';
import 'package:ksp/widget/loading.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class AboutUsForm extends StatefulWidget {
  AboutUsForm({Key? key, required this.model, required this.title})
    : super(key: key);
  final String title;
  final Future<dynamic> model;

  @override
  _AboutUsForm createState() => _AboutUsForm();
}

class _AboutUsForm extends State<AboutUsForm> {
  // final Set<Marker> _markers = {};
  Completer<GoogleMapController> _mapController = Completer();

  @override
  void initState() {
    super.initState();
  }

  void goBack() async {
    Navigator.pop(context, false);
  }

  void launchURLMap(String lat, String lng) async {
    String homeLat = lat;
    String homeLng = lng;

    final String googleMapslocationUrl =
        "https://www.google.com/maps/search/?api=1&query=$homeLat,$homeLng";

    final String encodedURl = Uri.encodeFull(googleMapslocationUrl);

    launchUrl(Uri.parse(encodedURl), mode: LaunchMode.externalApplication);
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
      child: FutureBuilder<dynamic>(
        future: widget.model, // function where you call your api
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          // AsyncSnapshot<Your object type>
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              var lat = double.parse(
                snapshot.data['latitude'] != ''
                    ? snapshot.data['latitude']
                    : 0.0,
              );
              var lng = double.parse(
                snapshot.data['longitude'] != ''
                    ? snapshot.data['longitude']
                    : 0.0,
              );
              return Scaffold(
                appBar: header(context, goBack, title: 'เกี่ยวกับเรา'),
                body: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (OverscrollIndicatorNotification overScroll) {
                    return false;
                  },
                  child: ListView(
                    children: [
                      Stack(
                        children: [
                          Container(
                            child: loadingImageNetwork(
                              snapshot.data['imageBgUrl'],
                              height: 350.0,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // SubHeader(th: "เกี่ยวกับเรา", en: "About Us"),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(
                              top: 290.0,
                              left: 15.0,
                              right: 15.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 0,
                                  blurRadius: 7,
                                  offset: Offset(
                                    0,
                                    3,
                                  ), // changes position of shadow
                                ),
                              ],
                            ),
                            height: 120.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: loadingImageNetwork(
                                    snapshot.data['imageLogoUrl'],
                                    // fit: BoxFit.fill,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(
                                      left: 5.0,
                                      right: 5.0,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      snapshot.data['title'],
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Kanit',
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Container(
                                  constraints: BoxConstraints(minWidth: 60),
                                  padding: EdgeInsets.all(10.0),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          iconButton(
                            title: 'ที่ตั้ง',
                            image: Image.asset(
                              "assets/images/location_circle.png",
                            ),
                            onTap: () {
                              dialogLocation(context, snapshot);
                            },
                          ),
                          iconButton(
                            title: 'เบอร์ติดต่อ',
                            image: Image.asset(
                              "assets/images/phone_circle.png",
                            ),
                            onTap: () {
                              launchUrl(
                                Uri.parse(
                                  'tel://' + '${snapshot.data['telephone']}',
                                ),
                              );
                            },
                          ),
                          iconButton(
                            title: 'อีเมล',
                            image: Image.asset("assets/images/mail_circle.png"),
                            onTap: () {
                              launchURL(
                                'mailto:' + '${snapshot.data['email']}',
                              );
                            },
                          ),
                          iconButton(
                            title: 'เว็บไซต์',
                            image: Image.asset(
                              "assets/images/network_circle.png",
                            ),
                            onTap: () {
                              launchURL('${snapshot.data['site']}');
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          iconButton(
                            title: 'facebook',
                            image: Image.asset(
                              "assets/images/facebook_circle.png",
                            ),
                            onTap: () {
                              launchUrl(
                                Uri.parse('${snapshot.data['facebook']}'),
                              );
                            },
                          ),
                          iconButton(
                            title: 'instagram',
                            image: Image.asset(
                              "assets/images/instagram_circle.png",
                            ),
                            onTap: () {
                              launchUrl(
                                Uri.parse('${snapshot.data['instagram']}'),
                              );
                            },
                          ),
                          iconButton(
                            title: 'line',
                            image: Image.asset("assets/images/line_circle.png"),
                            onTap: () {
                              launchURL('${snapshot.data['lineOfficial']}');
                            },
                          ),
                          iconButton(
                            title: 'youtube',
                            image: Image.asset(
                              "assets/images/youtube_circle.png",
                            ),
                            onTap: () {
                              launchURL('${snapshot.data['youtube']}');
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      // googleMap(lat, lng),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: double.infinity,
                        child: googleMap(lat, lng),
                      ),
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
                                launchURLMap(lat.toString(), lng.toString());
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
                    ],
                  ),
                ),
              );
            } else {
              return ListView(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                // controller: _controller,
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 50),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 7,
                              offset: Offset(
                                0,
                                3,
                              ), // changes position of shadow
                            ),
                          ],
                        ),
                        // color: Colors.orange,
                        child: Image.network(
                          '',
                          height: 350,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // SubHeader(th: "เกี่ยวกับเรา", en: "About Us"),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                          top: 350.0,
                          left: 15.0,
                          right: 15.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 7,
                              offset: Offset(
                                0,
                                3,
                              ), // changes position of shadow
                            ),
                          ],
                        ),
                        height: 120.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              // color: Colors.orange,
                              padding: EdgeInsets.symmetric(vertical: 17.0),
                              child: Image.asset("assets/logo/logo.png"),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(
                                  left: 10.0,
                                  right: 5.0,
                                ),
                                child: Text(
                                  '',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Kanit',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      iconButton(
                        title: 'ที่ตั้ง',
                        image: Image.asset("assets/images/location_circle.png"),
                        onTap: () {},
                      ),
                      iconButton(
                        title: 'เบอร์ติดต่อ',
                        image: Image.asset("assets/images/phone_circle.png"),
                        onTap: () {},
                      ),
                      iconButton(
                        title: 'อีเมล',
                        image: Image.asset("assets/images/mail_circle.png"),
                        onTap: () {},
                      ),
                      iconButton(
                        title: 'เว็บไซต์',
                        image: Image.asset("assets/images/network_circle.png"),
                        onTap: () {},
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      iconButton(
                        title: 'facebook',
                        image: Image.asset("assets/images/facebook_circle.png"),
                        onTap: () {},
                      ),
                      iconButton(
                        title: 'instagram',
                        image: Image.asset(
                          "assets/images/instagram_circle.png",
                        ),
                        onTap: () {},
                      ),
                      iconButton(
                        title: 'line',
                        image: Image.asset("assets/images/line_circle.png"),
                        onTap: () {},
                      ),
                      iconButton(
                        title: 'เว็บไซต์',
                        image: Image.asset("assets/images/youtube_circle.png"),
                        onTap: () {},
                      ),
                    ],
                  ),
                  Container(
                    height: 300,
                    width: double.infinity,
                    child: googleMap(13.8462512, 100.5234803),
                  ),
                ],
              );
            }
          }
        },
      ),
    );
  }

  Future dialogLocation(BuildContext context, AsyncSnapshot snapshot) {
    return showDialog(
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.2),
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(30),
            height: 280,
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'ที่ตั้ง',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontFamily: 'Kanit',
                    fontSize: 25,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  '${snapshot.data['address']}',
                  style: TextStyle(fontFamily: 'Kanit', fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF6C6C6C), // กำหนดสีพื้นหลัง
                          padding: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              7.0,
                            ), // กำหนดมุมโค้ง
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'ยกเลิก',
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 15,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(
                                context,
                              ).primaryColor, // ใช้สีพื้นหลังจาก theme
                          padding: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              7.0,
                            ), // กำหนดมุมโค้ง
                          ),
                        ),
                        onPressed: () async {
                          String googleUrl =
                              'comgooglemaps://?center=${snapshot.data['latitude']},${snapshot.data['longitude']}';
                          String appleUrl =
                              'https://maps.apple.com/?sll=${snapshot.data['latitude']},${snapshot.data['longitude']}';
                          if (await canLaunchUrl(
                            Uri.parse("comgooglemaps://"),
                          )) {
                            print('launching com googleUrl');
                            await launchUrl(Uri.parse(googleUrl));
                          } else if (await canLaunchUrl(Uri.parse(appleUrl))) {
                            print('launching apple url');
                            await launchUrl(Uri.parse(appleUrl));
                          } else {
                            throw 'Could not launch url';
                          }
                        },
                        child: Text(
                          'ติดต่อ',
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 15,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  InkWell iconButton({
    required String title,
    required Widget image,
    required Function onTap,
  }) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        onTap();
      },
      child: Container(
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor,
              ),
              child: image,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 9,
                    color: Theme.of(context).primaryColor,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ),
          ],
        ),
      ),
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
          <Factory<OneSequenceGestureRecognizer>>[
            new Factory<OneSequenceGestureRecognizer>(
              () => new EagerGestureRecognizer(),
            ),
          ].toSet(),
      onMapCreated: (GoogleMapController controller) {
        _mapController.complete(controller);
      },
      // onTap: _handleTap,
      markers:
          <Marker>[
            Marker(
              markerId: MarkerId('1'),
              position: LatLng(lat, lng),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed,
              ),
            ),
          ].toSet(),
    );
  }

  Widget rowData({
    Image? image,
    String title = '',
    String value = '',
    String typeBtn = '',
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        children: [
          Container(
            width: 30.0,
            height: 30.0,
            decoration: BoxDecoration(
              color: Color(0xFFF5661F),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(padding: EdgeInsets.all(5.0), child: image),
          ),
          Expanded(
            child: InkWell(
              onTap:
                  () =>
                      typeBtn != ''
                          ? typeBtn == 'email'
                              ? launchURL('mailto:' + value)
                              : typeBtn == 'phone'
                              ? launch('tel://' + value)
                              : typeBtn == 'link'
                              ? launchURL(value)
                              : null
                          : null,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 10,
                    color: Color(0xFF1B6CA8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
