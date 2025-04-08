import 'package:ksp/coming_soon.dart';
import 'package:ksp/shared/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:ksp/widget/blank.dart';
import 'package:ksp/widget/dialog.dart';
import 'package:ksp/widget/header.dart';
import 'package:ksp/widget/link_url.dart';
import 'package:ksp/widget/loading.dart';

class OtherMenuPage extends StatefulWidget {
  OtherMenuPage({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  _OtherMenuPage createState() => _OtherMenuPage();
}

class _OtherMenuPage extends State<OtherMenuPage> {
  Future<dynamic> _futureModel = Future.value(null);
  @override
  void initState() {
    _futureModel = postDio('${menuApi}read', {
      'titleEN': 'Organization',
    });
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
        backgroundColor: Color(0xFFFDF2E8),
        appBar: header(context, goBack, title: widget.title),
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
                  return GridView.builder(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      // childAspectRatio: (itemWidth / itemHeight),
                    ),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return _buildItem(snapshot.data[index]);
                    },
                  );
                } else {
                  return Center(
                    child: Container(
                      color: Colors.transparent,
                      child: Text(
                        'ไม่พบข้อมูล',
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }
              } else if (snapshot.hasError) {
                return Center(
                  child: Container(
                    color: Colors.white,
                    child: dialogFail(context),
                  ),
                );
              } else {
                return BlankLoading();
              }
            },
          ),
        ),
      ),
    );
  }

  void goBack() async {
    Navigator.pop(context, false);
  }

  Widget _buildItem(model) {
    var isInApp = true;
    if (model['direction'].length > 2) {
      isInApp = false;
    }
    return Container(
      // margin: EdgeInsets.all(5),
      padding: EdgeInsets.only(left: 5, right: 5),
      child: InkWell(
        onTap: () {
          if (isInApp) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ComingSoon(code: model['direction']),
              ),
            );
          } else
            launchURL(model['direction']);
        },
        child: Column(
          children: [
            Expanded(
              child: loadingImageNetwork(
                model['imageUrl'],
              ),
            ),
            SizedBox(height: 5),
            Expanded(
              child: Text(
                model['title'],
                style: TextStyle(
                  fontFamily: 'Kanit',
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
