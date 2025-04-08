
import 'package:ksp/shared/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:ksp/widget/blank.dart';
import 'package:ksp/widget/button.dart';
import 'package:ksp/widget/content.dart';

class ComingSoon extends StatefulWidget {
  ComingSoon({Key? key, required this.code}) : super(key: key);

  final String code;
  @override
  _ComingSoon createState() => _ComingSoon();
}

class _ComingSoon extends State<ComingSoon> {
  Future<dynamic> _futureModel = Future.value(null);
  @override
  void initState() {
    _futureModel = postDio(comingSoonApi, {'codeShort': widget.code});
    super.initState();
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
        // appBar: header(context, goBack, title: widget.title),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overScroll) {
            return false;
          },
          child: FutureBuilder<dynamic>(
            future: _futureModel,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                // print(snapshot.data);
                if (snapshot.data.length > 0) {
                  return ListView(
                    shrinkWrap: true,
                    children: [
                      Stack(
                        children: [
                          ContentWithOutShare(
                            code: snapshot.data[0]['code'],
                            model: snapshot.data[0],
                            urlGallery: comingSoonGalleryApi,
                          ),
                          Positioned(
                            right: 0,
                            top: 5,
                            child: Container(
                              child: buttonCloseBack(context),
                            ),
                          ),
                        ],
                      ),
                      // comment,
                    ],
                  );
                } else {
                  return _buildComing();
                }
              } else if (snapshot.hasError) {
                return _buildComing();
              } else {
                return BlankLoading();
              }
            },
          ),
        ),
      ),
    );
  }

  _buildComing() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
      child: Text(
        'Coming Soon',
        style: TextStyle(
          fontFamily: 'Kanit',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void goBack() async {
    Navigator.pop(context, false);
  }
}
