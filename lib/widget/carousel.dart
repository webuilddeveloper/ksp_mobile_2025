
import 'package:flutter/material.dart';
import 'package:ksp/widget/button.dart';
import 'package:ksp/widget/comment.dart';
import 'package:ksp/widget/content.dart';
import 'package:ksp/widget/loading.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CarouselRotation extends StatefulWidget {
  CarouselRotation({Key? key, required this.model, required this.nav}) : super(key: key);

  final Future<dynamic> model;
  final Function(String, String, dynamic, String) nav;

  @override
  _CarouselRotation createState() => _CarouselRotation();
}

class _CarouselRotation extends State<CarouselRotation> {
  final txtDescription = TextEditingController();
  int _current = 0;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtDescription.dispose();
    super.dispose();
  }

  final List<String> imgList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: widget.model, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>

        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return Column(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: 140,
                    viewportFraction: 0.7,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    },
                  ),
                  items: snapshot.data.map<Widget>(
                    (document) {
                      return new InkWell(
                        onTap: () {
                          widget.nav(
                            snapshot.data[_current]['linkUrl'],
                            snapshot.data[_current]['action'],
                            snapshot.data[_current],
                            snapshot.data[_current]['code'],
                          );
                        },
                        child: Container(
                          child: Center(
                            child: loadingImageNetwork(
                              document['imageUrl'],
                              fit: BoxFit.fill,
                              height: 140,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ],
            );
          } else {
            return Container();
          }
        } else {
          return Container();
        }
      },
    );
  }
}


// ignore: must_be_immutable
class CarouselForm extends StatefulWidget {
  CarouselForm({
    Key? key,
    required this.url,
    required this.code,
    this.model,
    required this.urlGallery,
  }) : super(key: key);

  final String url;
  final String code;
  final dynamic model;
  final String urlGallery;

  @override
  _CarouselForm createState() => _CarouselForm();
}

class _CarouselForm extends State<CarouselForm> {
  late Comment comment;
  late int _limit;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onLoading() async {
    setState(() {
      _limit = _limit + 10;
    });

    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.loadComplete();
  }

