import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:ksp/page/poi/poi_form.dart';
import 'package:ksp/page/poi/poi_list_vertical.dart';
import 'package:ksp/widget/blank.dart';
import 'package:ksp/widget/dialog.dart';
import 'package:ksp/widget/extension.dart';
import 'package:ksp/widget/header.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ksp/shared/api_provider.dart';
import 'package:ksp/widget/key_search.dart';
import 'package:ksp/widget/scroll_behavior.dart';
import 'package:ksp/widget/tab_category.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PoiList extends StatefulWidget {
  PoiList({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _PoiList createState() => _PoiList();
}

class _PoiList extends State<PoiList> {
  Completer<GoogleMapController> _mapController = Completer();

  final txtDescription = TextEditingController();
  bool hideSearch = true;
  String keySearch = '';
  String category = '';
  int _limit = 10;

  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );
  final RefreshController _refreshPanelController = RefreshController(
    initialRefresh: false,
  );

  PoiListVertical gridView = PoiListVertical(model: Future.value(null),);
  Future<dynamic> _futureModel = Future.value(null);
  late LatLngBounds initLatLngBounds;

  late double positionScroll;
  bool showMap = true;
  late LatLng latLng;

  // Future<dynamic> _futureModel;
  late Future<dynamic> futureCategory;
  List<dynamic> listTemp = [
    {
      'code': '',
      'title': '',
      'imageUrl': '',
      'createDate': '',
      'userList': [
        {'imageUrl': '', 'firstName': '', 'lastName': ''},
      ],
    },
  ];
  bool showLoadingItem = true;
  bool _linearLoading = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtDescription.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _determinePosition();
      // print('_determinePosition --> ${_determinePosition()}');
      await _getLocation();
    });

    futureCategory = postCategory('${poiCategoryApi}read', {
      'skip': 0,
      'limit': 100,
    });
  }

  _determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    } else if (permission == LocationPermission.always) {
    } else if (permission == LocationPermission.whileInUse) {
    } else if (permission == LocationPermission.unableToDetermine) {
    } else {
      throw Exception('Error');
    }
    return await Geolocator.getCurrentPosition();
  }

  _getLocation() async {
    // Position position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.best);

    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.best, // เลือกความแม่นยำที่ดีที่สุด
      distanceFilter: 10, // กำหนดระยะห่างการอัปเดตตำแหน่ง
    );

    Position position = await Geolocator.getCurrentPosition(
      locationSettings:
          locationSettings, // ใช้ locationSettings แทน desiredAccuracy
    );

    setState(() {
      latLng = LatLng(position.latitude, position.longitude);
      initLatLngBounds = LatLngBounds(
        southwest: LatLng(position.latitude - 0.2, position.longitude - 0.15),
        northeast: LatLng(position.latitude + 0.1, position.longitude + 0.1),
      );
    });
    _setFuture();
  }

  _setFuture() {
    setState(() {
      _futureModel = postDio('${poiApi}read', {
        'skip': 0,
        'limit': _limit,
        'category': category,
        "keySearch": keySearch,
        'latitude': latLng.latitude,
        'longitude': latLng.longitude,
      });
      gridView = PoiListVertical(model: _futureModel);
    });
  }

  void _onLoading() async {
    setState(() {
      _limit = _limit + 10;
    });
    _setFuture();
    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.loadComplete();
    _refreshPanelController.loadComplete();
  }

  void changeTab() async {
    // Navigator.pop(context, false);
    setState(() {
      showMap = !showMap;
    });
  }

  void goBack() async {
    Navigator.pop(context, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: headerCalendar(
        context,
        title: widget.title,
        isCenter: true,
        isShowLogo: false,
        isShowButtonPoi: true, // เพื่อให้โชว์ปุ่มขวาบน
        isButtonPoi: showMap, //ปุ่มที่เริ่มโชว์คือปุ่ม List
        callBackClickButtonCalendar:
            () => setState(() {
              showMap = !showMap;
              _limit = 10;
              _setFuture();

              futureCategory = postCategory('${poiCategoryApi}read', {
                'skip': 0,
                'limit': 100,
              });
            }),
      ),
      body: ScrollConfiguration(
        behavior: CsBehavior(),
        child: showMap ? _buildMap() : _buildList(),
      ),
    );
  }

  // show map
  SlidingUpPanel _buildMap() {
    double _panelHeightOpen =
        MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + 50);
    double _panelHeightClosed = 90;
    return SlidingUpPanel(
      maxHeight: _panelHeightOpen,
      minHeight: _panelHeightClosed,
      parallaxEnabled: true,
      parallaxOffset: .5,
      body: Container(
        padding: EdgeInsets.only(
          bottom: _panelHeightClosed + MediaQuery.of(context).padding.top + 50,
        ),
        child: googleMap(_futureModel),
      ),
      panelBuilder: (sc) => _panel(sc),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(5.0),
        topRight: Radius.circular(5.0),
      ),
      onPanelSlide:
          (double pos) => {
            setState(() {
              positionScroll = pos;
            }),
          },
    );
  }

  FutureBuilder googleMap(modelData) {
    List<Marker> _markers = <Marker>[];

    return FutureBuilder<dynamic>(
      future: modelData, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            snapshot.data
                .map(
                  (item) => _markers.add(
                    Marker(
                      markerId: MarkerId(item['code']),
                      position: LatLng(
                        double.parse(item['latitude']),
                        double.parse(item['longitude']),
                      ),
                      infoWindow: InfoWindow(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => PoiForm(
                                    code: item['code'],
                                    model: item,
                                    url: poiApi,
                                    urlComment: poiCommentApi,
                                    urlGallery: poiGalleryApi,
                                  ),
                            ),
                          );
                        },
                        title: item['title'].toString(),
                      ),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed,
                      ),
                    ),
                  ),
                )
                .toList();
          }

          return GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            compassEnabled: true,
            tiltGesturesEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(target: latLng, zoom: 15),
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            },
            onMapCreated: (GoogleMapController controller) {
              controller.moveCamera(
                CameraUpdate.newLatLngBounds(initLatLngBounds, 5.0),
              );
              controller.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(target: latLng, zoom: 15),
                ),
              );
              _mapController.complete(controller);
            },
            markers:
                snapshot.data.length > 0
                    ? _markers.toSet()
                    : <Marker>{
                      Marker(
                        markerId: MarkerId('1'),
                        position: LatLng(0.00, 0.00),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueRed,
                        ),
                      ),
                    },
          );
        } else if (snapshot.hasError) {
          return Center(child: Container(child: dialogFail(context)));
        } else {
          return Container();
        }
      },
    );
  }

  Widget _panel(ScrollController sc) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: SmartRefresher(
        enablePullDown: false,
        enablePullUp: true,
        footer: ClassicFooter(
          loadingText: ' ',
          canLoadingText: ' ',
          idleText: ' ',
          idleIcon: Icon(Icons.arrow_upward, color: Colors.transparent),
        ),
        controller: _refreshPanelController,
        onLoading: _onLoading,
        child: ListView(
          controller: sc,
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 10),
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey,
                ),
                height: 4,
              ),
              // child: AnimatedOpacity(
              //   opacity: positionScroll < 0.9 ? 1.0 : 0.0,
              //   duration: Duration(milliseconds: 300),
              //   child: Container(
              //     margin: EdgeInsets.only(top: 10),
              //     width: 40,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(5),
              //       color: Colors.grey,
              //     ),
              //     height: 4,
              //   ),
              // ),
            ),
            Container(
              height: 35,
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                'จุดบริการ',
                style: TextStyle(
                  fontFamily: 'Sarabun',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // child: Icon(
              //   Icons.arrow_circle_up,
              //   color: Theme.of(context).primaryColor,
              // ),
            ),
            // : Container(),
            SizedBox(height: 5),
            Container(child: gridView),
          ],
        ),
      ),
    );
  }
  // end show map

  // -------------------------------

  // show content
  Container _buildList() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          if (_linearLoading)
            LinearProgressIndicator(
              color: Color(0xFFF58A33).withOpacity(0.8),
              backgroundColor: Color(0xFFF58A33).withOpacity(0.3),
            ),
          SizedBox(height: 5),
          CategorySelector(
            model: futureCategory,
            onChange: (String val) {
              setData(val, keySearch);
              setState(() {
                showLoadingItem = true;
              });
            },
          ),
          SizedBox(height: 5),
          KeySearch(
            show: hideSearch,
            onKeySearchChange: (String val) {
              setData(category, val);
            },
          ),
          SizedBox(height: 10),
          Expanded(child: buildList()),
        ],
      ),
    );
  }

  FutureBuilder buildList() {
    return FutureBuilder<dynamic>(
      future: _futureModel, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          if (showLoadingItem) {
            return blankListData(context, height: 300);
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _linearLoading = true;
              });
            });
            return refreshList(listTemp);
          }
        } else if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Container(
              alignment: Alignment.center,
              height: 200,
              child: Text(
                'ไม่พบข้อมูล',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Sarabun',
                  color: Colors.grey,
                ),
              ),
            );
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _linearLoading = false;
                showLoadingItem = false;
                listTemp = snapshot.data;
              });
            });
            return refreshList(snapshot.data);
          }
        } else if (snapshot.hasError) {
          // return dialogFail(context);
          return InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              setState(() {
                futureCategory = postCategory('${poiCategoryApi}read', {
                  'skip': 0,
                  'limit': 100,
                });
              });
              _setFuture();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh, size: 50.0, color: Colors.blue),
                Text('ลองใหม่อีกครั้ง'),
              ],
            ),
          );
        } else {
          return refreshList(listTemp);
        }
      },
    );
  }

  SmartRefresher refreshList(List<dynamic> model) {
    return SmartRefresher(
      enablePullDown: false,
      enablePullUp: true,
      footer: ClassicFooter(
        loadingText: ' ',
        canLoadingText: ' ',
        idleText: ' ',
        idleIcon: Icon(Icons.arrow_upward, color: Colors.transparent),
      ),
      controller: _refreshController,
      onLoading: _onLoading,
      child: ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: model.length,
        itemBuilder: (context, index) {
          return card(context, model[index]);
        },
      ),
    );
  }

  Container card(BuildContext context, dynamic model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => PoiForm(
                    code: model['code'],
                    model: model,
                    url: poiApi,
                    urlComment: poiCommentApi,
                    urlGallery: poiGalleryApi,
                  ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          margin: EdgeInsets.only(bottom: 5.0),
          child: Column(
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(5.0),
                    topRight: const Radius.circular(5.0),
                  ),
                  color: Colors.white,
                ),
                child:
                    model['imageUrl'] != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(5.0),
                            topRight: const Radius.circular(5.0),
                          ),
                          child: Image.network(
                            '${model['imageUrl']}',
                            fit: BoxFit.contain,
                          ),
                        )
                        : BlankLoading(height: 200),
              ),
              Container(
                // height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: const Radius.circular(5.0),
                    bottomRight: const Radius.circular(5.0),
                  ),
                  color: Color(0xFFFFFFFF),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${model['title']}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Sarabun',
                        fontSize: 15.0,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF4D4D4D),
                      ),
                    ),
                    Text(
                      'วันที่ ' + dateStringToDate(model['createDate']),
                      style: TextStyle(
                        color: Color(0xFF8F8F8F),
                        fontFamily: 'Sarabun',
                        fontSize: 15.0,
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  setData(String categoryCode, String keySearkch) {
    setState(() {
      if (keySearch != "") {
        showLoadingItem = true;
      }
      category = categoryCode;
      keySearch = keySearkch;
      _limit = 10;
    });
    _setFuture();
  }

  // end show content
}
