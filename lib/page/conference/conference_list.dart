import 'package:flutter/material.dart';
import 'package:ksp/shared/api_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ksp/widget/header.dart';
import 'package:ksp/widget/key_search.dart';
import 'package:ksp/widget/tab_category.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'conference_list_vertical.dart';

class ConferenceList extends StatefulWidget {
  ConferenceList({Key? key, required this.title, required this.year}) : super(key: key);

  final String title;
  final String year;

  @override
  _ConferenceList createState() => _ConferenceList();
}

class _ConferenceList extends State<ConferenceList> {
  late ConferenceListVertical conference;
  bool hideSearch = true;
  final txtDescription = TextEditingController();
  final storage = FlutterSecureStorage();
  String keySearch = '';
  String category = '';
  int _limit = 0;
  Future<dynamic> _futureCategory = Future.value(null);

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

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

      _futureCategory = postCategory(
        '${conferenceCategoryApi}read',
        {
          'skip': 0,
          'limit': 100,
        },
      );

      conference = ConferenceListVertical(
        model: postDio('${conferenceApi}read', {
          'skip': 0,
          'limit': _limit,
          "keySearch": keySearch,
          'category': category,
          'year': widget.year,
          // 'profileCode': profileCode
        }),
        url: '${conferenceApi}read',
        urlGallery: '${conferenceGalleryApi}',
      );
    });
    // }

    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.loadComplete();
  }

  void goBack() async {
    Navigator.pop(context, false);
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
                    setState(
                      ()  {category = val;},
                    );
                    _onLoading();
                  },
                ),
                SizedBox(height: 5),
                KeySearch(
                  show: hideSearch,
                  onKeySearchChange: (String val) {
                    setState(
                      () {
                        keySearch = val;
                      },
                    );
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
                      idleIcon:
                          Icon(Icons.arrow_upward, color: Colors.transparent),
                    ),
                    controller: _refreshController,
                    onLoading: _onLoading,
                    child: ListView(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      children: [conference],
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