  @override
  void initState() {
    setState(() {
      _limit = 10;
    });

    // comment = Comment(
    //   code: widget.code,
    //   url: widget.urlComment,
    //   model: post('${newsCommentApi}read',
    //       {'skip': 0, 'limit': _limit, 'code': widget.code}),
    //   limit: _limit,
    // );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
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
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overScroll) {
            return false;
          },
          child: SmartRefresher(
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
            child: ListView(
              shrinkWrap: true,
              children: [
                Stack(
                  // fit: StackFit.expand,
                  // alignment: AlignmentDirectional.bottomCenter,
                  // shrinkWrap: true,
                  // physics: ClampingScrollPhysics(),
                  children: [
                    ContentCarousel(
                      code: widget.code,
                      url: widget.url,
                      model: widget.model,
                      urlGallery: widget.urlGallery,
                    ),
                    Positioned(
                      right: 0,
                      top: statusBarHeight + 5,
                      child: Container(
                        child: buttonCloseBack(context),
                      ),
                    ),
                  ],
                  // overflow: Overflow.clip,
                ),
                // widget.urlComment != '' ? comment : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class CarouselBanner extends StatefulWidget {
  CarouselBanner({Key? key, required this.model, required this.nav}) : super(key: key);

  final Future<dynamic> model;
  final Function(String, String, dynamic, String, String) nav;

  @override
  _CarouselBanner createState() => _CarouselBanner();
}

class _CarouselBanner extends State<CarouselBanner> {
  final txtDescription = TextEditingController();
  int _current = 0;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtDescription.dispose();
    super.dispose();
  }

  final List<String> imgList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return FutureBuilder<dynamic>(
      future: widget.model, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    widget.nav(
                      snapshot.data[_current]['linkUrl'],
                      snapshot.data[_current]['action'],
                      snapshot.data[_current],
                      snapshot.data[_current]['code'],
                      '',
                    );
                  },
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: (height * 22.5) / 100,
                      viewportFraction: 1.0,
                      enlargeCenterPage: false,
                      autoPlay: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      },
                    ),
                    items: snapshot.data.map<Widget>(
                      (document) {
                        return new Container(
                          child: Center(
                            child: loadingImageNetwork(
                              document['imageUrl'],
                              fit: BoxFit.fill,
                              height: (height * 22.5) / 100,
                              width: (width * 100) / 100,
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
                Container(
                  color: Color(0xFFFACBA4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: snapshot.data.map<Widget>((url) {
                      int index = snapshot.data.indexOf(url);
                      return Container(
                        width: _current == index ? 20.0 : 5.0,
                        height: 5.0,
                        margin: _current == index
                            ? EdgeInsets.symmetric(
                                vertical: 5.0,
                                horizontal: 1.0,
                              )
                            : EdgeInsets.symmetric(
                                vertical: 5.0,
                                horizontal: 2.0,
                              ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: _current == index
                              ? Theme.of(context).colorScheme.secondary
                              : Color(0xFFF0F0F0),
                          // : Color.fromRGBO(0, 0, 0, 0.4),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          } else {
            return Container();
          }
        } else {
          return Container(height: (height * 22.5) / 100);
        }
      },
    );
  }
}

class CarouselBannerDotStack extends StatefulWidget {
  CarouselBannerDotStack(
      {Key? key,
      required this.model,
      required this.onTap,
      this.height= 200,
      this.onLongPress,
      this.onLongPressEnd})
      : super(key: key);

  final Future<dynamic> model;
  final Function(String, String, dynamic, String, String) onTap;
  final double height;
  final Function(LongPressStartDetails longPressStartDetails, String image)?
      onLongPress;
  final Function(LongPressEndDetails longPressEndDetails)? onLongPressEnd;

  @override
  _CarouselBannerDotStack createState() => _CarouselBannerDotStack();
}

class _CarouselBannerDotStack extends State<CarouselBannerDotStack> {
  final txtDescription = TextEditingController();
  int _current = 0;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtDescription.dispose();
    super.dispose();
  }

  final List<String> imgList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: widget.model, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return Stack(
              children: [
                Container(
                  height: 200,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          widget.onTap(
                            snapshot.data[_current]['linkUrl'],
                            snapshot.data[_current]['action'],
                            snapshot.data[_current],
                            snapshot.data[_current]['code'],
                            '',
                          );
                        },
                        onLongPressStart: (details) => widget.onLongPress,
                        onLongPressEnd:(details) => widget.onLongPressEnd,
                        // onLongPressStart: (value) => widget.onLongPress(
                        //     value, snapshot.data[_current]['imageUrl']),
                        // onLongPressEnd: (value) => widget.onLongPressEnd(value),
                        child: CarouselSlider(
                          options: CarouselOptions(
                            height: 170,
                            viewportFraction: 1.0,
                            enlargeCenterPage: false,
                            autoPlay: true,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            },
                          ),
                          items: snapshot.data.map<Widget>(
                            (document) {
                              return Container(
                                child: loadingImageNetworkClipRRect(
                                  document['imageUrl'],
                                  fit: BoxFit.cover,
                                  height: double.infinity,
                                  width: MediaQuery.of(context).size.width,
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: snapshot.data.map<Widget>((url) {
                      int index = snapshot.data.indexOf(url);
                      return Container(
                        width: _current == index ? 35.0 : 10.0,
                        height: 10.0,
                        margin: _current == index
                            ? EdgeInsets.symmetric(
                                vertical: 5.0,
                                horizontal: 5.0,
                              )
                            : EdgeInsets.symmetric(
                                vertical: 5.0,
                                horizontal: 5.0,
                              ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: _current == index
                              ? Color(0xFFF5661F)
                              : Color(0xFFFACBA4),
                          boxShadow: [
                            BoxShadow(
                              color: _current == index
                                  ? Color(0xFFF5661F)
                                  : Color(0xFFFACBA4),
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          } else {
            return Container(
              height: 200,
            );
          }
        } else {
          return Container(
            height: 200,
          );
        }
      },
    );
  }
}
