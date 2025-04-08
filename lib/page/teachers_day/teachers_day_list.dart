import 'package:flutter/material.dart';
import 'package:ksp/shared/api_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ksp/widget/header.dart';
import 'package:ksp/widget/key_search.dart';
import 'package:ksp/widget/tab_category.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'teachers_day_list_vertical.dart';

class TeachersDayList extends StatefulWidget {
  TeachersDayList({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _TeachersDayList createState() => _TeachersDayList();
}

class _TeachersDayList extends State<TeachersDayList> {
  late TeachersDayListVertical teachersDay;
  bool hideSearch = true;
  final txtDescription = TextEditingController();
  final storage = FlutterSecureStorage();
  String keySearch = '';
  String category = '';
  int _limit = 0;
  Future<dynamic> _futureCategory = Future.value(null);

  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  void initState() {
    super.initState();
    _onLoading();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onLoading() async {
    // var profileCode = await storage.read(key: 'profileCode9');
    // if (profileCode != '' && profileCode != null) {
    setState(() {
      _limit = _limit + 10;

      _futureCategory = postCategory('${teachersDayCategoryApi}read', {
        'skip': 0,
        'limit': 100,
      });

      teachersDay = TeachersDayListVertical(
        model: postDio('${teachersDayApi}read', {
          'skip': 0,
          'limit': _limit,
          "keySearch": keySearch,
          'category': category,
          // 'profileCode': profileCode
        }),
        url: '${teachersDayApi}read',
        urlGallery: '${teachersDayGalleryApi}',
      );
    });
    // }

    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.loadComplete();
  }

  void goBack() async {
    Navigator.pop(context, false);
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => Menu(),
    //   ),
    // );
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
        appBar: header(context, goBack, title: widget.title),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overScroll) {
            return false;
          },
          child: Column(
            // controller: _controller,
            children: [
              SizedBox(height: 5),
              CategorySelector(
                model: _futureCategory,
                onChange: (String val) {
                  setState(() {
                    category = val;
                  });
                  _onLoading();
                },
              ),
              SizedBox(height: 5),
              KeySearch(
                show: hideSearch,
                onKeySearchChange: (String val) {
                  setState(() {
                    keySearch = val;
                  });
                  _onLoading();
                },
              ),
              SizedBox(height: 10),
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
                  child: ListView(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    // controller: _controller,
                    children: [teachersDay],
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
