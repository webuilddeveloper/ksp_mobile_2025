import 'package:ksp/shared/api_provider.dart';
import 'package:ksp/widget/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ksp/widget/link_url.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class VideoClipsPage extends StatefulWidget {
  VideoClipsPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _VideoClipsPageState createState() => _VideoClipsPageState();
}

class _VideoClipsPageState extends State<VideoClipsPage> {
  final storage = new FlutterSecureStorage();
  RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );
  late Future<dynamic> _futureModel;
  @override
  void initState() {
    _read();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _read() {
    _futureModel = postDio('${server}m/videoclips/read', {});
  }

  void _onLoading() async {
    // var profileCode = await storage.read(key: 'profileCode9');
    // if (profileCode != '' && profileCode != null) {
    setState(() {});
    // }

    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.loadComplete();
  }

  void goBack() async {
    Navigator.pop(context, false);
  }

  _buildData(dynamic data) {
    return Container(
      // padding: EdgeInsets.only(left: 5.0, right: 5.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1 / 1.45,
        ),
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              Container(
                child: GestureDetector(
                  onTap: () {
                    launchInWebViewWithJavaScript(data[index]['linkUrl']);
                  },
                  child: Container(
                    height: 120,
                    width: 170,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 0,
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                      ],
                      image: DecorationImage(
                        image: NetworkImage(data[index]['imageUrl']),
                        fit: BoxFit.fill,
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 5.0,
                      vertical: 0.0,
                    ),
                    // child: loadingImageNetwork(
                    //   data[index]['imageUrl'],
                    //   fit: BoxFit.cover,
                    // )
                    // Image.network(
                    //   ,
                    //   fit: BoxFit.cover,
                    //   height: 200,
                    // ),
                  ),
                ),
              ),
              Container(
                height: 100,
                width: 170,
                child: Text(
                  data[index]['title'],
                  style: TextStyle(
                    fontSize: 13.00,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              // Container(
              //   child: Center(
              //     child: Image.asset('assets/images/bar.png'),
              //   ),
              // ),
            ],
          );
        },
      ),
    );
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
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: header(
          context,
          () => Navigator.pop(context, false),
          title: widget.title,
        ),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overScroll) {
            return false;
          },
          child: Column(
            children: [
              Expanded(
                child: SmartRefresher(
                  enablePullDown: false,
                  enablePullUp: true,
                  footer: ClassicFooter(
                    loadingText: ' ',
                    canLoadingText: ' ',
                    idleText: ' ',
                    idleIcon: Icon(
                      Icons.arrow_upward,
                      color: Colors.transparent,
                    ),
                  ),
                  controller: _refreshController,
                  onLoading: _onLoading,
                  child: FutureBuilder<dynamic>(
                    future: _futureModel,
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<dynamic> snapshot,
                    ) {
                      if (snapshot.hasData) {
                        var listColumn = _buildData(snapshot.data);
                        return Padding(
                          padding: EdgeInsets.all(10),
                          child: ListView(
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            // controller: _controller,
                            children: [listColumn],
                            // children: listColumn,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Container();
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
